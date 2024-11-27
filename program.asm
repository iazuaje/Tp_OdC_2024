%include "globalData.asm"

global main


%macro macroMatarOficial 0
    
    call validarCasillaParaOficial
    cmp rax,1
    je  matarOficial
    
%endmacro

section .text
main:
    call    cicloDeJuego
    ret
       
cicloDeJuego:
    call    ImprimirPantalla
    call    JugarTurno
    call    CheckearCondicionesDeVictoria
    cmp     byte[estadoDeJuego], JUEGO_EN_CURSO
    je      cicloDeJuego
    call    FinalDePartida
    ret

ImprimirPantalla:
    limpiarPantalla
    ;===================
    print   msjSeparador,0
    print   msjTitulo,0
    print   msjSeparador,0
    print   caracterConSalto,0
    call    imprimirTablero
    print   msjSeparador,0
    ;====================
    ret

JugarTurno:
    call    mostrarMensajeComienzoDeTurno
    not     byte[esTurnoSoldados] ;Cambiamos de turno
    call    input
    ret

CheckearCondicionesDeVictoria:
    ret
    
FinalDePartida:
    cmp     byte[estadoDeJuego], FIN_DE_JUEGO
    je      volverARutina ;Cortamos ciclo
    
;validarPiezaElegida:
;    call    esPosicionValida
;    cmp     rax,0 ; el rax guarda el resultado de la rutina anterior
;    je      volverARutina
;    ret   

; MIGRAR DE AQUI EN ADELANTE =================================================

moverPieza:  
    sub  rax,rax
    
    cmp  BYTE[esTurnoSoldados],0
    je   cambiarFichaOficial
    
    obtenerCaracterIndice posFilaDestino, posColDestino
    mov BYTE[matriz + rbx + 1], 'X'  
              
    obtenerCaracterIndice posFilaOrigen, posColOrigen          
    mov  BYTE[matriz + rbx +1], ' '
    
    ret

cambiarFichaOficial:
    
    obtenerCaracterIndice posFilaDestino, posColDestino
    mov BYTE[matriz + rbx + 1], 'O'  
              
    obtenerCaracterIndice posFilaOrigen, posColOrigen          
    mov  BYTE[matriz + rbx +1], ' '
    
    cmp QWORD[variableAuxiliar1],255
    jne matarSoldado
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
    
    ret

matarOficial:
    
    mov QWORD[variableAuxiliar1], r8
    mov QWORD[variableAuxiliar2], r9
    
    obtenerCaracterIndice variableAuxiliar1, variableAuxiliar2      
    mov  BYTE[matriz + rbx +1], ' '
    ret
