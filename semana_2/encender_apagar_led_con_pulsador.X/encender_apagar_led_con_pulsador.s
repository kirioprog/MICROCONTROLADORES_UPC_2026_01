    ; vamos a seguir trabajando con el oscildor externo
	; led enciende cuando presiono y apga cuando vuelvo a presionar 
	PROCESSOR 18F57Q43
	#include<xc.inc>
	#include<pic18f57q43.inc>
	#include"cabecera.inc"

	PSECT code, reloc = 2, abs
     variable1 equ 500H
     variable2 equ 502H
     variable3 equ 503H

     ORG 0H
     goto configuro
     ORG 20H
     configuro:
	movlb 0H 
	movlw 70H
	movwf OSCCON1, b

	movlw 80H
	movwf OSCEN, b

	; configuracion de pines
	movlb 04H
	;PINES DE ENTRADA
	bsf TRISF, 3, b ; pin RF3 como entrada (0 SALIDA, 1 ENTRADA) 
	bcf ANSELF, 3, b ; digital -> ( 0 digital, 1 analogico) 

	; PINES SALIDA
	bcf TRISD, 3, b ; RD3 salida
	bcf ANSELD, 3, b ; digital
	bcf LATD, 3, b ; el led empezara apagado. 0
        inicio:
    
	movlb 04H

    ; esperar a que el boton este sin presionar , porque como estamos presinamos y el oscilador es demasiado rapido cuenta varias presiones 
    espera_suelto:
	btfsc PORTF, 3, b      ; si el boton no esta presionado 
	goto espera_suelto     ; si el boton esta presionado 
                          

    ; como el boton no esta presionado verificamos 
    espera_presionado:
        btfss PORTF, 3, b      ;presionamos el boton 
        goto espera_presionado ; si el boton no esta presionado 

    ; 3) Toggle LED
        btg LATD, 3, b

    ; 4) Espera a que SUELTEN (RF3 = 0) para evitar múltiples toggles por rebote
    espera_liberacion:
        btfsc PORTF, 3, b      ; si RF3=1, sigue esperando liberación
        goto espera_liberacion
	
	goto inicio
    end 











