%include "src/macrosInputOutput.asm"
%include "src/tablero.asm"
%include "src/validacionesEstadoJuego.asm"
%include "src/mensajes.asm"
%include "src/validacionesSoldados.asm"
%include "src/validacionesOficiales.asm"

extern sscanf
extern printf
extern gets
extern system

global GlobalData
section .data

    padding dw 0
    
    matriz  dw	"**","**",".X",".X",".X","**","**"          
            dw	"**","**",".X",".X",".X","**","**"       
            dw	".X",".X",".X",".X",".X",".X",".X"
            dw	".X",".X",".X",".X",".X",".X",".X"       
            dw	".X",".X","_ ","_ ","_ ",".X",".X" 
            dw	"**","**","_ ","_ ","_O","**","**"       
            dw	"**","**","_O","_ ","_ ","**","**",
            dw   00 ; padding

    LONG_ELEM           equ 2
    CANT_FIL            equ 7
    CANT_COL            equ 7
    MAX_CASILLAS        equ 96
    
    caracterConSalto    db  10,0
    
    posFilaOrigen       dq  0
    posColOrigen        dq  0
    
    posFilaDestino      dq  0
    posColDestino       dq  0
   
    ;BOOLEANOS   
    esTurnoSoldados     db  0
    EligiendoDestino    db  0
    
    cmd_clear           db  "clear",0
    
section .text
volverARutina:
    ret