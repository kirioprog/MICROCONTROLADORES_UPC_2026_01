; AL PRESIONAR EL PULSADOR SIEMPRE QUEDARA ENCENCIDO ! 
; NO HAY CIRCUITO, SOLO SIRVE PARA TEORIA ! 
    PROCESSOR 18F57Q43
#include <xc.inc>
#include <pic18f57q43.inc>
#include "cabecera.inc"

PSECT code, reloc = 2, abs

variable1 equ 500H
variable2 equ 501H
variable3 equ 502H

ORG 0H
goto configuro

ORG 20H

configuro:
    movlb 0H
    movlw 70H ;  CONFIGURACION BASICA PARA EL OSCILADOR EXTERNO! 
    movwf OSCCON1, b
   
    movlw 80H
    movwf OSCEN, b 
    
    ; iniciamos la configuracion de pines 
    movlb 04H
    bcf TRISF,3,  b ; pin en salida
    bcf ANSELF, 3, b ; pin en digital 
    bsf LATF, 3, b ; pin entregara 1 logico 
    
    bsf TRISD,3  ; el RD3 en entrada
    bcf ANSELD,3, b ;RD3 digital 

inicio:
    movlb 04H ; nos vamos aca porque aqui trabajamos con los pines, eso recuerda.
suelto:
    btfss PORTD ,3, b ; btfss-> si el bit esta en 1 salta  la siguiente instruccion
    ; PORTD -> vamos a leer el valor del puerto RD3 
    goto suelto
presionado: 
    btfsc PORTD, 3, b ; btfsc -> si el bit esta en 0 salta  la siguiente linea
    goto presionado ; si un caso el bit es 1 entra al goto y se va ejecutar lo quehay en ese goto y no regresa 
    bsf LATF,3,	b ; ponemos el RF3  en 1 , osea va entregar 5v
    goto inicio
    end 

