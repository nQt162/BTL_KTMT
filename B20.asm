.model small
.stack 100h

.data
    bufA db 255, ?, 255 dup('$')
    bufB db 255, ?, 255 dup('$')
    cnt  dw 0
    nl   db 13,10,'$'

.code
main proc
    mov ax, @data
    mov ds, ax

    ; Nhap chuoi thu nhat
    mov ah, 0Ah
    lea dx, bufA
    int 21h    

    ; Xuong dong
    mov ah, 09h
    lea dx, nl
    int 21h   

    ; Nhap chuoi thu hai
    mov ah, 0Ah
    lea dx, bufB
    int 21h

    ; Xuong dong
    mov ah, 09h
    lea dx, nl
    int 21h  

    ; Khoi tao SI va BX cho chuoi A
    lea si, bufA+2
    mov cl, bufA+1
    xor ch, ch
    mov bx, cx

    ; Khoi tao DI va DX cho chuoi B
    lea di, bufB+2
    mov cl, bufB+1
    xor ch, ch
    mov dx, cx

    xor cx, cx  ; CX = so lan xuat hien

outer:
    mov ax, bx
    sub ax, dx
    cmp si, offset bufA+2
    add ax, offset bufA+2
    cmp si, ax
    ja  done

    push si
    push di
    push dx

    mov bp, dx

compare:
    mov al, [si]
    cmp al, [di]
    jne skip
    inc si
    inc di
    dec bp
    jnz compare
    inc cx

skip:
    pop dx
    pop di
    pop si
    inc si
    jmp outer

done:
    mov cnt, cx
    mov ax, cnt
    call show

    mov ah, 4Ch
    int 21h
main endp

;--------------------
show proc
    mov cx, 0
    mov bx, 10

divloop:
    xor dx, dx
    div bx
    push dx
    inc cx
    cmp ax, 0
    jne divloop

print:
    pop dx
    add dl, '0'
    mov ah, 02h
    int 21h
    loop print

    mov ah, 09h
    lea dx, nl
    int 21h
    ret
show endp

end main
