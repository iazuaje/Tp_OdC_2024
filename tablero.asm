section .data
    stringParaPrinteo   dd "%c",0
    simboloSoldado      dd "X"
    simboloOficial      dd "O"
    simboloPiso         dd "."
    simboloPisoOficial  dd "_"
    simboloInvalido     dd " "
    
    longFila    dd 7
    longCol     dd 7
    longElement dd 4
 
section .bss
    tablero times 49 resd 1
    indiceX resd 1
    indiceY resd 1
    
section .text
initTablero:
    MOV RCX, 0
    MOV DWORD[indiceX], 0
    MOV DWORD[indiceY], 0

    MOV RBX, tablero
    MOV RAX, [indiceX]
    IMUL     DWORD[longFila]
    ADD RCX, RAX
    MOV RAX, [indiceY]
    IMUL     DWORD[longElement]
    ADD RCX, RAX
    ADD RBX, RCX
    
    MOV DWORD[RBX], "."
    
printTablero:
    MOV RCX, 0
    MOV DWORD[indiceX], 0
    MOV DWORD[indiceY], 0

    MOV RBX, tablero
    MOV RAX, [indiceX]
    IMUL     DWORD[longFila]
    ADD RCX, RAX
    MOV RAX, [indiceY]
    IMUL     DWORD[longElement]
    ADD RCX, RAX
    ADD RBX, RCX
    
    print stringParaPrinteo, RBX