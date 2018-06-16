; ==========================================
; Department Of Computer Science
; National Chiao Tung University
;
; Assembly Programming
; Final Programming Exam
; ==========================================
; Write programs in the Release mode
; ==========================================
; $Student Name:  Chia-Yu, Sun
; $Student ID:    0416045
; $Student Email: cysun0226@gmail.com
; ==========================================
; Prof. Sai-Keung Wong
; Date: 2018/06/07
;
TITLE final

include Irvine32.inc
include Macros.inc

.data

opt BYTE ?
frame_width DWORD 16
frame_height DWORD 12
menu_width DWORD 60
menu_height DWORD 11
menu_frame_color BYTE yellow



; menu
str_menu BYTE 10, 13, 10, 13,
"  === Options === ", 10, 13, 10, 13,
"  1. Recursive function", 10, 13,
"  2. Animation", 10, 13,
"  3. Show Credits", 10, 13,
"  4. Quit", 10, 13, 10, 13,
"  > Please select an option: ", 0

str_opt1 BYTE 10, 13,
" === Recursive function === ", 10, 13, 10, 13, 0

str_opt2 BYTE 10, 13,
" === Animation === ", 10, 13, 10, 13, 0

str_opt3 BYTE 10, 13,
" === Show Credits === ", 10, 13, 10, 13,
" This program is written by", 10, 13, 10, 13,
"    Name: Chia-Yu, Sun", 10, 13,
"    ID: 0416045", 10, 13,
"    Email Address: cysun0226@gmail.com", 10, 13, 10, 13,
" Thanks for playing. ", 10, 13,
" Press a key to go back to the main menu.", 0

bitmap BYTE 1, 1, 1, 1, 1
	BYTE 1, 0, 0, 0, 1
	BYTE 1, 0, 0, 0, 1
	BYTE 1, 0, 0, 0, 1
	BYTE 1, 1, 1, 1, 1

; opt_1
ipt_a SDWORD ?
ipt_b SDWORD ?


; PROTO
foo PROTO,
a : SDWORD,
b : SDWORD

draw_bit_map PROTO,
x_start: DWORD,
y_start: DWORD

earse_bit_map PROTO,
x_start: DWORD,
y_start: DWORD

; proto NOTE func PROTO
draw_bar PROTO,
y_start: DWORD,
line_length: DWORD

draw_straight PROTO,
x_start: DWORD,
y_start: DWORD,
line_length: DWORD

draw_frame PROTO,
x_start: DWORD,
y_start: DWORD,
f_width: DWORD,
f_height: DWORD



tmp_casting DWORD ?
bitmap_x DWORD 0
bitmap_y DWORD 0

blue_spot_x BYTE ?
blue_spot_y BYTE ?

bitmap_color BYTE 1
bar_delay BYTE 0

.code

; == main ===================================
main PROC
L_menu:
	call Clrscr
	call show_menu
	call get_key
	mov opt, al

	; if 4, quit
	cmp opt, '4'
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
	jne L_end_case
	call opt_3
	jmp L_end_case
L_end_case:
	jmp L_menu

L_quit:
	call draw_quit
	exit
main ENDP

; == main ===================================

; == show_menu ==============================
show_menu PROC
	mov edx, offset str_menu
	INVOKE WriteString
	mov eax, yellow
	call set_background_color
	INVOKE draw_frame, 0, 0, menu_width, menu_height
	mov dh, 9
	mov dl, 28
	call Gotoxy
	ret
show_menu ENDP
; == show_menu ==============================

; == draw_quit ==============================
draw_quit PROC
	mov eax, blue
	call set_background_color
	mov ecx, 13
	mov bar_delay, 1
L_draw_quit:
	push ecx
	mov ebx, 13
	sub ebx, ecx
	INVOKE draw_bar, ebx, 61
	pop ecx
	loop L_draw_quit

	call restore_color
	call Clrscr
	ret
draw_quit ENDP
; == draw_quit ==============================


; == opt1 ===================================
opt_1 PROC
L_opt1:
	call Clrscr
	mov edx, offset str_opt1
	INVOKE WriteString

	mWrite " > Please input a inside [-20, 20]: "
	call ReadInt
	mov ipt_a, eax
	mWrite " > Please input b inside [-20, 20]: "
	call ReadInt
	mov ipt_b, eax
	call Crlf

	mWrite "The result of foo(a,b) is as follows: "
	call Crlf
	INVOKE foo, ipt_a, ipt_b
	call Crlf
	mWrite "The value of foo(a,b) = "
	call WriteInt
	call Crlf
	call Crlf

	mWrite "Press 'r' to repeat and 'q' to return to the main menu."
	call get_key
	.if al == 'q'
		jmp L_opt1_quit
	.else
		jmp L_opt1
	.endif

