//Benjamin Kahl ONID: 934546520
#ifndef SMALLSH_H
#define SMALLSH_H
#include <signal.h>

struct Command{
    char* input[512];
    int background;
    char* inFile;
    char* outFile;
    int pid;
};

int prompt(struct Command* com);

void parse(struct Command* com, char* userInput);

void expandDollars(char* currLine);

void handleStatus(int lastExit);

void execCom(struct Command* com, struct sigaction* SIGINT_action, int* lastExit);

void handleSIGTSTP(int signum);

#endif