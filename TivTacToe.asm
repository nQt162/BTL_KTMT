Name "Tic Tac Toe"
Org 100h

.DATA
	MANG DB '1','2','3','4','5','6','7','8','9'
	PLAYER DB ?
	NEWLINE DB 13, 10, '$'
    N DB '                   WELCOME TO$'
	N1 DB '##### # ####  #####  ##  ####  #####  ##  ####$'
	N2 DB '  #   # #       #   #  # #       #   #  # #   $'
	N3 DB '  #   # #       #   #### #       #   #  # ####$'
	N4 DB '  #   # #       #   #  # #       #   #  # #   $'
	N5 DB '  #   # #### #  #   #  # #### #  #    ##  ####$' 
	PRESSKEY DB 'Nhan phim bat ky de tiep tuc...$' 
	PRESSKEY2 DB 'Nhan phim bat ky de tiep tuc...$'
	R DB 'Luat choi: $'
	R1 DB '1. Nguoi choi se lan luot dien vao cac o trong.$' 
	R2 DB '2. Nguoi choi thu 1 se bat dau tro choi.$'                                
	R3 DB '3. Nguoi choi 1 la "X" con nguoi choi 2 la "O".$' 
	R4 DB '4. Bang se duoc danh dau boi cac so.$'
	R5 DB '5. Dien so de danh dau vao o ban muon chon.$'
	R6 DB '6. Cu 3 o lien tiep theo hang doc, ngang hoac cheo se chien thang$'
	R7 DB 'Chuc may man!$'
	L DB  ' ___ ___ ___ $'
	L1 DB '|   |   |   |$'
	L2 DB '|___|___|___|$'  
	CENTER DB '                                 $'
	INPUT DB '               Nhap vi tri ban muon chon, luot cua nguoi choi: $'
	DRAW DB 'HOA! $'
	WIN DB 'NGUOI CHOI THANG: $'
	OCCUPIED DB 'O nay da duoc chon!$'

.CODE
main:
	mov cx, 9
	call CLEAR_SCREEN
	call PRINT_WELCOME
	call PRINT_RULES
	call PRINT_MANG

game_loop:
	mov bx, cx
	and bx, 1
	cmp bx, 0
	je isEven
	mov PLAYER, 'X'
	jmp nextPlayer
isEven:
	mov PLAYER, 'O'
nextPlayer:

get_input:
	call NEW_LINE
	call IN_NHAP
	call NHAP

	sub al, '1'
	xor ah, ah
	mov si, ax

	cmp MANG[si], 'X'
	je cell_taken
	cmp MANG[si], 'O'
	je cell_taken

	mov dl, PLAYER
	mov MANG[si], dl

	call PRINT_MANG
	call CHECKWIN

	loop game_loop

	call PRINT_DRAW
	jmp programEnd

cell_taken:
	call NEW_LINE
	call PRINT_CENTER
	lea dx, OCCUPIED
	mov ah, 9
	int 21h
	jmp get_input

programEnd:
	mov ah, 0
	int 16h
	ret

PRINT_MANG:
	call CLEAR_SCREEN
	push cx
	mov bx,0
	mov cx,3
	call PRINT_CENTER
	mov ah, 9
	lea dx, L
	int 21h
print_rows:  
    
	call NEW_LINE 
	call PRINT_CENTER
	mov ah, 9
	lea dx, L1
	int 21h
	call NEW_LINE
	call PRINT_CENTER
	push cx
	mov cx, 3
print_cells:
    
	mov ah, 2
	mov dl, '|'
	int 21h
	call PRINT_Space
	mov dl, MANG[bx]
	int 21h
	call PRINT_Space
	inc bx
	loop print_cells
	pop cx 
	mov dl, '|'
	int 21h
	call NEW_LINE 
	call PRINT_CENTER
	mov ah, 9
	lea dx, L2
	int 21h
	loop print_rows
	pop cx
	call NEW_LINE
	ret

PRINT_Space:
	mov dl, 32
	mov ah, 2
	int 21h
	ret

