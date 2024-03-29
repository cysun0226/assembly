
; ========================================================
;  Student Name: Chia-Yu, Sun
;  Student ID: 0416045
;  Email: cysun0226@gmail.com
; ========================================================
;  Instructor: Sai-Keung WONG
;  Email: cswingo@cs.nctu.edu.tw
;  Room: 706
;  Assembly Language
;  Date: 2018/05
; ========================================================
;  Description:
;
;  IMPORTANT: always save EBX, EDX, EDI and ESI as their
;  values are preserved by the callers in C calling convention.
;

INCLUDE Irvine32.inc
INCLUDE Macros.inc

invisibleDigitX  TEXTEQU %(-100000)
invisibleDigitY  TEXTEQU %(-100000)

;  PROTO C is to make agreement on calling convention for INVOKE

c_updatePositionsOfAllObjects PROTO C



; LABEL .data
.data
colors BYTE 01ch
colorOriginal BYTE 01ch

MYINFO	BYTE " Name: Chia-Yu, Sun;  ID: 0416045", 0

OpenMsgDelay	DWORD	25
EnterStageDelay	DWORD	50

MyMsg BYTE 0dh, 0ah, " === Final Project for Assembly Language === ",0dh, 0ah, 0dh, 0ah
BYTE " Programmer Name : Chia-Yu, Sun", 0dh, 0ah
BYTE " Programmer ID   : 0416045", 0dh, 0ah
BYTE " Email Address   : cysun0226@gmail.com", 0dh, 0ah, 0dh, 0ah
BYTE " >> Make sure that the screen dimension is (120, 30).", 0dh, 0ah, 0dh, 0ah
BYTE " Key usages:", 0dh, 0ah, 0dh, 0ah
BYTE "   x (flip), y (flip)", 0dh, 0ah
BYTE "   w (gray), g (grid)", 0dh, 0ah
BYTE "   a (reset), b (blue)", 0dh, 0ah
BYTE "   1-5: point size", 0dh, 0ah
BYTE "   8:2x4, 9:4x8, 0:8x8", 0dh, 0ah
BYTE "   < (blending), > (blending)", 0

CaptionString BYTE "Student Name: Chia-Yu, Sun",0
MessageString BYTE "Welcome to asm final project", 0dh, 0ah, 0dh, 0ah
				BYTE "My name is Chia-Yu, Sun", 0dh, 0ah
				BYTE "My Student ID is 0416045", 0dh, 0ah
				BYTE "My Email is: cysun0226@gmail.com", 0dh, 0ah, 0dh, 0ah
				BYTE "Control keys: ", 0dh, 0ah, 0dh, 0ah
				BYTE "  '1', '2', '3', '4' and '5': change image point size", 0dh, 0ah
				BYTE "  'i' : toggle to show or hide the student ID " , 0dh, 0ah
				BYTE "  'a': change the current image to back to the initial flower and change it to yellow " , 0dh, 0ah
				BYTE "  's': switch the image between gray image and initial image " , 0dh, 0ah
				BYTE "  'g' : toggle the game mode state. If in game mode, show the grid. " , 0dh, 0ah
				BYTE "  'x': flip the current image horizontally " , 0dh, 0ah
				BYTE "  'y': turn the current image upside-down ", 0dh, 0ah
				BYTE "  ESC : show student information and press Enter to quit the program", 0dh, 0ah, 0dh, 0ah
				BYTE " Mouse usages: ", 0dh, 0ah, 0dh, 0ah
				BYTE "  left mouse button: select and exchange the images for two selected grid cells", 0dh, 0ah, 0dh, 0ah
				BYTE "Enjoy playing!", 0


EndingMsg BYTE "Thanks for playing.", 0

CaptionString_EndingMessage BYTE "Student Name: Chia-Yu, Sun",0
MessageString_EndingMessage BYTE "Thanks for playing...", 0dh, 0ah, 0dh, 0ah
				BYTE "My Student ID is 0416045", 0dh, 0ah, 0dh, 0ah
				BYTE "My Email is: cysun0226@gmail.com", 0dh, 0ah, 0dh, 0ah
				BYTE "See you!", 0


windowWidth		DWORD 8000
windowHeight	DWORD 8000

scaleFactor	DWORD	128
canvasMinX	DWORD -4000
canvasMaxX	DWORD 4000
canvasMinY	DWORD -4000
canvasMaxY	DWORD 4000
;
particleRangeMinX REAL8 0.0
particleRangeMaxX REAL8 0.0
particleRangeMinY REAL8 0.0
particleRangeMaxY REAL8 0.0
;
tmpParticleY DWORD ?
;
particleSize DWORD  2
numParticles DWORD 20000
particleMaxSpeed DWORD 3

flgQuit		DWORD	0
; LABEL numObjects
numObjects	DWORD	1024
objPosX		SDWORD	1024 DUP(0)
objPosY		SDWORD	1024 DUP(0)
objTypes	BYTE	1024 DUP(1)
objSpeedX	SDWORD	1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20
			SDWORD	512 DUP(?)
objSpeedY	SDWORD	2, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20
			SDWORD	512 DUP(?)
objColor	DWORD	0, 254, 254,
					254, 254, 254,
					0, 127, 0,
					1024 DUP(255)
studentObjColor	DWORD	1024 DUP(?)
goMsg		BYTE "Final Project for Assembly Language. Let's start...", 0
bell		BYTE 0,0, 0

testDBL	REAL4	3.141592654
zero REAL8 0.0

studentIDDigit DWORD 0
studentID	DWORD 0, 1, 2, 3, 4, 5, 6

particleState BYTE 0
negOne REAL8 -1.0

DIGIT_BIT_MAP BYTE 1, 1, 1, 0 , 1, 0, 1, 0 , 0, 0, 1, 0 ,1, 0, 0, 0 ,1, 1, 1, 0 ,1, 0, 1, 0 ,1, 1, 1
							BYTE 1, 0, 1, 0 , 1, 0, 1, 0 , 0, 0, 1, 0 ,1, 0, 0, 0 ,1, 0, 1, 0 ,1, 0, 1, 0 ,1, 0, 0
							BYTE 1, 0, 1, 0 , 1, 1, 1, 0 , 0, 0, 1, 0 ,1, 1, 1, 0 ,1, 0, 1, 0 ,1, 1, 1, 0 ,1, 1, 1
							BYTE 1, 0, 1, 0 , 0, 0, 1, 0 , 0, 0, 1, 0 ,1, 0, 1, 0 ,1, 0, 1, 0 ,0, 0, 1, 0 ,0, 0, 1
							BYTE 1, 1, 1, 0 , 0, 0, 1, 0 , 0, 0, 1, 0 ,1, 1, 1, 0 ,1, 1, 1, 0 ,0, 0, 1, 0 ,1, 1, 1
;                     0     ;      4     ;      1     ;     6     ;     0     ;     4     ;     5


DIGIT_ALL		BYTE 1, 1, 1, 1
			    	BYTE 1, 1, 1, 1
			    	BYTE 1, 1, 1, 0dh
			    	BYTE 1, 1, 1, 1
			    	BYTE 1, 1, 1, 1

DIGIT_MO_0		BYTE 0, 0, 1, 0dh
							BYTE 0, 0, 0, 0dh
							BYTE 0, 0, 0, 0dh
							BYTE 0, 0, 0, 0dh
							BYTE 0, 0, 0, 0ffh
DIGIT_MO_SIZE = ($-DIGIT_MO_0)
DIGIT_MO_1		BYTE 0, 1, 1, 0dh
							BYTE 0, 0, 0, 0dh
							BYTE 0, 0, 0, 0dh
							BYTE 0, 0, 0, 0dh
							BYTE 0, 0, 0, 0ffh

