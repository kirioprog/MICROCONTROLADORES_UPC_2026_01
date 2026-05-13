PROCESSOR 18F57Q43
    #include<xc.inc>
    #include<pic18f57q43.inc>
    #include"cabecera.inc"

    PSECT code, reloc = 2 , abs

 variable1 equ 500H
 variable2 equ 501H
 valor     equ 505H

 ; ROM 8:28 - "TODO OBRA PARA BIEN DE LOS QUE AMAN A DIOS"
 ORG 000300H
 msg_TODO: db 78H, 3FH, 5EH, 3FH   ; TODO

 ORG 000310H
 msg_OBRA: db 3FH, 7CH, 50H, 77H   ; OBRA

 ORG 000320H
 msg_PARA: db 73H, 77H, 50H, 77H   ; PARA

 ORG 000330H
 msg_BIEN: db 7CH, 06H, 79H, 37H   ; BIEN

 ORG 000340H
 msg_DE:   db 00H, 00H, 5EH, 79H   ; _  _ D E

 ORG 000350H
 msg_LOS:  db 00H, 38H, 3FH, 6DH   ; _  L O S

 ORG 000360H
 msg_QUE:  db 00H, 67H, 3EH, 79H   ; _  Q U E

 ORG 000370H
 msg_AMAN: db 77H, 55H, 77H, 37H   ; AMAN

 ORG 000380H
 msg_A:    db 00H, 00H, 00H, 77H   ; _  _  _  A

 ORG 000390H
 msg_DIOS: db 5EH, 06H, 3FH, 6DH   ; DIOS

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

    movlb 04H
    clrf TRISD, b
    clrf ANSELD, b
    clrf LATD, b

    movlw 11110000B
    movwf TRISB, b
    clrf ANSELB, b
    clrf LATB, b

inicio:
    movlb 05H
    clrf valor, b

    ; --- TODO ---
w_TODO:
    clrf TBLPTRU, a
    movlw 03H
    movwf TBLPTRH, a
    movlw 00H
    movwf TBLPTRL, a
    call multiplexor
    movlb 05H
    incf valor, f, b
    movlw 250
    cpfseq valor, b
    goto w_TODO
    movlb 05H
    clrf valor, b

    ; --- OBRA ---
w_OBRA:
    clrf TBLPTRU, a
    movlw 03H
    movwf TBLPTRH, a
    movlw 10H
    movwf TBLPTRL, a
    call multiplexor
    movlb 05H
    incf valor, f, b
    movlw 250
    cpfseq valor, b
    goto w_OBRA
    movlb 05H
    clrf valor, b

    ; --- PARA ---
w_PARA:
    clrf TBLPTRU, a
    movlw 03H
    movwf TBLPTRH, a
    movlw 20H
    movwf TBLPTRL, a
    call multiplexor
    movlb 05H
    incf valor, f, b
    movlw 250
    cpfseq valor, b
    goto w_PARA
    movlb 05H
    clrf valor, b

    ; --- BIEN ---
w_BIEN:
    clrf TBLPTRU, a
    movlw 03H
    movwf TBLPTRH, a
    movlw 30H
    movwf TBLPTRL, a
    call multiplexor
    movlb 05H
    incf valor, f, b
    movlw 250
    cpfseq valor, b
    goto w_BIEN
    movlb 05H
    clrf valor, b

    ; --- DE ---
w_DE:
    clrf TBLPTRU, a
    movlw 03H
    movwf TBLPTRH, a
    movlw 40H
    movwf TBLPTRL, a
    call multiplexor
    movlb 05H
    incf valor, f, b
    movlw 250
    cpfseq valor, b
    goto w_DE
    movlb 05H
    clrf valor, b

    ; --- LOS ---
w_LOS:
    clrf TBLPTRU, a
    movlw 03H
    movwf TBLPTRH, a
    movlw 50H
    movwf TBLPTRL, a
    call multiplexor
    movlb 05H
    incf valor, f, b
    movlw 250
    cpfseq valor, b
    goto w_LOS
    movlb 05H
    clrf valor, b

    ; --- QUE ---
w_QUE:
    clrf TBLPTRU, a
    movlw 03H
    movwf TBLPTRH, a
    movlw 60H
    movwf TBLPTRL, a
    call multiplexor
    movlb 05H
    incf valor, f, b
    movlw 250
    cpfseq valor, b
    goto w_QUE
    movlb 05H
    clrf valor, b

    ; --- AMAN ---
w_AMAN:
    clrf TBLPTRU, a
    movlw 03H
    movwf TBLPTRH, a
    movlw 70H
    movwf TBLPTRL, a
    call multiplexor
    movlb 05H
    incf valor, f, b
    movlw 250
    cpfseq valor, b
    goto w_AMAN
    movlb 05H
    clrf valor, b

    ; --- A ---
w_A:
    clrf TBLPTRU, a
    movlw 03H
    movwf TBLPTRH, a
    movlw 80H
    movwf TBLPTRL, a
    call multiplexor
    movlb 05H
    incf valor, f, b
    movlw 250
    cpfseq valor, b
    goto w_A
    movlb 05H
    clrf valor, b

    ; --- DIOS ---
w_DIOS:
    clrf TBLPTRU, a
    movlw 03H
    movwf TBLPTRH, a
    movlw 90H
    movwf TBLPTRL, a
    call multiplexor
    movlb 05H
    incf valor, f, b
    movlw 250
    cpfseq valor, b
    goto w_DIOS

    goto inicio   ; loop infinito, vuelve a TODO

multiplexor:
    movlb 04H
    TBLRD*+
    movff TABLAT, LATD
    bsf LATB, 3, b
    movlb 05H
    call retardo
    movlb 04H
    bcf LATB, 3, b
    TBLRD*+
    movff TABLAT, LATD
    bsf LATB, 2, b
    movlb 05H
    call retardo
    movlb 04H
    bcf LATB, 2, b
    TBLRD*+
    movff TABLAT, LATD
    bsf LATB, 1, b
    movlb 05H
    call retardo
    movlb 04H
    bcf LATB, 1, b
    TBLRD*+
    movff TABLAT, LATD
    bsf LATB, 0, b
    movlb 05H
    call retardo
    movlb 04H
    bcf LATB, 0, b
    return

retardo:
    movlb 05H
    movlw 7
    movwf variable1, b
mmm:
    movlw 50
    movwf variable2, b
nnn:
    decfsz variable2, 1, 1
    goto nnn
    decfsz variable1, 1, 1
    goto mmm
    return

    end