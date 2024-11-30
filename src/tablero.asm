; Generador de matriz de tablero
; Pre: recibe un vector/matriz de 49 elementos. 
;      cada elemento tiene un caracter inicial que representa el piso 
;      y otro al lado que representa la pieza si es que existe pero 
;       siempre tiene que tener dos caracteres. Las piezas validas son 'X' y 'O'. 
; Pos:
;	- muestra los caracteres de la matriz recibida en 7x7 con las piezas disponibles  
;       
;
;***************************************************************************
section	.data
    iteradorFila         dq  0 ; para recorrer filas
    iteradorColumna      dq  0 ; para recorrer columnas
	
    caracterSinSalto     db  ' %c', 0
    caracterNumerico     db  '  ■ %i', 0
    caracterBorde        db  ' ■', 0
    
    stringBordeVertical  db  '  ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■',10,0
    stringNroColumna     db  '  ■   ■ 0 1 2 3 4 5 6 ■',10,0
    
    variableAuxiliar1    dq  255
    variableAuxiliar2    dq  255
    
section .text
imprimirTablero:
    ;Reiniciamos los iteradores
    mov     QWORD[iteradorFila], 0
    mov     QWORD[iteradorColumna], 0
    
    ;Printeamos las cabeceras del tablero
    print   stringBordeVertical, 0
    print   stringNroColumna, 0
    print   stringBordeVertical, 0
    sub     rsp, 8
    mov     rax, 0
      
    jmp     cicloPrintTablero
    
cicloPrintTablero:    
    cmp     rax, MAX_CASILLAS
    jge     salirCiclo
    jmp     iterarFila
    
salirCiclo:
    print   stringBordeVertical, 0
    print   caracterConSalto, 0
    add	    rsp, 8
    ret

iterarFila:
    cmp     QWORD[iteradorColumna], 0 ; Nos fijamos si estamos al principio de la fila
    je      printearInicioDeFila
    jmp     iterarFila1

printearInicioDeFila:
    print   caracterNumerico, [iteradorFila]
    print   caracterBorde, 0
    jmp     iterarFila1
    
iterarFila1:
    obtenerCaracterIndice iteradorFila,iteradorColumna
    
    mov     rdi, caracterSinSalto
    sub     rsi, rsi
    
    mov     rsi, QWORD[matriz + rbx] ;Preparamos para printear el primer byte  del elemento
    
    ;===================================
    ; aca hay que chequear si hay pieza para printearla
    ; if(segundo char es una pieza X o O)
    cmp     BYTE[matriz + rbx + 1], 'X'
    je      printearPieza
    cmp     BYTE[matriz + rbx + 1], 'O'
    je      printearPieza
    ;===================================
    
    jmp     iterarColumna

printearPieza:
    mov     rsi, QWORD[matriz + rbx + 1]
    jmp     iterarColumna

iterarColumna:
    sub     rax,rax
    call    printf
    
    inc     QWORD[iteradorColumna]
    cmp     QWORD[iteradorColumna], CANT_COL
    jge     reiniciarIndiceColumna
    mov     rax, rbx
    
    jmp     cicloPrintTablero

reiniciarIndiceColumna:
    print   caracterBorde,0
    print   caracterConSalto, 0
    mov     QWORD[iteradorColumna],0
    inc     QWORD[iteradorFila]
    mov     rax, rbx
    jmp     cicloPrintTablero
    
esPosicionValida:
    ;recorrer matriz
    obtenerCaracterIndice posFilaOrigen,posColOrigen
    
    cmp     BYTE[EligiendoDestino],0
    je      validarPiezaOrigen
    jmp     validarCasillaDestino     
    
validarPiezaOrigen:
    cmp     BYTE[esTurnoSoldados],0
    je      validarPiezaOficial
    jmp     validarPiezaSoldado
      
validarPiezaSoldado:   
    cmp     BYTE[matriz + rbx + 1], 'X'
    je      devolverResultadoValido
    mov     rax, 0
    ret
    
validarPiezaOficial:
    cmp     BYTE[matriz + rbx + 1], 'O'
    je      devolverResultadoValido
    jmp     devolverResultadoInvalido

devolverResultadoValido:
    mov     rax, 1
    ret
    
devolverResultadoInvalido:
    mov     rax,0
    ret   
    
validarCasillaDestino:
    cmp     BYTE[esTurnoSoldados],0
    je      validarCasillaParaOficial
    jmp     validarCasillaParaSoldado
 
validarCasillaParaSoldado:
    call    estaVacio
    cmp     rax,0
    je      devolverResultadoInvalido
    call    validarDestinoSoldado
    cmp     rax,0
    je      devolverResultadoInvalido
    
    jmp     devolverResultadoValido

estaVacio:
    obtenerCaracterIndice   posFilaDestino, posColDestino
    cmp     BYTE[matriz + rbx + 1],' '
    je      volverARutina
    jmp     devolverResultadoInvalido

    
validarDestinoSoldado:
    ;si hay pared al frente entonces si tiene que chequear si la fila es igual y ademas si es a derecha o izquierda
    ;obtengo si tiene *
    inc     QWORD[posFilaOrigen]
    obtenerCaracterIndice  posFilaOrigen,posColOrigen
    dec     QWORD[posFilaOrigen]
    cmp     BYTE[matriz + rbx + 1], '*'
    je      validarDestinoConPared
    
    ;validacion fila    
    mov     rax, [posFilaOrigen]
    mov     rbx, [posFilaDestino]
    inc     rax    
    cmp     rax, rbx
    jne     devolverResultadoInvalido
    
    ;validacion columna
    mov     rax, [posColOrigen]
    mov     rbx, [posColDestino]
    cmp     rax, rbx ;valido si es la misma columna
    je      volverARutina
    
    dec     rax
    cmp     rax,rbx ; si es col - 1
    je      volverARutina
    
    add     rax,2
    cmp     rax,rbx ; si es col + 1
    je      volverARutina
    
    jmp     devolverResultadoInvalido
      