L_opt1_quit:
	ret
opt_1 ENDP
; == opt1 ===================================

; == foo ====================================
foo PROC,
	a : SDWORD,
	b : SDWORD

	; if ( (a <= b) || (b == 0) ) return 0;
	.if b == 0
		jmp L_foo_ret_zero
	.endif

	mov eax, a
	mov ebx, b
	cmp eax, ebx
	jle L_foo_ret_zero


	; if ( (a/b)%2 == 0 )
	;	{ printf("E"); return a+b + foo(a-1, b); }
	mov edx, 0
	mov eax, a
	idiv b

	test eax, 1		; check even or odd
	jne L_odd

	; (a/b)%2 == 0
	mov al, 'E'
	call WriteChar
	; foo(a-1, b)
	mov eax, a
	dec eax
	INVOKE foo, eax, b
	mov ebx, b
	add ebx, a ; a+b
	add eax, ebx
	jmp L_foo_ret

L_odd:
	; (a/b)%2 != 0
	; int x = foo(a, b+1);
	; printf("O");
	; return x;
	mov ebx, b
	inc ebx
	INVOKE foo, a, ebx
	push eax
	mov al, 'O'
	call WriteChar
	pop eax
	jmp L_foo_ret

L_foo_ret_zero:
	mov eax, 0

L_foo_ret:
	ret

foo ENDP
; == foo ====================================

; == opt2 ===================================
opt_2 PROC
L_opt2:
	call Clrscr
	mov eax, gray
	call set_background_color
	INVOKE draw_bar, 0, 16

	mov ecx, 12
	L_draw_area:
		INVOKE draw_bar, ecx, 16
		loop L_draw_area

	mov bitmap_x, 0
	mov bitmap_y, 0
	INVOKE draw_bit_map, 0, 0

	mov blue_spot_x, 2
	mov blue_spot_y, 2
	call draw_blue_sopt

L_moving_bitmap:

	call get_key
	push eax
	INVOKE earse_bit_map, bitmap_x, bitmap_y
	call earse_blue_sopt
	pop eax


	.if al == 'w'
		.if bitmap_y > 0
			dec bitmap_y
		.endif
		movzx edx, blue_spot_y
		sub edx, 4
		.if edx == bitmap_y
			dec blue_spot_y
		.endif
	.endif

	.if al == 'a'
		.if bitmap_x > 0
			dec bitmap_x
		.endif

		movzx edx, blue_spot_x
		sub edx, 4
		.if edx == bitmap_x
			dec blue_spot_x
		.endif
	.endif

	.if al == 's'
		.if bitmap_y < 8
			inc bitmap_y
		.endif

		movzx edx, blue_spot_y
		.if edx == bitmap_y
			inc blue_spot_y
		.endif
	.endif

	.if al == 'd'
		.if bitmap_x < 11
			inc bitmap_x
		.endif

		movzx edx, blue_spot_x
		.if edx == bitmap_x
			inc blue_spot_x
		.endif
	.endif

	.if al == 27
		jmp L_opt2_quit
	.endif

	.if al == 'r'
		neg bitmap_color
	.endif


	INVOKE draw_bit_map, bitmap_x, bitmap_y
	call draw_blue_sopt
	jmp L_moving_bitmap


	call Crlf
L_opt2_quit:
	call restore_color
	ret
opt_2 ENDP
; == opt2 ===================================

; == draw_bit_map ===========================
draw_bit_map PROC,
	x_start: DWORD,
	y_start: DWORD

	mov eax, y_start
	mov tmp_casting, eax
	mov dh, BYTE PTR tmp_casting
	mov eax, x_start
	mov tmp_casting, eax
	mov dl, BYTE PTR tmp_casting
	call Gotoxy

	mov esi, offset bitmap
	mov ecx, 5
L_draw_bitmap:
	push ecx
	mov ecx, 5
L_draw_bitmap_row:
	mov bl, [esi]
	.if bl == 1
		.if bitmap_color == 1
			mov eax, yellow
		.else
			mov eax, white
		.endif
		call set_background_color
	.else
		mov eax, gray
		call set_background_color
	.endif
	inc esi
	mov al, ' '
	INVOKE WriteChar
	loop L_draw_bitmap_row
	pop ecx
	inc dh
	call Gotoxy
	loop L_draw_bitmap

	ret
draw_bit_map ENDP

; == draw_bit_map ===========================