DIGIT_MO_2		BYTE 1, 1, 1, 0dh
							BYTE 0, 0, 0, 0dh
							BYTE 0, 0, 0, 0dh
							BYTE 0, 0, 0, 0dh
							BYTE 0, 0, 0, 0ffh

DIGIT_MO_3		BYTE 1, 1, 1, 0dh
							BYTE 1, 0, 0, 0dh
							BYTE 0, 0, 0, 0dh
							BYTE 0, 0, 0, 0dh
							BYTE 0, 0, 0, 0ffh

DIGIT_MO_4		BYTE 1, 1, 1, 0dh
							BYTE 1, 0, 0, 0dh
							BYTE 1, 0, 0, 0dh
							BYTE 0, 0, 0, 0dh
							BYTE 0, 0, 0, 0ffh

DIGIT_MO_5		BYTE 1, 1, 1, 0dh
							BYTE 1, 0, 0, 0dh
							BYTE 1, 1, 0, 0dh
							BYTE 0, 0, 0, 0dh
							BYTE 0, 0, 0, 0ffh

DIGIT_MO_6		BYTE 1, 1, 1, 0dh
							BYTE 1, 0, 0, 0dh
							BYTE 1, 1, 1, 0dh
							BYTE 0, 0, 0, 0dh
							BYTE 0, 0, 0, 0ffh

DIGIT_MO_7		BYTE 1, 1, 1, 0dh
							BYTE 1, 0, 0, 0dh
							BYTE 1, 1, 1, 0dh
							BYTE 0, 0, 1, 0dh
							BYTE 0, 0, 0, 0ffh

DIGIT_MO_8		BYTE 1, 1, 1, 0dh
							BYTE 1, 0, 0, 0dh
							BYTE 1, 1, 1, 0dh
							BYTE 0, 0, 1, 0dh
							BYTE 0, 0, 1, 0ffh


DIGIT_MO_9		BYTE 1, 1, 1, 0dh
							BYTE 1, 0, 0, 0dh
							BYTE 1, 1, 1, 0dh
							BYTE 0, 0, 1, 0dh
							BYTE 0, 1, 1, 0ffh

DIGIT_MO_10		BYTE 1, 1, 1, 0dh
							BYTE 1, 0, 0, 0dh
							BYTE 1, 1, 1, 0dh
							BYTE 0, 0, 1, 0dh
							BYTE 1, 1, 1, 0ffh

DIGIT_MO_11		BYTE 1, 1, 1, 0dh
							BYTE 1, 0, 1, 0dh
							BYTE 1, 1, 1, 0dh
							BYTE 1, 0, 1, 0dh
							BYTE 1, 1, 1, 0ffh

DIGIT_MO_12		BYTE 1, 1, 1, 0dh
							BYTE 1, 1, 1, 0dh
							BYTE 1, 1, 1, 0dh
							BYTE 1, 0, 1, 0dh
							BYTE 1, 1, 1, 0ffh

DIGIT_MO_13		BYTE 1, 1, 1, 0dh
							BYTE 1, 1, 1, 0dh
							BYTE 1, 1, 1, 0dh
							BYTE 1, 1, 1, 0dh
							BYTE 1, 1, 1, 0ffh

DIGIT_INDEX		DWORD	0
TOTALDIGITS		DWORD	13


DIGIT_0			BYTE 1, 1, 1, 0dh
						BYTE 1, 0, 1, 0dh
						BYTE 1, 0, 1, 0dh
						BYTE 1, 0, 1, 0dh
						BYTE 1, 1, 1, 0ffh
DIGIT_SIZE = ($-DIGIT_0)
DIGIT_1			BYTE 0, 1, 0, 0dh
						BYTE 0, 1, 0, 0dh
						BYTE 0, 1, 0, 0dh
						BYTE 0, 1, 0, 0dh
						BYTE 0, 1, 0, 0ffh

DIGIT_2			BYTE 1, 1, 1, 0dh
						BYTE 0, 0, 1, 0dh
						BYTE 1, 1, 1, 0dh
						BYTE 1, 0, 0, 0dh
						BYTE 1, 1, 1, 0ffh



stage				DWORD 0
currentDigit			DWORD 0
objPosForOneDigitX	SDWORD 1000 DUP(0)
objPosForOneDigitY	SDWORD 1000 DUP(0)
digitX SDWORD -8000
digitY SDWORD 25000
digitTimer DWORD 0
colorTimer DWORD 0
colorIndex DWORD 0

offsetImage DWORD 0

digitOffsetX DWORD 0
digitSpacingDFTWidth DWORD	2000
digitSpacingDFTHeight DWORD 2000

digitSpacingWidth DWORD	2000
digitSpacingHeight DWORD 2000

digitMaxSpeed DWORD 10
digitMaxDFTSpeed DWORD 10

digitWidth DWORD 0

totalColors	DWORD	0
colorRed	BYTE	10000 DUP(0)
colorGreen	BYTE	10000 DUP(0)
colorBlue	BYTE	10000 DUP(0)

openingMsg	BYTE	 0dh, 0ah, " This program shows 0416045 using bitmap and manipulates images....",0dh, 0ah
			BYTE	" Great programming.", 0
movementDIR	BYTE 0
state		BYTE	0

imagePercentage DWORD	0

mImageStatus DWORD 0
mImagePtr0 BYTE 200000 DUP(?)
mImagePtr1 BYTE 200000 DUP(?)
mImagePtr2 BYTE 200000 DUP(?)
mTmpBuffer	BYTE	200000 DUP(?)
mImageWidth DWORD 0
mImageHeight DWORD 0
mBytesPerPixel DWORD 0
mImagePixelPointSize DWORD 6

mFlipX DWORD 0
mFlipY DWORD 1
mEnableBrighter DWORD 0
mAmountOfBrightness DWORD 1
mBrightnessDirection DWORD 0

				; x, y, width, height
mSubImage		DWORD	0, 0, 30, 30
mShowAtLocation	DWORD	30, 30
;
;

; width and height
GridDimensionW	DWORD	8
GridDimensionH	DWORD	8
GridCellW			DWORD	1
GridCellH			DWORD	1
CurGridX		DWORD	0
CurGridY		DWORD	0
flgPickedGrid	DWORD	0
PickedGridX		DWORD	-1
PickedGridY		DWORD	-1

OldPickedGridX		DWORD	-1
OldPickedGridY		DWORD	-1

GridColorRed		BYTE	0
GridColorGreen		BYTE	0
GridColorBlue		BYTE	0


FlgSaveImage		BYTE	0
FlgRestoreImage		BYTE	0
FlgShowGrid			BYTE	0	; 2
FlgYellowFlower		BYTE	0	; 3
FlgBrigtenImage		BYTE	0	; 4
FlgDarkenImage		BYTE	0	; 5
FlgGrayLevelImage	BYTE	0	; 6

programState		BYTE	0


IMAGE_HEIGHT	DWORD ?
IMAGE_WIDTH	DWORD ?
mouse_convert_scale DWORD 64
targetPos_x DWORD ?
targetPos_y DWORD ?
arrive_target DWORD 0
growing SDWORD 1
random_color SDWORD -1
set_rainbow SDWORD -1
set_clear SDWORD -1
rainbow_id DWORD 0
press_dir_key SDWORD -1
RAINBOW_COLOR_R BYTE 255, 204, 255, 0,   0,   0,   76
RAINBOW_COLOR_G BYTE 0,   102, 255, 255, 0,   0,   0
RAINBOW_COLOR_B BYTE	0,   0,   0,   0,   255, 102, 153


