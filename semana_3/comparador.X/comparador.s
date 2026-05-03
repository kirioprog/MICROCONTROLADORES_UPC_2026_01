PROCESSOR 18F57Q43
#include <xc.inc>
#include <pic18f57q43.inc>
#include "cabecera12.inc"
 
PSECT code, reloc=2, abs

numB equ 500H ; nuestas variables para los 2 nmeros  #1
numD equ 501H  ; #2

ORG 000000H
goto configuro

ORG 000020H ; salto de vectores 

configuro:
    movlb 00H  ; conf del oscilador interno 
    movlw 60H
    movwf OSCCON1, b
    movlw 02H
    movwf OSCFRQ, b
    movlw 40H
    movwf OSCEN, b

    movlb 04H  ; pasamos al banco 4 
    
    clrf ANSELB, b   ; todos los pines de los puertos B,D,A en digital . 
    clrf ANSELD, b
    clrf ANSELA, b

    ; conf entradas y salidas 
    movlw 0FH  ; 0000 1111 , usamos los puertos 0 al 3 ( ESTAN COMO ENTRADA )
    movwf TRISB, b
    movlw 0FH ; uso del puerto 0 al 3 
    movwf TRISD, b
    
    clrf TRISA, b ; todo el puerto A en salida. es para los leds. 
    clrf LATA, b ; el puerto A arroja 0v. los switch conectados a 5v 

inicio:
    movlb 04H
    movf PORTB, w, b ; leer el estado del puerto B y guardamos en registro w 
    
    andlw 0FH  ; leemos solo los 3 bits menos significativos. 
    
    movlb 05H
    movwf numB, b ; guardamos el valor en la varaiable numB

    movlb 04H           ; lo mismo para el numero D 
    movf PORTD, w, b
    andlw 0FH           
    movlb 05H           
    movwf numD, b

    movf numB, w, b ; pasamos el valor del numB al  registro w

    cpfseq numD, b ; verificamos si eta igual, si es diferente salta la sigueinte linea 
    
    goto no_son_iguales
    goto prender_igual ; si es igual se va a este goto 

no_son_iguales:
    cpfslt numD, b
    goto D_es_mayor
    goto D_es_menor

prender_igual:
    movlb 04H
    movlw 01H ; prendemos el primer led, el A0 
    movwf LATA, b 
    goto inicio ; regreso para que siga el bucle infinito 

D_es_mayor:
    movlb 04H
    movlw 02H ; prendo el A1 
    movwf LATA, b
    goto inicio

D_es_menor:
    movlb 04H
    movlw 04H ; prendo el A2
    movwf LATA, b
    goto inicio

end


