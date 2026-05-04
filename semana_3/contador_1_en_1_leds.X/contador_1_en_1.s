PROCESSOR 18F57Q43
    #include<xc.inc>
    #include<pic18f57q43.inc>
    #include "cabecera.inc"
    PSECT code, reloc=2, abs 
 
 variable1 equ 500H ; vamos a reemplazar estas direcciones en el banco 5 por dichos nombres
 variable2 equ 501H
 variable3 equ 502H
 
 ORG 0 
 goto configuro 
 ORG 20 
 configuro:
    movlb 0H ; nos vamos al banco 0  por los registros  del oscilador (VAMOS A UTIILZAR OSCILADOR INTERNO) 
    movlw 60H
    movwf OSCCON1, b 
    movlw 2H
    movwf OSCFRQ,b 
    movlw 40H
    movwf OSCEN, b 
    
    ; VAMOS A CONFIGURAR LOS PINES QUE VAMOS A UTLIZAR 
    movlb 4H ; nos vamos al banco 4  porque aqui estan los registros que controlan  los pines
    clrf TRISD,b ; 0 salida, 1 entrada ) 
    clrf ANSELD, b ;( 0 digital, 1 analogico) 
    clrf LATD, b 
    
 inicio: 
    incf LATD, b  ; vamos a sumar 1 al valor actual que hay en el puerto D , banqueamos al banco 4( ahi definimos los pines) 
    ;el incf lo que hace es incrementar 
    ; recuerda que pusimos todos nuestros pines en 0 osea el numero seria 0000 0001, si le aumentamos en 1 etc.. 
    call retardo ; vamos a retardo y luego regresamos
    goto inicio  ; asi nos encerramos en el bucle.. 
    
  retardo:
    ; LOS NUMEROS QUE PONGAN EN EL RETARDO TIENEN QUE SER <255  por los 8 bits 
    movlw 100
    movwf variable1, b ; en este caso variable 1 dira cuantas vecez se repite todo el bloque interno
    
    xxx:
    movlw 250
    movwf variable2,b ; itera la variable2, 200 vecez
    yyy: 
    movlw 5
    movwf variable3, b
    zzz:
    decfsz variable3, 1, 1 ; le vamos a restar uno a la variable 3 y saltara a la siguiente linea cuando el resultado sea 0 
    ;1,1 -> el variable se guarda en la misma memoria, si fuera 0 se guarda en w , el otro 1 signifca que respeta mi banco 
    goto zzz ; el goto nos va a permitir que se siga descontando entrando a un bucle 
    decfsz variable2, 1, 1 ; vamos a ir contando al revez, osea 250,249,etc, el decfsz decrementa el valor del registro
    goto yyy 
    decfsz variable1, 1,1
    goto xxx 
    return  ; damos por finalizado el retardo y volvemo a donde al retado 
    
    end 


