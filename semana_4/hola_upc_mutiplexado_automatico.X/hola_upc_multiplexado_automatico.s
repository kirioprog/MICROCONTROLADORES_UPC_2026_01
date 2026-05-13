PROCESSOR 18F57Q43
    #include<xc.inc>
    #include<pic18f57q43.inc>
    #include"cabecera.inc"
    
    ;define_XTAL_FREQ 4000000UL ;  definimos una frecuenica de 4MHZ / Sirve para utilzar delay 
    PSECT code, reloc = 2 , abs
 ; retardo
 variable1 equ 500H
 variable2 equ 501H
 ; retardo2 
 
 valor equ 505H

 
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
    
     
    ; PIN QUE CONTROLA EL SELECTOR DEL MULTIPLEXOR/ los transistores  / 4 DISPLAY 
    movlw 11110000B ; -> B7 - B0 
    movwf TRISB, b ; B0-B3 salida
    clrf ANSELB, b ; digital
    clrf LATB, b ; empieza en 0v 
    
inicio:
    movlb 05H
    clrf valor, b
    goto hola

    
    hola:
	clrf TBLPTRU, a ; en vez de hacer el movwf 00H y luego el movwf como todo es 0 pasamos degrente con el clrf 
	movlw 03H
	movwf TBLPTRH, a
	clrf TBLPTRL, a
	call multiplexor
	
	movlb 05H
	incf valor, f, b
	movlw 250
	cpfseq valor, b 
	goto hola
	goto arreglar_contador
	
    arreglar_contador:
	movlb 05H
	clrf valor, b
	goto upc

    upc:
	clrf TBLPTRU, a
	movlw 04H
	movwf TBLPTRH, a
	clrf TBLPTRL, a
	call multiplexor
	movlb 05H
	incf valor, f, b
	movlw 250
	cpfseq valor, b 
	goto upc
	goto inicio
	
    multiplexor:
	TBLRD*+ ; LEEMOS LOS DATOS A LOS QUE APUNTAMOS TBLPTR ->pasamos al registro TABLAT -> incrementamos el TBLPTR en 1 
	; osea ya no hacemos el incf 
	; OJO: TAMBIEN LO PUEDES HACER CON - 
	movff TABLAT, LATD ; copiamos el vlaor de tablat a latd 
	bsf LATB, 3, a ; ASI IMPRIMIMOS EL PIN EN LA POSICION DESCONTAR	

	; pasamos al banco 5 porque recurda que ahi esta nuestra variable1 variable2 
	movlb 05H
	call retardo
	movlb 04H
	bcf LATB,3, a

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
	return
	
   
	    
    retardo:
    movlb 05H
	movlw 10
	movwf variable1, b
    mmm:
	movlw 110
	movwf variable2, b
    nnn:
	decfsz variable2, 1, 1
	goto nnn
	decfsz variable1, 1, 1 
	goto mmm
	return
    
  
 	
	end 
    
	    
	    
	
	
    
	

  
    
    
    
    