singleObjPosX DWORD	1024 DUP(0)
singleObjPosY DWORD	1024 DUP(0)
singleObjColorR DWORD	255, 1024 DUP(0)
singleObjColorG DWORD	0, 1024 DUP(0)
singleObjColorB DWORD	0, 1024 DUP(0)
save_PosX DWORD ?
save_PosY DWORD ?
save_Direction DWORD ?
save_snake_num DWORD ?
save_flg_target SDWORD ?
save_arrive_target SDWORD ?
save_growing SDWORD ?
save_target_x DWORD ?
save_target_y DWORD ?

color_buffer_R DWORD	1024 DUP(0)
color_buffer_G DWORD	1024 DUP(0)
color_buffer_B DWORD	1024 DUP(0)

pos_buffer_x DWORD	1024 DUP(0)
pos_buffer_y DWORD	1024 DUP(0)

; LABEL my PROTO
set_grid_dimension PROTO,
grid_x: DWORD,
grid_y: DWORD

coordinate_mapping PROTO,
row_pos: DWORD

pos_x DWORD ?
pos_y DWORD ?
;  LABEL my var
digit_speed DWORD 100
x_space DWORD 10
y_space DWORD 10

obj_num DWORD 0
digit_ori_x SDWORD -30000
digit_ori_y SDWORD 40000
digit_x SDWORD -30000
digit_y SDWORD 40000

obj_x_idx DWORD 0
obj_y_idx DWORD 0
digit_direction SDWORD 1 ; 1 ->, -1 <-
digit_left SDWORD ?
digit_right SDWORD ?
if_display_digit SDWORD 0
image_color_idx DWORD 0
image_idx DWORD 0
if_turn_yellow SDWORD 1
mImagePtrGray BYTE 200000 DUP(?)
if_gray_image SDWORD -1
if_game_mode SDWORD -1
cur_grid BYTE 100 DUP(?)

grid_top DWORD ?
grid_bottom DWORD ?
grid_left DWORD ?
grid_right DWORD ?

selected_grid_top DWORD ?
selected_grid_bottom DWORD ?
selected_grid_left DWORD ?
selected_grid_right DWORD ?

prev_selected_grid_top DWORD ?
prev_selected_grid_bottom DWORD ?
prev_selected_grid_left DWORD ?
prev_selected_grid_right DWORD ?

mImagePtrGame BYTE 200000 DUP(?)
mImagePtrSelect BYTE 200000 DUP(?)

hover_color SDWORD 1
select_grid SDWORD 0

mPrevSelectBuffer BYTE 200000 DUP(?)
mCurSelectBuffer BYTE 200000 DUP(?)
swap_step DWORD 0
game_mode DWORD 0
cur_grid_x DWORD 8
cur_grid_y DWORD 8


.code

; =================================================
;  void asm_InitializeApp()
;
;  This function is called
;  at the beginning of the program.
; =================================================
asm_InitializeApp PROC C USES ebx edi esi edx
	mov al, blue + white*16
	or al, 88h
	mov ah, 080h
	call SetTextColor
	mov dl, 0
	mov dh, 16
	mov edi, offset openingMsg
	call gotoxy
	P0:
	mov al, [edi]
	call writechar
	; mov eax, 25
	mov eax, 1
	call delay
	mov al, [edi]
	inc edi
	cmp al, 0
	je P1
	cmp al, 0dh
	jne P0
	inc dh
	call gotoxy
	jmp P0
	P1:
	call ReadInt

	call Crlf
	call Crlf
	mWrite " (Press enter to start) "
	; DONE Ask For Input Init
	; call Crlf
	; mWrite " Initialization setting: "
	; call Crlf
	; call Crlf
	; mWrite "  ( If the user does not input anything, the program will use the default value. )"
	; call Crlf
	; call Crlf
	; mWrite "  > Input the maximum speed of a digit (integer): "
	; call readInt
	; .if eax == 0
	; mov digit_speed, 100
	; .else
	; mov digit_speed, eax
	; .endif
	;
	; mWrite "  > Input the spacing for the blocks along the X-axis (integer): "
	; call readInt
	; .if eax == 0
	; mov x_space, 25
	; .else
	; mov x_space, eax
	; .endif
	;
	; mWrite "  > Input the spacing for the blocks along the Y-axis (integer): "
	; call readInt
	; .if eax == 0
	; mov y_space, 25
	; .else
	; mov y_space, eax
	; .endif

	call Crlf
	call Crlf
	call Crlf
	mWrite " --- log ---"
	call Crlf
	call Crlf

	mov ebx, OFFSET CaptionString
	mov edx, OFFSET MessageString
	call MsgBox
	ret

	ret
asm_InitializeApp ENDP

; =================================================
; void setCursor(int x, int y)
;
; Set the position of the cursor
; in the console (text) window.
; =================================================
setCursor PROC C USES edx,
	x:DWORD, y:DWORD
	mov edx, y
	shl edx, 8
	xor edx, x
	call Gotoxy
	ret
setCursor ENDP

; =================================================
; void asm_ClearScreen()
;
; Clear the screen.
; We can set text color if you want.
; =================================================
asm_ClearScreen PROC C
	mov al, 0
	mov ah, 0
	call SetTextColor
	call clrscr
	ret
asm_ClearScreen ENDP

; =================================================
; void asm_ShowTitle()
;
; Show the title of the program
; at the beginning.
; =================================================
asm_ShowTitle PROC C USES edx
	INVOKE setCursor, 0, 0
	xor eax, eax
	mov ah, 0h
	mov al, 0e1h
	call SetTextColor
	mov edx, offset MyMsg
	call WriteString
	ret
asm_ShowTitle ENDP

; =================================================
; void asm_InitObjects()
;
; Initialize the objects,
; including the speed, colors, etc.
; That're up to you (programmers).
; =================================================
asm_InitObjects PROC C
	; TODO asm InitObjects
	mov if_turn_yellow, 0
	call backup_image
	call clear_obj
	ret
asm_InitObjects ENDP

asm_computeCircularPosX PROC C
	fld testDBL
	ret
asm_computeCircularPosX ENDP

asm_GetNumParticles PROC C
mov eax, numParticles
ret
asm_GetNumParticles ENDP
; =================================================
asm_GetParticleMaxSpeed PROC C
mov eax, particleMaxSpeed
ret
asm_GetParticleMaxSpeed ENDP

; int asm_GetParticleSize()
;
; Return the particle size.
; =================================================
asm_GetParticleSize PROC C
	mov eax, 2
	ret
asm_GetParticleSize ENDP

; =================================================
; void asm_handleMousePassiveEvent( int x, int y )
; =================================================
asm_handleMousePassiveEvent PROC C USES eax ebx edx,
	x : DWORD, y : DWORD
	mov eax, x
	mWrite "x:"
	call WriteDec
	mWriteln " "
	mov eax, y
	mWrite "y:"
	call WriteDec
	mWriteln " "

	; TODO Mouse Passive Event
 .if if_game_mode == 1
 		mov eax, x
		mov pos_x, eax
		mov eax, y
		mov pos_y, eax
		call earse_grid
		call get_grid_range
 .endif

	ret
asm_handleMousePassiveEvent ENDP



