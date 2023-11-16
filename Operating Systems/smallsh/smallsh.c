//Benjamin Kahl ONID: 934546520
#ifndef SMALLSH_C
#define SMALLSH_C
#include <fcntl.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <string.h>
#include <dirent.h>
#include <time.h>
#include <signal.h>
#include "smallsh.h"

//Global background state, handled by handleSIGTSTP
int gBackground = 1;

int prompt(struct Command* com){
    char userInput[2048];
    memset(userInput, '\0', sizeof(userInput));
    int i;
    int flag = 0;
    printf(": ");
    //I typically use scanf, but for some reason I had issues with recognizing blank lines when using it
    fgets(userInput, 2048, stdin);
    fflush(stdout);
    
    //Check for blank/newline
    if(userInput[0] == '#' || userInput[0] == '\n'){
        return 1;
    }

    //Remove the \n character from the input
    for(i = 0; !flag && i < 2048; i++){
        if(userInput[i] == '\n'){
            userInput[i] = '\0';
            flag = 1;
        }
    }
    //time to start scraping the input into individual commands/args
    parse(com, userInput);
    flag = 0;
    for (i = 0; i < 512 && !flag ; i++){
        //Set NULL terminator
        if (com->input[i][0] == '\0'){
            com->input[i] = NULL;
            if(i == 0){
                return 1;
            }
            flag = 1;
        }
    }
    
    return 0;
}

void parse(struct Command* com, char* userInput){
    int i;
    int flag = 0;
    //Check for foreground or background
    com->background = 0;
    for (i = 0; !flag && i < 2048; i++){
        if (userInput[i] == '\0' && userInput[i-1] == '&'){
            flag = 1;
            userInput[i-1] = '\0';       
            if(gBackground == 1){
                com->background = 1;
            } else {
                com->background = 0;
            }
        }
    }
    char* saveptr;
    char* token = __strtok_r(userInput, " ", &saveptr);
    for(i = 0; token && i < 512; i++){
        //Check for input redirection, and where to redirect
        if(strcmp(token, "<") == 0){
            token = __strtok_r(NULL, " ", &saveptr);
            strcpy(com->inFile, token);
        }
        //Output redirection
        else if (strcmp(token, ">") == 0){
            token = __strtok_r(NULL, " ", &saveptr);
            strcpy(com->outFile, token);
        }
        else {
            //add command or argument to list
            strcpy(com->input[i], token);
            expandDollars(com->input[i]);
        }
        //Iterate
        token = __strtok_r(NULL, " ", &saveptr);
    }
}

void expandDollars(char* currLine){
    //Check to see if the string even contains "$$"
    if (strstr(currLine, "$$") == NULL){
        return;
    }
    //Has "$$", begin tokenization
    char temp[64] = {0};
    pid_t pid = getpid();
    char pidStr[16];
    sprintf(pidStr, "%d", pid);
    //Tokenization has issues if the input is just $$
    if(strcmp(currLine, "$$") == 0){
        strcpy(currLine, pidStr);
        return;
    }
    char* saveptr;
    char* token = strtok_r(currLine, "$$", &saveptr);
    while(token != NULL){
        strcat(temp, token);
        strcat(temp, pidStr);
        token = strtok_r(NULL, "$$", &saveptr);
    }
    strcpy(currLine, temp);
}

//Prints out last exit status
void handleStatus(int lastExit){
    if (WIFEXITED(lastExit)){
       printf("exit value %d\n", WEXITSTATUS(lastExit));
       fflush(stdout);
    } else {
        printf("terminated by signal %d\n", WTERMSIG(lastExit));
        fflush(stdout);
    }
}

