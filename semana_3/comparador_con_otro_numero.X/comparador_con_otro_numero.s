; vamos ingresar un numero utilizando 2 swith de 4 patitas 
    PROCESSOR 18F57Q43
    #include <xc.inc>
    #include <pic18f57q43.inc>
    #include "cabecera.inc"
    
    PSECT code, reloc=2, abs
 Numero equ 500H
 ORG 0H
 goto configuro
 ORG 20H
 
 configuro:
    movlb 0H 
    movlw 60H
    movwf OSCCON1, b 
    movlw 02H
    movwf OSCFRQ,b 
    movlw 40H
    movwf OSCEN,b 
    
    ; VAMOS A CONFIGURAR EL PIN DEL NUMERO , SERA ENTRADA DIGITAL 
    ; AHORA TAMBIEN LOS PINES DEL LED QUE NOS DIRA SI ES MAYOR, MENOR O NINGUNO
    
    
    ; 0 DIGITAL, 1 ANALOGICO 
    movlb 04H
    clrf ANSELB, b ; al poner todo en 0 ponemos todos los pines del puerto B DIGITAL, ( 1 ANALOGICO ) 
    clrf ANSELD, b; aqui estaran conectados nuestro led  ( TAMBIEN DIGITAL) 
    
    ; vamos a configurar si es salida o entrada (0 SALIDA, 1 ENTRADA  ) 
    movlw 0FFH ; ese numero en hexadecimal es el nuero 1111 1111 en binario 
    movwf TRISB, b 
    clrf TRISD, b 
    
    ; COMO TENEMOS UNA SALIDA, VAMOS A DEFINIR SI LA SALIDA SERA EN BAJO O ALTO
    clrf LATD, b 
    
inicio:
    movlb 4H ; porque recurda que esn ete banco se encarga de los pines
    movf PORTB, w, b ;
    movlb 05H ; nos vamos al banco 5  porque recuerd que ahi ubicamos nuestra variable numero 
    movwf numero, b ; el valor que recogimos de la entrada de puerto b lo pasamos a nuesta variable numero 
    
    ; VAMOS A INICIAR CON LAS EVALUACIONES ! 
    movlw 200 .
    cpfsgt numero,b ; le pregunta si numero es mayor a w ; si es verdad salta la siguiente linea 
    
    goto evaluar_menor
    goto si_es_mayor_numero
    
    evaluar_menor:
    
    movlw 70 ; la otra opcion es que sea menor queeste  entre 70 y  200 
    
    cpfslt numero, b ; le preguntamos si numero es  menor que w 
    goto es_medio
    goto confirmado_es_menor
    
    si_es_mayor_numero:
    movlb 04H ; nos vamos nuevamente al banco 4 en donde controlamos los pines
    movlw 01H ; vamos a prener el pine 1 por eso el numero 1 conectado al RD0 
    movwf LATD, b  ; al pin 1 le vamos a entregar 5v por osea 0000 0001 
    goto inicio: ; volvemos para que el bucle continue
    
    confirmado_es_menor:
    movlb 04H
    movlw 02H ; vamos a prender el segundo led, conectdo al RD1 
    movwf LATD, B ; VAMOS A MANDAR 5V POR ESE PIN 
    goto inicio; volvemos al bucle 
    
    es_medio: 
    movlb 04H
    clrf LATD, b ; el problema nos dice que cuando no cumpla ninguna de las 2 conidicoes pagamos ambos leds 
    goto inicio 
    
    end