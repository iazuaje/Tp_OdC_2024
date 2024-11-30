section .text
global validacionesOficiales

sePuedenMoverOficiales:
    mov     QWORD[iteradorFila],0
    mov     QWORD[iteradorColumna],0
    mov     QWORD[vecIterador], 0
    call    reiniciarVectorPosOficiales
    
    call    obtenerPosicionesOficiales
    call    revisarOficialesObtenidos 

_sePuedenMoverOficiales:
    cmp     r8,0
    je      volverARutina
    
    mov     rbx, QWORD[vecIterador]
    imul    rbx,8
    
    mov     rax,QWORD[vecPosicionesOficiales + rbx]
    mov     QWORD[variableAuxiliar1], rax
    
    cmp     rax,8
    je      volverARutina
    
    inc     QWORD[vecIterador]
    mov     rbx, QWORD[vecIterador]
    imul    rbx,8
    mov     rax,QWORD[vecPosicionesOficiales + rbx]
    mov     QWORD[variableAuxiliar2],rax
    
    call    verificarSiHayMovimientosDisponibles
    cmp     r8,0
    jne     volverARutina
    
    inc     QWORD[vecIterador]
    cmp     QWORD[vecIterador],TAMANIO_VECTOR
    jge     _sePuedenMoverOficiales
    
    ret

verificarSiHayMovimientosDisponibles:
    mov     r8,0
    
    ;verificamos fila superior
    dec     QWORD[variableAuxiliar1]
    call    verificarFilaConMovimientos
    
    ;verificamos medio
    inc     QWORD[variableAuxiliar1]
    call    verificarFilaMedioConMovimientos
    
    ;verificamos inferior
    inc     QWORD[variableAuxiliar1]
    call    verificarFilaConMovimientos
    
    ;fila inferior + 1
    inc     QWORD[variableAuxiliar1]
    call    verificarFilaInferiorConSalto
    
    ;fila superior - 1
    sub     QWORD[variableAuxiliar1],4
    call    verificarFilaSuperiorConSalto
    
    ret    
    
verificarFilaConMovimientos:
    mov     r10,QWORD[variableAuxiliar2]
    dec     QWORD[variableAuxiliar2]
    
    obtenerCaracterIndice variableAuxiliar1,variableAuxiliar2
    cmp     BYTE[matriz + rbx + 1], ' '
    je      continuarJuego
    
    inc     QWORD[variableAuxiliar2]
    obtenerCaracterIndice variableAuxiliar1, variableAuxiliar2
    cmp     BYTE[matriz + rbx + 1], ' '
    je      continuarJuego
    
    inc     QWORD[variableAuxiliar2]
    obtenerCaracterIndice variableAuxiliar1, variableAuxiliar2
    cmp     BYTE[matriz + rbx + 1], ' '
    je      continuarJuego

    mov     QWORD[variableAuxiliar2],r10
    ret

verificarFilaMedioConMovimientos:
    mov     r10,QWORD[variableAuxiliar2]
    dec     QWORD[variableAuxiliar2]
    
    obtenerCaracterIndice variableAuxiliar1,variableAuxiliar2
    cmp     BYTE[matriz + rbx + 1], ' '
    je      continuarJuego
    
    add     QWORD[variableAuxiliar2], 2 
    obtenerCaracterIndice variableAuxiliar1,variableAuxiliar2
    cmp     BYTE[matriz + rbx + 1], ' '
    je      continuarJuego
    
    ;con saltos
    
    cmp     BYTE[matriz +  rbx + 1],'X'
    call    verificarEspacioVacioPorDerecha    
    cmp     r8,1
    je      volverARutina
    
    sub     QWORD[variableAuxiliar2],2
    cmp     BYTE[matriz +  rbx + 1],'X'
    call    verificarEspacioVacioPorIzquierda
    cmp     r8,1
    je      volverARutina
    
    mov     QWORD[variableAuxiliar2],r10
    ret
    
verificarEspacioVacioPorDerecha:
    jne     volverARutina
    
    inc     QWORD[variableAuxiliar2]
    obtenerCaracterIndice variableAuxiliar1, variableAuxiliar2
    cmp     BYTE[matriz + rbx + 1], ' '
    je      continuarJuego
    ret
    
verificarEspacioVacioPorIzquierda:
    jne     volverARutina
    
    dec     QWORD[variableAuxiliar2]
    obtenerCaracterIndice variableAuxiliar1, variableAuxiliar2
    cmp     BYTE[matriz + rbx + 1], ' '
    je      continuarJuego
    ret
    
