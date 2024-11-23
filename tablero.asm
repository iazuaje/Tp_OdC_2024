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

%macro saltarLinea 0
    mov     rdi, caracterConSalto
    sub     rsi, rsi
    sub     rax, rax
    call    printf
%endmacro

section	.data
    iteradorFila        dq  0 ; para recorrer filas
    iteradorColumna     dq  0 ; para recorrer columnas
	
    caracterSinSalto    db  ' %c',0
    caracterConSalto    db  10,0

section .text
imprimirTablero:
    sub     rsp, 8
    mov     rax, 0  
    jmp     inicioCiclo
    
inicioCiclo:    
    cmp     rax, MAX_CASILLAS
    jge     salirCiclo
    
    mov     rax, [iteradorFila]       
    imul    rax, LONG_ELEM
    imul    rax, CANT_COL
    
    mov     rbx, rax
    
    mov     rax, [iteradorColumna]
    imul    rax, LONG_ELEM          
    add     rbx, rax
    
    mov     rdi, caracterSinSalto
    sub     rsi, rsi
    
    mov     rsi, QWORD[matriz + rbx]
    
    ;===================================
    ; aca hay que chequear si hay pieza
    ; if(segundo char es una pieza X o O)
    ; mov rsi, QWORD [matriz + rbx + 1]
    cmp     BYTE[matriz + rbx + 1], 'X'
    je      printearPieza
    cmp     BYTE[matriz + rbx + 1], 'O'
    je      printearPieza
    ;===================================
    
    jmp     imprimirCasilla

imprimirCasilla:
    sub     rax,rax
    call    printf
    
    inc     QWORD[iteradorColumna]
    cmp     QWORD[iteradorColumna], CANT_COL
    jge     reiniciarIndiceColumna
    mov     rax, rbx
    
    jmp     inicioCiclo

salirCiclo:
    saltarLinea
    add	    rsp, 8
    ret
    
reiniciarIndiceColumna:
    saltarLinea
    mov     QWORD[iteradorColumna],0
    inc     QWORD[iteradorFila]
    mov     rax, rbx
    jmp     inicioCiclo
    
printearPieza:
    mov     rsi, QWORD[matriz + rbx + 1]
    jmp     imprimirCasilla