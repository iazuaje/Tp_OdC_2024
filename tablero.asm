; Generador de matriz de tablero
; Pre: recibe un vector/matriz de 49 elementos. 
;      cada elemento tiene un caracter inicial que representa el piso 
;      y otro al lado que representa la pieza si es que existe pero 
;       siempre tiene que tener dos caracteres. Las piezas validas son 'X' y 'O'. 
; Pos:
;	- muestra los caracteres de la matriz recibida en 7x7 con las piezas disponibles  
;       (temporalmente la defino acá, la idea seria que sea definida en program.asm)	
;
;***************************************************************************
extern printf
%include "globalData.asm"

section	.data
    iteradorFila        dq  0 ; para recorrer filas
    iteradorColumna     dq  0 ; para recorrer columnas
	
    caracterSinSalto    db  ' %c', 0
    caracterNumerico    db  '  ■ %i', 0
    caracterBorde       db  ' ■', 0
    
    stringBordeVertical db  '  ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■',10,0
    stringNroColumna    db  '  ■   ■ 0 1 2 3 4 5 6 ■',10,0

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

iterarFila:
    cmp     QWORD[iteradorColumna], 0 ; Nos fijamos si estamos al principio de la fila
    je      printearInicioDeFila
    jmp     iterarFila1

printearInicioDeFila:
    print   caracterNumerico, [iteradorFila]
    print   caracterBorde, 0
    jmp     iterarFila1
    
iterarFila1:
    mov     rax, [iteradorFila]       
    imul    rax, LONG_ELEM
    imul    rax, CANT_COL
    
    mov     rbx, rax
    
    mov     rax, [iteradorColumna]
    imul    rax, LONG_ELEM          
    add     rbx, rax
    
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
    
salirCiclo:
    print   stringBordeVertical, 0
    print   caracterConSalto, 0
    add	    rsp, 8
    ret