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

        i               dd      0 ; para recorrer filas
        j               dd      0 ; para recorrer columnas
        indiceActual    dd      0
	

        LONG_ELEM	equ	2
	CANT_FIL	equ	7
	CANT_COL	equ	7
        MAX_CASILLAS    equ     49
        
        caracterSinSalto              db      '%c',0
        caracterConSalto              db      10,0



section .text

imprimirTablero:
    ;mov ebp, esp; for correct debugging
    
    mov		 eax,DWORD[i]	;eax = elemento (4 bytes / dword)									
    cdqe									
    
inicioCiclo:
    cmp          rax, MAX_CASILLAS             
    jge          salirCiclo
    
                                    
    mov          ebx, [i]                   ; aca carga el indice i 
    imul         ebx, CANT_COL
    ; HACERLO  DESDE BX USANDO EL EJEMPLO DE VECTOR
    add          ebx, DWORD[j]
    imul         ebx, LONG_ELEM             ; calculo desplazamiento (i * LONG_ELEM)
    
    sub		 rsp,8
    mov          esi, DWORD[matriz + ebx]   ; cargo el char (primer byte del elemento) 
    mov          rdi, caracterSinSalto  
    call         printf
    add          rsp,8
    
    inc          QWORD[j]
    cmp          QWORD[j], CANT_COL
    je           reiniciarIndiceColumna         
            
    mov		 eax,ebx	;eax = elemento (4 bytes / dword)									
    cdqe
    
    jmp inicioCiclo




salirCiclo:
    
    ret
    
reiniciarIndiceColumna:
    mov         DWORD[j],0
    mov         rdi,caracterConSalto
    call        printf
    inc         QWORD[i]
    mov		eax,ebx	;eax = elemento (4 bytes / dword)									
    cdqe
    jmp         inicioCiclo
    
