.Model Small
.Stack 100H
.Data
    Board db '1','2','3','4','5','6','7','8','9'
    Turn db 'X'
    Move db 0
    PressKey db 13,10,' Nhan phim bat ky de tiep tuc...$'
    PressKey2 db 13,10,'             Nhan phim bat ky de tiep tuc...$' 
    PlayerXTurn db 13,10,'                     Luot cua nguoi choi X (Nhap 1-9): $'
    PlayerOTurn db 13,10,'                     Luot cua nguoi choi O (Nhap 1-9): $'
    Invalid db 13,10,'                     Vi tri khong hop le hoac da duoc chon! Thu lai.$'
    MsgXWin db 13,10,'                           Nguoi choi X thang!$'
    MsgOWin db 13,10,'                           Nguoi choi O thang!$'
    MsgDraw db 13,10,'                                   Hoa!$'  
    Center db '                         $'
    EmptyLine db '       |       |       $'
    EndLine   db '_______|_______|_______$'
    MsgNewLine db 13,10,'$' 
    TitleLine1 db '  _|_|_| _|_|_| _|_|_|   _|_|_|   _|   _|_|_|   _|_|_| _|_|_| _|_|_|$'
    TitleLine2 db '    _|     _|   _|         _|   _|  _| _|         _|   _|  _| _|    $' 
    TitleLine3 db '    _|     _|   _|         _|   _|  _| _|         _|   _|  _| _|    $' 
    TitleLine4 db '    _|     _|   _|         _|   _|_|_| _|         _|   _|  _| _|_|_|$' 
    TitleLine5 db '    _|     _|   _|         _|   _|  _| _|         _|   _|  _| _|    $' 
    TitleLine6 db '    _|     _|   _|         _|   _|  _| _|         _|   _|  _| _|    $' 
    TitleLine7 db '    _|   _|_|_| _|_|_|     _|   _|  _| _|_|_|     _|   _|_|_| _|_|_|$'
    RuleTitle db 13,10,'                          Luat choi Tic Tac Toe:$'
    RuleLine1 db 13,10, '            1. Mang bang chuc nang 3x3 cho hai nguoi choi. $'
    RuleLine2 db 13,10, '            2. Nguoi choi X va O thay phien nhau chon vao mang. $'
    RuleLine3 db 13,10, '            3. Nguoi choi X di truoc, nhap vi tri (1-9).$'
    RuleLine4 db 13,10, '            4. Cam thuc, ba ky tu X hoac O dan den chien thang. $'
    RuleLine5 db 13,10, '            5. Tro choi ket thuc khi co nguoi thang hoac hoa. $'
    RuleLine6 db 13,10, '            6. Nhap phim bat ky de tiep tuc. Chuc vui ve!$'
