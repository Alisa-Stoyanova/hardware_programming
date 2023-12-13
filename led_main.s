;* File Name          : main.s
;* Author             : Luca Ziegler
;* Author             : Alisa Stoyanova	
;* Version            : V1
;* Date               : 02.12.2023
;* Description        : Misst die Ausgangsspannung eines Sensors am Analog-Digitalwandler A3.7  (0V - maximal 3V)
;						und gibt auf den Leuchtdioden (LED) an den Ports PG0-PG15 als Leuchtbalken aus.

;*******************************************************************************

	EXTERN Init_TI_Board		; Initialize the serial line
	EXTERN ADC3_CH7_DMA_Config  ; Initialize the ADC
	EXTERN Delay				; Delay (ms) function
	EXTERN GPIO_G_SET			; Set output-LEDs
	EXTERN GPIO_G_CLR			; Clear output-LEDs
	EXTERN ADC3_DR				; ADC Value (ADC3_CH7_DMA_Config has to be called before)

;********************************************
; Data section, aligned on 4-byte boundery
;********************************************
	
	AREA MyData, DATA, align = 2
		
;********************************************
; Code section, aligned on 8-byte boundery
;********************************************

	AREA |.text|, CODE, READONLY, ALIGN = 2

; RN: Direktive, um Registern Namen zu geben 
adc_wert   			RN   7			; Wert
adc_dr	    		RN	 8			; Adresse	
gpio_set   			RN   9
gpio_clr   			RN   10
counter				RN 	 11
output				RN	 12			; sum, average (Balkenlaenge), LED-Ausgabe
 
;--------------------------------------------
; main subroutine
;--------------------------------------------
	EXPORT main [CODE]
		
main	PROC

		BL	Init_TI_Board			; Initialize the serial line to TTY for compatability to out TI-C-Board
		BL 	ADC3_CH7_DMA_Config 	; Initialize and config ADC3.7
							
		;	I/O-Adressen in Registern speichern
		LDR     adc_dr, 	=ADC3_DR        	; Adresse des ADC
		LDR     gpio_clr, 	=GPIO_G_CLR			; I/O loeschen
		LDR     gpio_set, 	=GPIO_G_SET			; I/O setzen

messschleife
		MOV counter, #16						; Anzahl der Messungen
		MOV output, #0							; Summe zuruecksetzen
		
repeat_01
		LDR		adc_wert, [adc_dr]				; Messwert lesen
		ADD		output, adc_wert				; Messwerte aufaddieren
		
		; Warten		
		MOV		r0, #0x20						; Zeit die gewartet werden soll in [ms]
		BL		Delay							; Wartet entsprechend dem Wert von R0 in [ms]
												; ACHTUNG! BL Delay veraendert die Register R0-R3!
		SUBS counter, #1						; Zaehler dekrementieren, Flags setzen
until_01 
		BEQ endrepeat_01						; Z == 1? --> Schleife beenden
		BNE repeat_01							; weiter messen
endrepeat_01

		; Ausgabewert ermitteln
		LSR output, #4							; Mittelwert berechnen (durch 2^4 dividieren)
		LSR output, #8							; Mittelwert auf 4 Bit reduzieren
;		LSR output, #12							; durch 2^4 dividieren und auf 4 Bit reduzieren --> 4 + 8
		MOV r0, #1
		MOV output, r0, LSL output				; 1 um Balkenlaenge nach links schieben
		SUB output, #1							; davon 1 subtrahieren
		
		; LED Ausgabe
		MOV		r5, #0xffff						; 16-Bit-GPIO-Port --> #0xffff
		STRH	r5, [gpio_clr]					; LEDs loeschen (gpio_clr funktioniert wie BIC)
		STRH	output, [gpio_set]				; Ausgabe Bitmuster

		B       messschleife
				
		
forever	B	forever								; nowhere to return if main ends		
		ENDP
	
		ALIGN
       
		END