; =================================================
; void asm_handleMouseEvent(int button, int status, int x, int y)
; =================================================
asm_handleMouseEvent PROC C USES ebx,
	button : DWORD, status : DWORD, x : DWORD, y : DWORD

	call earse_grid
	mWriteln "asm_handleMouseEvent"
	mov eax, button
	mWrite "button:"
	call WriteDec
	mWriteln " "
	mov eax, status
	mWrite "status:"
	call WriteDec
	mov eax, x
	mov pos_x, eax
	mWriteln " "
	mWrite "x:"
	call WriteDec
	mWriteln " "
	mov eax, y
	mov pos_y, eax
	mWrite "y:"
	call WriteDec
	mWriteln " "
	mov eax, windowWidth
	mWrite "windowWidth:"
	call WriteDec
	mWriteln " "
	mov eax, windowHeight
	mWrite "windowHeight:"
	call WriteDec
	mWriteln " "

	; TODO click
	;.if select_grid == 0
	cmp status, 1
	jne exit0



	;.endif
	.if select_grid == 1
		call get_grid_range
		mov swap_step, 0
		call swap_buf
		mov swap_step, 1
		call swap_buf
		.if game_mode == 0
			INVOKE set_grid_dimension, 8, 8
		.elseif game_mode == 9
			INVOKE set_grid_dimension, 4, 8
		.else
			INVOKE set_grid_dimension, 2, 4
		.endif
		mov select_grid, 0
		call backup_image
		jmp exit0
	.endif

	.if game_mode == 0
		INVOKE set_grid_dimension, 8, 8
	.elseif game_mode == 9
		INVOKE set_grid_dimension, 4, 8
	.else
		INVOKE set_grid_dimension, 2, 4
	.endif
	mov select_grid, 1
	call get_grid_range
	call draw_selected
	call save_selected
exit0:
	ret
asm_handleMouseEvent ENDP
; =================================================
; int asm_HandleKey(int key)
;
; Handle key events.
; Return 1 if the key has been handled.
; Return 0, otherwise.
; =================================================
asm_HandleKey PROC C,
	key : DWORD
	mov eax, key
	cmp al, 27 ;  ESC
	jne L1
	mov al, white + blue*16
	mov ah, 01h
	call SetTextColor
	mov ebx, OFFSET CaptionString_EndingMessage
	mov edx, OFFSET MessageString_EndingMessage
	call MsgBox
	mWriteLn "Thanks for playing..."
	mWriteLn "My studen name is Chia-Yu, Sun"
	mWriteLn "My student ID is: 0416045."

	mWriteLn "Press ENTER to quit."
	call ReadInt
	exit
	mov state, 0
L1:
	; TODO handle key

	; digits
	.if key == 'i'
		.if if_display_digit == 0
			mov if_display_digit, 1
			call digit_init
		.else
			mov if_display_digit, 0
			call clear_obj
		.endif
	.endif
	.if key == 'I'
		.if if_display_digit == 0
			mov if_display_digit, 1
			call digit_init
		.else
			mov if_display_digit, 0
			call clear_obj
		.endif
	.endif

	; pixel size
	.if key == '1'
		mov mImagePixelPointSize, 1
	.endif
	.if key == '2'
		mov mImagePixelPointSize, 2
	.endif
	.if key == '3'
		mov mImagePixelPointSize, 3
	.endif
	.if key == '4'
		mov mImagePixelPointSize, 4
	.endif
	.if key == '5'
		mov mImagePixelPointSize, 5
	.endif

	; a (turn yellow)
	.if key == 'a'
		call restore_image
		mov mImagePixelPointSize, 6
		mov if_turn_yellow, 1
		call turn_yellow
	.endif

	; s
	.if key == 's'
		.if if_gray_image == -1
			neg if_gray_image
			call gray_image
		.else
			neg if_gray_image
			call restore_image
		.endif
	.endif

	; x (flip horizon)
	.if key == 'x'
		call flip_horizon
	.endif

	; y (upside down)
	.if key == 'y'
		call upside_down
	.endif

	; g (game mode)
	.if key == 'g'
		neg if_game_mode
		.if if_game_mode == 1
			call backup_image
			mov game_mode, 0
			mov cur_grid_x, 8
			mov cur_grid_y, 8
			INVOKE set_grid_dimension, 8, 8
			call backup_image
		.else
			call restore_image
		.endif
	.endif

	; grid setting
	.if key == '8'
		.if if_game_mode == 1
			neg if_game_mode
			call restore_image
			mov cur_grid_x, 4
			mov cur_grid_y, 2
			mov game_mode, 8
			INVOKE set_grid_dimension, 2, 4
			neg if_game_mode
			call backup_image
		.endif
	.endif

	.if key == '9'
		.if if_game_mode == 1
			neg if_game_mode
			call restore_image
			mov cur_grid_x, 8
			mov cur_grid_y, 4
			mov game_mode, 9
			INVOKE set_grid_dimension, 4, 8
			neg if_game_mode
			call backup_image
		.endif
	.endif

	.if key == '0'
		.if if_game_mode == 1
			neg if_game_mode
			call restore_image
			mov cur_grid_x, 8
			mov cur_grid_y, 8
			mov game_mode, 0
			INVOKE set_grid_dimension, 8, 8
			neg if_game_mode
			call backup_image
		.endif
	.endif



exit0:
	mov eax, 0
	ret
asm_HandleKey ENDP

; =================================================
; void asm_EndingMessage()
;
; This function is called
; when the program exits.
; =================================================
asm_EndingMessage PROC C
	mov ebx, OFFSET CaptionString_EndingMessage
	mov edx, OFFSET MessageString_EndingMessage
	call MsgBox
	mov ah, 0h
	mov al, 0e1h
	call SetTextColor
	mov edx, offset EndingMsg
	call WriteString
	ret
asm_EndingMessage ENDP

; =================================================
; void asm_SetWindowDimension(int w, int h, int scaledWidth, int scaledHeight)
;
; w: window resolution (i.e. number of pixels) along the x-axis.
; h: window resolution (i.e. number of pixels) along the y-axis.
; scaledWidth : scaled up width
; scaledHeight : scaled up height
;
; =================================================
asm_SetWindowDimension PROC C USES ebx,
	w: DWORD, h: DWORD, scaledWidth : DWORD, scaledHeight : DWORD
	mov ebx, offset windowWidth
	mov eax, w
	mov [ebx], eax
	mov eax, scaledWidth
	shr eax, 1	;  divide by 2, i.e. eax = eax/2
	mov ebx, offset canvasMaxX
	mov [ebx], eax
	neg eax
	mov ebx, offset canvasMinX
	mov [ebx], eax
	; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
	mov ebx, offset windowHeight
	mov eax, h
	mov [ebx], eax
	mov eax, scaledHeight
	shr eax, 1	;  divide by 2, i.e. eax = eax/2
	mov ebx, offset canvasMaxY
	mov [ebx], eax
	neg eax
	mov ebx, offset canvasMinY
	mov [ebx], eax
	;
	finit
	fild canvasMinX
	fstp particleRangeMinX
	;
	finit
	fild canvasMaxX
	fstp particleRangeMaxX
	;
	finit
	fild canvasMinY
	fstp particleRangeMinY
	;
	finit
	fild canvasMaxY
	fstp particleRangeMaxY
	;
	ret
asm_SetWindowDimension ENDP
; =================================================
; int asm_GetNumOfObjects()
;
; Return the number of objects
; =================================================
asm_GetNumOfObjects PROC C
	mov eax, numObjects
	ret
asm_GetNumOfObjects ENDP

; =================================================
; int asm_GetObjectType(int objID)
;
; Return the object type
; =================================================
asm_GetObjectType		PROC C USES ebx edx,
	objID: DWORD
	push ebx
	push edx
	xor eax, eax
	mov edx, offset objTypes
	mov ebx, objID
	mov al, [edx + ebx]
	pop edx
	pop ebx
	ret
asm_GetObjectType		ENDP

; =================================================
; =================================================
asm_GetObjPosX		PROC C
mov eax,objPosX
ret
asm_GetObjPosX		ENDP

