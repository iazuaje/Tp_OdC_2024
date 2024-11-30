section .text
global validacionesSoldados

seOcupoFortaleza:
    cmp     r8,0
    je  volverARutina
    
    ;en realidad estaria bueno chequear todas las posiciones que tengan piso de fortaleza tengan X
    ;pero eso implica recorrer la matriz y validar cada casilla ocupada. Hasta mientras se usara esto:
    
    ;si la torre fue ocupada desde los indices 60,62,64
                                              ;74,76,78
                                              ;88,90,92
    mov     r8,0
    mov     rbx,60
                                                                                      
    cmp     BYTE[matriz + rbx + 1],'X'
    call    validarOcupacionDeSoldado
    add     rbx, 2
    
    cmp     BYTE[matriz + rbx + 1],'X'
    call    validarOcupacionDeSoldado
    add     rbx, 2
    
    cmp     BYTE[matriz + rbx + 1],'X'
    call    validarOcupacionDeSoldado

    mov     rbx,74
    cmp     BYTE[matriz + rbx + 1],'X'
    call    validarOcupacionDeSoldado
    add     rbx, 2
    
    cmp     BYTE[matriz + rbx + 1],'X'
    call    validarOcupacionDeSoldado
    add     rbx, 2
    
    cmp     BYTE[matriz + rbx + 1],'X'
    call    validarOcupacionDeSoldado

    mov     rbx,88
    cmp     BYTE[matriz + rbx + 1],'X'
    call    validarOcupacionDeSoldado
    add     rbx, 2
    
    cmp     BYTE[matriz + rbx + 1],'X'
    call    validarOcupacionDeSoldado
    add     rbx, 2
    
    cmp     BYTE[matriz + rbx + 1],'X'
    call    validarOcupacionDeSoldado
    
    ret

validarOcupacionDeSoldado:
    jne     continuarJuego  
    ret
    
contarCantidadSoldadosActual:
    cmp     BYTE[cantidadSoldadosActual], MAX_CASILLAS_FORTALEZA
    jg      continuarJuego
    
    cmp     QWORD[indiceActual], MAX_CASILLAS
    jge     terminarJuegoOficiales
    
    obtenerCaracterIndice iteradorFila, iteradorColumna
    call    verSiHaySoldadoVivo
    
    inc     QWORD[iteradorColumna]
    call    reiniciarIndiceCol
    
    cmp     QWORD[indiceActual], MAX_CASILLAS
    jle     contarCantidadSoldadosActual
    
    ret
    
verSiHaySoldadoVivo:
    cmp     BYTE[matriz + rbx + 1], 'X'
    je      incrementarCantSoldadosVivosActual
    
    ret
    
incrementarCantSoldadosVivosActual:   
    inc     BYTE[cantidadSoldadosActual]
    ret
    
terminarJuegoOficiales:
    not     BYTE[GananSoldados]
    mov     r8,0
    ret
    
gananOficiales:
    cmp     r8,0
    je      volverARutina  ; si ya ganaron los soldados, ni chequeamos y salimos de la rutina
    
    mov     BYTE[cantidadSoldadosActual],0
    mov     QWORD[indiceActual],0
    mov     QWORD[iteradorFila],0
    mov     QWORD[iteradorColumna],0
    
    call    contarCantidadSoldadosActual

    ret