%macro print 2
    mov     rax, 0 ; Limpiamos el rax para evitar errores
    mov     rdi, %1
    mov     rsi, %2 ; SE USA UNA UNICA VEZ EN TODO EL PROGRAMA.
    sub     rsp, 8
    call    printf
    add     rsp, 8
%endmacro

%macro get 1
    mov     rdi, %1
    sub     rsp, 8
    call    gets
    add     rsp, 8
%endmacro

%macro limpiarPantalla 0
    mov     rdi, cmd_clear
    sub     rsp, 8
    call    system
    add     rsp, 8
%endmacro

extern printf
extern gets
extern system

section .data
    cmd_clear db    "clear",0

