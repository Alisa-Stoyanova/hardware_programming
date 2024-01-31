#include "stringsort.h"
#include <stdio.h>

/* Zahl im String bestimmen und zurückgeben */
int getNum(char *pMeinString)
{
    int result = 0;
    int i = 0;

    while (pMeinString[i] != '\0')
    {
        if (pMeinString[i] >= '0' && pMeinString[i] <= '9')
        {
            result = result * 10 + (pMeinString[i] - '0'); // Horner Schema
        }

        i++;
    }

    return result;
}

/* Ausdrucken der Stringliste auf Terminal/TFT-Screen*/
void PrintStringliste(char *pMeineStrings[])
{
    for (int i = 0; pMeineStrings[i][0] != '\0'; i++) // [string][sign]
    {
        printf("%s\n", pMeineStrings[i]);
    }
}

/* Sortieren einer Stringliste nach der Größe */
/* der Zahl im String, ruft dazu getNum() auf.*/
void SortiereStrings(char *pMeineStrings[])
{
    char *temp;
    int len = 0; // length of the outer array - number of lines

    // Zähle die Anzahl der Strings in der Liste
    while (pMeineStrings[len][0] != '\0')
    {
        len++;
    }

    for (int i = 0; i < len - 1; i++) // bubblesort: go only until next to last to compare with last
    {
        // Schleife für den Durchlauf des Strings
        for (int j = 0; j < len - i - 1; j++) // letztes Element ist schon das groesste --> -i
        {
            // Schleife für den Vergleich der Elemente
            if (getNum(pMeineStrings[j]) > getNum(pMeineStrings[j + 1]))
						//if (getNum_asm(pMeineStrings[j]) > getNum_asm(pMeineStrings[j + 1]))
						{
                // Überprüft, ob das aktuelle Element größer als das nächste Element ist
                // Wenn ja, werden die Elemente getauscht
                temp = pMeineStrings[j];
                pMeineStrings[j] = pMeineStrings[j + 1];
                pMeineStrings[j + 1] = temp;
            }
        }
    }
}