asm_GetObjPosY		PROC C
mov eax,objPosY
ret
asm_GetObjPosY		ENDP
; =================================================
; void asm_GetObjectColor (int &r, int &g, int &b, int objID)
; Input: objID, the ID of the object
; Return: the color three color components
; red, green and blue.
; =================================================
asm_GetObjectColor  PROC C USES ebx edi esi,
	r: PTR DWORD, g: PTR DWORD, b: PTR DWORD, objID: DWORD
; TODO Get Object Color
	mov ebx, r
	mov DWORD PTR [ebx], 100
	mov ebx, g
	mov DWORD PTR [ebx], 255
	mov ebx, b
	mov DWORD PTR [ebx], 200
	ret
;
asm_GetObjectColor ENDP
; =================================================
; int asm_ComputeRotationAngle(a, b)
; return an angle*10.
; =================================================
asm_ComputeRotationAngle PROC C USES ebx,
	a: DWORD, b: DWORD
	mov ebx, b
	shl ebx, 1
	mov eax, a
	add eax, 10
	ret
asm_ComputeRotationAngle ENDP

; =================================================
; int asm_ComputePositionX(int x, int objID)
;
; Return the x-coordinate.
; =================================================
asm_ComputePositionX PROC C USES edi esi,
	x: DWORD, objID: DWORD
	; DONE asm Compute PosX
	mov esi, offset objPosX
	mov eax, objID
	mov ebx, 4
	mul ebx
	add esi, eax
	mov eax, DWORD PTR [esi]


	ret
asm_ComputePositionX ENDP

; =================================================
; int asm_ComputePositionY(int y, int objID)
;
; Return the y-coordinate.
; =================================================
asm_ComputePositionY PROC C USES ebx esi edx,
	y: DWORD, objID: DWORD
	; DONE asm Compute PosY
	mov esi, offset objPosY
	mov eax, objID
	mov ebx, 4
	mul ebx
	add esi, eax
	mov eax, DWORD PTR [esi]
	ret
asm_ComputePositionY ENDP

ASM_setText PROC C
	; mov al, 0e1h
	mov al, 01eh
	call SetTextColor
	ret
ASM_setText ENDP

asm_ComputeParticlePosX PROC C,
xPtr : PTR REAL8
ret
asm_ComputeParticlePosX ENDP

;
asm_ComputeParticlePosY PROC C,
x : DWORD, yPtr : PTR REAL8, yVelocityPtr : PTR REAL8
ret
asm_ComputeParticlePosY ENDP
; =================================================
; =================================================
; void asm_updateSimulationNow()
;
; Update the simulation.
; For examples,
; we can update the positions of the objects.
; =================================================
asm_updateSimulationNow PROC C USES edi esi ebx
;  TODO update Simulation Now
	.if if_display_digit == 1
		call move_digit
	.else
		mov numObjects, 0
	.endif

	.if if_turn_yellow == 1
		call turn_yellow
	.endif

	.if if_game_mode == 1
	  call hover_grid
  .endif

update0:
; =================================================
; DO NOT DELETE THE FOLLOWING LINES
	INVOKE c_updatePositionsOfAllObjects
; =================================================
	ret
asm_updateSimulationNow ENDP

; =================================================
asm_SetImageInfo PROC C USES esi edi ebx,
imageIndex : DWORD,
imagePtr : PTR BYTE, w : DWORD, h : DWORD, bytesPerPixel : DWORD
;  CHANGED Set Image Info

; store image into mImagePtrx
mov eax, w
mov mImageWidth, eax
mov ebx, h
mov mImageHeight, ebx
mul ebx ; eax = mImageWidth * mImageHeight
.if imageIndex == 0
	mov esi, offset mImagePtr0
.else
	mov esi, offset mImagePtr1
.endif
mov ecx, eax
L_SET_IMG_INFO:
	mov ebx, ecx
	mov eax, 3
	mul ebx ; eax = ecx*3
	mov ebx, imagePtr
	; r
	add ebx, eax ; ebx = imagePtr + ecx*3
	mov dl, BYTE PTR [ebx]
	push ebx
	mov ebx, esi
	add ebx, eax ; ebx = mImagePtr0 + ecx*3
	mov BYTE PTR [ebx], dl
	; g
	pop eax ; imagePtr + ecx*3
	inc eax
	inc ebx ; mImagePtr0 + ecx*3
	mov dl, BYTE PTR [eax]
	mov BYTE PTR [ebx], dl
	; b
	inc eax
	inc ebx ; mImagePtr0 + ecx*3
	mov dl, BYTE PTR [eax]
	mov BYTE PTR [ebx], dl
loop L_SET_IMG_INFO

ret
asm_SetImageInfo ENDP
; =================================================

asm_GetImagePixelSize PROC C
mov eax, mImagePixelPointSize
ret
asm_GetImagePixelSize ENDP

asm_GetImageStatus PROC C
mov eax, mImageStatus
ret
asm_GetImageStatus ENDP

asm_getImagePercentage PROC C
mov eax, imagePercentage
ret
asm_getImagePercentage ENDP
; =================================================; ; ;
; asm_GetImageColour(int imageIndex, int ix, int iy, int &r, int &g, int &b)
;
asm_GetImageColour PROC C USES ebx esi,
imageIndex : DWORD,
ix: DWORD, iy : DWORD,
r: PTR DWORD, g: PTR DWORD, b: PTR DWORD

;  CHNAGED asm Get Image Colour

	mov ebx, mImageWidth; index = iy*w + ix
	mov eax, iy
	mov edx, mImageHeight
	sub edx, eax
	mov eax, edx
	mul ebx ; eax = iy*w
	mov ebx, ix
	add eax, ebx ; eax = iy*w + ix
	mov ebx, 3
	mul ebx ; eax = 3* (iy*w + ix)

	mov esi, eax
	.if imageIndex == 0
		mov image_idx, 0
		mov ebx, offset mImagePtr0
	.else
		mov image_idx, 1
		mov ebx, offset mImagePtr1
	.endif
	mov ebx, offset mImagePtr0
	add esi, ebx

	mov ebx, r
	mov al, BYTE PTR [esi]
	mov BYTE PTR [ebx], al

	inc esi
	mov ebx, g
	mov al, BYTE PTR [esi]
	mov BYTE PTR [ebx], al

	inc esi
	mov al, BYTE PTR [esi]
	mov ebx, b
	mov BYTE PTR [ebx], al

ret
asm_GetImageColour ENDP
; =================================================; ; ;

; =================================================
; const char *asm_getStudentInfoString()
;
; return pointer in edx
asm_getStudentInfoString PROC C
	mov eax, offset MYINFO
	ret
asm_getStudentInfoString ENDP

; void asm_GetImageDimension(int &iw, int &ih)
asm_GetImageDimension PROC C USES ebx,
iw : PTR DWORD, ih : PTR DWORD
	;  DONE Get Image Dimension
	mov ebx, iw
	mov eax, mImageWidth
	mov [ebx], eax
	mov ebx, ih
	mov eax, mImageHeight
	mov [ebx], eax
ret
asm_GetImageDimension ENDP

asm_GetImagePos PROC C USES ebx,
x : PTR DWORD,
y : PTR DWORD
mov eax, canvasMinX
mov ebx, scaleFactor
cdq
idiv ebx
mov ebx, x
mov [ebx], eax

mov eax, canvasMinY
mov ebx, scaleFactor
cdq
idiv ebx
mov ebx, y
mov [ebx], eax
ret
asm_GetImagePos ENDP