NHAP:
	mov ah, 1
	int 21h
	cmp al, '1'
	jb NHAP
	cmp al, '9'
	ja NHAP
	ret

PRINT_WELCOME:
	lea dx, N
	mov ah, 9
	int 21h
	call NEW_LINE
	lea dx, N1
	mov ah, 9
	int 21h
	call NEW_LINE
	lea dx, N2
	mov ah, 9
	int 21h
	call NEW_LINE
	lea dx, N3
	mov ah, 9
	int 21h
	call NEW_LINE
	lea dx, N4
	mov ah, 9
	int 21h
	call NEW_LINE
	lea dx, N5
	mov ah, 9
	int 21h
	call NEW_LINE
	lea dx, PRESSKEY
	mov ah, 9
	int 21h
	mov ah, 1
	int 21h
	ret

PRINT_RULES:
	call CLEAR_SCREEN
	lea dx, R
	mov ah, 9
	int 21h
	call NEW_LINE
	lea dx, R1
	mov ah, 9
	int 21h
	call NEW_LINE
	lea dx, R2
	mov ah, 9
	int 21h
	call NEW_LINE
	lea dx, R3
	mov ah, 9
	int 21h
	call NEW_LINE
	lea dx, R4
	mov ah, 9
	int 21h
	call NEW_LINE
	lea dx, R5
	mov ah, 9
	int 21h
	call NEW_LINE
	lea dx, R6
	mov ah, 9
	int 21h
	call NEW_LINE 
	lea dx, R7
	mov ah, 9
	int 21h
	call NEW_LINE
	lea dx, PRESSKEY2
	mov ah, 9
	int 21h
	mov ah, 1
	int 21h
	ret

NEW_LINE:
	lea dx, NEWLINE
	mov ah, 9
	int 21h
	ret
PRINT_CENTER: 
    lea dx, CENTER
    mov ah, 9
    int 21h
    ret
PRINT_DRAW:
	call NEW_LINE
	lea dx, CENTER     
	mov ah, 9
	int 21h 
	lea dx, DRAW
	mov ah, 9
	int 21h
	ret

PRINT_WIN:
	call NEW_LINE
	call PRINT_MANG
    lea dx, CENTER     
	mov ah, 9
	int 21h 
	lea dx, WIN
	mov ah, 9
	int 21h
	mov dl, PLAYER
	mov ah, 2
	int 21h
	jmp programEnd

IN_NHAP:  
	lea dx, INPUT
	mov ah, 9
	int 21h
	mov dl, PLAYER
	mov ah, 2
	int 21h
	call PRINT_Space
	ret

CHECKWIN:
	mov bl, MANG[0]
	cmp bl, MANG[1]
	jne skip1
	cmp bl, MANG[2]
	jne skip1
	call PRINT_WIN
skip1:
	mov bl, MANG[3]
	cmp bl, MANG[4]
	jne skip2
	cmp bl, MANG[5]
	jne skip2
	call PRINT_WIN
skip2:
	mov bl, MANG[6]
	cmp bl, MANG[7]
	jne skip3
	cmp bl, MANG[8]
	jne skip3
	call PRINT_WIN
skip3:
	mov bl, MANG[0]
	cmp bl, MANG[3]
	jne skip4
	cmp bl, MANG[6]
	jne skip4
	call PRINT_WIN
skip4:
	mov bl, MANG[1]
	cmp bl, MANG[4]
	jne skip5
	cmp bl, MANG[7]
	jne skip5
	call PRINT_WIN
skip5:
	mov bl, MANG[2]
	cmp bl, MANG[5]
	jne skip6
	cmp bl, MANG[8]
	jne skip6
	call PRINT_WIN
skip6:
	mov bl, MANG[0]
	cmp bl, MANG[4]
	jne skip7
	cmp bl, MANG[8]
	jne skip7
	call PRINT_WIN
skip7:
	mov bl, MANG[2]
	cmp bl, MANG[4]
	jne skip8
	cmp bl, MANG[6]
	jne skip8
	call PRINT_WIN
skip8:
	ret

CLEAR_SCREEN:
	mov ax, 3
	int 10h 
	ret

end main
