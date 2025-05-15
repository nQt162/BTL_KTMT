.Model Small
.Stack 100h
.Data
    msg db 0dh,0ah,"1-Add", 0dh,0ah,"2-Multiply", 0dh,0ah,"3-Subtract", 0dh,0ah,"4-Divide", 0dh,0ah,"5-Exit", 0Dh,0Ah, '$'
    msg1 db 0dh, 0ah, "Select type: $"
    msg2 db 0dh,0ah,"Enter First No : $"
    msg3 db 0dh,0ah,"Enter Second No : $"
    msg4 db 0dh,0ah,"Choice Error $" 
    msg5 db 0dh,0ah,"Result : $" 
    msg6 db 0dh,0ah ,"Thank you for using the calculator!$ "
    crlf db 13, 10, '$'
             
    base_decmical dw 10 
    x dw 0
             
    a dw 0
    b dw 0 
    res dw 0 
    choice db 0
.Code    
Main PROC
    mov ax, @Data
    mov ds, ax 
    
    lea dx, msg
    mov ah, 9
    int 21h 

    mainLoop: 
        lea dx, msg1
        mov ah, 9
        int 21h
        
        mov ah, 01h
        int 21h
        mov [choice], al

   
        cmp choice, '5'
        je exit
        cmp choice, '1'
        je do_add
        cmp choice, '2'
        je do_mul
        cmp choice, '3'
        je do_sub
        cmp choice, '4'
        je do_div
    
        lea dx, msg4
        mov ah, 9
        int 21h
        lea dx, crlf
        mov ah, 9
        int 21h
        
        jmp mainLoop    

    do_add:  
        call ReadNum
        call Addition
        jmp show_result
    do_mul:           
        call ReadNum
        call Multiply
        jmp show_result
    do_sub:           
        call ReadNum
        call Substract
        jmp show_result
    do_div:          
        call ReadNum
        call Divide
        jmp show_result

    show_result:
        lea dx, msg5
        mov ah, 9
        int 21h
        
        call OutputInteger  
         
        lea dx, crlf
        mov ah, 9
        int 21h      
        
        jmp mainLoop

    exit:
        lea dx, msg6
        mov ah, 9
        int 21h

        mov ah, 4Ch
        int 21h
Main ENDP
      

InputInteger PROC
    mov x, 0
    
    loopDigit:
        mov ah, 1
        int 21h
        
        cmp al, 13
        je endInput
        cmp al, ' '
        je endInput
        
        mov ah, 0           ; reset 
        sub al, '0'         ; convert from char to int
        push ax
        
        mov ax, x
        mul base_decmical
        mov x, ax
        pop ax
        add x, ax
        
        jmp loopDigit  
    
    endInput:
    ret        
        
InputInteger ENDP

ReadNum PROC
    lea dx, msg2
    mov ah, 9
    int 21h
    call InputInteger
    mov ax, [x]
    mov [a], ax 

    lea dx, msg3
    mov ah, 9
    int 21h
    call InputInteger
    mov ax, [x]
    mov [b], ax
    
    ret     
    
ReadNum ENDP

OutputInteger PROC
    mov ax, res
    mov cx, 0
    
    GetDigit:
        mov dx, 0           ; reset
        div base_decmical
        push dx
        
        inc cx  
        cmp ax, 0
        je showInteger  
        
                jmp GetDigit
    showInteger:
        mov ah, 2
        
        pop dx
        add dl, '0'
        
        int 21h
        
        dec cx
        cmp cx, 0
        jne showInteger
ret

OutputInteger ENDP
 
Addition PROC
    mov ax, [a]
    add ax, [b] 
    mov [res], ax   
                 
    ret
Addition ENDP  

Substract PROC
    mov ax, [a]
    sub ax, [b] 
    mov [res], ax   
                 
    ret 
Substract ENDP  
    
Multiply PROC
    mov ax, [a]
    mov bx, [b] 
    mul bx
    mov [res], ax   
                 
    ret 
Multiply ENDP

Divide PROC
    mov ax, [a]
    mov bx, [b]
    div bx 
    mov [res], ax   
                 
    ret 
Divide ENDP  

END MAIN