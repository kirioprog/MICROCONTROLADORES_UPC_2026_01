PROCESSOR 18F57Q43
#include <xc.inc>
#include <pic18f57q43.inc>
#include "cabecera.inc"

PSECT code, reloc=2, abs

valor    equ    00H          ; direccion 500H (Bank 5), es automatico 

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
    
    ;CONFIGURACION PINES 
    movlb    04H             ; banco 4 (TRISB ANSELB LATB)
    bsf      TRISB,4,b       ; RB4: Entrada
    bcf      ANSELB,4,b      ; RB4: Digital
    bsf      WPUB,4,b        ; RB4: Pull-Up
    ;WPU -> registro de control de pull ups , 
    ; en este caso ponemos en pull upp el pin RB4 
    
    movlw    00000000B       ; RD<7-0>: Salidas ( EN VEZ DE PONER EN HEXA, PONGO EN BINARIO) 
    movwf    TRISD,b
    
    clrf     ANSELD,b        ; RD<7-0>: Digital
    
    movlw    3FH   ; es el numero 0 en el 7 segmentos 0011 1111
    movwf    LATD,b          ; Display en valor 0
    
    movlb    05H             ; bank 5
    clrf     valor,b         ; se pone en 00000000 la variable valor 
    movlb    04H             ; bank 4

    
    
   ; NOTA:
   ; SIN PRESIONAR = 1  / PRESIONADO = 0
inicio:
    btfsc    PORTB,4 ; verificamos que el boton esta presionado 
    goto     inicio ; va a seguir espreando presiones el boton 
    
    ;HACEMOS COMO UNA DOBLE VERIFICACION 
    
    btfss    PORTB,4 ;  si el boton no esta presionado,osea lo sueltas 
    movlb    05H  ; pero si el boton si esta presionado 
    
    incf     valor,f,b ; como vimos que ya soltamos el boton, incrementa en 1 valor . 
    ; como valor inicialmente tenia 0 ahora +1 = 1 
    
    movlw    10
    cpfseq   valor ; comparamos el valor que tiene la variable valor con el registro w
    ; como contamos de 0 a 10, observa que lo comparams con 10 
    ; si son diferentes va a goto sigue, pero si son iguales reinicia el conteoo con clrf 
    
    goto     sigue
    clrf     valor,b

sigue: ; en esta etiqueta continuamos con el conteo 
    movf     valor,w ; copia lo que hay en valor a w. en este caso en valor hay 1 
    addwf    valor,w,b ; sumamos el valor del registro w con el de valor , en este caso  1 ´+1  = 2 
    ; este resultado se guarda en w
    
    call     tabla
    movwf    LATD,b ; Ya tenemos cargado el numero en w y lo sacamos 
    goto     inicio

tabla:
    movlb    04H             ; bank 4 / recuerda que este banco controla los pines 
    addwf    PCL,f,b         ; PCL = PCL + WREG (salta a la direccion del PCL)
    ; osea lo que va a pasar en este caso es que va ejecutar la linea wreg posiciones mas abajo de PCL	
    ;  EJEMPLO W es 2 va ejecutar la el 5BH 
    ; esto pasa por el PCL-> PROGRAM COUNTER  LOW(salto calculado) 
    ; tambien puedes aplicar el a 
    
    ;retlw -> returnn literal en w
    ; carga el valor , por ejemplo 5FH en  el registro w  y regresa a donde la llamaste (call  tabla) 
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
    
    ; PORQUE PONEMOS ESTOS APAGADO ? 
    ; si en algun momento wreg es 10  u otro valor mas grande  protgege el display de que no se ejecute algo raro 
    retlw    00H             ; apagado
    retlw    00H             ; apagado
    retlw    00H             ; apagado
    retlw    00H             ; apagado
    retlw    00H             ; apagado
    retlw    00H             ; apagado

end





