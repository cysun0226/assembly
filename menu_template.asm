; ==========================================
; Assembly menu template
; ==========================================
; Student Name:  Chia-Yu, Sun
; Student ID:    0416045
; Student Email: cysun0226@gmail.com
; ==========================================

TITLE menu

include Irvine32.inc
include Macros.inc

.data
p DWORD 2, 3, 4
opt BYTE ?
frame_width BYTE 80
frame_height BYTE 13
menu_height BYTE 20
tmp_casting DWORD ?
menu_background_color BYTE black
menu_frame_color BYTE yellow
menu_text_color BYTE white
wait_option_height BYTE 11

; opt1
n DWORD ?
m DWORD ?
n_1 REAL8 3.5
n_2 REAL8 1.0
s_0 REAL8 3.5
s_1 REAL8 1.0
cur_n REAL8 ?
return_addr DWORD ?

; menu
str_menu BYTE  10, 13,
"   === Options === ", 10, 13, 10, 13,
"   1. ... ", 10, 13,
"   2. ... ", 10, 13,
"   3. ... ", 10, 13,
"   4. ... ", 10, 13,
"   5. Quit the program", 10, 13, 10, 13,
"   > Please select an option: ", 0

; opt1 message
str_opt1_msg BYTE 10, 13,
" === Change ship color === ", 10, 13, 10, 13,
" Please select a color for the space ship. ", 10, 13, 10, 13, 0

; opt2 message
str_opt2_msg BYTE 10, 13,
" === Show a frame === ", 10, 13, 10, 13, 0

; opt3 message
str_opt3_msg BYTE 10, 13,
" === Play === ", 10, 13, 10, 13,
" press 'e' to move up and press 'c' to move down ", 10, 13, 10, 13, 0

; opt4 message
str_opt4_msg BYTE 10, 13,
"   === Show author information === ", 10, 13, 10, 13,
"   Studnet ID    : 0416045 ", 10, 13,
"   Studnet name  : Chia-Yu, Sun ", 10, 13,
"   Studnet email : cysun0226@gmail.com ", 10, 13, 10, 13, 0

; quit message
str_quit_msg BYTE 10, 13, 10, 13,
" Thanks for playing this system.", 10, 13, 10, 13,
" This program is written by ", 10, 13, 10, 13,
"   Name: Chia-Yu, Sun", 10, 13,
"   ID: student 0416045", 10, 13, 10, 13,
" I am learning assembly programming.", 10, 13,
" Please contact me at cysun0226@gmail.com", 10, 13, 10, 13,
" (Press anykey to quit.)", 0


; == main =====================
.code
main PROC
L_menu:
	call Clrscr
	call show_menu
	call get_key
	mov opt, al

	; if 5, quit
	cmp opt, '5'
	je L_quit

	cmp opt, '1'
	jne case_2
	call opt_1
	jmp L_end_case
case_2:
	cmp opt, '2'
	jne case_3
	call opt_2
	jmp L_end_case
case_3:
	cmp opt, '3'
	jne case_4
	call opt_3
	jmp L_end_case
case_4:
	cmp opt, '4'
	jne L_end_case
	call opt_4
L_end_case:
	jmp L_menu
L_quit:
	call Clrscr
	mov edx, offset str_quit_msg
	invoke WriteString
	call waitKey
	exit

main ENDP
; == main =====================

; == show menu =====================
show_menu PROC
	movzx eax, menu_background_color
	shl eax, 4
	movzx ebx, menu_text_color
	add eax, ebx
	call SetTextColor
	movzx ecx, menu_height
	movzx ebx, frame_width
L_draw_menu_background:
	mov eax, ecx
	call draw_bar
	loop L_draw_menu_background

	; menu message
	call Crlf
	mov edx, offset str_menu
	invoke WriteString

	; menu border
	movzx eax, menu_frame_color
	shl eax, 4
	call SetTextColor
	; bottom border
	movzx eax, menu_height
	inc eax
	call draw_bar
	; top border
	mov eax, 0
	call draw_bar
	; left border
	mov eax, 0
	mov ebx, 0
	mov bl, menu_height
	add bl, 2
	call draw_straight
	; right border
	movzx eax, frame_width
	mov ebx, 0
	mov bl, menu_height
	add bl, 2
	call draw_straight
	mov dh, wait_option_height
	mov dl, 30
	call Gotoxy

	call restore_color
	ret
