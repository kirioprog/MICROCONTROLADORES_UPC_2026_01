PROCESSOR 18F57Q43

#include <xc.inc>
#include <pic18f57q43.inc>
#include "cabecera.inc"

PSECT code, reloc=2, abs

unidad     equ 500H
decena     equ 501H
centena    equ 502H
millar     equ 503H

var1       equ 504H
var2       equ 505H

ORG 0H
goto configuro

ORG 20H

configuro:

    movlb 00H

    ; reloj
    movlw 60H
    movwf OSCCON1,b

    movlw 02H
    movwf OSCFRQ,b

    movlw 40H
    movwf OSCEN,b

    ; puerto D
    movlb 04H

    clrf TRISD,b
    clrf ANSELD,b
    clrf LATD,b

    ; puerto B
    movlw 0F0H
    movwf TRISB,b

    clrf ANSELB,b
    clrf LATB,b

    ; limpiar variables
    clrf unidad,a
    clrf decena,a
    clrf centena,a
    clrf millar,a

inicio:

    movlw 5
    movwf var1,a

multiplex:

    ; creamos el bucle para el codigo 
    ; lo reptimos el numero de vecesx mostrado arriba , es tan rapido que no se percibiria 
    ; mostramos los display 
    call mostrar_unidad
    call mostrar_decena
    call mostrar_centena
    call mostrar_millar

    decfsz var1,f,a ; decrementamos en 1 el contador para medir el tiempo 
    goto multiplex ; si no llega a 0 sigue retadno 
    
    contador: ; se ejecuta cuando 7ua lega al final del var1 

	incf unidad,f,a ; pasmaos a 1 en el primer caso 
	movlw 9
	cpfsgt unidad,a 
	goto inicio ; si no llega a su limite vuele a ejecutar desde el inicio 
		    ; en este caso unidad ya tendra 1 el cual ira a mostrar_unidad 

	clrf unidad,a ; si llega a su limite vuelve a contar dessde 0 

	incf decena,f,a
	movlw 9
	cpfsgt decena,a
	goto inicio
	clrf decena,a

	incf centena,f,a
	movlw 9
	cpfsgt centena,a
	goto inicio
	clrf centena,a


	incf millar,f,a
	movlw 9
	cpfsgt millar,a
	goto inicio
	clrf millar,a
	goto inicio


mostrar_unidad:
    movlw 01H
    movwf LATB,b
    
    movf unidad,w,a ;por contador unidad ya tiene 1
    addwf unidad,w,a
    call tabla
    movwf LATD,b
    
    
    call retardo
    
    
    return



mostrar_decena:
    movlw 02H
    movwf LATB,b
    
    movf decena,w,a
    addwf decena,w,a
    call tabla 
    movwf LATD,b

    

    call retardo

    

    return



mostrar_centena:

    movf centena,w,a
    addwf centena,w,a
    call tabla
    movwf LATD,b
    

    movlw 04H
    movwf LATB,b

    call retardo

    clrf LATB,b

    return



mostrar_millar:

    movf millar,w,a
    addwf millar,w,a
    call tabla
    movwf LATD,b

    movlw 08H
    movwf LATB,b

    call retardo

    clrf LATB,b

    return


tabla:
    movlb    04H             ; bank 4 / recuerda que este banco controla los pines 
    addwf    PCL,f,b
    retlw    3FH             ; 0
    retlw    06H             ; 1
    retlw    5BH             ; 2
    retlw    4FH             ; 3
    retlw    66H             ; 4
    retlw    6DH             ; 5
    retlw    7DH             ; 6
    retlw    07H             ; 7
    retlw    7FH             ; 8
    retlw    6FH             ; 9
    
    ; PORQUE PONEMOS ESTOS APAGADO ? 
    ; si en algun momento wreg es 10  u otro valor mas grande  protgege el display de que no se ejecute algo raro 
    retlw    00H             ; apagado
    retlw    00H             ; apagado
    retlw    00H             ; apagado
    retlw    00H             ; apagado
    retlw    00H             ; apagado
    retlw    00H             ; apagado


retardo:

    movlw 80
    movwf var2,a

xxx:

    decfsz var2,f,a
    goto xxx

    return

END