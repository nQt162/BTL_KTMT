.model small 
.stack 100h 
.data
   
    x_float_count db 0       ; Dung de hien thi phan thap phan sau chia
    x        dw 0            ; toan hang 1
    y        dw 0            ; toan hang 2
    buffer   db 6 dup(0),'$' ; Bo dem chuoi nhap so
    lenth    dw 0            ; Do dai chuoi so da nhap
    operand1 db 0            ; Toan tu luu +, -, *, /, =
    operand2 db 0            ; Toan tu luu =
    key      db 0            ; Luu ky tu vua nhap
    xsighn   db 0            ; Danh dau = 1 neu ket qua am
;---------------------------------------------------   

;error
;---------------------------------------------------  
    div0msg db "Div0!$"                             
;---------------------------------------------------
 
;print lines
;---------------------------------------------------                           
    l0   db 201,21 dup(205),187,'$'
    l8   db 186,21 dup(' '),186,'$';second line
    
    l1   db 186,'   ',201,13 dup(205),187,'   ',186,'$'
    l2   db 186,'   ',186,13 dup(' '),186,'   ',186,'$'
    l3   db 186,'   ',200,13 dup(205),188,'   ',186,'$'
    
    l4   db 186,' ',218,196,191,' ',218,196,191,' ',218,196,191,' ',218,196,191,' ',218,196,191,' ',186,'$'
    l4_2 db 186,' ',218,9 dup(196),191,' ',218,196,191,' ',179,' ',179,' ',186,'$'
    l5   db 186,' ',179,' ',179,' ',179,' ',179,' ',179,' ',179,' ',179,' ',179,' ',179,' ',179,' ',186,'$'
    l5_2 db 186,' ',192,196,217,' ',192,196,217,' ',192,196,217,' ',192,196,217,' ',179,' ',179,' ',186,'$'
    l5_3 db 186,' ',179,9 dup(' '),179,' ',179,' ',179,' ',179,' ',179,' ',186,'$'
    l6   db 186,' ',192,196,217,' ',192,196,217,' ',192,196,217,' ',192,196,217,' ',192,196,217,' ',186,'$'
    l6_2 db 186,' ',192,9 dup(196),217,' ',192,196,217,' ',192,196,217,' ',186,'$'
    l7   db 200,21 dup(205),188,'$'
;---------------------------------------------------                           
ends

;---------------------------------------------------
gotoxy macro x,y        ;move cursor
       pusha
       mov dl,x
       mov dh,y
       mov bx,0
       mov ah,02h
       int 10h 
       popa
endm
;--------------------------------------------------- 
putstr macro buffer     ;print string
       pusha
       mov ah,09h
       mov dx,offset buffer
       int 21h 
       popa
endm
;---------------------------------------------------
putch  macro char,color ;print character
       pusha
       mov ah,09h
       mov al,char
       mov bh,0
       mov bl,color
       mov cx,1
       int 10h 
       popa
endm
;---------------------------------------------------
clear  macro buf
       lea si,buf
       mov [si],' '
       mov [si+1],' '
       mov [si+2],' '
       mov [si+3],' '
       mov [si+4],' '
       mov [si+5],' '
       gotoxy 15,3
       putstr buf
endm
;---------------------------------------------------
number_in  macro  n,operand,lenth
    local l1,l1_2,l1_2_1,l1_3
    local l2,l3,l4
    local next_step, store_operand

    pusha
    
      
    mov lenth, 0  
    lea si, buffer         
    
l1:
    mov ah, 08h            ;nhap ki tu vao ban phim 
    int 21h
    mov key, al
    
l1_2: 
    cmp lenth, 0
    jne next_step
    clear buffer       
    putstr buffer          ;in ra chuoi rong , ghi de len man hinh
    gotoxy 17,3

next_step:
    cmp al, '0'            ; kiem tra xem ki tu co phai la so
    jb l2
    cmp al, '9'
    ja l2

l1_3:
    mov al, key
    mov [si], al
    pusha
    mov dl, al
    mov ah, 02h            ; in ra so da nhap vao 
    int 21h
    popa
    inc si
    inc lenth
    jmp l1

; ==============================
l2: 
    cmp al, '+'
    je store_operand
    cmp al, '-'
    je store_operand
    cmp al, '*'
    je store_operand
    cmp al, '/'
    je store_operand
    cmp al, '='
    je store_operand
    jmp l1  

; ==============================
store_operand:
    cmp lenth, 0
    je l4  
    gotoxy 26,3
    mov operand, al  

 
    mov dl, operand           ;in ra toan tu ( + - * / ) da nhap 
    mov ah, 02h
    int 21h

   
    lea si, buffer
    mov cx, lenth
    mov dx, 0
    mov bx, 10

l3:                          ; in ra ket qua 
    mov ax, dx
    mul bx
    mov dx, ax
    mov ah, 0
    mov al, [si]
    sub al, 48
    add dx, ax
    inc si
    loop l3

    mov n, dx

l4:
    mov n, dx
    gotoxy 24,3
    popa
endm

 
     