; == earse_bit_map ==========================
earse_bit_map PROC,
x_start: DWORD,
y_start: DWORD
	mov eax, y_start
	mov tmp_casting, eax
	mov dh, BYTE PTR tmp_casting
	mov eax, x_start
	mov tmp_casting, eax
	mov dl, BYTE PTR tmp_casting
	call Gotoxy
	mov eax, gray
	call set_background_color

	mov ecx, 5
L_earse_bitmap:
	push ecx
	mov ecx, 5
L_earse_bitmap_row:
	mov al, ' '
	INVOKE WriteChar
	loop L_earse_bitmap_row
	pop ecx
	inc dh
	call Gotoxy
	loop L_earse_bitmap
	ret
earse_bit_map ENDP
; == earse_bit_map ==========================

; == opt3 ===================================
opt_3 PROC
L_opt3:
	call Clrscr
	mov edx, offset str_opt3
	INVOKE WriteString
	call Crlf
L_opt3_quit:
	call waitKey
	ret
opt_3 ENDP
; == opt3 ===================================

; == waitKey ================================
waitKey PROC
	call Crlf
	call Crlf
	mWrite " (Press any key to continue...)"
L_wait_anykey:
	mov eax, 50
	call Delay
	call ReadKey
	jz L_wait_anykey
	call Crlf
	ret
waitKey ENDP
; == waitKey ================================

; == get_key ================================
get_key PROC
L_wait_key:
	mov eax, 50
	call Delay
	call ReadKey
	jz L_wait_key
	ret
get_key ENDP
; == get_key ================================

; == set_background_color ===================
set_background_color PROC
	shl eax, 4
	call SetTextColor
	ret
set_background_color ENDP
; == set_background_color ===================

; == restore_color ==========================
restore_color PROC
	mov eax, 00001111b
	call SetTextColor
	ret
restore_color ENDP
; == restore_color ==========================

; == draw frame =============================
draw_frame PROC USES eax ebx ecx edx,
	x_start: DWORD,
	y_start: DWORD,
	f_width: DWORD,
	f_height: DWORD

	; bottom border
	mov ebx, f_height
	inc ebx
	add ebx, y_start

	INVOKE draw_bar, ebx, f_width

	; top
	mov eax, 0
	INVOKE draw_bar, y_start, f_width
	; left
	mov ecx, f_height
	add ecx, 2
	INVOKE draw_straight, x_start, y_start, ecx
	; right
	mov eax, f_width
	add eax, x_start
	mov ecx, f_height
	add ecx, 2
	INVOKE draw_straight, eax, y_start, ecx

	call restore_color
	ret
draw_frame ENDP
; == draw frame =============================

; == draw_bar ====================
draw_bar PROC USES eax ebx ecx edx,
	y_start: DWORD,
	line_length: DWORD,

  mov dh, BYTE PTR y_start
	mov dl, 0
  call Gotoxy
	mov ecx, line_length
L_DRAW_BAR:
  mov al, ' '
  INVOKE WriteChar

	.if bar_delay != 0
		mov eax, 25
		call Delay
	.endif

  loop L_DRAW_BAR
  ret
draw_bar ENDP
; == draw bar ===============================

; == draw straight ==========================
draw_straight PROC USES eax ebx ecx edx,
	x_start: DWORD,
	y_start: DWORD,
	line_length: DWORD

	mov eax, y_start
	mov tmp_casting, eax
	mov dh, BYTE PTR tmp_casting
	mov eax, x_start
	mov tmp_casting, eax
	mov dl, BYTE PTR tmp_casting
	call Gotoxy
	mov ecx , line_length
L_DRAW_STRAIGHT:
	mov al, ' '
	invoke WriteChar
	mov dl, BYTE PTR tmp_casting
	inc dh

	call Gotoxy
	loop L_DRAW_STRAIGHT
	ret
draw_straight ENDP
; == draw straight ==========================

; == draw_blue_sopt ==========================
draw_blue_sopt PROC
	mov dl, blue_spot_x
	mov dh, blue_spot_y
	call Gotoxy

	mov eax, lightblue
	call set_background_color
	mov al, ' '
	INVOKE WriteChar

	ret
draw_blue_sopt ENDP
; == draw_blue_sopt ==========================

; == earse_blue_sopt =========================
earse_blue_sopt PROC
	mov dl, blue_spot_x
	mov dh, blue_spot_y
	call Gotoxy

	mov eax, gray
	call set_background_color
	mov al, ' '
	INVOKE WriteChar
	ret
earse_blue_sopt ENDP
; == earse_blue_sopt =========================

end main
