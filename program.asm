;%include "macrosInputOutput.asm"
%include "tablero.asm"

global main


%macro guardarPosicion 1

    mov     rdi, inputJugador
    mov     rsi, formateoInt
    mov     rdx, %1
    
    sub     rsp, 8
    sub     rax, rax
    call    sscanf
    add     rsp,8
    

    
%endmacro

section .bss
    inputJugador        resb 1
    
section .data
    ;MENSAJES
    msjSeparador                db  "====================================",10,0
    msjTitulo                   db  "=            EL ASALTO             =",10,0
    msjInputFila                db  "Ingrese la fila de la pieza que desea mover: ", 0
    msjInputColumna             db  "Ingrese la columna de la pieza que desea mover: ", 0
    msjInputFilaDestino         db  "Ingrese la fila de la ubicacion a la que desea moverse: ", 0
    msjInputColumnaDestino      db  "Ingrese la columna de la ubicacion a la que desea moverse: ", 0
    msjInputError               db  "(ERROR) -- El valor ingresado es invalido, ingrese otro:", 10, 0
    msjJgSoldados               db  "Es el turno de los soldados (X):", 10, 0
    msjJgOficiales              db  "Es el turno de los oficiales (O):", 10, 0
    msjOrigenInvalido           db  "(ERROR) -- No hay pieza disponible para seleccionar, ingrese otras coordenadas:",10,0
    
    formateoInt         db  "%i",0
    
    ;BOOLEANOS
    EligiendoColumna    db  0


section .text
main:
    limpiarPantalla
    
    ;===================
    print   msjSeparador,0
    print   msjTitulo,0
    print   msjSeparador,0
    print   caracterConSalto,0
    call    imprimirTablero
    print   msjSeparador,0
    ;====================
    
    cmp     byte[esTurnoSoldados], 0
    je      turnoSoldados
    jmp     turnoOficiales
    
turnoSoldados:
    ;====================
    print   msjJgSoldados, 0
    print   msjSeparador, 0
    ;====================
    
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
    cmp     byte[EligiendoDestino],0
    je      inputFilaOrigen
    print   msjInputFilaDestino, 0
    jmp     input1
    
inputFilaOrigen:
    print   msjInputFila, 0
    jmp     input1
    
inputColumnaOrigen:
    print   msjInputColumna, 0
    jmp     input1

inputColumna:
    cmp     byte[EligiendoDestino],0
    je     inputColumnaOrigen
    print   msjInputColumnaDestino, 0
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
    je      guardarPosicionFila
    jmp     guardarPosicionColumna
    
    
guardarPosicionFila:
    cmp     byte[EligiendoDestino], 0
    je      guardarPosicionFilaOrigen
    
    guardarPosicion posFilaDestino
    not     byte[EligiendoColumna]
    jmp     input
    
guardarPosicionColumna:
    cmp     byte[EligiendoDestino], 0
    je      guardarPosicionColOrigen
    
    guardarPosicion posColDestino
    not     byte[EligiendoColumna]
    jmp     validarPiezaElegida
    
guardarPosicionFilaOrigen:
    guardarPosicion posFilaOrigen
    not     byte[EligiendoColumna]
    jmp     input 
    
guardarPosicionColOrigen:
    guardarPosicion posColOrigen
    not     byte[EligiendoColumna]
    jmp     validarPiezaElegida
    
    
validarPiezaElegida:
    call    esPosicionOrigenValida
    cmp     rax,0 ; el rax guarda el resultado de la rutina anterior
    je      mostrarOrigenInvalido
    
    not     BYTE[EligiendoDestino]
    cmp     BYTE[EligiendoDestino],0
    je      main
    jmp     input     

inputErroneo:
    print   msjInputError, 0
    jmp     input
    
mostrarOrigenInvalido:
    print   msjOrigenInvalido, 0
    jmp     input

fin:
    ret