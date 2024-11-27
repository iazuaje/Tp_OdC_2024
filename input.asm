section .text
global input

input:
    cmp     byte[estadoDeJuego], FIN_DE_JUEGO
    je      volverARutina
    
    call    inputFila
    not     byte[EligiendoColumna]
    call    inputColumna
    not     byte[EligiendoColumna]
    
    ;VALIDAR LA PIEZA ELEGIDA Y EN CASO MALO VOLVER AL INPUT
    
    ;Destino
    not     byte[EligiendoDestino]
    call    inputFila
    not     byte[EligiendoColumna]
    call    inputColumna
    not     byte[EligiendoColumna]
    
    ;VALIDAR LA PIEZA ELEGIDA Y EN CASO MALO VOLVER AL INPUT
    ret
    
inputFila:
    call    printMensajeFilaOrigen
    call    printMensajeFilaDestino
    call    obtenerValor
    ret

inputColumna:
    call    printMensajeColumnaOrigen
    call    printMensajeColumnaDestino
    call    obtenerValor
    ret

obtenerValor:
    get     inputJugador
    cmp     byte[inputJugador], "p"
    je      setearFinalDeJuego
    call    validarInput
    cmp     rax,0
    je      reobtenerValor
    call    guardarValor
    ret
    
reobtenerValor:
    call    mostrarInputInvalido
    jmp     input
    
    
validarInput:
    cmp     byte[inputJugador], 48 ;ASCII para '0'
    jl      reobtenerValor
    cmp     byte[inputJugador], 54 ;ASCII para '6'
    jge     reobtenerValor
    ret
    
guardarValor:
    call    guardarPosicionFila
    call    guardarPosicionColumna
    ret

guardarPosicionFila:
    cmp     byte[EligiendoColumna], 0
    jne     volverARutina
    
    call    guardarFilaOrigen
    call    guardarFilaDestino
    mov     rax, 0 ;Seguimos con el inpu
    ret
   
guardarFilaOrigen:
    cmp     byte[EligiendoDestino], 0
    jne     volverARutina
    
    guardarPosicion posFilaOrigen
    ret

guardarFilaDestino:
    cmp     byte[EligiendoDestino], 0
    je      volverARutina
    
    guardarPosicion posFilaDestino
    ret

guardarPosicionColumna:
    cmp     byte[EligiendoColumna], 0
    je      volverARutina
    
    call guardarColumnaOrigen
    call guardarColumnaDestino
    ret

guardarColumnaOrigen:
    cmp     byte[EligiendoDestino], 0
    jne     volverARutina
    
    guardarPosicion posColOrigen
    mov     rax, 0 ;limpiamos rax
    ret

guardarColumnaDestino:
    cmp     byte[EligiendoDestino], 0
    je      volverARutina
    
    guardarPosicion posColDestino
    mov rax, 1 ;Terminamos
    ret

    