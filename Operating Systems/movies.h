#ifndef MOVIES_H
#define MOVIES_H

//Declaration for Movie struct, contains all necessary data
struct Movie{
    char* title;
    int year;
    char* languages[5];
    double rating;
    struct Movie* next;
};

//Declaration for TopMovie struct, contains the year and a 
//pointer to the highest rated movie of that year.
struct TopMovie{
    int year;
    struct Movie* topMovie;
};

struct Movie* initialize(char* file);

struct Movie* createMovie(char* currLine);

void menu(struct Movie* head);

void showYear(struct Movie* head, int year);

void showHighest(struct Movie* head);

void showLang(struct Movie* head, char* lang);


#endif