; == digit_init =======================
; DONE digit_init
digit_init PROC USES eax ebx ecx edx edi esi
	mov obj_x_idx, 0
	mov obj_y_idx, 0
	mov eax, digit_ori_x
	mov digit_left, eax
	mov esi, offset DIGIT_BIT_MAP
	mov ecx, 5
	mov ebx, digit_ori_y ; dig_y
	L_DIGIT_INIT_R:
		mov eax, digit_ori_x ;dig_x
		push ecx
		mov ecx, 27
		L_DIGIT_INIT_C:
			movzx edx, BYTE PTR [esi]
			.if edx == 1
				mov edi, offset objPosX
				add edi, obj_x_idx
				mov SDWORD PTR [edi], eax
				mov edi, offset objPosY
				add edi, obj_y_idx
				mov SDWORD PTR [edi], ebx
				add obj_x_idx, 4
				add obj_y_idx, 4
				inc obj_num
			.endif
			add eax, 2500
			inc esi
			loop L_DIGIT_INIT_C
		sub ebx, 2500
		pop ecx
		loop L_DIGIT_INIT_R
	mov digit_right, eax
	sub digit_right, 2500
	ret
digit_init ENDP
; == digit_init =======================

; == move_digit =======================
; DONE move digit
move_digit PROC USES eax ebx ecx edx edi esi
	mov obj_x_idx, 0
	mov obj_y_idx, 0
	; boundary check
	mov eax, canvasMaxX
	.if digit_right >= eax
		neg digit_direction
	.endif
	mov eax, canvasMinX
	.if digit_left <= eax
		neg digit_direction
	.endif

	.if digit_direction == 1
		add digit_right, 100
		add digit_left, 100
	.else
		sub digit_left, 100
		sub digit_right, 100
	.endif


	mov ecx, obj_num
L_MOVE_DIGIT:
	mov edi, offset objPosX
	add edi, obj_x_idx
	.if digit_direction == 1
		add SDWORD PTR [edi], 100
	.else
		sub SDWORD PTR [edi], 100
	.endif
	add obj_x_idx, 4
	loop L_MOVE_DIGIT

	ret
move_digit ENDP
; == move_digit =======================

; == clear_obj ========================
; DONE clear obj
clear_obj PROC USES eax ebx ecx edx edi esi
	mov obj_x_idx, 0

	mov ecx, 1024
L_CLEAR_OBJ:
	mov edi, offset objPosX
	add edi, obj_x_idx
	mov SDWORD PTR [edi], 60000
	mov edi, offset objPosY
	add edi, obj_x_idx
	mov SDWORD PTR [edi], 60000
	add obj_x_idx, 4
	loop L_CLEAR_OBJ

	ret
clear_obj ENDP
; == clear_obj ========================

; == turn_yellow ======================
; DONE turn yellow
turn_yellow PROC USES eax ebx ecx edx edi esi
	.if image_idx == 0
		mov esi, offset mImagePtr0
	.else
		mov esi, offset mImagePtr1
	.endif
	mov esi, offset mImagePtr0

	; mov esi, offset mImagePtr0
	mov edi, offset mTmpBuffer
	mov image_color_idx, 0
	mov if_turn_yellow, 0
	mov ecx, 65536
L_TURN_YELLOW:
	; r
	inc esi
	inc edi
	; g
	inc esi
	inc edi
	; b
	mov al, BYTE PTR [edi]
	.if al > 100
		mov al, BYTE PTR [esi]
		.if al > 50
			dec BYTE PTR [esi]
			mov if_turn_yellow, 1
		.endif
	.endif
	inc esi
	inc edi
	loop L_TURN_YELLOW

	ret
turn_yellow ENDP
; == turn_yellow ======================

; == restore_image =====================
; CHANGED restore_image
restore_image PROC USES eax ebx ecx edx edi esi
	.if image_idx == 1
		mov edi, offset mImagePtr1
	.else
		mov edi, offset mImagePtr0
	.endif
	mov edi, offset mImagePtr0

	.if if_game_mode == 1
		mov esi, offset mImagePtrGame
	.else
		mov esi, offset mTmpBuffer
	.endif

	mov ecx, 65535*3
L_RESTORE_IMAGE:
	mov al, BYTE PTR [esi]
	mov BYTE PTR [edi], al
	inc esi
	inc edi
	loop L_RESTORE_IMAGE
	ret
restore_image ENDP
; == restore_image =====================

; == backup_image =====================
; DONE backup image
backup_image PROC USES eax ebx ecx edx edi esi
	.if if_game_mode == 1
		mov edi, offset mImagePtrGame
	.else
		mov edi, offset mTmpBuffer
	.endif

	.if image_idx == 0
		mov esi, offset mImagePtr0
	.endif
	.if image_idx == 1
		mov esi, offset mImagePtr1
	.endif
	mov esi, offset mImagePtr0

	mov ecx, 65535*3
L_BACKUP_IMAGE:
	mov al, BYTE PTR [esi]
	mov BYTE PTR [edi], al
	inc esi
	inc edi
	loop L_BACKUP_IMAGE
	ret
backup_image ENDP
; == backup_image =====================

; == gray_image =====================
; (r+g+b)/3
; DONE gray_image
gray_image PROC USES eax ebx ecx edx edi esi
	.if image_idx == 0
		mov esi, offset mImagePtr0
	.endif
	.if image_idx == 1
		mov esi, offset mImagePtr1
	.endif
	mov esi, offset mImagePtr0
	mov eax, 0
	mov bl, 3
	mov ecx, 65535
L_GRAY_IMAGE:
	movzx eax, BYTE PTR [esi]
	inc esi
	movzx edx, BYTE PTR [esi]
	add eax, edx
	inc esi
	movzx edx, BYTE PTR [esi]
	add eax, edx
	inc esi

	; / 3
	mov bl, 3
	div bl
	sub esi, 3
	mov BYTE PTR [esi], al
	inc esi
	mov BYTE PTR [esi], al
	inc esi
	mov BYTE PTR [esi], al
	inc esi

	loop L_GRAY_IMAGE
	ret
gray_image ENDP
; == gray_image =====================

; == flip_horizon ===================
; DONE flip horizon
flip_horizon PROC USES eax ebx ecx edx edi esi
	mov esi, offset mImagePtr0
	mov ecx, 256
L_FLIP_HORIZON_R:
	push ecx
	mov ecx, 256
	L_FLIP_HORIZON_C_PUSH:
		movzx eax, BYTE PTR [esi]
		push eax
		inc esi
		movzx eax, BYTE PTR [esi]
		push eax
		inc esi
		movzx eax, BYTE PTR [esi]
		push eax
		inc esi
		loop L_FLIP_HORIZON_C_PUSH
	sub esi, 256*3
	mov ecx, 256
	L_FLIP_HORIZON_C_POP:
		pop eax
		mov ebx, eax
		inc esi
		pop eax
		mov BYTE PTR [esi], al
		inc esi
		pop eax
		mov BYTE PTR [esi], bl
		sub esi, 2
		mov BYTE PTR [esi], al
		add esi, 2
		inc esi
		loop L_FLIP_HORIZON_C_POP
	pop ecx
	loop L_FLIP_HORIZON_R
	ret
flip_horizon ENDP
; == flip_horizon ===================

; == upside_down ====================
; DONE upside down
upside_down PROC USES eax ebx ecx edx edi esi
	mov esi, offset mImagePtr0
	mov ecx, 65536*3
L_UPSIDE_DOWN_PUSH:
	movzx eax, BYTE PTR [esi]
	push eax
	inc esi
	loop L_UPSIDE_DOWN_PUSH

	mov esi, offset mImagePtr0
	mov ecx, 65536
