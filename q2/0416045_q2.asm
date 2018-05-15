; ==========================================
; quiz 2
; ==========================================
; $Student Name:  Chia-Yu, Sun
; $Student ID:    0416045
; $Student Email: cysun0226@gmail.com
; ==========================================


TITLE quiz_2

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

draw_bitmap PROTO,
x_start: DWORD,
y_start: DWORD,
map: DWORD

p DWORD 2, 3, 4
opt BYTE ?
FRAME_WIDTH BYTE 80
FRAME_HEIGHT BYTE 23
menu_height BYTE 20
tmp_casting DWORD ?
menu_background_color BYTE black
menu_frame_color BYTE green
menu_text_color BYTE white
wait_option_height BYTE 11
bitmap_color BYTE yellow
draw_delay DWORD 0
draw_inverse DWORD 0
draw_delay_time DWORD 25
ship_height_change DWORD 0
ship_x BYTE ?
ship_y BYTE ?
ship_old_x BYTE ?
ship_old_y BYTE ?

; menu
str_menu BYTE  10, 13,
"   === Options === ", 10, 13, 10, 13,
"   1. Change ship color ", 10, 13,
"   2. Show a frame around the screen rectangular area ", 10, 13,
"   3. Play now!!! ", 10, 13,
"   4. Show author information ", 10, 13,
"   5. Quit game ", 10, 13, 10, 13,
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
" (press 'e' to move up and press 'c' to move down, space bar to back to the menu) ", 10, 13, 10, 13, 0

; opt4 message
str_opt4_msg BYTE 10, 13,
"   === Show author information === ", 10, 13, 10, 13,
"   Studnet ID    : 0416045 ", 10, 13,
"   Studnet name  : Chia-Yu, Sun ", 10, 13,
"   Studnet email : cysun0226@gmail.com ", 10, 13, 10, 13, 0

BITMAP_WIDTH	DWORD	5
BITMAP_HEIGHT	DWORD	3
BITMAP1 BYTE 1, 1, 0, 1, 1
          BYTE 0, 0, 1, 0, 0
          BYTE 1, 1, 0, 1, 1

BITMAP2 BYTE 1, 1, 1, 1, 1
          BYTE 0, 1, 0, 1, 0
          BYTE 1, 1, 1, 1, 1


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
  movzx ebx, FRAME_WIDTH
	movzx ecx, FRAME_HEIGHT
  call Crlf
  mWrite " === Quiz 2 ==="
  INVOKE draw_bitmap, 3, 3, 0
  call waitKey

  call Crlf
	INVOKE draw_frame, 0, 3, ebx, ecx



  call Crlf
  call Crlf
  mWrite " > Press w a s d to move the bit map"
  call Crlf
  mWrite " > Press space bar to switch the bit map"
  call Crlf
  mWrite " > Press esc to quit"

  call play_bitmap
	; call waitKey

	; quit
	call Clrscr
	mov edx, offset str_quit_msg
	INVOKE WriteString
	call get_key

	exit
main ENDP
; == main =====================

; == play_bitmap =====================
; NOTE play bitmap
play_bitmap PROC
	; show the ship in the middle
	movzx eax, bitmap_color
	shl eax, 4
	call SetTextColor
	mov dh, 17
	mov bh, dl
	mov dl, 38
	call Gotoxy
	mov al, ' '
  invoke WriteChar
	invoke WriteChar
	invoke WriteChar
	mov ship_x, dl
	mov ship_y, dh
	mov ship_old_x, dl

L_opt3_ship_moving:
	mov ship_height_change, 0
	mov al, ship_y
	mov ship_old_y, al
	call ReadKey
	; no key is pressed
	jz L_opt3_no_key_pressed
	.if al == 'w'
	dec ship_height_change
	mov dh, ship_y
	dec dh
	.if dh < 6 ; out of boundary
	mov dh, 26
	.endif
	mov ship_y, dh
	.elseif al == 's'
	inc ship_height_change
	mov dh, ship_y
	inc dh
	.if dh > 26 ; out of boundary
	mov dh, 6
	.endif
	mov ship_y, dh
	.elseif al == ' '
	jmp L_opt3_quit
	.endif

