; ==========================================
; quiz 4
; ==========================================
; Student Name:  Chia-Yu, Sun
; Student ID:    0416045
; Student Email: cysun0226@gmail.com
; ==========================================


TITLE quiz_4

include Irvine32.inc
include Macros.inc

; NOTE data
.data
; proto NOTE func PROTO
draw_bar PROTO,
y_start: DWORD,
line_length: DWORD,
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
FRAME_WIDTH BYTE 60
FRAME_HEIGHT BYTE 20
menu_height BYTE 21
tmp_casting DWORD ?
menu_background_color BYTE black
menu_frame_color BYTE blue
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

; LABEL start coordinate
player_x BYTE 59
player_y BYTE 23

AI_x BYTE 59
AI_y BYTE 4
AI_down BYTE 0

player_win_msg BYTE " You win!", 0
AI_win_msg BYTE " AI win!", 0

reset BYTE 0
game_over BYTE 0

tunnel DWORD 29 dup(?)

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

game_map BYTE 3000 dup(0)


; == main =====================
; LABEL main
.code
main PROC
  movzx ebx, FRAME_WIDTH
	movzx ecx, FRAME_HEIGHT

  call Crlf
  mWrite " === Quiz 4 ==="
  call Crlf
	INVOKE draw_frame, 0, 3, ebx, ecx
  call Crlf
  call Crlf
  mWrite " > Press w a s d to move"
  call Crlf
  mWrite " > Press space bar to pause/resume"
  call Crlf
  mWrite " > Press r to restart the game"
  call Crlf
  mWrite " > Press q to quit"

; LABEL start game
L_START_GAME:
  mov reset, 0
  mov player_x, 59
  mov player_y, 23
  mov AI_x, 59
  mov AI_y, 4
  mov AI_down, 0
  call generate_map
  call dump_map
  movzx ebx, FRAME_WIDTH
  movzx ecx, FRAME_HEIGHT
  INVOKE draw_frame, 0, 3, ebx, ecx
  call draw_AI
  call draw_player
  call play_game
  .if reset == 1
    jmp L_START_GAME
  .endif

	; quit
	call Clrscr
  call restore_color
	mov edx, offset str_quit_msg
	INVOKE WriteString
	call get_key

	exit
main ENDP
; == main =====================

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

; == draw_player ============================
; LABEL draw player
; -------------------------------------------
draw_player PROC USES eax ebx ecx edx
  mov eax, yellow
  call set_background_color
  mov dl, player_x
  mov dh, player_y
  call Gotoxy
  mov al, ' '
  call WriteChar
  ret
draw_player ENDP
; == draw_player ============================

; == erase_player ============================
; LABEL erase player
; -------------------------------------------
erase_player PROC USES eax ebx ecx edx
  call restore_color
  mov dl, player_x
  mov dh, player_y
  call Gotoxy
  mov al, ' '
  call WriteChar
  ret
erase_player ENDP
; == erase_player ============================

; == draw_AI ============================
; LABEL draw AI
; -------------------------------------------
draw_AI PROC USES eax ebx ecx edx
  mov eax, red
  call set_background_color
  mov dl, AI_x
  mov dh, AI_y
  call Gotoxy
  mov al, ' '
  call WriteChar
  ret
draw_AI ENDP
; == draw_AI ================================

; == erase_AI ===============================
; LABEL erase AI
; -------------------------------------------
erase_AI PROC USES eax ebx ecx edx
  call restore_color
  mov dl, AI_x
  mov dh, AI_y
  call Gotoxy
  mov al, ' '
  call WriteChar
  ret
erase_AI ENDP
; == erase_AI ================================

; == generate map ============================
; LABEL generate map
; function: generate_map
; -------------------------------------------
generate_map PROC
  call Randomize
  mov ecx, 1200
L_MAP_INIT:
  mov ebx, offset game_map
  mov eax, ecx
  shl eax, 1
  add ebx, eax

  test ecx, 1
  jne L_MAP_INIT_BLACK
  mov BYTE PTR [ebx], 0
  jmp L_MAP_INIT_NEXT
L_MAP_INIT_BLACK:
  mov eax, 5
  call RandomRange
  .if eax < 4
    mov BYTE PTR [ebx], 1
  .else
    mov BYTE PTR [ebx], 0
  .endif
L_MAP_INIT_NEXT:
  loop L_MAP_INIT

  mov ecx, 20
L_GENERATE_TUNNEL:
  ; push ecx
  test ecx, 1
  je L_GENERATE_TUNNEL_QUIT
  mov eax, 60
  mul ecx ; eax = 60*r
  mov ebx, eax
  mov edx, offset game_map

  mov eax, 19
  call RandomRange
  inc eax
  ; map[r*width+c]
  add edx, eax
  mov BYTE PTR [edx], 0
  L_GENERATE_TUNNEL_QUIT:
  loop L_GENERATE_TUNNEL

  mov ecx, 60
L_GENERATE_BOUNDARY:
  loop L_GENERATE_BOUNDARY

  ret
generate_map ENDP
; == generate map ============================

; == draw map ================================
; LABEL draw map
; function: draw map
; -------------------------------------------
draw_map PROC USES eax ebx ecx edx
  mov dh, 3
  mov dl, 0
  call Gotoxy

  mov ecx, 1200
  mov esi, offset game_map
L_DRAW_MAP:
  mov ebx, 1200
  sub ebx, ecx
  add ebx, esi

  mov dl, [ebx]
  .if dl == 0
  mov eax, black
  .else
  mov eax, blue
  .endif
  call set_background_color
  mov al, ' '
  call WriteChar

  mov edx, 0
  mov eax, ecx
  mov ebx, 60
  div ebx
  .if edx == 0
  call Crlf
  .endif
  loop L_DRAW_MAP

  ret