L_UPSIDE_DOWN_POP:
	pop ebx
	inc esi
	pop eax
	mov BYTE PTR [esi], al
	inc esi
	pop eax
	sub esi, 2
	mov BYTE PTR [esi], al
	add esi, 2
	mov BYTE PTR [esi], bl
	inc esi
	loop L_UPSIDE_DOWN_POP
	call flip_horizon
	ret
upside_down ENDP
; == upside_down ====================

; == set_grid_dimension =============
; TODO grid dimension
set_grid_dimension PROC USES eax ebx ecx edx edi esi,
	grid_x: DWORD,
	grid_y: DWORD

	.if select_grid == 0
		call restore_image
	.endif
	.if image_idx == 0
		mov esi, offset mImagePtr0
	.else
		mov esi, offset mImagePtr1
	.endif
	mov esi, offset mImagePtr0


	 mov ecx, 256
	L_GRID_X:
		cmp ecx, 1
		je L_GRID_X_FIRST
		cmp ecx, 255
		je L_GRID_X_FIRST
		.if grid_x == 4
			test ecx, 111111b
		.elseif grid_x == 8
			test ecx, 11111b
		.else
			test ecx, 1111111b
		.endif
		jne L_GRID_X_PASS
		L_GRID_X_FIRST:
		push ecx
		mov ecx, 256
		L_GRID_X_DRAW:
			mov BYTE PTR [esi], 255
			inc esi
			mov BYTE PTR [esi], 255
			inc esi
			mov BYTE PTR [esi], 255
			inc esi
			loop L_GRID_X_DRAW
			sub esi, 256*3
		pop ecx
		L_GRID_X_PASS:
		add esi, 256*3
		loop L_GRID_X

		mov esi, offset mImagePtr0
		mov ecx, 256
	 L_GRID_Y:
		 push ecx
		 mov ecx, 256
		 L_GRID_Y_C:
		 	 cmp ecx, 1
			 je L_GRID_Y_RIGHT
			 .if grid_y == 8
			 		test ecx, 11111b
			 .elseif grid_y == 4
			 		test ecx, 111111b
			 .else ; 2
			 		test ecx, 1111111b
			 .endif
			 jne L_GRID_Y_PASS
			 L_GRID_Y_RIGHT:
			 mov BYTE PTR [esi], 255
			 inc esi
			 mov BYTE PTR [esi], 255
			 inc esi
			 mov BYTE PTR [esi], 255
			 inc esi
			 sub esi, 3
		 L_GRID_Y_PASS:
		   add esi, 3
			 loop L_GRID_Y_C
		 pop ecx
		 loop L_GRID_Y


	ret
set_grid_dimension ENDP
; == set_grid_dimension =============

; == earse_grid =====================
; TODO earse grid
earse_grid PROC USES eax ebx ecx edx edi esi
	call restore_image
	ret
earse_grid ENDP
; == earse_grid =====================

; == hover_grid =====================
; TODO hover grid
hover_grid PROC USES eax ebx ecx edx edi esi

neg hover_color
mov esi, offset mImagePtr0
mov ecx, 256
L_DRAW_GRID:
 push ecx
 mov edx, ecx ; edx = y
 mov ecx, 256
 L_DRAW_GRID_C:
 	 ; ecx = x
	 mov eax, 256
	 sub eax, ecx
	 cmp eax, grid_left
	 je L_DRAW_GRID_COL
	 cmp eax, grid_left
	 jl L_DRAW_GRID_PASS
	 cmp eax, grid_right
	 je L_DRAW_GRID_COL
	 jg L_DRAW_GRID_PASS
	 jmp L_DRAW_GRID_ROW

	 L_DRAW_GRID_COL:
	 mov eax, 256
	 sub eax, edx
	 cmp eax, grid_top
	 jl L_DRAW_GRID_PASS
	 cmp eax, grid_bottom
	 jg L_DRAW_GRID_PASS
	 jmp L_DRAW_GRID_LINE

	 L_DRAW_GRID_ROW:
	 mov eax, 256
	 sub eax, edx
	 cmp eax, grid_top
 	 je L_DRAW_GRID_LINE
	 cmp eax, grid_bottom
	 je L_DRAW_GRID_LINE
	 jmp L_DRAW_GRID_PASS

	 L_DRAW_GRID_LINE:

	 mov BYTE PTR [esi], 255
	 inc esi
	 .if hover_color == 1
	 		mov BYTE PTR [esi], 255
	 .else
	    mov BYTE PTR [esi], 0
	 .endif
	 inc esi
	 mov BYTE PTR [esi], 0
	 inc esi
	 sub esi, 3
 L_DRAW_GRID_PASS:
	 add esi, 3
	 loop L_DRAW_GRID_C
 pop ecx
 dec ecx
 cmp ecx, 0
 jg L_DRAW_GRID

	ret
hover_grid ENDP

; == hover_grid =====================

; == draw_selected =====================
; TODO draw selected
draw_selected PROC USES eax ebx ecx edx edi esi

mov esi, offset mImagePtr0
mov ecx, 256
L_DRAW_SELECTED_GRID:
 push ecx
 mov edx, ecx ; edx = y
 mov ecx, 256
 L_DRAW_SELECTED_GRID_C:
 	 ; ecx = x
	 mov eax, 256
	 sub eax, ecx
	 cmp eax, selected_grid_left
	 je L_DRAW_SELECTED_GRID_COL
	 jl L_DRAW_SELECTED_GRID_PASS
	 cmp eax, selected_grid_right
	 je L_DRAW_SELECTED_GRID_COL
	 jg L_DRAW_SELECTED_GRID_PASS
	 jmp L_DRAW_SELECTED_GRID_ROW

	 L_DRAW_SELECTED_GRID_COL:
	 mov eax, 256
	 sub eax, edx
	 cmp eax, selected_grid_top
	 jl L_DRAW_SELECTED_GRID_PASS
	 cmp eax, selected_grid_bottom
	 jg L_DRAW_SELECTED_GRID_PASS
	 jmp L_DRAW_SELECTED_GRID_LINE

	 L_DRAW_SELECTED_GRID_ROW:
	 mov eax, 256
	 sub eax, edx
	 cmp eax, selected_grid_top
 	 je L_DRAW_SELECTED_GRID_LINE
	 cmp eax, selected_grid_bottom
	 je L_DRAW_SELECTED_GRID_LINE
	 jmp L_DRAW_SELECTED_GRID_PASS

	 L_DRAW_SELECTED_GRID_LINE:

	 mov BYTE PTR [esi], 255
	 inc esi
	 mov BYTE PTR [esi], 0
	 inc esi
	 mov BYTE PTR [esi], 0
	 inc esi
	 sub esi, 3
 L_DRAW_SELECTED_GRID_PASS:
	 add esi, 3
	 loop L_DRAW_SELECTED_GRID_C
 pop ecx
 dec ecx
 cmp ecx, 0
 jg L_DRAW_SELECTED_GRID

 mov eax, selected_grid_top
 mov prev_selected_grid_top, eax
 mov eax, selected_grid_bottom
 mov prev_selected_grid_bottom, eax
 mov eax, selected_grid_right
 mov prev_selected_grid_right, eax
 mov eax, selected_grid_left
 mov prev_selected_grid_left, eax

 call backup_image

	ret
draw_selected ENDP

; == draw_selected ==================

