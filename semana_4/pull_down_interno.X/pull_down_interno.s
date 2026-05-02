PROCESSOR 18F57Q43
#include <xc.inc>
#include <pic18f57q43.inc>
#include "cabecera.inc"

PSECT code, reloc=2, abs

valor    equ    00H          ; direccion 500H (Bank 5)

ORG      000000H
goto     configuro

ORG      000020H
configuro:
    movlb    00H             ; banco 0 (OSCCON1 OSCFRQ OSCEN)
    movlw    60H             ; Oscilador Interno - Div_Freq: /1
    movwf    OSCCON1,b
    movlw    02H             ; freq_int = 4MHz
    movwf    OSCFRQ,b
    movlw    40H             ; habilita el oscilador interno
    movwf    OSCEN,b
    movlb    04H             ; banco 4 (TRISB ANSELB LATB)
    bsf      TRISB,4,b       ; RB4: Entrada
    bcf      ANSELB,4,b      ; RB4: Digital
    bsf      WPUB,4,b        ; RB4: Pull-Up
    movlw    00000000B       ; RD<7-0>: Salidas
    movwf    TRISD,b
    clrf     ANSELD,b        ; RD<7-0>: Digital
    movlw    3FH
    movwf    LATD,b          ; Display en valor 0
    movlb    05H             ; bank 5
    clrf     valor,b         ; valor = 0
    movlb    04H             ; bank 4

inicio:
    btfsc    PORTB,4
    goto     inicio
    btfss    PORTB,4
    goto     $-1
    movlb    05H
    incf     valor,f,b
    movlw    10
    cpfseq   valor
    goto     sigue
    clrf     valor,b

sigue:
    movf     valor,w
    addwf    valor,w,b
    call     tabla
    movwf    LATD,b
    goto     inicio

tabla:
    movlb    04H             ; bank 4
    addwf    PCL,f,b         ; PCL = PCL + WREG (salta a la direccion del PCL)
    retlw    3FH             ; 0
    retlw    06H             ; 1
    retlw    5BH             ; 2
    retlw    4FH             ; 3
    retlw    66H             ; 4
    retlw    6DH             ; 5
    retlw    7DH             ; 6
    retlw    07H             ; 7
    retlw    7FH             ; 8
    retlw    67H             ; 9
    retlw    00H             ; apagado
    retlw    00H             ; apagado
    retlw    00H             ; apagado
    retlw    00H             ; apagado
    retlw    00H             ; apagado
    retlw    00H             ; apagado

end





