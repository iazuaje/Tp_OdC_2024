%include "macrosInputOutput.asm"
global main

section .bss
    inputJugador        resb 1
    
section .data
    msjInput            db  "Ingrese su movimiento:", 10, 0
    msjInputError       db  "El valor ingresado es invalido, ingrese otro:", 10, 0
    msjJgSoldados       db  "Turno de los soldados:", 10, 0
    msjJgOficiales      db  "Turno de los oficiales:", 10, 0
    esTurnoSoldados     db  0
section .text
main:
    limpiarPantalla
    ;ACÁ IRÍA DIBUJAR EL TABLERO
    cmp byte[esTurnoSoldados], 0
    je turnoSoldados
    jmp turnoOficiales
    
turnoSoldados:
    print msjJgSoldados, 0
    ;logica para soldados
    not byte[esTurnoSoldados]
    jmp input
    
turnoOficiales:
    print msjJgOficiales, 0
    ;Logica para oficiales
    not byte[esTurnoSoldados]
    jmp input

input:
    print msjInput, 0
    get inputJugador
    cmp byte[inputJugador], "p"
    je fin
    cmp byte[inputJugador], "y"
    je main
    cmp byte[inputJugador], "n"
    je main
    jmp inputErroneo
    
inputErroneo:
    print msjInputError, 0
    jmp input
    
fin:
    ret