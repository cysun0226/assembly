;========================================================
; asm assignment 01
; Student Name: Chia-Yu SUN
; Student ID: 0416045
; Email: cysun0226@gmail.com
;========================================================
; Menu:
; 1. Show colorful frames
; 2. Sum up signed integers
; 3. Sum up unsigned integers
; 4. Compute sin(x)
; 5. Show student information
; 6. Quit
;========================================================

TITLE assignment_01

include Irvine32.inc
include Macros.inc

.data
frame_width DWORD 80
frame_height DWORD 23
frame_num DWORD 10


; Menu
; [10, 13] are newline
str_options BYTE 10, 13, " === Options === ", 10, 13, 10, 13
str_opt1 BYTE " 1. Show colorful frames" , 10, 13
str_opt2 BYTE " 2. Sum up signed integers" , 10, 13
str_opt3 BYTE " 3. Sum up unsigned integers" , 10, 13
str_opt4 BYTE " 4. Compute sin(x)" , 10, 13
str_opt5 BYTE " 5. Show student information" , 10, 13
str_opt6 BYTE " 6. Quit" , 10, 13, 10, 13
str_ipt_opt BYTE " > Please select an option : ", 0


opt BYTE ?
space BYTE " ", 0
out_cnt DWORD ?
str_show_frame BYTE 10, 13, " --- show color frames --- ", 10, 13, 0

str_sum_int BYTE 10, 13, 10, 13, " --- Sum up signed integers ---", 10, 13, 10, 13,
  " > Please input the number of integers : ", 0
int_num DWORD ?
str_ipt_int BYTE 10, 13, " > Please input integers : ", 0
sum DWORD 0
str_sum BYTE 10, 13, " Sum = ", 0
cur_h BYTE ?
cur_l BYTE ?

str_wait_key BYTE 10, 13, " (Press any key to return...) ", 0

str_show_inform BYTE 10, 13, 10, 13, " --- Show student information ---", 10, 13, 10, 13,
                " student ID            : 0416045 ", 10, 13,
                " student name          : Chia-Yu Sun ", 10, 13,
                " student email address : cysun0226@gmail.com ", 10, 13, 0

; color frame
old_color DWORD 1111b
return_addr DWORD ?

; sin
PI REAL8 3.1415926
rad REAL8 180.0
x_ori REAL8 ?
x REAL8 ?
n DWORD ?
x_2 REAL8 ?
taylor_series REAL8 ?
sin_result REAL8 0.0
tmp_casting DWORD ?
series_sign REAL8 1.0
minus_1 REAL8 -1.0

.code
; == main ==========================================
main PROC
L_menu:
  call Clrscr
  call show_menu
L_wait_opt:
  mov eax, 50 ; sleep, to allow OS to time slice
  call Delay
  call ReadKey
  jz L_wait_opt
  mov opt, al

  ; if 6, quit
  cmp opt, '6'
  je quit

  cmp opt, '1'
  jne case_2
  call show_color_frame
  jmp L_end_case
case_2:
  cmp opt, '2'
  jne case_3
  call sum_up_int
  jmp L_end_case
case_3:
  cmp opt, '3'
  jne case_4
  call sum_up_unsigned_int
  jmp L_end_case
case_4:
  cmp opt, '4'
  jne case_5
  call compute_sin
  jmp L_end_case
case_5:
  cmp opt, '5'
  jne L_end_case
  call show_inform
L_end_case:
  mov edx, offset str_wait_key
  invoke WriteString
L_wait_key:
  mov eax, 50 ; sleep, to allow OS to time slice
  call Delay
  call ReadKey
  jz L_wait_key
  jmp L_menu
quit:
  exit
main ENDP
; == main ==========================================


; == show menu =====================================

show_menu PROC
  mov edx, offset str_options
  invoke WriteString
  ret
show_menu ENDP

; == show menu =====================================


; == draw color frame ==============================

