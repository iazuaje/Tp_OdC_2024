%include "macrosInputOutput.asm"
global main

section .bss
    nombre resb 50
    
section .data
    mensaje     db      "Hola mundo",10,0
    mensaje1    db      "Cuál es tu nombre?",10,0
    msgfinal    db      "Mucho gusto en conocerte, %s",10, 0

section .text
main:
    print   mensaje, 0
    print   mensaje1, 0
    get     nombre
    print   msgfinal, nombre
    ret