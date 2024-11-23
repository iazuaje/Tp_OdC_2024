;%include "macrosInputOutput.asm"
%include "tablero.asm"

global main

section .bss
    inputJugador        resb 1
    
section .data
    ;MENSAJES
    msjSeparador        db  "====================================",10,0
    msjTitulo           db  "=            EL ASALTO             =",10,0
    msjInputFila        db  "Ingrese la fila de la pieza que desea mover: ", 0
    msjInputColumna     db  "Ingrese la columna de la pieza que desa mover: ", 0
    msjInputError       db  "(ERROR) -- El valor ingresado es invalido, ingrese otro:", 10, 0
    msjJgSoldados       db  "Es el turno de los soldados (X):", 10, 0
    msjJgOficiales      db  "Es el turno de los oficiales (O):", 10, 0
    
    ;BOOLEANOS
    EligiendoColumna    db  0
    esTurnoSoldados     db  0
section .text
main:
    limpiarPantalla
    print   msjSeparador,0
    print   msjTitulo,0
    print   msjSeparador,0
    print   caracterConSalto,0
    ;===================
    call    imprimirTablero
    ;====================
    print   msjSeparador,0
    cmp     byte[esTurnoSoldados], 0
    je      turnoSoldados
    jmp     turnoOficiales
    
turnoSoldados:
    print   msjJgSoldados, 0
    print   msjSeparador, 0
    not     byte[esTurnoSoldados] ;Cambiamos de turno
    jmp     input
    
turnoOficiales:
    print   msjJgOficiales, 0
    not     byte[esTurnoSoldados] ;Cambiamos de turno
    jmp     input

input:
    cmp     byte[EligiendoColumna], 0
    je      inputFila
    jmp     inputColumna

inputFila:
    print   msjInputFila, 0
    jmp     input1
    
inputColumna:
    print   msjInputColumna, 0
    jmp     input1
    
input1:
    get     inputJugador
    cmp     byte[inputJugador], "p"
    je      fin
    jmp     validarInput

validarInput:
    cmp     byte[inputJugador], 48 ;ASCII para '0'
    jge     validarInput1
    jmp     inputErroneo
    
validarInput1:
    ;Nos aseguramos que la entrada del usuario sea menor o igual a 54 ('6' en ASCII)
    cmp     byte[inputJugador], 54
    jg      inputErroneo
        
    cmp     byte[EligiendoColumna], 0
    not     byte[EligiendoColumna]
    je      input

    ;Acá hacer las validaciones de movimiento respectivas
    jmp     main
    
    

inputErroneo:
    print   msjInputError, 0
    jmp     input
    
fin:
    ret