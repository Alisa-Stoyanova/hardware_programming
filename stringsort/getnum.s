; Code section, aligned on 8-byte boundery
;********************************************
   AREA MyCode, CODE, readonly, align = 2
   GLOBAL getNum_asm
;---------------------------------------------------
;--- Bestimt die Zahl in einer Zeichenkette vom
;--- Aufbau "Name    Zahl    EUR"
;--- in:    R0 = Adresse des Textes
;--- out:   R0 = Zahl im Text
;---------------------------------------------------
getNum_asm    PROC
            push {R1-R3, lr}            ; gerade Anzahl von Registern!
            mov R1, #0                  ; Zahl im String initialisieren (in C result = 0)
            mov R3, #10                 ; Faktor für Horner Schema
while_01                                ; while(aktuelles Zeichen keine Zahl)
            ldrb R2, [R0], #1           ; Aktuelles Zeichen lesen und danach aktuelle Adresse + 1
            cmp R2, #'1'                ; Wenn aktuelles Zeichen kleiner als '1'
            blo while_01                ; dann nächstes Zeichen kontrollieren
            cmp R2, #'9'                ; Wenn es über '1' und kleiner gleich '9' ist
            bls while_02	            ; ist das Zeichen eine Zahl und wir springen in den Number Loop
            b while_01                  ; Ansonsten wieder in die while-Schleife
endwhile_01
while_02								; number_loop
            sub R2, #'0'                ; Ascii Code in Zahl umwandeln
            mul R1, R3                  ; aktuelle Zahl mit 10 multiplizieren
            add R1, R2                  ; gelesene Zahl addieren
            ldrb R2, [R0], #1           ; nächstes Zeichen betrachten
            cmp R2, #' '                ; Wenn nächstes Zeichen ein Leerzeichen, dann Ende
            bne while_02             	; sonst in den Loop zurück
endwhile_02            
            mov R0, R1                  ; r0 <-- Ergebnis
            pop {R1-R3, lr}
            bx   LR
        ENDP
	END