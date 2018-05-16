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

erase_bitmap PROTO,
x_start: DWORD,
y_start: DWORD

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
bitmap_type DWORD 0
draw_delay DWORD 0
draw_inverse DWORD 0
draw_delay_time DWORD 25
bitmap_x DWORD ?
bitmap_y DWORD ?
bitmap_old_x DWORD ?
bitmap_old_y DWORD ?

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
  call Crlf
	INVOKE draw_frame, 0, 3, ebx, ecx
  call Crlf
  call Crlf
  mWrite " > Press w a s d to move the bit map"
  call Crlf
  mWrite " > Press space bar to switch the bit map"
  call Crlf
  mWrite " > Press q or esc to quit"

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
  ; show bitmap in the middle
  mov ebx, 38
  mov edx, 17
  mov ecx, bitmap_type
  INVOKE draw_bitmap, ebx, edx, ecx

L_bitmap_moving:
  push ebx
  push edx
	call get_key
	; no key is pressed
  pop edx
  pop ebx

  INVOKE erase_bitmap, ebx, edx

	.if al == 'w'
  .if edx > 4 ; in boundary
	dec edx
	.endif

	.elseif al == 's'
  .if edx < 24
  inc edx
  .endif

  .elseif al == 'a'
  .if ebx > 1
  dec ebx
  .endif

  .elseif al == 'd'
  .if ebx < 75
  inc ebx
  .endif

  .elseif al == 'b'
  mov bitmap_type, 0
  mov ecx, 0

  .elseif al == ' '
  mov ecx, 1
  sub ecx, bitmap_type
  mov bitmap_type, ecx

	.elseif al == 27 ; esc
	jmp L_bitmap_quit

  .elseif al == 'q'
	jmp L_bitmap_quit

  .endif

  INVOKE draw_bitmap, ebx, edx, ecx
  jmp L_bitmap_moving

L_bitmap_quit:
  call restore_color
	ret
play_bitmap ENDP
; == play_bitmap =====================

; == draw_bitmap =====================
; LABEL draw bitmap
; function: draw_bitmap(int x, int y, int map)
; -------------------------------------------
draw_bitmap PROC USES eax ebx ecx edx,
	x_start: DWORD,
	y_start: DWORD,
	map: DWORD

  push eax
  push ebx
  push ecx
  push edx

  mov eax, y_start
  mov tmp_casting, eax
	mov dh, BYTE PTR tmp_casting
  mov eax, x_start
  mov tmp_casting, eax
	mov dl, BYTE PTR tmp_casting
  call Gotoxy

  .if map == 0
  mov esi, offset BITMAP1
  mov bitmap_color, yellow
  .else
  mov esi, offset BITMAP2
  mov bitmap_color, blue
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
  call restore_color

  pop edx
  pop ecx
  pop ebx
  pop eax
  ret
draw_bitmap ENDP

; == draw_bitmap =====================

; == erase_bitmap =====================
; LABEL erase bitmap
; function: erase_bitmap(int x, int y)
; -------------------------------------------
erase_bitmap PROC USES eax ebx ecx edx,
	x_start: DWORD,
	y_start: DWORD

  push eax
  push ebx
  push ecx
  push edx

  mov eax, y_start
  mov tmp_casting, eax
	mov dh, BYTE PTR tmp_casting
  mov eax, x_start
  mov tmp_casting, eax
	mov dl, BYTE PTR tmp_casting
  call Gotoxy
  call restore_color

  mov ecx, 3
L_ERASE_BITMAP:
  push ecx
  mov ecx, 5
L_ERASE_BITMAP_ROW:
  mov al, ' '
  INVOKE WriteChar
  loop L_ERASE_BITMAP_ROW
  pop ecx
  inc dh
  call Gotoxy
  loop L_ERASE_BITMAP

  pop edx
  pop ecx
  pop ebx
  pop eax
  ret
erase_bitmap ENDP

; == erase_bitmap =====================


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
	line_length: DWORD
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
