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

section	.data


	
	matriz		dw	"* ","* ",".X",".X",".X","* ","* "          
			dw	"* ","* ",".X",".X",".X","* ","* "       
			dw	".X",".X",".X",".X",".X",".X",".X"
			dw	".X",".X",".X",".X",".X",".X",".X"       
			dw	".X",".X","_ ","_ ","_ ",".X",".X" 
			dw	"* ","* ","_ ","_ ","_O","* ","* "       
			dw	"* ","* ","_O","_ ","_ ","* ","* " 

        i               dq      0 ; para recorrer filas
        j               dq      0 ; para recorrer columnas
        indiceActual    dq      0
	

        LONG_ELEM	equ	2
	CANT_FIL	equ	7
	CANT_COL	equ	7
        MAX_CASILLAS    equ     49
        
        caracterSinSalto              db      '%c',0
        caracterConSalto              db      10,0



section .text

imprimirTablero:
    
    sub		 rsp,  8
    mov          rax, 0  
    jmp          inicioCiclo
    
							
    
inicioCiclo:
            
    cmp          rax, MAX_CASILLAS
    jge          salirCiclo
    
    mov          rax, [i]
    imul         rax, LONG_ELEM
    ;imul         rax, CANT_COL
    
    mov          rbx, rax
    
    ;mov          rax, [j]
    ;imul         rax, LONG_ELEM          
    ;add		 rbx, rax
    
    mov          rdi, caracterSinSalto
    sub          rsi, rsi
    mov          rsi,  QWORD[matriz + rbx]

    sub          rax,rax
    call	 printf
    
    
    inc         QWORD[i]
    mov         rax, [i]
    
    jmp         inicioCiclo



salirCiclo:
    add		 rsp,  8
    ret
    
reiniciarIndiceColumna:
    