;---------------------------------------------------
putrez macro buffer,x
       local next_digit,pz1,pz2
       local nex1,nex2
     
       pusha
       mov ax,x             
       mov cl,x_float_count
       clear buffer
       lea si,buffer               
       mov bx,10             
       mov [si+5],'0'
       mov [si+4],'.'
       mov [si+3],'0'
       
    ;........................                         
       next_digit: 
        cmp cl,0
        jne nex1
        cmp x_float_count,0
        jne nex2
        
        mov [si+5],'0'
        dec si
    nex2:    
        mov dl,'.'
        mov [si+5],dl
        dec si
        dec cl
        dec x_float_count
        jmp next_digit
         
    nex1:
        mov dx,0            ; buffer 
        div bx             
        add dl,48          
        mov [si+5],dl
        dec si
        dec cl
        cmp ax,0
        jne next_digit
         
     
   ;.........................          
       gotoxy 17,3          ;print buffer
       putstr buffer 
        
      
       
   pz1:
       cmp xsighn,1
       jne pz2
       gotoxy 15,3
       putch '-' , 15
   pz2:
       popa
endm
;---------------------------------------------------
reset macro
       mov x,0
       mov y,0 
       mov xsighn,0       
       clear buffer
       mov key,0
       mov operand1,0
       mov operand2,0
endm


.code

start:
; set segment registers:
    mov ax, @data
    mov ds, ax    

call print_screen    
 
begin:
      reset
      calc1:
          number_in x,operand1,lenth
          mov al,operand1
          cmp al,'='  
          je calc1          
          
      calc2:
          number_in y,operand2,lenth
          mov al,operand2
          cmp al,'='
          jne calc1          ;if not '=', restart (invalid input)
          call calculate
              
          putrez buffer,x    ;display result
          mov x_float_count, 0
          mov xsighn,0
          jmp calc1          ;start again for new calculation
 

;--------------------------------------------------
 
print_screen proc :
        gotoxy 10,0;...........
        putstr l0
        gotoxy 10,1
        putstr l8
        gotoxy 10,2;........  ;
        putstr l1          ;  ;
        gotoxy 10,3        ;  ;out cadr
        putstr l2          ;  ;
        gotoxy 10,4        ;  ;
        putstr l3          ;  ;
        gotoxy 10,5;...... ;  ;
        putstr l4        ; ;result board + exit key
        gotoxy 10,6      ; ;  ;
        putstr l5        ; ;  ;
        gotoxy 10,7      ; ;  ;
        putstr l6        ; ;  ;
        gotoxy 10,8      ; ;  ;
        putstr l4        ; ;  ;
        gotoxy 10,9      ;key board
        putstr l5        ; ;  ;
        gotoxy 10,10     ; ;  ;
        putstr l6        ; ;  ;
        gotoxy 10,11     ; ;  ;
        putstr l4        ; ;  ;
        gotoxy 10,12     ; ;  ;
        putstr l5        ; ;  ;
        gotoxy 10,13     ; ;  ;
        putstr l5_2      ; ;  ;
        gotoxy 10,14     ; ;  ;
        putstr l4_2      ; ;  ;
        gotoxy 10,15;..... ;  ;
        putstr l5_3      ;  ;
        gotoxy 10,16;.......  ;  
        putstr l6_2      ;
        gotoxy 10,17    
        putstr l7 
        
         
        ;keyboard labels
        
        
        gotoxy 13,6
        putch '7',14
        gotoxy 17,6
        putch '8',14
        gotoxy 21,6
        putch '9',14
        gotoxy 25,6
        putch '/',11
        gotoxy 29,6
        putch 'C',5
        gotoxy 13,9
        putch '4',14
        gotoxy 17,9
        putch '5',14
        gotoxy 21,9
        putch '6',14
        gotoxy 25,9
        putch '*',11
        gotoxy 29,9
        putch 241,11
        gotoxy 13,12
        putch '1',14
        gotoxy 17,12
        putch '2',14
        gotoxy 21,12
        putch '3',14
        gotoxy 25,12
        putch '-',11
        gotoxy 29,13
        putch '=',11
        gotoxy 17,15
        putch '0',14
      
        gotoxy 25,15
        putch '+',11        
          
       
print_screen endp
;--------------------------------------------------
 
calculate proc 
    
    cmp operand1,'+'
    je plus
    cmp operand1,'-'
    je minus
    cmp operand1,'*'
    je mult
    cmp operand1,'/'
    je devide
    jmp begin   ;no match found!

    plus:       
        mov ax,x
        add ax,y                        
        mov x,ax
        ret                   
                                                                              
    minus:                                
        mov ax,x
        cmp ax,y
        jae mi3
        jb mi4
                
        mi3:            ; neu x >= y 
            mov ax,x
            sub ax,y
            mov x,ax
            mov xsighn,0
            ret
        mi4:            ; neu x  < y , cho xsighn = 1 de lam dau - ;
            mov ax,y
            sub ax,x
            mov x,ax
            mov xsighn,1
            ret
    mult:
        mov ax, x
        mov bx, y
        mul bx       
        mov x, ax
        ret
                   
                            
    devide:       
        cmp y, 0
        je div0
                                      
        xor dx, dx
        mov ax, x 
        mov bx, 10
        mul bx           
        mov bx, y
        xor dx, dx
        div bx           
        mov x, ax        
        mov x_float_count, 1  
        ret                    
                                   
calculate endp
;---------------------------------------------------    

div0:
    gotoxy 15,3            
    putstr div0msg
    mov ah, 01h
    int 21h
    jmp begin                       
 
exit:
    mov ax, 4c00h ; exit 
    int 21h    
ends
 
end start