draw_map ENDP
; == draw map ================================

; == play game ================================
; LABEL play game
; ---------------------------------------------
play_game PROC
L_PLAY_GAME:
  .if game_over == 1
    jmp L_READ_KEY
  .endif

  .if player_x == 1
    mov eax, 11100000b ; yellow background, white text
    call SetTextColor
    mov dl, 25
    mov dh, 3
    call Gotoxy
    mov edx, offset player_win_msg
    INVOKE WriteString
    call restore_color
    mov game_over, 1
  .endif

  .if AI_x == 1
    mov eax, 11100000b ; yellow background, white text
    call SetTextColor
    mov dl, 27
    mov dh, 3
    call Gotoxy
    mov edx, offset AI_win_msg
    INVOKE WriteString
    call restore_color
    mov game_over, 1
  .endif

L_READ_KEY:
	call ReadKey
	jz L_NO_KEY_INPUT

  ; erase old player
  call erase_player

  .if al == 'q'
    jmp L_GAME_OVER
  .endif

  .if al == 'r'
    mov reset, 1
    mov game_over, 0
    jmp L_GAME_OVER
  .endif

  .if al == 'w'
    push eax
		movsx ebx, player_y
    sub ebx, 4
    movsx ecx, player_x
    ; check
    ; boundary
    .if ebx == 0
      jmp L_W_QUIT
    .endif
    ; map[x+y*w]
    mov eax, 60
    mul ebx ; eax = y*w
    add eax, ecx ; eax = x + y*w
    mov ebx, offset game_map
    add eax, ebx
    mov dl, BYTE PTR [eax]
    .if dl == 0
      mov dh, player_y
      dec dh
      mov player_y, dh
    .endif
    L_W_QUIT:
    pop eax
	.endif

  .if al == 's'
  push eax
  movsx ebx, player_y
  sub ebx, 4
  movsx ecx, player_x
  inc ebx
  ; check
  .if ebx > 19
    jmp L_S_QUIT
  .endif

  ; map[x+y*w]
  mov eax, 60
  mul ebx ; eax = y*w
  add eax, ecx ; eax = x + y*w
  add eax, offset game_map
  mov dl, BYTE PTR [eax]
  .if dl == 0
    mov dh, player_y
    inc dh
    mov player_y, dh
  .endif
  L_S_QUIT:
  pop eax
	.endif

  .if al == 'a'
    push eax
    movsx ebx, player_y
    sub ebx, 4
    movsx ecx, player_x
    dec ecx
    ; check
    .if ecx == 0
      jmp L_A_QUIT
    .endif
    ; map[x+y*w]
    mov eax, 60
    mul ebx ; eax = y*w
    add eax, ecx ; eax = x + y*w
    add eax, offset game_map
    mov dl, BYTE PTR [eax]
    .if dl == 0
      mov dh, player_x
      dec dh
      mov player_x, dh
    .endif
    L_A_QUIT:
    pop eax
	.endif

  .if al == 'd'
    push eax
    movsx ebx, player_y
    sub ebx, 4
    movsx ecx, player_x
    inc ecx
    ; check
    .if ecx > 59
      jmp L_D_QUIT
    .endif
    ; map[x+y*w]
    mov eax, 60
    mul ebx ; eax = y*w
    add eax, ecx ; eax = x + y*w
    add eax, offset game_map
    mov dl, BYTE PTR [eax]
    .if dl == 0
      mov dh, player_x
      inc dh
      mov player_x, dh
    .endif
    L_D_QUIT:
    pop eax
	.endif

  call draw_player

  mov eax, 50
  call Delay
  jmp L_PLAY_GAME

L_NO_KEY_INPUT:
  .if game_over == 1
    mov eax, 50
    call Delay
    jmp L_READ_KEY
  .endif

  mov eax, 150
	call Delay
  call erase_AI

  ; move AI
  movsx ebx, AI_y
  sub ebx, 4
  movsx ecx, AI_x
  dec ecx
  push ebx
  ; check left
  mov eax, 60
  mul ebx ; eax = y*w
  add eax, ecx ; eax = x + y*w
  mov ebx, offset game_map
  add eax, ebx
  mov dl, BYTE PTR [eax]
  pop ebx
  .if dl == 0
    mov AI_down, 0
    mov dh, AI_x
    dec dh
    mov AI_x, dh
  .else
    .if AI_down != 1
      .if ebx != 0
        mov dh, AI_y
        dec dh
        mov AI_y, dh
      .else
        mov AI_down, 1
        mov dh, AI_y
        inc dh
        mov AI_y, dh
      .endif
    .else
      mov dh, AI_y
      inc dh
      mov AI_y, dh
    .endif
  .endif
  call draw_AI

  jmp L_PLAY_GAME

L_GAME_OVER:
  ret
play_game ENDP
; == play game =============================

; == dump map ==============================
; LABEL dump map
; ------------------------------------------
dump_map PROC
  mov dh, 3
  mov dl, 0
  call Gotoxy
  mov ecx, 1200
  mov esi, offset game_map
L_DUMP_MAP:
  push ecx
  mov ebx, 1200
  sub ebx, ecx
  add ebx, esi

  mov dl, [ebx]
  .if dl == 0
    mov eax, black
  .else
    mov eax, blue
  .endif
  call set_background_color
  call WriteChar

  mov edx, 0
  mov eax, ecx
  mov ebx, 60
  div ebx
  pop ecx
  .if edx == 0
  call Crlf
  mov al, '1'
  call WriteChar
  .endif

loop L_DUMP_MAP

  ret
dump_map ENDP
; == dump map ==============================


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
