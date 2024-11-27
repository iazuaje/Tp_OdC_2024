%include "macrosInputOutput.asm"
%include "tablero.asm"
%include "input.asm"
%include "mensajes.asm"

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

    LONG_ELEM           equ 2
    CANT_FIL            equ 7
    CANT_COL            equ 7
    MAX_CASILLAS        equ 96
    
    caracterConSalto    db  10,0
    formateoInt         db  "%i",0
    
    posFilaOrigen       dq  0
    posColOrigen        dq  0
    
    posFilaDestino      dq  0
    posColDestino       dq  0
    
    ;BOOLEANOS   
    esTurnoSoldados     db  0
    EligiendoDestino    db  0
    EligiendoColumna    db  0
    
    estadoDeJuego       db  0
    JUEGO_EN_CURSO      equ 0
    FIN_DE_JUEGO        equ 255

section .bss
    inputJugador        resb 1

section .text

volverARutina:
    ret

setearFinalDeJuego:
    mov     byte[estadoDeJuego], FIN_DE_JUEGO
    ret



    