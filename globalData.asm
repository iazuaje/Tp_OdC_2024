global GlobalData
section .data
    matriz  dw	"* ","* ",".X",".X",".X","* ","* "          
            dw	"* ","* ",".X",".X",".X","* ","* "       
            dw	".X",".X",".X",".X",".X",".X",".X"
            dw	".X",".X",".X",".X",".X",".X",".X"       
            dw	".X",".X","_ ","_ ","_ ",".X",".X" 
            dw	"* ","* ","_ ","_ ","_O","* ","* "       
            dw	"* ","* ","_O","_ ","_ ","* ","* " 

    LONG_ELEM       equ 2
    CANT_FIL        equ 7
    CANT_COL        equ 7
    MAX_CASILLAS    equ 96