void execCom(struct Command* com, struct sigaction* SIGINT_action, int* lastExit){
    int file_descriptor;
    int redirect;
    int i;
    pid_t spawnpid = -5;
    spawnpid = fork();
    switch (spawnpid)
    {
    case -1:
        perror("Hull Breach\n");
        exit(1);
        break;
    case 0:
        // Child process
        // Start taking ^C again
        SIGINT_action->sa_handler = SIG_DFL;
        sigaction(SIGINT, SIGINT_action, NULL);

        // Handle input redirection
        if (com->inFile[0] != '\0'){

            file_descriptor = open(com->inFile, O_RDONLY);
            if (file_descriptor == -1){
                exit(1);
            }
            redirect = dup2(file_descriptor, 0);
            if (redirect == -1){
                perror("Unable to assign input file\n");
                exit(2);
            }
            close(file_descriptor);
        }

        // Redirect, only if there is a file
        if (com->outFile[0] != '\0'){
            file_descriptor = open(com->outFile, O_WRONLY | O_CREAT | O_TRUNC, 0666);
            if (file_descriptor == -1){
                exit(1);
            }

            redirect = dup2(file_descriptor, 1);
            if (redirect == -1){
                perror("Unable to assign output file\n");
                exit(2);
            }
            close(file_descriptor);
        }

        // Execute as external command, checking first to see if it returns
        if (execvp(com->input[0], (char **)com->input) == -1){
            printf("%s: No such file or directory\n", com->input[0]);
            fflush(stdout);
            exit(2);
        }
        break;

    default:
        // execute as background
        if (com->background && gBackground){
            pid_t parentPid = waitpid(spawnpid, lastExit, WNOHANG);
            printf("background pid is: %d\n", spawnpid);
            fflush(stdout);
        }
        // else wait normally
        else{
            pid_t parentPid = waitpid(spawnpid, lastExit, 0);
        }

        // Wait for child to terminate
        while ((spawnpid = waitpid(-1, lastExit, WNOHANG)) > 0){
            printf("background pid %d is done: ", spawnpid);
            handleStatus(*lastExit);
            fflush(stdout);
        }
        break;
    }
}

//I could've made this a wacky pseudo member function in Command with function pointers, chose not to and created a global var instead
void handleSIGTSTP(int signum){
    switch (gBackground){
    case 1:
        write(1, "\nEntering foregorund-only mode (& is now ignored)\n", 50);
        fflush(stdout);
        gBackground = 0;   
        break;
    
    default:
        write(1, "\nExiting foreground-only mode\n", 30);
        fflush(stdout);
        gBackground = 1;
        break;
    }
}

int main(int argc, char* argv[]){
    int exit = 1;
    int i;
    int lastExit = 0;
    struct Command com;
    //allocate memory/initialize com
    //Allocate 512 bytes for 512 potential arguments
    for (i = 0; i < 512; i++){
        com.input[i] = calloc(64, sizeof(char));
        memset(com.input[i], '\0', 64);
    }
    com.inFile = calloc(256, sizeof(char));
    memset(com.inFile, '\0', sizeof(com.inFile));
    com.outFile = calloc(256, sizeof(char));
    memset(com.outFile, '\0', sizeof(com.outFile));
    com.pid = getpid();
    com.background = 0;

    //Initialize signal handlers
    struct sigaction SIGINT_action = {0};
    SIGINT_action.sa_handler = SIG_IGN;
    sigfillset(&SIGINT_action.sa_mask);
    SIGINT_action.sa_flags = 0;
    sigaction(SIGINT, &SIGINT_action, NULL);

    struct sigaction SIGTSTP_action = {0};
    SIGTSTP_action.sa_handler = handleSIGTSTP;
    sigfillset(&SIGTSTP_action.sa_mask);
    SIGTSTP_action.sa_flags = 0;
    sigaction(SIGTSTP, &SIGTSTP_action, NULL);

    while(exit != 0){
        if (prompt(&com) == 0){
            if (strcmp(com.input[0], "exit") == 0){
                exit = 0;
            } else if (strcmp(com.input[0], "status") == 0){
                handleStatus(lastExit);
            } else if (strcmp(com.input[0], "cd") == 0){
                //Check first to see if any directory was inputted
                if (com.input[1] != NULL){
                    //Check if it is a valid directory
                    if (chdir(com.input[1]) == -1){
                        printf("No directory found.\n");
                        fflush(stdout);
                    }
                } else {
                    //No argument? Set directory to HOME
                    chdir(getenv("HOME"));
                }
                
            }
            else {
                //Not an inbuilt command, go to execCom
                execCom(&com, &SIGINT_action, &lastExit);
            }
        }
        //Reset vars
        for (i = 0; i < 512; i++){
            if (com.input[i] == NULL){
                com.input[i] = calloc(64, sizeof(char));
            }
            memset(com.input[i], '\0', 64);
        }
        com.inFile[0] = '\0';
        com.outFile[0] = '\0';
        com.background = 0;
    }
    return EXIT_SUCCESS;
}
#endif