validarDestinoConPared:
    ;validacion fila
    mov     rax, [posFilaOrigen]
    mov     rbx, [posFilaDestino]
    cmp     rax,rbx
    jne     devolverResultadoInvalido
  
    ;valida movimiento en sector izquierdo
    mov     rax, [posColOrigen]
    mov     rbx, [posColDestino]
    cmp     rax,2
    jl      validarParaDerecha
    
    ;valida movimiento en sector derecho
    dec     rax
    cmp     rax,rbx 
    je      volverARutina
    jmp     devolverResultadoInvalido

validarParaDerecha:
    inc     rax             
    cmp     rax,rbx  
    je      volverARutina
    jmp     devolverResultadoInvalido
    
       
validarCasillaParaOficial:
    call    estaVacio
    cmp     rax,0
    je      devolverResultadoInvalido
    call    validarDestinoOficial
    cmp     rax,0
    je      devolverResultadoInvalido
    jmp     devolverResultadoValido
    
validarDestinoOficial:
    ;reiniciamos las variables auxiliares
    mov     QWORD[variableAuxiliar1],255
    mov     QWORD[variableAuxiliar2],255
    
    ;movimiento a una casilla de distancia
    mov     rax, [posFilaOrigen]
    mov     rbx, [posFilaDestino]
    
    ;========= FILA INFERIOR
    inc     rax
    cmp     rax,rbx
    je      validarOficialFila
   
    ;========= FILA SUPERIOR  
    sub     rax, 2
    cmp     rax,rbx
    je      validarOficialFila
    
    ;========= FILA MEDIO
    inc     rax
    cmp     rax,rbx
    je      validarOficialFilaMedio
    
    ;========= FILA INFERIOR + 1
    add     rax, 2
    cmp     rax, rbx
    je      validarOficialFilaSaltoInferior 
    
    ;========= FILA SUPERIOR + 1
    sub     rax, 4
    cmp     rax, rbx
    je      validarOficialFilaSaltoSuperior
    
    jmp     devolverResultadoInvalido
    
validarOficialFila:
    mov     rax, [posColOrigen]
    mov     rbx, [posColDestino]
    
    ;esquina izquierda
    dec     rax
    cmp     rax,rbx
    je      volverARutina
    
    ;misma columna
    inc     rax
    cmp     rax,rbx
    je      volverARutina
    
    ;esquina derecha
    inc     rax
    cmp     rax,rbx
    je      volverARutina
    
    jmp     devolverResultadoInvalido
   
validarOficialFilaMedio:
    mov     rax, [posColOrigen]
    mov     rbx, [posColDestino]
    mov     rcx, [posFilaDestino]
    
    dec     rax
    cmp     rax,rbx
    je      volverARutina
    
    add     rax, 2
    cmp     rax,rbx
    je      volverARutina 
    
    ;verificamos las mas lejanas
    
    ;izquierda lejana
    sub     rax,3
    cmp     rax,rbx
    je      irAVerificacionSaltoAumentandoRax
    
    ;derecha lejana
    add     rax, 4
    cmp     rax,rbx
    je      irAVerificacionSaltoDecreciendoRax
    jmp     devolverResultadoInvalido
   
validarOficialFilaSaltoInferior:
   ;verifico lado izquierdo
   mov      rax, [posColOrigen]
   mov      rbx, [posColDestino]
   mov      rcx, [posFilaDestino]
   dec      rcx
   
   sub      rax,2
   cmp      rax,rbx
   je       irAVerificacionSaltoAumentandoRax
   
   add      rax,2
   cmp      rax,rbx
   je       verificarCondicionSalto
   
   add      rax,2
   cmp      rax,rbx
   je       irAVerificacionSaltoDecreciendoRax
   jmp      devolverResultadoInvalido
   
validarOficialFilaSaltoSuperior:
   mov      rax, [posColOrigen]
   mov      rbx, [posColDestino]
   mov      rcx, [posFilaDestino]
   inc      rcx
  
   ;esquina superior izquierda
   sub      rax,2
   cmp      rax,rbx
   je       irAVerificacionSaltoAumentandoRax
   
   ;medio
   add      rax, 2
   cmp      rax,rbx
   je       verificarCondicionSalto
   
   ;esquina superior derecha
   add      rax,2
   cmp      rax,rbx
   je       irAVerificacionSaltoDecreciendoRax
   jmp      devolverResultadoInvalido

irAVerificacionSaltoAumentandoRax:
    inc     rax
    jmp     verificarCondicionSalto    

irAVerificacionSaltoDecreciendoRax:
    dec     rax
    jmp     verificarCondicionSalto

verificarCondicionSalto:
   mov      QWORD[variableAuxiliar1],rcx
   mov      QWORD[variableAuxiliar2],rax
   
   obtenerCaracterIndice variableAuxiliar1, variableAuxiliar2
   
   mov      rcx, variableAuxiliar1
   mov      rax, variableAuxiliar2
   
   cmp      BYTE[matriz + rbx + 1], 'X'
   je       volverARutina
   jmp      devolverResultadoInvalido