show_menu ENDP
; == show menu =====================

; == opt1 =====================
opt_1 PROC
L_opt1:
	call Clrscr
	mov edx, offset str_opt1_msg
	invoke WriteString

	mWrite " (or input n = 0 to return to menu)"
L_opt1_get_n:
	call Crlf
	call Crlf
	mWrite " > Input n [0, 100]: "
	call readInt
	cmp eax, 0
	je L_opt1_quit
	jl L_opt1_invalid_n
	cmp eax, 100
	jg L_opt1_invalid_n
	jmp L_opt1_valid_n
L_opt1_invalid_n:
	call Crlf
	mWrite "   [X] The input is not in [0, 100]. Please input again."
	call Crlf
	jmp L_opt1_get_n
L_opt1_valid_n:
	mov n, eax
	mWrite " > Input m (non-zero, signed integer): "
	call readInt
	mov m, eax

	; sum = (1+n)n
	mov ebx, n
	mov eax, n
	inc ebx
	mul ebx ; result is now in eax

	; divide m
	mov ebx, m
	idiv ebx
	; quotient is in ax , rem is in dx
	call Crlf
	call Crlf
	mWrite " The quotient = "
	call WriteInt
	call Crlf
	mov eax, edx
	mWrite " The remainder = "
	call WriteInt
	; jmp L_opt1
L_opt1_quit:
	call waitKey
	ret
opt_1 ENDP
; == opt1 =====================

; == opt2 =====================
opt_2 PROC
L_opt2:
	call Clrscr
	mov edx, offset str_opt2_msg
	invoke WriteString

L_opt2_get_n:
	call Crlf
	call Crlf
	mWrite " > Input n [0, 50]: "
	call readInt
	cmp eax, 0
	je L_opt2_quit
	jl L_opt2_invalid_n
	cmp eax, 50
	jg L_opt2_invalid_n
	jmp L_opt2_valid_n
L_opt2_invalid_n:
	call Crlf
	mWrite "   [X] The input is not in [0, 50]. Please input again."
	call Crlf
	jmp L_opt2_get_n
L_opt2_valid_n:
	mov n, eax
	mov ebx, eax
	mWrite " > Input m (non-zero, signed integer): "
	call readInt
	mov m, eax

	; if (n%2 == 0), result = -n
	test ebx, 1
	jnz L_opt2_odd_n
	neg ebx
	jmp L_opt2_result
	; else if (n%2 == 1), result = n+1
L_opt2_odd_n:
	inc ebx
L_opt2_result:
	mov ecx, m
	mov eax, ebx
	mul ecx ; series*m
	call Crlf
	call Crlf
	mWrite " The result = "
	call WriteInt
	call Crlf
	call waitKey
	; jmp L_opt2
L_opt2_quit:
	ret
opt_2 ENDP
; == opt2 =====================

; == opt3 =====================
opt_3 PROC
L_opt3:
	call Clrscr
	mov edx, offset str_opt3_msg
	invoke WriteString
L_opt3_get_n:
	call Crlf
	call Crlf
	mWrite " > Pleas input n: "
	call readInt
	cmp eax, 0
	je L_opt3_quit
	jl L_opt3_invalid_n
	jmp L_opt3_valid_n
L_opt3_invalid_n:
	call Crlf
	mWrite "   [X] The input must > 0. Please input again."
	call Crlf
	jmp L_opt3_get_n
L_opt3_valid_n:
	mov n, eax
	; S(n) = S(n-1) + S(n-2)
	finit
	fld s_0
	fstp n_1
	fld s_1
	fstp n_2
	mov ecx, n
	dec ecx
L_opt3_computing:
	; f(n) = f(n-1) + f(n-2)
	fld n_2
	fld n_1
	fadd
	fstp cur_n
	; f(n-2) = f(n-1)
	fld n_1
	fstp n_2
	; f(n-1) = f(n)
	fld cur_n
	fstp n_1
	loop L_opt3_computing

	call Crlf
	call Crlf
	fld cur_n
	mWrite " The result = "
	call WriteFloat
	call Crlf
	call waitKey
	; jmp L_opt3
