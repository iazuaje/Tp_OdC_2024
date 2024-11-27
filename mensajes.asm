section .data
    msjSeparador                db  "====================================",10,0
    msjTitulo                   db  "=            EL ASALTO             =",10,0
    msjInputFila                db  "Ingrese la fila de la pieza que desea mover: ", 0
    msjInputColumna             db  "Ingrese la columna de la pieza que desea mover: ", 0
    msjInputFilaDestino         db  "Ingrese la fila de la ubicacion a la que desea moverse: ", 0
    msjInputColumnaDestino      db  "Ingrese la columna de la ubicacion a la que desea moverse: ", 0
    msjInputError               db  "(ERROR) -- El valor ingresado es invalido, ingrese otro:", 10, 0
    msjJgSoldados               db  "Es el turno de los soldados (X):", 10, 0
    msjJgOficiales              db  "Es el turno de los oficiales (O):", 10, 0
    msjOrigenInvalido           db  "(ERROR) -- Coordenada invalida, ingrese otras coordenadas:",10,0

section .text
global mensajes

mostrarMensajeComienzoDeTurno:
    call    printMensajeTurnoSoldado
    call    printMensajeTurnoOficial
    ret

printMensajeTurnoSoldado:
    cmp     byte[esTurnoSoldados],0
    jne     volverARutina 
    ;====================
    print   msjJgSoldados, 0
    print   msjSeparador, 0
    ;====================
    ret
    
printMensajeTurnoOficial:
    cmp     byte[esTurnoSoldados],0
    je      volverARutina 
    ;====================
    print   msjJgOficiales, 0
    print   msjSeparador, 0
    ;====================
    ret
    
printMensajeFilaOrigen:
    cmp     byte[EligiendoDestino],0
    jne     volverARutina
    
    print   msjInputFila, 0
    ret

printMensajeFilaDestino:
    cmp     byte[EligiendoDestino],0
    je      volverARutina
    
    print   msjInputFilaDestino, 0
    ret
    
printMensajeColumnaOrigen:
    cmp     byte[EligiendoDestino],0
    jne     volverARutina
    
    print   msjInputColumna, 0
    ret
    
printMensajeColumnaDestino:
    cmp     byte[EligiendoDestino],0
    je      volverARutina
    
    print   msjInputColumnaDestino, 0
    ret
    
mostrarInputInvalido:
    print   msjInputError, 0
    mov     rax, 0 ;Aseguramos que el error es levantado
    ret    