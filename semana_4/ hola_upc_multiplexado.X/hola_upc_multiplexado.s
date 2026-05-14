PROCESSOR 18F57Q43
    #include<xc.inc>
    #include<pic18f57q43.inc>
    #include"cabecera.inc"
    
    ;#define_XTAL_FREQ 4000000UL ;  definimos una frecuenica de 4MHZ / Sirve para utilzar delay 
    PSECT code, reloc = 2 , abs
 
 variable1 equ 500H
 variable2 equ 501H
 descontar equ 502H

 
 ORG 000300H
 mensaje1 : db 76H, 3FH, 38H, 77H ; con puntero almacenamos la palabra HOLA 
 
 ORG 000400H
 mensaje2 : db 00H, 3EH, 73H, 39H ; con puntero almacenamos la palabra UPC

 ORG 0H
 goto configuro
 ORG 20H 
 
 configuro: 
    movlb 00H
    movlw 60H
    movwf OSCCON1, b 
    movlw 02H
    movwf OSCFRQ, b 
    movlw 40H
    movwf OSCEN, b 
    
    ; pines del display 8 pines 
    movlb 04H
    clrf TRISD, b  ; salida PUERTO D
    clrf ANSELD, b ; digital PUERTO D
    clrf LATD, b ; salida empieza en 0v 
    
    ; seleccionamos el mensaje a salir HOLA o MUNDO 
    bsf TRISA,0,  b ; entrada RA0
    bcf ANSELA,0 , b ; digital RA0
     
    ; PIN QUE CONTROLA EL SELECTOR DEL MULTIPLEXOR/ los transistores  
    movlw 11110000B ; -> B7 - B0 
    movwf TRISB, b ; B0-B3 salida
    clrf ANSELB, b ; digital
    clrf LATB, b ; empieza en 0v 
    
inicio:
    btfss PORTA,0  ; cuando activamos el interruptor pasamos a upc , asi que al inicio empieza con hola automaticamente 
    goto hola
    goto upc
    
    hola:
	clrf TBLPTRU, a ; en vez de hacer el movwf 00H y luego el movwf como todo es 0 pasamos degrente con el clrf 
	movlw 03H
	movwf TBLPTRH, a
	clrf TBLPTRL, a
	goto multiplexor
    
    upc:
	clrf TBLPTRU, a
	movlw 04H
	movwf TBLPTRH, a
	clrf TBLPTRL, a 
	goto multiplexor
	
    multiplexor:
	TBLRD*+ ; LEEMOS LOS DATOS A LOS QUE APUNTAMOS TBLPTR ->pasamos al registro TABLAT -> incrementamos el TBLPTR en 1 
	; osea ya no hacemos el incf 
	; OJO: TAMBIEN LO PUEDES HACER CON - 
	movff TABLAT, LATD ; copiamos el vlaor de tablat a latd 
	bsf LATB, 3, b ; ASI IMPRIMIMOS EL PIN EN LA POSICION DESCONTAR	

	; pasamos al banco 5 porque recurda que ahi esta nuestra variable1 variable2 
	movlb 05H
	call retardo
	movlb 04H
	bcf LATB,3, b

	TBLRD*+ 
	movff TABLAT, LATD 
	bsf LATB, 2, b 	 
	movlb 05H
	call retardo
	movlb 04H
	bcf LATB,2, b

	TBLRD*+ 
	movff TABLAT, LATD 
	bsf LATB, 1, b 	 
	movlb 05H
	call retardo
	movlb 04H
	bcf LATB,1, b


	TBLRD*+ 
	movff TABLAT, LATD 
	bsf LATB, 0, b 	 
	movlb 05H
	call retardo
	movlb 04H
	bcf LATB,0, b
	goto inicio
	    
    retardo:
	movlw 3
	movwf variable1, b
    xxx:
	movlw 110
	movwf variable2, b
    yyy:
	decfsz variable2, 1, 1
	goto yyy
	decfsz variable1, 1, 1 
	goto xxx
	return
	
	end 
    
	    
	    
	
	
    
	

  
    
    
    
    