L_opt3_no_key_pressed:
	; erase whole ship
	mov dl, ship_old_x
	mov dh, ship_old_y
	.if dl < 5
	movzx ebx, frame_width
	movzx ecx, frame_height
	sub ecx, 2
	movzx eax, bitmap_color
	call set_background_color
	INVOKE draw_straight, ebx, 5, ecx ; x, y, length
	mov eax, black
	call set_background_color
	INVOKE draw_straight, 1, 6, ecx ; x, y, length
	INVOKE draw_straight, 2, 6, ecx ; x, y, length
	INVOKE draw_straight, 3, 6, ecx ; x, y, length
	mov dl, ship_old_x
	mov dh, ship_old_y
	.endif
	mov eax, black
	call set_background_color
	call Gotoxy
	mov al, ' '
  invoke WriteChar
	invoke WriteChar
	invoke WriteChar
	invoke WriteChar

	; draw new ship
	movzx eax, bitmap_color
	call set_background_color
	mov dh, ship_y
	mov dl, ship_x
	mov ship_old_x, dl
	; inc dl

	.if dl > 77
	mov dl, 1
	; draw left frame
	movzx ebx, frame_width
	movzx ecx, frame_height
	INVOKE draw_straight, 0, 5, ecx
	INVOKE draw_straight, ebx, 5, ecx ; x, y, length
	.endif
	mov ship_x, dl
	call Gotoxy
	mov al, ' '
  invoke WriteChar
	invoke WriteChar
	invoke WriteChar

	mov eax, 50
	call Delay
	jmp L_opt3_ship_moving

L_opt3_quit:
  call restore_color
	ret
play_bitmap ENDP
; == play_bitmap =====================

; == draw_bitmap =====================
; LABEL draw bitmap
; function: draw_frame(int x, int y, int map)
; -------------------------------------------
draw_bitmap PROC USES eax ebx ecx edx,
	x_start: DWORD,
	y_start: DWORD,
	map: DWORD

  mov eax, y_start
  mov tmp_casting, eax
	mov dh, BYTE PTR tmp_casting
  mov eax, x_start
  mov tmp_casting, eax
	mov dl, BYTE PTR tmp_casting
  call Gotoxy

  .if map == 0
  mov esi, offset BITMAP1
  .else
  mov esi, offset BITMAP2
  .endif

  mov ecx, 3
L_DRAW_BITMAP:
  push ecx
  mov ecx, 5
L_DRAW_BITMAP_ROW:
  mov bl, [esi]
  .if bl == 1
  movzx eax, bitmap_color
  call set_background_color
  .else
  call restore_color
  .endif
  inc esi
  mov al, ' '
  INVOKE WriteChar
  loop L_DRAW_BITMAP_ROW
  pop ecx
  inc dh
  call Gotoxy
  loop L_DRAW_BITMAP

  ret
draw_bitmap ENDP

; == draw_bitmap =====================


; == waitKey =====================
waitKey PROC
	call Crlf
	call Crlf
	mWrite " (Press anykey to continue...)"
L_wait_anykey:
	mov eax, 50
	call Delay
	call ReadKey
	jz L_wait_anykey
	call Crlf
	ret
waitKey ENDP
; == waitKey =====================

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

; == draw frame =============================
; LABEL draw frame
; function: draw_frame(int x, int y, width, height)
; receive: x_start, y_start, width, height
; pass by PROTO
; -------------------------------------------
draw_frame PROC USES eax ebx ecx edx,
	x_start: DWORD,
	y_start: DWORD,
	f_width: DWORD,
	f_height: DWORD


	; menu border
	movzx eax, menu_frame_color
	shl eax, 4
	call SetTextColor
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
; LABEL set background color
; calling-request: put color into eax.
; -------------------------------------------
set_background_color PROC
	shl eax, 4
	call SetTextColor
	ret
set_background_color ENDP
; == set background color ====================

end main
