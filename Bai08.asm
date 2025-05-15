.Model Small
.Stack 100H
.Data
    MSG1    DB 'Nhap so he co so 10: $'
    MSG2    DB 13,10,'So chuyen sang he 16: $'
    CLRF    DB 13,10, '$'
    Number  DW 0
    Ten     DW 10
    Sixteen DW 16

.Code 
Main Proc
    MOV AX, @Data
    MOV DS, AX
    MOV CX, 0  
    
    ; In thong bao nhap
    LEA DX, MSG1
    MOV AH, 09h
    INT 21h

READ:
    MOV AH, 1
    INT 21H    
    CMP AL, 13
    JE NEXT
    SUB AL, '0'
    MOV AH, 0
    PUSH AX
    MOV AX, Number
    MUL Ten
    MOV Number, AX 
    POP AX
    ADD Number, AX
    JMP READ

NEXT: 
    ; In thong bao ket qua
    LEA DX, MSG2
    MOV AH, 09h
    INT 21H

    ; Bat dau chuyen sang he 16
    MOV AX, Number
    MOV CX, 0

REPEAT:
    MOV DX, 0
    DIV Sixteen
    PUSH DX
    INC CX
    CMP AX, 0
    JG REPEAT

TAKE_OUT:
    POP DX
    CMP DX, 10
    JE A
    CMP DX, 11
    JE B
    CMP DX, 12
    JE C
    CMP DX, 13
    JE D
    CMP DX, 14
    JE E
    CMP DX, 15
    JE F
    ADD DX, '0'
    JMP PRINT

A: MOV DL, 'A'
   JMP PRINT
B: MOV DL, 'B'
   JMP PRINT
C: MOV DL, 'C'
   JMP PRINT
D: MOV DL, 'D'
   JMP PRINT
E: MOV DL, 'E'
   JMP PRINT
F: MOV DL, 'F'
   JMP PRINT     

PRINT:
    MOV AH, 2
    INT 21H
    LOOP TAKE_OUT

    MOV AH, 4CH
    INT 21H

Main Endp
END
