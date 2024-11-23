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

%include "macrosMatriz.asm"
extern printf

section	.data
	msjSalUno	db	'Elemento guardado en fila %li columna %li: %c',10,13,0


	
	matriz		dw	"* ","* ",".X",".X",".X","* ","* "          
			dw	"* ","* ",".X",".X",".X","* ","* "       
			dw	".X",".X",".X",".X",".X",".X",".X"
			dw	".X",".X",".X",".X",".X",".X",".X"       
			dw	".X",".X","_ ","_ ","_ ",".X",".X" 
			dw	"* ","* ","_ ","_ ","_O","* ","* "       
			dw	"* ","* ","_O","_ ","_ ","* ","* " 

        i               dd      0
        j               dd      0

	

        LONG_ELEM	equ	2
	CANT_FIL	equ	7
	CANT_COL	equ	7
        MAX_CASILLAS    equ     49



section .text

imprimirTablero:
    ;mov ebp, esp; for correct debugging
    sub		 rsp,8
    mov		 eax,[i]	;eax = elemento (4 bytes / dword)									
    cdqe									
    
inicioCiclo:
    cmp          rax, MAX_CASILLAS             
    jge          salirCiclo
    
    mov          ebx,i   
    asignarRdi   
                                    
    mov          ebx, [i]                   ; aca carga el indice i 
    imul         ebx, LONG_ELEM             ; calculo desplazamiento (i * LONG_ELEM)
    mov          rsi, QWORD[matriz + ebx]   ; cargo el char (primer byte del elemento) 
    
    sub          rax,rax  ;esto es necesario por limpiar el rax para prepararlo para el printf (eso entiendo)
    call         printf
    
    
    inc          QWORD[i]                 
    mov		 eax,[i]	;eax = elemento (4 bytes / dword)									
    cdqe
    
    jmp inicioCiclo

salirCiclo:
    add         rsp,8
    ret
    
