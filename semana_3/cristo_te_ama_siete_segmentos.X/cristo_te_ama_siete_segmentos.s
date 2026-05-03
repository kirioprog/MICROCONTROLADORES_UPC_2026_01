 PROCESSOR 18F57Q43
    #include <xc.inc>
    #include <pic18f57q43.inc>
    #include "cabecera.inc"
    
    PSECT code, reloc=2, abs
 
 variable1 equ 500H
 variable2 equ 501H
 variable3 equ 502H
 
 ORG 0H
 goto configuro
 ORG 20H 
 
 configuro: 
    ; vamos a configurar nuetro oscildor como sisempre ; oscilador interno jeje 
    movlb 0H
    movlw 60H
    movwf OSCCON1, b 
    movlw 02H
    movwf OSCFRQ, b
    movlw 40H
    movwf OSCEN, b 
    
    
    ;VAMOS A CONFIGURAR NUESTROS PINES
    movlb 04H
     
    ;definimos como salida digital 
     clrf TRISD, b ; todos los pines del puerto D como digital ( 0 Salida, 1 entrada) 
     clrf ANSELD, b ; todos los pines como salida ( o digital, 1 analogico ) 
     clrf LATD, b ; al inciio todo estaran a 0v 
     
inicio: 
    movlw 39H ; C en el 7 segmentos 
    movwf LATD, b ; vamos a activar el C de cristo te ama, osea el LATD, madna en voltaje el numero que le damos 
    call retardo1
    movlw 50H 
    movwf LATD, b
    call retardo1
    movlw 06H
    movwf LATD, b
    call retardo1
    movlw 6DH
    movwf LATD, b 
    call retardo1
    movlw 78H
    movwf LATD, b
    call retardo1
    movlw 3FH
    movwf LATD, b
    call retardo1
    
    movlw 00H ; ESTE ES EL ESPACIO 
    movwf LATD, b
    call retardo1
    
    movlw 78H
    movwf LATD, b
    call retardo1
    movlw 79H
    movwf LATD, b
    call retardo1
    movlw 77H
    movwf LATD, b
    call retardo1
    movlw 37H
    movwf LATD, b
    call retardo1
    movlw 77H
    movwf LATD, b
    call retardo1
    goto inicio
    
    retardo1: 
    movlb 5H ; porque aqui guardamos nuestar variables para el retardo 
    movlw 100
    movwf variable1, b
    
    xxx:
    movlw 110
    movwf variable2,b 
    yyy: 
    movlw 20
    movwf variable3, b 
    zzz:
    ; AQUI YA VAMOS A EMPEZAR A DESCONTAR EN 1 EN 1 , y como observas de la ultima a la primera variable 
    decfsz variable3,1, 1
    goto zzz ; asi hacemos que siga que siga descoentando 
    
    decfsz variable2,1,1
    goto yyy
    
    decfsz variable1,1,1
    goto xxx
    
    movlb 04H; nos volvemos al banco 4 (    aun no se porque ) 
    
    return 
    
    end 
    
    
    
    


