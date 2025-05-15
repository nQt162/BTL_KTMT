.model small
.stack 100h
.data
    clrf            db  13, 10, '$'
    input_buffer    db  100 dup('$')
    result          dw  0
.code
main proc
    mov ax, @data
    mov ds, ax

    mov ah, 0ah
    lea dx, input_buffer
    int 21h

    mov ah, 9
    lea dx, clrf
    int 21h

    lea si, input_buffer + 2
    mov cx, 0

search_loop:
    cmp byte ptr [si], '$'
    je finish_search

    cmp byte ptr [si], 'k'
    jne next_char

    mov ax, word ptr [si]
    mov dx, word ptr [si+2]
    cmp ax, 'tk'
    jne next_char
    cmp dx, 'tm'
    jne next_char

    inc cx
    add si, 3

next_char:
    inc si
    jmp search_loop

finish_search:
    mov result, cx

    mov ax, cx
    mov cx, 0
    mov bx, 10

divide_loop:
    xor dx, dx
    div bx
    push dx
    inc cx
    test ax, ax
    jnz divide_loop

print_loop:
    pop dx
    add dl, '0'
    mov ah, 2
    int 21h
    loop print_loop

    mov ah, 9
    lea dx, clrf
    int 21h

    mov ah, 4ch
    int 21h
main endp
end main
