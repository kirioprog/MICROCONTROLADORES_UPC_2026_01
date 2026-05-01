PROCESSOR 18F57Q43 ; esta configuracion lo vas hacer siempre 
    #include <xc.inc>
    #include <pic18f57q43.inc>
    #include "cabecera.inc"
    
PSECT code, reloc = 2, abs  ; vamos dar inicio al programa

 ; definimos variables que despues la vamos a utilzar para nuestro retardo
 ; son direcciones de memoria y solo le doy un nombre+
 variable1 equ 500H
 variable2 equ 501H
 variable3 equ 502H
 
 ORG 0H ; a PARTIR DE AQUI EL PROGRAMA VA EMPEZAR A COLOCAR CODIGO, 0X00000
 
 goto configuro  ; le decimos al programa que va a saltar a configuro ... 
 
 ORG 20H  ; nos dice que configuro esta en la direccion 0x0020, en esta direccion porque va a saltar los vectores que estan ocupados
 
 configuro: 
    movlb 0H ; nos vamos a este banco porque aqui estan los registros que voy a utilizar para conf. el oscilador!
    movlw 60H ;  es el 0110 0000 en binario 
    ;  RECUERDA -> los  bit 4-6  nos dice que oscilador utilizar; los bit del 0-3 selecciona el divisor 
    ;110-> oscilador interno  ; 000 -> OSCILADOR EXTERNO 
    ;divisor 0000 ( sin division)- 0001(division entre 2) - 00010 ( division entre 4)   : OSEA 2 elevado al # binario
    movwf OSCCON1, b ; Con OSCCON1 seleccionamos el oscilador y dividir su frecuencia ya previamente cargado 60H
    
    ;NOTA SI UTILIZAMOS UN OSCILADOR EXTERNO NO USAMOS OSCFRQ NI OSCEN  
    
    movlw 02H  ; seleccionamos la frecuencia con la que queremos trabajar
    ; RECUERDA: el oscilador interno nos ofrece las siguientes frecuenicas 1,2,4,8,12,16,32,48,64 MHz
    ; accedemos a ello escogiendo por ejemmplo 00 ->1MHZ, 01 -> 2MHz, 02-> 4MHZ y asi en orden con lo de arriba
    ; en este caso estamos ecogiendo el 4MHz 
    movwf OSCFRQ, b ; vamos a configurar para que trabeje a	4MHz 
    
    movlw 40H  ; vamos habilitar el oscilador, osea lo vamos a prender el oscilador interno 
    ; 0100 0000 -> habilitamos el oscilador interno 
    ; NOTA : EL OSCILADOR INTERNO NO NECESITA SER HABILITITADO PORQUE ES EXTERNO . ASI QUE ESTO NO SE PONE 
    movwf OSCEN, b
    
    movlb 04H ; Nos vamos l banco 4 porque aqui estan los registros para configurar los pines  del pic 
    bcf TRISF,3 ,b ; -> BIT CLEAR FILE -> poner un bit a 0 
    ; TRISF -> controla los pines del puerto F, puede ser entrada(1) o salida(o); en este caso ponemos el RF3 en 0 -> salida
    
    bcf ANSELF, 3, b ;  EL ANSLEF define el pin como analogico (1) o digital(0)  en el pin RF3 
    
    bsf LATF, 3, b ; BIT SET FILE -> pone un bit en 1 , en este caso el RF3 estara en 1 
    ; LATF -> como es salida, define el valor que sale por el pin, al estar en 1 el RF3-> va a salir 5v o 3.3 V 
    ; NOTA SI  MI PIN ESTA COMO ENTRADA NO ES NECESARIO QUE LO UTILICE 
    
 ; VAMOS A ESCRIBIR LO QUE REALMENTE VA EJECUTAR EL PROGRAMA ! 
 inicio: 
    movlb 05H ; vamos a trabajar en el banco 5 porque aqui estan nuestras variables 500,501,502
    call retardo ; salta a retardo, ejecuta todo lo que hay ahi y vuelve a ejecutar la linea que sigue 
    movlb 04H ; regresamos al banco 4 porque volveremos a trabaar con los pines 
    btg LATF, 3, b ; BIT TOGGLE  -> cambia el bit, osea si estaba en 1 lo pasa a 0 y asi, en este caso para el RF3 
    ; como recuerdas el latf expula 0V o 1V  asi prendemos y apagamos el led 
    goto inicio ; volvemos a empezar y eso se vuelve un bucle infinito 
   
    ; vaos hacer un retardo de 100x250x5 = 125 000 iteracciones 
    ;1 iteraccion = 1 ciclo - > 1 / ( FOSC / 4 ) 
    ;FOSC -> en este caso pusimos 4MHZ enotnces  1 ciclo dura  1us
    ; en nuestro caso hay 2 intruccion esp or iteraccion decfsz y goto , entonces son 250 000 iteraccion s = 0.25 segundos. 
 retardo: 
    movlw 100 ; cargamos 100 al registro w 
    movwf variable1, b ; guardamos el 100 en variable1 banqueado en banco 5 porque a esa direccion pertenece 
    ; este sera mi contador principal
    xxx:; mas adelante vamos a utilziar goto y vamos a volver..  1er bucle 
    movlw 250
    movwf variable2, b ; 2do bucle 
    yyy: 
    movlw 5
    movwf variable3, b  ; 3er bucle 
    zzz: 
    decfsz variable3, 1,1 ; resta 1 y ese resultado se guarda autoamticament een la variable 3 y cuando llegue a 0 sale del bucle 
    goto zzz
    
    decfsz variable2, 1, 1
    goto yyy
    
    decfsz variable1, 1, 1 
    goto xxx
    
    return ; regresamos y ejecutamos la linea que sigue, regresamos porque hicimos un call 
    
    
     
    