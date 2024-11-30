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

%macro imprimirTableroMacro 0
    print   msjSeparador,0
    print   msjTitulo,0
    print   msjSeparador,0
    print   caracterConSalto,0
    call    imprimirTablero
    print   msjSeparador,0
%endmacro

%macro guardarPosicion 1

    mov     rdi, inputJugador
    mov     rsi, formateoInt
    mov     rdx, %1
    
    sub     rsp, 8
    sub     rax, rax
    call    sscanf
    add     rsp,8
    
%endmacro

%macro macroMatarOficial 0
    
    call validarCasillaParaOficial
    cmp rax,1
    je  matarOficial
    
%endmacro

%macro obtenerCaracterIndice 2  ; carga el rbx con el indice
    sub     rax, rax
    mov     rax, [%1]       
    imul    rax, LONG_ELEM
    imul    rax, CANT_COL
    
    mov     rbx, rax
    
    mov     rax, [%2]
    imul    rax, LONG_ELEM          
    add     rbx, rax
%endmacro



section .data


