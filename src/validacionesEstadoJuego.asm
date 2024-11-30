section .data
    
    vecPosicionesOficiales  dq  8,8,8,8
    vecIterador             dq  0
    TAMANIO_VECTOR          equ 4
    
    indiceActual            dq 0
    
    cantidadSoldadosActual  db 0
    
    MAX_CASILLAS_FORTALEZA  equ 8
    
section .text

gananSoldados:
    call    sePuedenMoverOficiales ;En validacionesOficiales.asm
    call    seOcupoFortaleza ;En validacoinesSoldados.asm
    
    ret

continuarJuego: 
    mov     r8,1
    ret
    
_terminarJuego:
    mov     r8,0
    ret    