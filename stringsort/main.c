#include <stdio.h>
#include "TI_Lib.h" //für evtl. Ausgabe auf TFT-Bildschirm

#include "stringsort.h"

// ... sonstige Headerdateien ...

char *pMeineStrings[] = { // pointer auf string array
    "Haller 25 EUR",
    "Kandinsky 13 EUR",
    "Brombach 5 EUR",
    "Zaluskowski 120 EUR",
    "Osman 17 EUR",
    ""};

int main(void)
{
    Init_TI_Board();
    printf("\f\n"); // Lösche Terminal-Screen
    TFT_cls();      // Lösche TFT-Display des TI-Boards

    PrintStringliste(pMeineStrings);
		printf("\n");
    SortiereStrings(pMeineStrings) ;
    PrintStringliste(pMeineStrings);

    while (1)
    {
    } // Endlosschleife
}
