 PROCESSOR 18F57Q43  

#include <xc.inc>

#include <pic18f57q43.inc>

#include "cabecera.inc"

PSECT code, reloc=2, abs

variable1 equ 500H

variable2 equ 501H

variable3 equ 502H
ORG 000500H ; AQUI VAMOS ALMACENAR LOS DATOS DE LA TABLA, LOS DEL EJERCICIO
numero: db 0x04H, 0xAFH, 0xBEH,0x89H ; numero es l etiqueta, db significa definir byte y estos valores se van almacenar				
; en la direccion numero + 0, numero +1, etc , COM OPUEDES VER LA DIRECCION NUMERO ES 000500H PORQWUE HICIMOS EL STALTO HASTA AQUI 
ORG 0 ; recuerda que aqui inicia el prohgrama cuando lo  prendo 
goto configuro ; hacemos un salto a la etiqueta configuro para evitar los vectores 
ORG 20 ; aqui termina el salto 

 
 configuro:
    movlb 0 ; vamos al banco 0 porque aqui estan los registros del oscilador
    movlw 60 
    movwf OSCCON1, b ; contorlamos el selector del oscilador 
    movlw 2
    movwf OSCFRQ,b
    movlw 40
    movwf OSCEN, b
    movlb 4 ; NOS MOVEMOS AL BANCO 4 
    clrf TRISD,b  ; VAMOS A TRABAJAR CON EL PUERTO D POR ESO PONEMOS AL FINAL LA D
		   ; el clrf pone todos los pines del puerto D en 0 , y recuerda 0 es ponerlos como slaida y 1 entrada
    clrf ANSELD, b ; configuramos todos los pines como  puerto digital porque 0 es digital y 1 es analogic
    clrf LATD, b ; ponemos todos los pindes del puerto D a 0v porque 0 es low y 1 es high 
				
				
; VAMOS A INICAR CON EL BUCLE PIRNCIPAL
inicio: ; es la etiqueta que le damos para iniciar toedo  
    
    ; VAMOS IR AL PUNTERO 000500H que es en donde ubicamos nuetra etiqueta numero lineas mas arribas con el	ORG
    
    movlw 00 ; nos vamos al registro 0 del banoc 5 en donde estsmos ubicados
    movwf TBLPTRU,b ; Vamos a poner el la tabal de puntero en la parte de mayor pero el 00 
    movlw 05 
    movwf TBLPTRH, b ; ahora en los sigueintes y ves que se va armando el 0005 
    movlw 00
    movwf TBLPTRL, b ; y estos son los 2 ultimos numeros que faltaban ahora yua tenemos la direccio del purneto 000500
    
    TBLRD* ; VAMOS A LEER LOS DATOS QUE ESTAN APUNTANDO A LA DIRECCCIONDE PTR OSEA LOS QUE ACABMOS DE SUBIR Y COPIARLOS AL REGISTRO TABLAT 
    movf TABLAT,w, b ; vamos a mover el dato leido desde tablat al registro w .  pero en este caso el primer bit osea el numero 0x04H que definimos en numero
    movwf LATD, b ; este dato se envia al puerto D osea en el puerto de desde puerto D0 hasta el D7 va a salir el numero 04 que es 0000 0100, osea el RD2 va estar en 1
    CALL retardo
    
    incf TBLPTRL, f, b ; incrementamos el puntero de tabla para el siguiente dato osea vmaos acceer al segundo dato que pusimos en numero 
			; el f signfic que guarda el dato en el mismo rgistro osea la acutalizacionj 
			; ahora apunta a 0x000501
    TBLRD*
    movf TABLAT, w, b 
    movwf LATD, b
    CALL retardo
    
    incf TBLPTRL,f, b ; ahora apunta a 0x000502H
    TBLRD*
    movf TABLAT, w, b
    movwf LATD,b
    CALL retardo
    
    incf TBLPTRL,f, b ; ahora paunta a 0x000503H
    TBLRD*
    movf TABLAT, w, b 
    movwf LATD, b
    goto inicio ; y asi generamos nuetro bucle infinito . se va reiniccar cimpre 
    
   
retardo:
    movlw 100
    movwf variable1,b ; banqueado en el banco 5 porque recueda que la direccion pertenece al banco 5 
xxx:
    movlw 250
    movwf variable2, b
yyy:
    movlw 5 
    movwf variable3, b
zzz:
    decfsz variable3,1,1 ; resta 1  y ese resultado se guarda autoamticamente en la variable3 y cuando llegue a 0 ahi recien salta a la siguiente linea 
    goto zzz ; ponemos el goto para que regrese y le siga restando 1 asi hasta que llegue a 0 
    decfsz variable2,1,1
    goto yyy ; porque la variable2 lo pousimos dentro de la etiqueta yyy
    decfsz variable1,1,1
    goto xxx
    return ; regresamos a donde llamamos a retardo
    
end 