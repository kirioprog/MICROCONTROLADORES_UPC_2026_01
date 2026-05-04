PROCESSOR 18F57Q43
    #include <xc.inc>
    #include <pic18f57q43.inc>
    #include "cabecera.inc"
    
    PSECT code, reloc = 2, abs
 
 variable1 equ 500H
 variable2 equ 501H
 variable3 equ 502H
 valor equ 503H
 
 ORG 0H
 goto configuro
 ORG 20H
 
 configuro:
    movlw 60H
    movwf OSCCON1, a
    movlw 02H
    movwf OSCFRQ, a
    movlw 40H
    movwf OSCEN, a
    
    ; definimos pines, salida,digital
    clrf ANSELD, a ; digital
    clrf TRISD, a ; salida
    clrf LATD, a  ; 0v 
    
    
inicio: 
    movlb 5H
    clrf valor, b 
    conteo: 
	movlw 2
	addwf valor, f, a 
	addwf valor, w, a 
	movwf LATD, a 
	call retardo
	movlw 254
	cpfseq valor, a
	goto conteo
	goto inicio
    

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
    
    
    