; == get_grid_range =================
; TODO get grid range
get_grid_range PROC USES eax ebx ecx edx edi esi
	cmp cur_grid_x, 8
	jne L_GET_GRID_X_4

	mov edx, 0
	mov eax, pos_x
	mov ebx, 100
	div ebx
	; eax = column
	mov ebx, 32
	mul ebx ; eax = column*100
	mov grid_left, eax
	.if select_grid == 1
		mov selected_grid_left, eax
	.endif
	add eax, 32
	; .if eax == 256
	; 	dec eax
	; .endif
	mov grid_right, eax
	.if select_grid == 1
		mov selected_grid_right, eax
	.endif
	jmp L_GET_GRID_Y

	L_GET_GRID_X_4:
	cmp cur_grid_x, 4
	jne L_GET_GRID_X_2
	mov edx, 0
	mov eax, pos_x
	mov ebx, 200
	div ebx
	; eax = column
	mov ebx, 64
	mul ebx ; eax = column*100
	mov grid_left, eax
	.if select_grid == 1
		mov selected_grid_left, eax
	.endif
	add eax, 64
	mov grid_right, eax
	; .if eax == 256
	; 	dec eax
	; .endif
	.if select_grid == 1
		mov selected_grid_right, eax
	.endif
	jmp L_GET_GRID_Y

	L_GET_GRID_X_2:
	mov edx, 0
	mov eax, pos_x
	mov ebx, 400
	div ebx
	; eax = column
	mov ebx, 128
	mul ebx ; eax = column*100
	mov grid_left, eax
	.if select_grid == 1
		mov selected_grid_left, eax
	.endif
	add eax, 128
	mov grid_right, eax
	; .if eax == 256
	; 	dec eax
	; .endif
	.if select_grid == 1
		mov selected_grid_right, eax
	.endif

	L_GET_GRID_Y:
	cmp cur_grid_y, 8
	jne L_GET_GRID_Y_4

	mov edx, 0
	mov eax, pos_y
	mov ebx, 100
	div ebx
	; eax = row
	mov ebx, 32
	mul ebx ; eax = column*100
	mov grid_top, eax
	.if select_grid == 1
		mov selected_grid_top, eax
	.endif
	add eax, 32
	; .if eax == 256
	; 	dec eax
	; .endif
	mov grid_bottom, eax
	.if select_grid == 1
		mov selected_grid_bottom, eax
	.endif
	jmp L_GET_GRID_QUIT

	L_GET_GRID_Y_4:
	cmp cur_grid_y, 4
	jne L_GET_GRID_Y_2

	mov edx, 0
	mov eax, pos_y
	mov ebx, 200
	div ebx
	; eax = row
	mov ebx, 64
	mul ebx ; eax = column*100
	mov grid_top, eax
	.if select_grid == 1
		mov selected_grid_top, eax
	.endif
	add eax, 64
	; .if eax == 256
	; 	dec eax
	; .endif
	mov grid_bottom, eax
	.if select_grid == 1
		mov selected_grid_bottom, eax
	.endif
	jmp L_GET_GRID_QUIT

	L_GET_GRID_Y_2:
	mov edx, 0
	mov eax, pos_y
	mov ebx, 400
	div ebx
	; eax = row
	mov ebx, 128
	mul ebx ; eax = column*100
	mov grid_top, eax
	.if select_grid == 1
		mov selected_grid_top, eax
	.endif
	add eax, 128
	; .if eax == 256
	; 	dec eax
	; .endif
	mov grid_bottom, eax
	.if select_grid == 1
		mov selected_grid_bottom, eax
	.endif

L_GET_GRID_QUIT:
	ret
get_grid_range ENDP
; == get_grid_range =================



; == mouse_coordinate_convert =======
mouse_coordinate_convert PROC USES eax ebx ecx edx edi esi
	ret
mouse_coordinate_convert ENDP
; == mouse_coordinate_convert =======

; == coordinate_mapping =============
; TODO coordinate mapping
coordinate_mapping PROC USES eax ebx ecx edx edi esi,
	row_pos: DWORD

	mov edx, 0
	mov eax, row_pos
	mov ebx, 800
	div ebx

	; eax = r (y)
	; edx = c (x)
	mov pos_x, edx
	mov pos_y, eax

	ret
coordinate_mapping ENDP
; == coordinate_mapping =============

; == save_selected ==================
; TODO save selected
save_selected PROC USES eax ebx ecx edx edi esi
mov esi, offset mImagePtr0
mov edi, offset mPrevSelectBuffer
mov ecx, 256
L_SAVE_SELECTED_GRID:
 push ecx
 mov edx, ecx ; edx = y
 mov ecx, 256
 L_SAVE_SELECTED_C:
 	 ; ecx = x
	 mov eax, 256
	 sub eax, ecx
	 cmp eax, selected_grid_left
	 jl L_SAVE_SELECTED_PASS
	 cmp eax, selected_grid_right
	 jge L_SAVE_SELECTED_PASS

	 mov eax, 256
	 sub eax, edx
	 cmp eax, selected_grid_top
	 jl L_SAVE_SELECTED_PASS
	 cmp eax, selected_grid_bottom
	 jge L_SAVE_SELECTED_PASS

	 mov al, BYTE PTR [esi]
	 mov BYTE PTR [edi], al
	 inc esi
	 inc edi
	 mov al, BYTE PTR [esi]
	 mov BYTE PTR [edi], al
	 inc esi
	 inc edi
	 mov al, BYTE PTR [esi]
	 mov BYTE PTR [edi], al
	 inc esi
	 inc edi
	 sub esi, 3
 L_SAVE_SELECTED_PASS:
	 add esi, 3
	 loop L_SAVE_SELECTED_C
 pop ecx
 dec ecx
 cmp ecx, 0
 jg L_SAVE_SELECTED_GRID

	ret
save_selected ENDP
; == save_selected ==================

; == swap ===========================
; TODO swap_buf
swap_buf PROC USES eax ebx ecx edx edi esi
	mov esi, offset mImagePtr0
	mov edi, offset mPrevSelectBuffer

	mov ecx, 256
	L_SWAP:
		push ecx
		mov edx, ecx
		mov ecx, 256
		L_SWAP_C:
		  mov eax, 256
		  sub eax, ecx
			.if swap_step == 0
		  	mov ebx, selected_grid_left
			.else
				mov ebx, prev_selected_grid_left
			.endif
			cmp eax, ebx
		  jl L_SWAP_PASS
			.if swap_step == 0
		  	mov ebx, selected_grid_right
			.else
				mov ebx, prev_selected_grid_right
			.endif
			cmp eax, ebx
		  jge L_SWAP_PASS

			mov eax, 256
	 	  sub eax, edx
			.if swap_step == 0
		  	mov ebx, selected_grid_top
			.else
				mov ebx, prev_selected_grid_top
			.endif
	 	  cmp eax, ebx
	 	  jl L_SWAP_PASS
			.if swap_step == 0
		  	mov ebx, selected_grid_bottom
			.else
				mov ebx, prev_selected_grid_bottom
			.endif
	 	  cmp eax, ebx
	 	  jge L_SWAP_PASS

			mov al, BYTE PTR [esi]
			mov ah, BYTE PTR [edi]
	 	  mov BYTE PTR [edi], al
			mov BYTE PTR [esi], ah
	 	  inc esi
	 	  inc edi
			mov al, BYTE PTR [esi]
			mov ah, BYTE PTR [edi]
	 	  mov BYTE PTR [edi], al
			mov BYTE PTR [esi], ah
	 	  inc esi
	 	  inc edi
			mov al, BYTE PTR [esi]
			mov ah, BYTE PTR [edi]
	 	  mov BYTE PTR [edi], al
			mov BYTE PTR [esi], ah
	 	  inc esi
	 	  inc edi
	 	  sub esi, 3
		L_SWAP_PASS:
			add esi, 3
			dec ecx
			cmp ecx, 0
			jg L_SWAP_C
		pop ecx
		dec ecx
		cmp ecx, 0
		jg L_SWAP

		ret
swap_buf ENDP
; == swap ===========================

END
