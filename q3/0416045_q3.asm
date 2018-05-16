; ==========================================
; Quiz 3
; ==========================================
; Student Name:  Chia-Yu, Sun
; Student ID:    0416045
; Student Email: cysun0226@gmail.com
; ==========================================

TITLE quiz_3

include Irvine32.inc
include Macros.inc

; NOTE data
.data
; proto NOTE func PROTO
draw_bar PROTO,
y_start: DWORD,
line_length: DWORD,
; TODO add delay_time, is_inverse as parameters
; delay_time: BYTE,
; is_inverse: BYTE

draw_straight PROTO,
x_start: DWORD,
y_start: DWORD,
line_length: DWORD

draw_frame PROTO,
x_start: DWORD,
y_start: DWORD,
f_width: DWORD,
f_height: DWORD


opt BYTE ?
frame_width BYTE 62
frame_height BYTE 22
menu_height BYTE 20
tmp_casting DWORD ?
menu_background_color BYTE black
menu_frame_color BYTE yellow
menu_text_color BYTE white
wait_option_height BYTE 11
draw_delay DWORD 0
draw_inverse DWORD 0
draw_delay_time DWORD 25

current_left_col DWORD 1
current_right_col DWORD 61
current_top_row DWORD 2
current_bottom_row DWORD 21

display_frame DWORD 1
frame_color DWORD lightCyan
row_or_frame BYTE 0

; opt1


; menu
str_menu BYTE  10, 13,
"   === Options === ", 10, 13, 10, 13,
"   1. Floating point calculation", 10, 13,
"   2. Simple control ", 10, 13,
"   3. Quit ", 10, 13, 10, 13,
"   > Please select an option: ", 0

; opt1 message
str_opt1_msg BYTE 10, 13,
" === Floating point calculation === ", 10, 13, 10, 13,
" Please input three floating point numbers a, b, and c. ", 10, 13, 10, 13, 0

; opt2 message
str_opt2_msg BYTE 10, 13,
" === Simple control === ", 10, 13, 10, 13, 0

; opt3 message
str_opt3_msg BYTE 10, 13,
" === Play === ", 10, 13, 10, 13,
" (press 'e' to move up and press 'c' to move down, space bar to back to the menu) ", 10, 13, 10, 13, 0

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
; LABEL main
.code
main PROC
L_menu:
	call restore_color
	call Clrscr
	call show_menu
	call get_key
	mov opt, al

	; if 5, quit
	cmp opt, '3'
	je L_quit

	cmp opt, '1'
	jne case_2
	call opt_1
	jmp L_end_case
case_2:
	cmp opt, '2'
	jne L_end_case
	call opt_2
	jmp L_quit
L_end_case:
	jmp L_menu
L_quit:
	call Clrscr
	mov edx, offset str_quit_msg
	INVOKE WriteString
	call get_key
	exit
main ENDP
; == main =====================

; == show menu =====================
; NOTE show_menu
show_menu PROC
	; menu message
	mov edx, offset str_menu
	invoke WriteString
	ret
show_menu ENDP
; == show menu =====================

; == opt1 =====================
; LABEL: opt1
opt_1 PROC
L_opt1:
	call Clrscr
	mov edx, offset str_opt1_msg
	invoke WriteString
	finit
	mWrite " > Input a: "
	call ReadFloat
	mWrite " > Input b: "
	call ReadFloat
	mWrite " > Input c: "
	call ReadFloat
	call Crlf
	fmul
	fadd
	mWrite " a+b*c = "
	call WriteFloat
	call Crlf
	call waitKey
	ret
opt_1 ENDP
; == opt1 =====================

; == opt2 =====================
; NOTE opt2
opt_2 PROC
	call restore_color
	call Clrscr
	mov edx, offset str_opt2_msg
	invoke WriteString
	mWrite " > Press r to build a new bitmap"

L_opt2_loop:
	call get_key

	.if al == 'q'
		jmp L_opt2_quit
	.endif

	.if al == 'r'
		call draw_map
		mov current_left_col, 1
		mov current_right_col, 61
		mov current_top_row, 2
		mov current_bottom_row, 21
	.endif

	.if al == 'f'
		.if display_frame == 1
			mov display_frame, 0
			mov eax, gray
		.else
			mov display_frame, 1
			mov eax, lightCyan
		.endif
		mov frame_color, eax
		call set_background_color
		INVOKE draw_frame, 0, 1, 62, 20
	.endif

	.if al == 'w'
		mov eax, gray
		call set_background_color
		mov row_or_frame, 1
		mov ebx, current_top_row
		INVOKE draw_bar, ebx, 61
		mov row_or_frame, 0
		.if ebx < 21
			inc ebx
		.endif
		mov current_top_row, ebx
	.endif

	.if al == 's'
		mov eax, gray
		call set_background_color
		mov row_or_frame, 1
		mov ebx, current_bottom_row
		INVOKE draw_bar, ebx, 61
		mov row_or_frame, 0
		.if ebx > 2
			dec ebx
		.endif
		mov current_bottom_row, ebx
	.endif

	.if al == 'a'
		mov eax, gray
		call set_background_color
		mov ebx, current_left_col
		INVOKE draw_straight, ebx, 2, 20
		.if ebx < 61
			inc ebx
		.endif
		mov current_left_col, ebx
	.endif

	.if al == 'd'
		mov eax, gray
		call set_background_color
		mov ebx, current_right_col
		INVOKE draw_straight, ebx, 2, 20
		.if ebx > 1
			dec ebx
		.endif
		mov current_right_col, ebx
	.endif

	jmp L_opt2_loop