L_opt3_quit:
	ret
opt_3 ENDP
; == opt3 =====================

; == opt4 =====================
opt_4 PROC
	call Clrscr
	mov edx, offset str_opt4_msg
	invoke WriteString

	mov eax, blue
	shl eax, 4
	call SetTextColor
	call Clrscr

	; show white char in the middle
	mov eax, white
	shl eax, 4
	call SetTextColor
	call GetMaxXY
	mov dh, frame_height
	mov bh, dl
	shr dl, 1
	dec dl
	call Gotoxy
	mov al, ' '
  invoke WriteChar

	; move left and right
	; right
	movzx ecx, dl
L_opt4_move_right:
	mov bl, dl
	dec dl
	mov eax, blue
	shl eax, 4
	call SetTextColor
	call Gotoxy
	mov al, ' '
	invoke WriteChar
	mov dl, bl
	inc dl
	mov eax, white
	shl eax, 4
	add eax, white
	call SetTextColor
	call Gotoxy
	mov al, ' '
	invoke WriteChar
	mov eax, 100 ; sleep, to allow OS to time slice
	call Delay
	loop L_opt4_move_right

	dec bh
	dec bh
	movzx ecx, bh
L_opt4_move_left:
	mov bl, dl
	inc dl
	mov eax, blue
	shl eax, 4
	call SetTextColor
	call Gotoxy
	mov al, ' '
	invoke WriteChar
	mov dl, bl
	dec dl
	mov eax, white
	shl eax, 4
	add eax, white
	call SetTextColor
	call Gotoxy
	mov al, ' '
	invoke WriteChar
	mov eax, 100 ; sleep, to allow OS to time slice
	call Delay
	loop L_opt4_move_left

	call restore_color
	ret
opt_4 ENDP
; == opt4 =====================

; == waitKey =====================
waitKey PROC
	call Crlf
	call Crlf
	mWrite " (Press anykey to back to the menu...)"
L_wait_anykey:
	mov eax, 50
	call Delay
	call ReadKey
	jz L_wait_anykey
	call Crlf
	ret
waitKey ENDP
; == waitKey =====================

; --------------------------------------------------
; function: draw_bar(int h, int w)
; receive: height, width
; pass by eax, ebx
; --------------------------------------------------
draw_bar PROC
	push eax
	push ebx
	push ecx
	push edx
  mov tmp_casting, eax
  mov dh, BYTE PTR tmp_casting
  mov dl, 0
  call Gotoxy
	mov ecx, ebx
L_DRAW_BAR:
  mov al, ' '
  invoke WriteChar
  loop L_DRAW_BAR
	pop edx
	pop ecx
	pop ebx
	pop eax
  ret
draw_bar ENDP
; == draw bar ===============================


; == draw straight ==========================
; function: draw_straight(int h, int w)
; receive: x_coordinate, length
; pass by eax, ebx
; --------------------------------------------------
draw_straight PROC
	push eax
	push ebx
	push ecx
	push edx
	mov tmp_casting, eax
	mov dl, BYTE PTR tmp_casting
	mov dh, 0
	call Gotoxy
	mov ecx, ebx
L_DRAW_STRAIGHT:
	mov al, ' '
	invoke WriteChar
	mov dl, BYTE PTR tmp_casting
	inc dh
	call Gotoxy
	loop L_DRAW_STRAIGHT
	pop edx
	pop ecx
	pop ebx
	pop eax
	ret
draw_straight ENDP
; == draw straight ==========================

; == restore color ==========================
restore_color PROC
	mov eax, 00001111b ; black background, white text
	call SetTextColor
	ret
restore_color ENDP
; == restore color ==========================

; == get key ================================
; the result of key will store in al
; -------------------------------------------
get_key PROC
L_wait_key:
	mov eax, 50
	call Delay
	call ReadKey
	jz L_wait_key
	ret
get_key ENDP
; == get key =================================

end main