; --------------------------------------------------
; function: draw_bar(int h, int w)
; receive: height, width
; pass by stack
; --------------------------------------------------
draw_bar PROC
  push ebp
  mov ebp, esp
  push eax
  push ebx
  push ecx
  push edx
  mov eax, [ebp + 12]
  mov ebx, [ebp + 8]
  ; pop ebx ; w
  ; pop eax ; h
  mov ecx, frame_width
  sub ecx, ebx
  sub ecx, ebx ; FRAME_WIDTH-2*w
  add eax, 4
  add ebx, 1
  mov tmp_casting, eax
  mov dh, BYTE PTR tmp_casting
  mov tmp_casting, ebx
  mov dl, BYTE PTR tmp_casting
  add dl, 2
  call Gotoxy
L_DRAW_BAR:
  mov al, ' '
  invoke WriteChar
  loop L_DRAW_BAR
  pop edx
  pop ecx
  pop ebx
  pop eax
  mov esp, ebp
  pop ebp
  ret
draw_bar ENDP

; --------------------------------------------------
; function: draw_line(int width, int height, int length)
; receive: height, width
; pass by stack
; --------------------------------------------------
draw_line PROC
  ;pop ecx ; length
  ;pop ebx ; height
  ;pop eax ; width
  push ebp
  mov ebp, esp
  push eax
  push ebx
  push ecx
  push edx
  mov eax, [ebp + 16]
  mov ebx, [ebp + 12]
  mov ecx, [ebp + 8]
  sub ecx, ebx
  add ebx, 4
  mov tmp_casting, eax
  mov dl, BYTE PTR tmp_casting
  add dl, 2
  mov tmp_casting, ebx
  mov dh, BYTE PTR tmp_casting
L_DRAW_LINE:
  call Gotoxy
  inc dh ; h++
  mov al, ' '
  invoke WriteChar
  invoke WriteChar
  loop L_DRAW_LINE
  pop edx
  pop ecx
  pop ebx
  pop eax
  mov esp, ebp
  pop ebp
  ret
draw_line ENDP

; --------------------------------------------------
; function: show_color_frame
; parameters: none
; --------------------------------------------------
show_color_frame PROC
  mov return_addr, esp
  call Clrscr
  mov edx, offset str_show_frame
  call WriteString
  mov ebx, 0 ; prev_color
  mov ecx, frame_num
  call Randomize
L_show_color_frame:
  ; choose a new color
  mov ebx, old_color ; prev_color
L_choose_new_color:
  mov eax, 7; color
  call RandomRange
  cmp eax, ebx
  je L_choose_new_color
  mov old_color, eax
  add eax, 1
  shl eax, 4
  call SetTextColor
  ; draw_bar(int h, int w)
  mov edx, frame_num
  sub edx, ecx ; i
  push edx ; h
  mov eax, 2
  push edx
  mul edx ; eax = 2*i
  pop edx
  push eax ; w
  call draw_bar
  ; draw_line(i*2+1, i, FRAME_HEIGHT-i)
  mov ebx, 1
  add ebx, eax ; i*2+1
  push ebx
  push edx ; i
  mov ebx, frame_height
  sub ebx, edx
  push ebx ; FRAME_HEIGHT-i
  call draw_line
  ; draw_line(FRAME_WIDTH-i*2-1, i, FRAME_HEIGHT-i);
  mov ebx, frame_width
  sub ebx, eax ; FRAME_WIDTH-i*2
  sub ebx, 1 ; FRAME_WIDTH-i*2-1
  push ebx ; FRAME_WIDTH-i*2-1
  push edx ; i
  mov ebx, frame_height
  sub ebx, edx
  push ebx ; FRAME_HEIGHT-i
  call draw_line
  ; draw_bar(FRAME_HEIGHT-i, i*2);
  push ebx ; FRAME_HEIGHT-i
  ; pop eax ; i*2
  push eax ; i*2
  call draw_bar
  ; delay
  mov eax, 500 ; 1000 msec
  call Delay
  dec ecx
  cmp ecx, 0
  jne L_show_color_frame
  mov esp, return_addr
  mov eax, frame_height
  add eax, 6
  mov tmp_casting, eax
  mov dh, BYTE PTR tmp_casting
  mov dl, 0
  call Gotoxy
  mov eax, 00001111b ; black background, white text
  call SetTextColor
  ret
