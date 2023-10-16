#ifndef MOVIES_C
#define MOVIES_C
#include <fcntl.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#include <string.h>
#include "movies.h"

struct Movie* initialize(char* file){
    //Most of the code has been modeled after students.c from the linked file on the assignment page
    //Initialize vars
    int numMovies = 0;
    char* currLine = NULL;
    size_t len = 0;
    ssize_t nread;
    char* token;

    //Open filestream
    FILE* movieFile = fopen(file, "r");

    //Set up linked list
    struct Movie* head = NULL;
    struct Movie* tail = NULL;
    struct Movie* newMovie = NULL;

    //Get title line so the program doesn't add it to the linked list
    getline(&currLine, &len, movieFile);
    //Process line by line until end of file, inserting into linked list once processed (unsorted)
    while((nread = getline(&currLine, &len, movieFile)) != -1){
        newMovie = createMovie(currLine);
        if(head == NULL){
            head = newMovie;
            tail = newMovie;
        }
        else{
            tail->next = newMovie;
            tail = newMovie;
        }
        //store number of movies processed for final printf before return
        numMovies++;
    }
    //Free and close data
    free(currLine);
    fclose(movieFile);
    //Print report
    printf("Processed file %s and parsed data for %d movies \n", file, numMovies);
    return head;
}

struct Movie* createMovie(char* currLine){
    struct Movie* newMovie = malloc(sizeof(struct Movie));
    //Modeled after student.c
    //Hold position
    char* saveptr;

    char* token = __strtok_r(currLine, ",", &saveptr);
    newMovie->title = calloc(strlen(token) + 1, sizeof(char));
    strcpy(newMovie->title, token);

    token = __strtok_r(NULL, ",", &saveptr);
    newMovie->year = atoi(token);

    //set token to the language block
    token = __strtok_r(NULL, "[],", &saveptr);

    //tempory token to break into array
    char* tempptr;
    char* temp = __strtok_r(token, ";", &tempptr);
    int i = 0;
    while(temp != NULL){
        //Insert languages into the array dynamically with calloc
        newMovie->languages[i] = calloc(strlen(temp) + 1, sizeof(char));
        strcpy(newMovie->languages[i], temp);
        temp = __strtok_r(NULL, "[];", &tempptr);
        i++;
    }
    token = __strtok_r(NULL,",\0", &saveptr);
    newMovie->rating = strtod(token, &saveptr);
    return newMovie;
}

void showYear(struct Movie* head, int year){
    struct Movie* curr = head;
    //Simple comparison as the program iterates, prints if it matches inputted year
    while(curr != NULL){
        if (curr->year == year){
            printf("%s\n", curr->title);
        }
        curr = curr->next;
    }
    printf("\n");
}

void showHighest(struct Movie* head){
    struct Movie* curr = head;
    //Array to store all the top movies, from 1900-2021 per instructions
    //If a movie falls outside of this range, it will not be added.
    struct TopMovie topMovies[122];
    int i = 0;
    int year = 0;
    //Initialize array for storing top movies
    for (i = 0; i < 122; i++){
        topMovies[i].year = i + 1900;
        topMovies[i].topMovie = NULL;
    }

    //Iterate through linked list, adding movies to array.
    while(curr != NULL){
        year = curr->year;
        //Null case
        if (topMovies[year - 1900].topMovie == NULL){
            topMovies[year - 1900].topMovie = curr;
        } 
        //In the event of an equal case, the first movie is added and the second is discarded
        if(curr->rating > topMovies[year - 1900].topMovie->rating){
            topMovies[year - 1900].topMovie = curr;
        }
        curr = curr->next;
    }
    //Print out the array
    for(i = 0; i < 122; i++){
        if(topMovies[i].topMovie != NULL){
            printf("%d %.1f %s\n", topMovies[i].topMovie->year, topMovies[i].topMovie->rating, topMovies[i].topMovie->title);
        }
    }
    printf("\n");
}

void showLang(struct Movie* head, char* lang){
    struct Movie* curr = head;
    int i = 0;
    //set flag for if match is found
    int found = 0;
    while(curr != NULL){
        //Set up loop to check each language
        for(i = 0; i < 5; i++){
            //Null check
            if(curr->languages[i] != NULL){
                //Actual comparison
                if(strcmp(curr->languages[i], lang) == 0){
                //Set flag and print
                found = 1;
                printf("%d %s\n",curr->year, curr->title);
                break;
                }
            }
        }
        //Iterate
        curr = curr->next;
    }

    //Message for if flag was not set
    if (!found){
        printf("No movies found for langauge: %s\n", lang);
    }
    
    printf("\n");
}

//Simple user menu utilizing a switch statement
void menu(struct Movie* head){
    int exit = 1;
    int userInMen = 0;
    int userIn = 0;
    //User input buffer for option 3
    char userBuf[21];
    while(exit != 0){
        printf("1. Show movies released in the specified year\n2. Show highest rated movie for each year\n"
        "3. Show the title and year of release of all movies in a specific language\n4. Exit from the program\n\n");
        printf("Enter a choice from 1 to 4: ");
        scanf("%d", &userInMen);
        switch(userInMen){
            case 1:
                printf("Enter the year for which you want to see movies: ");
                scanf("%d", &userIn);
                showYear(head, userIn);
                break;
            case 2:
                showHighest(head);
                break;
            case 3:
                printf("Enter the language for which you want to see movies: ");
                scanf("%20s", userBuf);
                showLang(head, userBuf);
                break;
            case 4:
                exit = 0;
                break;
            default:
                printf("Please enter a valid option.\n");
                break;
        }

    }
}

int main(int argc, char* argv[]){
    struct Movie* head = initialize(argv[1]);
    menu(head);
    return 0;
}


#endif