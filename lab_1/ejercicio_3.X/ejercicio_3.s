PROCESSOR 18F57Q43
    #include<xc.inc>
    #include<pic18f57q43.inc>
    #include "cabecera.inc"
    
    PSECT code, reloc = 2, abs
 variable1 equ 500H
 variable2 equ 501H
 variable3 equ 502H
 conteo equ 503H
 
 ; NUMEROS ALMACENAMOS EN LA ETIQUETAS NUMEROS PARA NUESTRO PUNTERO 
 
 ORG 000F00H
 ; NOTA PERO COMO LAS DIRECCIONES ESTAN EN 3 EN 3 TENGO QUE SUBIR DIRECCION POR DIRECCION 
 
 numeros:
    db 0x48 ; cuando pones 0x ya no pones el H 
    ORG 00F03H
    db 0x1C
    ORG 00F06H
    db 0x3B
    ORG 00F09H
    db 0x29
    org 00F0CH
    db 0x6F
    org 00F0FH
    db 0x53
    org 00F12H
    db 0xAB
    org 00F15H
    db 0x4E
    org 00F18H
    db 0x1D
    org 00F1BH
    db 0xFF	
 
 ORG 0H
 goto configuro
 ORG 20H
 
 configuro:
    movlb 0H
    movlw 60H
    movwf OSCCON1, b
    movlw 04H ; Seleccionamos el oscilador interno de 8MHz
    movwf OSCFRQ, b
    movlw 40H
    movwf OSCEN, b 
    
    ;configuracion de pines
    movlb 04H
    clrf TRISD, b ; puerto D en salida
    bsf TRISB, 0, b ; RB0 entrada
    
    clrf ANSELD, b ; digital
    bcf ANSELB, 0, b ; digital
    
    clrf LATD, b ; 0v al inicio 
    
    
    ; configuramos el valor de la variable conteo
   ; movlb 5H
    ;movlw 00000000B
    ;movwf conteo, b
    
 inicio: 
    ; vamos a la direccion con puntero !
    movlb 4H
    btfss PORTB, 0 , b ; boton presionado 
    goto inicio
    
    movlb 05H
    movlw 00000000B
    movwf conteo, b
  
    ; BANCO DE ACCESO DIRECTO -> CUANDO UTILIZAMOS EL a en vez del b 
    ; con accedes directamente Todos los" SFRs(registro funcion especial) " (F00H a FFFH) ? LATD, TBLPTRL, TABLAT, PORTB,OSCCON1, ANSELD, ETC
    ; osea sin hacer el movlb , pero si aun asi quieres poner el movlb lo banqueas al banco 0FH, SIMEPRE, SIN IMPORTAR DONDE GUARDAS TUS DATOS 
    ; tambien funciona para La RAM baja (000H a 05FH)
    
    
    movlw 00H
    movwf TBLPTRU, a
    movlw 0FH
    movwf TBLPTRH, a
    movlw 00H
    movwf TBLPTRL, a
    reproduccion: 
	
	TBLRD*  ;  leemos la informacion que apunta el puntero y subimos a tablat con este comando 
	movf TABLAT, w, a
	movlb 04H  ;vamos a trabajar con el pin asi que debemos pasar al banco de pines 
	movwf LATD, b 
	CALL retardo  
	;incrementamos en 3 la direccion 
	incf TBLPTRL, f , a
        incf TBLPTRL , f, a
	incf TBLPTRL, f , a
	movlb 05H 
	incf conteo, f, b
	movlw 10 ; numero natural
	cpfseq conteo, b ;
	goto reproduccion
	goto inicio
	
	
	  
    retardo: 
	movlw 150 ; cargamos 100 al registro w 
	movwf variable1, b ; guardamos el 100 en variable1 banqueado en banco 5 porque a esa direccion pertenece 
    ; este sera mi contador principal
    xxx:; mas adelante vamos a utilziar goto y vamos a volver..  1er bucle
	movlw 250
	movwf variable2, b ; 2do bucle 
    yyy: 
	movlw 50
	movwf variable3, b  ; 3er bucle 
    zzz: 
	decfsz variable3, 1,1 ; resta 1 y ese resultado se guarda autoamticament een la variable 3 y cuando llegue a 0 sale del bucle 
	goto zzz
    
	decfsz variable2, 1, 1
	goto yyy
    
	decfsz variable1, 1, 1 
	goto xxx
    
	return ; regresamos y ejecutamos la linea que sigue, regresamos porque hicimos un call 
    
    end 
    
    