show_color_frame ENDP
; == draw color frame ==============================

; == sum up signed int =============================
sum_up_int PROC
  call Clrscr

  mov edx, offset str_sum_int
  call WriteString

  call readInt
  mov int_num, eax

  mov edx, offset str_ipt_int
  call WriteString
  call Crlf
  call Crlf

  mov ecx, int_num
L_IPT_INT:
  mWrite " > "
  call readInt
  push eax
  loop L_IPT_INT

  mov eax, 0
  mov ecx, int_num
L_SUM_INT:
  pop ebx
  add eax, ebx
  loop L_SUM_INT

  mov edx, offset str_sum
  call WriteString
  call WriteInt
  call Crlf

  ret
sum_up_int ENDP
; == sum up signed int =============================

; == sum up unsigned int ===========================
sum_up_unsigned_int PROC
  call Clrscr
  call Crlf
  call Crlf
  mWrite " --- Sum up unsigned integers ---"
  call Crlf
  call Crlf
  mWrite " > Please input the number of integers : "
  call readInt
  call Crlf
  mov int_num, eax
  mWrite " > Please input integers : "
  call Crlf
  call Crlf

  mov ecx, int_num
L_IPT_USINT:
  mWrite " > "
  call ReadDec
  push eax
  loop L_IPT_USINT

  mov ecx, int_num
  mov eax, 0
L_SUM_USINT:
  pop ebx
  add eax, ebx
  loop L_SUM_USINT

  call Crlf
  mWrite " Sum = "
  call WriteDec
  call Crlf
  call Crlf

  ret
sum_up_unsigned_int ENDP
; == sum up unsigned int ===========================

; == sin ===========================================
to_radian PROC
  fld rad
  fdiv
  fld PI
  fmul
  fstp x
  ret
to_radian ENDP

compute_sin PROC
  finit
  call Clrscr
  call Crlf
  call Crlf
  mWrite " --- Compute sin(x) ---"
  call Crlf
  call Crlf
  mWrite " > Please input x : "
  call ReadFloat
  fst x
  fst x_ori
  call Crlf
  mWrite " > Please input n (number of terms) : "
  call ReadInt
  mov n, eax

  call to_radian
  call get_sin

  call Crlf
  call Crlf
  mWrite " sin("
  fld x_ori
  call WriteFloat
  mWrite ") = "
  fld sin_result
  call WriteFloat
  call Crlf
  ret
compute_sin ENDP

; --------------------------------------------------
; function: get_sin
; parameters: x, n (store in memory)
; --------------------------------------------------
get_sin PROC
  ; x^2
  fld x
  fst taylor_series
  fld x
  fmul
  fstp x_2

  mov ebx, 0 ; i
  mov ecx, DWORD PTR n
L_SIN:
  ; sum += taylor_series;
  fld taylor_series
  fld sin_result
  fadd
  fstp sin_result
  ; taylor_series *= - (x*x) / (2*(i+1) * (2*(i+1)+1));
  inc ebx
  mov eax, 2
  mul ebx ; eax = 2*(i+1)
  mov edx, eax
  inc eax
  mul edx ; eax = 2*(i+1) * (2*(i+1)+1)
  fld x_2
  mov tmp_casting, eax
  fild tmp_casting
  fdiv
  fchs
  fld taylor_series
  fmul
  fstp taylor_series

  loop L_SIN

  ret
get_sin ENDP
; == sin ===========================================

; == show student information ======================

show_inform PROC
  call Clrscr
  mov edx, offset str_show_inform
  call WriteString
  ret
show_inform ENDP

; == show student information ======================

END main
