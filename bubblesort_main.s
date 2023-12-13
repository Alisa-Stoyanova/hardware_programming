;********************************************
; Data section / Speicher reservieren
;********************************************
	AREA MyData, DATA, align = 4
DataList DCD 35, -1, 13, -4096, 800, 101, -3, -5, -310, 0, 65
DataListEnd DCD 0
	GLOBAL DataList
	GLOBAL DataListEnd

;********************************************
; Code section
;********************************************

	AREA MyCode, CODE, readonly, align = 4

;********************************************
; main subroutine
;********************************************
	GLOBAL main
    
main PROC

	mov r0, #1					; Getauscht <-- Ja
	ldr r4, =DataListEnd		; Die Adresse von DataListEnd speichern (Pseudobefehl)

while_01
	cmp r0, #1					; Getauscht == Ja
	bne endwhile_01				; Wenn nicht getauscht, dann Programmende
	mov r0, #0					; Getauscht <-- Nein
	ldr r1, =DataList			; Zeiger auf den ersten Wert setzen (Pseudobefehl)
while_02
	cmp r1, r4					; Zeiger zeigt auf den letzten Wert?
	beq endwhile_02				; Ja
do_02
	ldr r2, [r1]				; Den aktuellen Wert speichern
	ldr r3, [r1, #4]			; Den nächsten Wert speichern
if_01
	cmp r2, r3					; Der aktuelle Wert > der folgende Wert?
	ble endif_01				; Nicht tauschen
then_01
	str r2, [r1, #4]			; Der aktuelle Wert mit dem nächsten tauschen (Source, Destination)
	str r3, [r1]				; Der nächste Wert mit dem aktuellen tauschen
	mov r0, #1					; Getauscht <-- Ja
endif_01
	add r1, #4					; Zeiger auf den folgenden Element setzen
	b while_02					; Unbedingter Sprung auf Anfang der Schleife
endwhile_02
	b while_01					; Unbedingter Sprung auf Anfang der Schleife
endwhile_01

forever b forever				; Endlose Schleife, wenn main endet
    ENDP
	ALIGN 4
	END