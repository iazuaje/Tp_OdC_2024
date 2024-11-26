%include "macrosInputOutput.asm"
extern  sscanf

global GlobalData
section .data
    matriz  dw	"**","**",".X",".X",".X","**","**"          
            dw	"**","**",".X",".X",".X","**","**"       
            dw	".X",". ",".X",". ",".X",". ",".X"
            dw	".X",".X",".X",". ",".X",".X",".X"       
            dw	".X",". ","_X","_O","_X",". ",".X" 
            dw	"**",".X","_X","_X","_X","**","**"       
            dw	"**",". ","_O","_ ","_ ",". ","**" 

    LONG_ELEM       equ 2
    CANT_FIL        equ 7
    CANT_COL        equ 7
    MAX_CASILLAS    equ 96
    
    caracterConSalto    db  10,0
    
    
    posFilaOrigen  dq  0 ; inicializamos en 8 para indicar que es posicion invalida
    posColOrigen   dq  0
    
    posFilaDestino dq  0
    posColDestino  dq  0
   
    
    ;BOOLEANOS   
    esTurnoSoldados     db  255
    EligiendoDestino    db  0
    




    