L_opt2_quit:
	call restore_color
	ret
opt_2 ENDP
; == opt2 =====================

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

; == draw map ===============================
; LABEL draw map
draw_map PROC USES eax ebx ecx edx
	call Randomize
	mov dh, 1
	mov dl, 0
	call Gotoxy
	mov ecx, 20
L_draw_map:
	push ecx
	mov dl, 0
	inc dh
	call Gotoxy
	mov ecx, 62
L_draw_map_row:
L_choose_new_color:
	mov eax, 14; color
	call RandomRange
	inc eax
	cmp eax, gray
	je L_choose_new_color
	call set_background_color
	mov al, ' '
	call WriteChar
	loop L_draw_map_row
	pop ecx
	loop L_draw_map

	mov eax, frame_color
	call set_background_color
	INVOKE draw_frame, 0, 1, 62, 20

	call restore_color
	ret
draw_map ENDP
; == draw map ===============================

; == draw frame =============================
; LABEL draw frame
; function: draw_frame(int x, int y, width, height)
; receive: x_start, y_start, width, height
; -------------------------------------------
draw_frame PROC USES eax ebx ecx edx,
	x_start: DWORD,
	y_start: DWORD,
	f_width: DWORD,
	f_height: DWORD

	; bottom border
	mov ebx, f_height
	inc ebx
	add ebx, y_start
	; can't use eax in invoke
	INVOKE draw_bar, ebx, f_width

	; top border
	mov eax, 0
	INVOKE draw_bar, y_start, f_width
	; left border
	; mov eax, 0
	; mov ebx, 0
	mov ecx, f_height
	add ecx, 2
	INVOKE draw_straight, x_start, y_start, ecx
	; right border
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
; NOTE draw_bar
; function: draw_bar(int h, int w)
; receive: height, width
; pass by PROTO
; --------------------------------------------------
draw_bar PROC USES eax ebx ecx edx,
	y_start: DWORD,
	line_length: DWORD,
	; delay_time: BYTE,
	; is_inverse: BYTE

  ; mov tmp_casting,
  mov dh, BYTE PTR y_start
	mov dl, 0
	.if row_or_frame == 1
		inc dl
	.endif
	mov ebx, draw_inverse
	.if draw_inverse != 0
	mov bl, BYTE PTR line_length
	add dl, bl
	.endif
  call Gotoxy
	mov ecx, line_length
L_DRAW_BAR:
  mov al, ' '
	mov ebx, draw_delay
	.if ebx != 0
	push eax
	mov eax, ebx
	call Delay
	pop eax
	.endif
  INVOKE WriteChar
	mov ebx, draw_inverse
	.if ebx != 0
	dec dl
	call Gotoxy
	.endif
  loop L_DRAW_BAR
  ret
draw_bar ENDP
; == draw bar ===============================

; == draw straight ==========================
; NOTE draw straight
; function: draw_straight(int x, int y, length)
; receive: x_start, y_start, length
; pass by PROTO
; --------------------------------------------------
draw_straight PROC USES eax ebx ecx edx,
	x_start: DWORD,
	y_start: DWORD,
	line_length: DWORD

	mov eax, y_start
	mov tmp_casting, eax
	mov dh, BYTE PTR tmp_casting ; y_start
	mov eax, x_start
	mov tmp_casting, eax
	mov dl, BYTE PTR tmp_casting ; x_start
	call Gotoxy
	mov ecx , line_length
L_DRAW_STRAIGHT:
	mov al, ' '
	invoke WriteChar
	mov dl, BYTE PTR tmp_casting

	mov ebx, draw_inverse
	.if ebx == 0
	inc dh
	.else
	dec dh
	.endif

	call Gotoxy

	mov ebx, draw_delay
	.if ebx != 0
	push eax
	mov eax, draw_delay
	call Delay
	pop eax
	.endif
	loop L_DRAW_STRAIGHT
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
; NOTE get_key
; parameters: the result of key will store in al
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

; == set background color ====================
; calling-request: put color into eax.
; -------------------------------------------
set_background_color PROC
	shl eax, 4
	call SetTextColor
	ret
set_background_color ENDP
; == set background color ====================

end main