verificarFilaSuperiorConSalto:
    mov     r10, QWORD[variableAuxiliar1]; 2
    mov     r11, QWORD[variableAuxiliar2]; 3 
    
    ;chequeo por izquierda
    inc     QWORD[variableAuxiliar1] ; 3
    dec     QWORD[variableAuxiliar2] ; 2
    
    obtenerCaracterIndice variableAuxiliar1, variableAuxiliar2
    cmp     BYTE[matriz + rbx + 1],'X'
    jne     volverARutina 
    
    dec     QWORD[variableAuxiliar1] ; 2
    dec     QWORD[variableAuxiliar2] ; 1
    
    obtenerCaracterIndice variableAuxiliar1, variableAuxiliar2
    cmp     BYTE[matriz + rbx + 1], ' '
    je      continuarJuego
    
    ;chequeo por medio
    add     QWORD[variableAuxiliar2],2 ; 3
    inc     QWORD[variableAuxiliar1]   ; 3
    
    obtenerCaracterIndice variableAuxiliar1, variableAuxiliar2
    cmp     BYTE[matriz + rbx + 1],'X'
    jne     volverARutina    
    
    dec     QWORD[variableAuxiliar1] ; 2
    
    obtenerCaracterIndice variableAuxiliar1, variableAuxiliar2
    cmp     BYTE[matriz + rbx + 1], ' '
    je      continuarJuego
    
    ;chequeo por derecha
    inc     QWORD[variableAuxiliar1] ; 3
    inc     QWORD[variableAuxiliar2] ; 4
    
    obtenerCaracterIndice variableAuxiliar1, variableAuxiliar2
    cmp     BYTE[matriz + rbx + 1],'X'
    jne     volverARutina    
    
    dec     QWORD[variableAuxiliar1] ; 2
    inc     QWORD[variableAuxiliar2] ; 5
    
    obtenerCaracterIndice variableAuxiliar1, variableAuxiliar2
    cmp     BYTE[matriz + rbx + 1], ' '
    je      continuarJuego
    
    mov     QWORD[variableAuxiliar1],r10 ; 6
    mov     QWORD[variableAuxiliar2],r11 ; 3
    
    ret   
    
verificarFilaInferiorConSalto:
    mov     r10, QWORD[variableAuxiliar1] ; 6
    mov     r11, QWORD[variableAuxiliar2] ; 3
    
    ;chequeo por izquierda
    dec     QWORD[variableAuxiliar1] ; 5
    dec     QWORD[variableAuxiliar2] ; 2
    
    obtenerCaracterIndice variableAuxiliar1, variableAuxiliar2
    cmp     BYTE[matriz + rbx + 1],'X'
    jne     volverARutina
    
    inc     QWORD[variableAuxiliar1]
    dec     QWORD[variableAuxiliar2] 
    
    obtenerCaracterIndice variableAuxiliar1, variableAuxiliar2
    cmp     BYTE[matriz + rbx + 1], ' '
    je      continuarJuego
    
    ;chequeo por medio
    add     QWORD[variableAuxiliar2],2
    dec     QWORD[variableAuxiliar1]
    
    obtenerCaracterIndice variableAuxiliar1, variableAuxiliar2
    cmp     BYTE[matriz + rbx + 1],'X'
    jne     volverARutina    
    inc     QWORD[variableAuxiliar1]
    obtenerCaracterIndice variableAuxiliar1, variableAuxiliar2
    cmp     BYTE[matriz + rbx + 1], ' '
    je      continuarJuego
    
    ;chequeo por derecha
    inc     QWORD[variableAuxiliar2]
    dec     QWORD[variableAuxiliar1]
    
    obtenerCaracterIndice variableAuxiliar1, variableAuxiliar2
    cmp     BYTE[matriz + rbx + 1],'X'
    jne     volverARutina    
    
    inc     QWORD[variableAuxiliar1]
    inc     QWORD[variableAuxiliar2]
    
    obtenerCaracterIndice variableAuxiliar1, variableAuxiliar2
    cmp     BYTE[matriz + rbx + 1], ' '
    je      continuarJuego
    
    mov     QWORD[variableAuxiliar1],r10 ; 6
    mov     QWORD[variableAuxiliar2],r11 ; 3
    
    ret   
    
revisarOficialesObtenidos: 
    cmp     QWORD[vecPosicionesOficiales],8
    je      _terminarJuego
    
    ret  
    
obtenerPosicionesOficiales:    
    cmp     QWORD[vecIterador],TAMANIO_VECTOR
    jge     volverARutina
    
    cmp     QWORD[indiceActual], MAX_CASILLAS
    jge     volverARutina
    
    obtenerCaracterIndice iteradorFila, iteradorColumna
    call    guardarPosicionOficial
    
    inc     QWORD[iteradorColumna]
    call    reiniciarIndiceCol
    
    jmp     obtenerPosicionesOficiales

reiniciarIndiceCol:
    cmp     QWORD[iteradorColumna], CANT_COL
    jge     _reiniciarIndiceCol
    mov     QWORD[indiceActual],rbx
    ret
    
_reiniciarIndiceCol:
    mov     QWORD[iteradorColumna],0
    inc     QWORD[iteradorFila]
    mov     QWORD[indiceActual],rbx
    ret
    
guardarPosicionOficial:
    cmp     BYTE[matriz + rbx + 1], 'O'
    je      _guardarPosicionOficial
    
    ret
    
_guardarPosicionOficial:
    mov     rbx, QWORD[vecIterador]
    mov     rcx, QWORD[iteradorFila]
    imul    rbx,8
    mov     QWORD[vecPosicionesOficiales + rbx],rcx
    mov     r14,QWORD[vecPosicionesOficiales + rbx]
    
    inc     QWORD[vecIterador]
    mov     rbx, QWORD[vecIterador]
    imul    rbx,8

    mov     rcx,QWORD[iteradorColumna]
    mov     QWORD[vecPosicionesOficiales + rbx],rcx
    mov     r14,QWORD[vecPosicionesOficiales + rbx]
    
    inc     QWORD[vecIterador]
    
    mov     r8,2
    ret
    
reiniciarVectorPosOficiales:
    mov     QWORD[vecIterador], 0

_reiniciarVectorPosOficiales:
    mov     rbx, QWORD[vecIterador]
    imul    rbx, 8
    
    mov     QWORD[vecPosicionesOficiales + rbx], 8
    inc     QWORD[vecIterador]
    
    cmp     QWORD[vecIterador], TAMANIO_VECTOR
    jl      _reiniciarVectorPosOficiales
    
    mov     QWORD[vecIterador], 0
    ret