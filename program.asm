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

%macro macroMatarOficial 0
    
    call validarCasillaParaOficial
    cmp rax,1
    je  matarOficial
    
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
    msjOrigenInvalido           db  "(ERROR) -- Coordenada invalida, ingrese otras coordenadas:",10,0
    
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
    call    esPosicionValida
    cmp     rax,0 ; el rax guarda el resultado de la rutina anterior
    je      mostrarOrigenInvalido
    
    not     BYTE[EligiendoDestino]
    cmp     BYTE[EligiendoDestino],0
    je      moverPieza
    jmp     input     

moverPieza:  
    sub  rax,rax
    
    cmp  BYTE[esTurnoSoldados],0
    je   cambiarFichaOficial
    
    
    obtenerCaracterIndice posFilaDestino, posColDestino
    mov BYTE[matriz + rbx + 1], 'X'  
              
    obtenerCaracterIndice posFilaOrigen, posColOrigen          
    mov  BYTE[matriz + rbx +1], ' '
    
    jmp main    

cambiarFichaOficial:
    
    obtenerCaracterIndice posFilaDestino, posColDestino
    mov BYTE[matriz + rbx + 1], 'O'  
              
    obtenerCaracterIndice posFilaOrigen, posColOrigen          
    mov  BYTE[matriz + rbx +1], ' '
    
    cmp QWORD[variableAuxiliar1],255
    jne  matarSoldado
    jmp validarQueNoTeniaSoldadosAlrededor
  
matarSoldado:
    obtenerCaracterIndice variableAuxiliar1,variableAuxiliar2
    mov BYTE[matriz + rbx + 1], ' '   
    jmp main  

validarQueNoTeniaSoldadosAlrededor:
    
    mov r8, QWORD[posFilaDestino]
    mov r9, QWORD[posColDestino]
    
    mov rcx, QWORD[posFilaOrigen]
    mov QWORD[posFilaDestino], rcx
    
    mov rcx, QWORD[posColOrigen]
    mov QWORD[posColDestino], rcx
    
    ;chequear salto izquierdo superior
    sub QWORD[posFilaDestino],2
    sub QWORD[posColDestino],2
    macroMatarOficial
    
    ;chequear salto medio superior
    add QWORD[posColDestino],2
    macroMatarOficial
    
    ;chequear salto derecho superior
    add QWORD[posColDestino],2
    macroMatarOficial
    
    ;chequear salto medio izquierdo
    add QWORD[posFilaDestino],2
    sub QWORD[posColDestino],4
    macroMatarOficial
    
    ;chequear salto medio derecho
    add QWORD[posColDestino],4
    macroMatarOficial
    
    ;chequear salto izquierdo inferior
    add QWORD[posFilaDestino],2
    sub QWORD[posColDestino],4
    macroMatarOficial
    
    ;chequear salto medio inferior
    add QWORD[posColDestino],2
    macroMatarOficial
    
    ;chequear salto derecho inferior
    add QWORD[posColDestino],4
    macroMatarOficial
    
    jmp main

matarOficial:
    
    mov QWORD[variableAuxiliar1], r8
    mov QWORD[variableAuxiliar2], r9
    
    obtenerCaracterIndice variableAuxiliar1, variableAuxiliar2      
    mov  BYTE[matriz + rbx +1], ' '
    jmp main


inputErroneo:
    
    print   msjInputError, 0
    jmp     input
    
mostrarOrigenInvalido:
    mov     BYTE[EligiendoDestino], 0
    print   msjOrigenInvalido, 0
    jmp     input

fin:
    ret