.Code
MAIN:
    MOV AX, @Data
    MOV DS, AX
    CALL CLEAR_SCREEN
    CALL ShowTitle
    MOV AH, 9
    LEA DX, PressKey
    INT 21H
    MOV AH, 1
    INT 21H
    CALL ShowRule
    GameLoop:  
        CALL CLEAR_SCREEN
        CALL PRINT_BOARD
        MOV AH, 9
        LEA DX, Center
        INT 21H
        CMP Turn, 'X'
        JE ShowX
        LEA DX, PlayerOTurn
        JMP ShowTurn
    ShowX:
        LEA DX, PlayerXTurn
    ShowTurn:
        INT 21H
        MOV AH, 1
        INT 21H
        SUB AL, '1'
        CMP AL, 8
        JA InvalidMove
        MOV BL, AL
        MOV BH, 0
        MOV AL, Board[bx]
        CMP AL, 'X'
        JE InvalidMove
        CMP al, 'O'
        JE InvalidMove
        MOV AL, Turn
        MOV Board[bx], AL
        INC Move
        CALL CheckWin
        CMP AL, 1
        JE WIN
        CMP Move, 9
        JE DRAW
        CMP Turn, 'X'
        JE SET_O
        MOV Turn, 'X'
        JMP GameLoop
    SET_O:
        MOV Turn, 'O'
        JMP GameLoop
    InvalidMove:
        CALL NEWLINE
        LEA DX, Center
        INT 21H
        LEA DX, Invalid
        INT 21H
        MOV AH, 1
        INT 21H
        JMP GameLoop
    WIN:
        CALL CLEAR_SCREEN
        CALL PRINT_BOARD
        MOV AH, 9h
        LEA DX, Center
        INT 21H
        CMP Turn, 'X'
        JE X_WIN
        LEA DX, MsgOWin
        JMP ShowResult
    X_WIN:
        LEA DX, MsgXWin
    ShowResult:
        INT 21H
        JMP Exit
    DRAW: 
        CALL CLEAR_SCREEN
        CALL PRINT_Board
        MOV AH, 9
        LEA DX, Center
        INT 21H
        LEA DX, MsgDraw
        INT 21H
    Exit:
        MOV AH, 4CH
        INT 21H
    ShowTitle Proc
        MOV AH, 9
        LEA DX, TitleLine1
        INT 21H
        CALL NEWLINE
        LEA DX, TitleLine2
        INT 21H
        CALL NEWLINE
        LEA DX, TitleLine3
        INT 21H
        CALL NEWLINE
        LEA DX, TitleLine4
        INT 21H
        CALL NEWLINE
        LEA DX, TitleLine5
        INT 21H
        CALL NEWLINE
        LEA DX, TitleLine6
        INT 21H
        CALL NEWLINE
        LEA DX, TitleLine7
        INT 21H
        CALL NEWLINE
        RET
    ShowTitle Endp 
    ShowRule Proc
        CALL CLEAR_SCREEN
        MOV AH, 2      
        MOV BH, 0        
        MOV DH, 0        
        MOV DL, 0        
        INT 10H          
        MOV AH, 9
        LEA DX, Center
        INT 21H
        LEA DX, RuleTitle 
        INT 21H
        CALL NEWLINE
        LEA DX, RuleLine1
        INT 21H
        CALL NEWLINE
        LEA DX, RuleLine2
        INT 21H
        CALL NEWLINE
        LEA DX, RuleLine3
        INT 21H
        CALL NEWLINE
        LEA DX, RuleLine4
        INT 21H
        CALL NEWLINE
        LEA DX, RuleLine5
        INT 21H
        CALL NEWLINE
        LEA DX, RuleLine6
        INT 21H
        CALL NEWLINE
        MOV AH, 9
        LEA DX, PressKey2
        INT 21H
        MOV AH, 1
        INT 21H
        RET
    ShowRule Endp
    CLEAR_SCREEN Proc
        MOV AH, 6
        MOV AL, 0
        MOV BH, 7
        MOV CX, 0
        MOV DX, 184FH
        INT 10H
        RET
    CLEAR_SCREEN Endp
    PRINT_BOARD Proc
        PUSH AX
        PUSH BX
        PUSH DX
        MOV AH, 2
        MOV BH, 0
        MOV DH, 5
        MOV DL, 0
        INT 10H
        MOV CX, 3
        MOV BX, 0
    PrintRows:
        CALL PrintEmptyLine
        CALL PrintLineNumbers
        DEC CX
        JNZ PRINT_SEP
        JMP FINISH
    PRINT_SEP:
        CALL PrintLineSep
        JMP PrintRows
    FINISH:
        POP AX
        POP BX
        POP DX
        RET
    PRINT_BOARD Endp
    PrintEmptyLine Proc
        MOV AH, 9
        LEA DX, Center
        INT 21H
        LEA DX, EmptyLine
        INT 21H
        CALL NEWLINE
        RET
    PrintEmptyLine Endp
    PrintLineNumbers Proc 
        PUSH AX
        PUSH DX
        MOV AH, 9
        LEA DX, Center
        INT 21H
        MOV DL, ' '
        CALL PrintChar
        MOV DL , ' '
        CALL PrintChar
        MOV DL, ' '
        CALL PrintChar
        MOV DL, Board[bx]
        CALL PrintChar
        MOV DL, ' '
        CALL PrintChar
        MOV DL, ' ' 
        CALL PrintChar
        MOV DL, ' '
        CALL PrintChar  
        MOV DL, '|'
        CALL PrintChar
        MOV DL, ' '
        CALL PrintChar
        MOV DL, ' '
        CALL PrintChar
        MOV DL, ' '
        CALL PrintChar
        MOV DL, Board[bx+1]
        CALL PrintChar
        MOV DL, ' '
        CALL PrintChar
        MOV DL, ' '
        CALL PrintChar       
        MOV DL, ' '  
        CALL PrintChar
        MOV DL, '|'
        CALL PrintChar
        MOV DL, ' '  
        CALL PrintChar 
        MOV DL, ' '
        CALL PrintChar
        MOV dl, ' '
        CALL PrintChar
        MOV dl, Board[bx+2]
        CALL PrintChar
        CALL newline
        ADD BX, 3
        POP AX
        POP DX
        RET
    PrintLineNumbers Endp
    PrintLineSep Proc
        MOV AH, 9
        LEA DX, Center
        INT 21H
        LEA DX, EndLine
        INT 21H
        CALL NewLine
        RET
    PrintLineSep Endp
    PrintChar Proc 
        MOV AH, 2
        INT 21H
        RET
    PrintChar Endp
    NEWLINE Proc 
        MOV AH, 9
        LEA DX, MsgNewLine
        INT 21H
        RET
    NEWLINE Endp
    CheckWin Proc
        PUSH BX
        PUSH CX
        MOV BX, 0
        MOV CX, 3
    CheckRows:
        MOV AL, Board[bx]
        CMP AL, Board[bx+1]
        JNE NextRow
        CMP AL, Board[bx+2]
        JNE NextRow
        MOV AL, 1
        JMP FoundWin
    NextRow:
        ADD BX, 3
        DEC CX
        JNZ CheckRows
        MOV BX, 0
        MOV CX, 3
    CheckCols:
        MOV AL, Board[bx]
        CMP AL, Board[bx+3]
        JNE NextCol
        CMP AL, Board[bx+6]
        JNE NextCol
        MOV AL, 1
        JMP FoundWin
    NextCol:
        INC BX
        DEC CX
        JNZ CheckCols
        MOV AL, Board[0]
        CMP AL, Board[4]
        JNE CheckDiag2
        CMP AL, Board[8]
        JE WinDiag
    CheckDiag2:
        MOV AL, Board[2]
        CMP AL, Board[4]
        JNE NoWin
        CMP AL, board[6]
        JNE NoWin
    Windiag:
        MOV AL, 1
        JMP FoundWin
    NoWin:
        MOV AL, 0
    FoundWin:
        POP CX
        POP BX
        RET
    CheckWin Endp
END MAIN