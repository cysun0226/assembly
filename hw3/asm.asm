
;========================================================
; Student Name: Chia-Yu, Sun
; Student ID: 0416045
; Email: cysun0226@gmail.com
;========================================================
; Prof. Sai-Keung WONG
; Email: cswingo@cs.nctu.edu.tw
; Room: EC706
; Assembly Language
; Date: 2018/04/15
;========================================================
; Description:
;
; IMPORTANT: always save EBX, EDX, EDI and ESI as their
; values are preserved by the callers in C calling convention.
;

INCLUDE Irvine32.inc
INCLUDE Macros.inc

invisibleDigitX  TEXTEQU %(-100000)
invisibleDigitY  TEXTEQU %(-100000)

MOVE_LEFT	= 0
MOVE_RIGHT	= 1
MOVE_UP		= 2
MOVE_DOWN	= 3
MOVE_STOP	= 4

MOVE_LEFT_KEY	= 'a'
MOVE_RIGHT_KEY	= 'd'
MOVE_UP_KEY		= 'w'
MOVE_DOWN_KEY	= 's'


; PROTO C is to make agreement on calling convention for INVOKE

c_updatePositionsOfAllObjects PROTO C

ShowSubRegionAtLoc PROTO,
	x : DWORD, y: DWORD, w : DWORD, h : DWORD, x0 : DWORD, y0 : DWORD

computeLocationOfPixelInImage PROTO,
	x0 : DWORD, y0 : DWORD, w : DWORD, h : DWORD

swapPickedGridCellandCurGridCellRegion PROTO

PROGRAM_STATE_PRE_START_GAME	= 0
PROGRAM_STATE_START_GAME		= 1
PROGRAM_STATE_PRE_PLAY_GAME		= 2
PROGRAM_STATE_PLAY_GAME			= 3
PROGRAM_STATE_PRE_END_GAME		= 4
PROGRAM_STATE_END_GAME			= 5


; LABEL .data

.data

colors BYTE 01ch
colorOriginal BYTE 01ch

MYINFO	BYTE "My Student Name: Chia-Yu, Sun; StudentID: 0416045",0

OpenMsgDelay	DWORD	25
EnterStageDelay	DWORD	50

MyMsg BYTE 0dh, 0ah, " == Assignment Three for Assembly Language == ", 0dh, 0ah, 0dh, 0ah
BYTE " Programmer Name : Chia-Yu, Sun", 0dh, 0ah
BYTE " Programmer ID   : 0416045", 0dh, 0ah
BYTE " Email Address   : cysun0226@gmail.com", 0dh, 0ah, 0dh, 0ah
BYTE " ( Make sure that the screen dimension is (120, 30). )", 0dh, 0ah, 0dh, 0ah
BYTE " Key usages:", 0dh, 0ah, 0dh, 0ah
BYTE "  'a': left, 'd': right, 'w': up, 's': down", 0dh, 0ah
BYTE "  'p': rainbow color " , 0dh, 0ah
BYTE "  'r': random color " , 0dh, 0ah
BYTE "  'c': clear " , 0dh, 0ah
BYTE "  'l': load " , 0dh, 0ah
BYTE "  'v': save " , 0dh, 0ah
BYTE "  spacebar : toggle grow / not grow", 0dh, 0ah
BYTE "  ESC : quit the program", 0dh, 0ah, 0dh, 0ah

BYTE " Mouse usages: ", 0dh, 0ah, 0dh, 0ah
BYTE "  passive mouse movement: show the mouse cursor", 0dh, 0ah
BYTE "  left mouse button: set target", 0dh, 0ah, 0dh, 0ah, 0

CaptionString BYTE "Student Name: Chia-Yu, Sun",0
MessageString BYTE "Welcome to Snake game", 0dh, 0ah, 0dh, 0ah
				BYTE "My Student ID is 0416045", 0dh, 0ah
				BYTE "My Email is: cysun0226@gmail.com", 0dh, 0ah, 0dh, 0ah
				BYTE "Control keys: ", 0dh, 0ah, 0dh, 0ah
				BYTE "  'a': left, 'd': right, 'w': up, 's': down", 0dh, 0ah
				BYTE "  'p': rainbow color " , 0dh, 0ah
				BYTE "  'r': random color " , 0dh, 0ah
				BYTE "  'c': clear " , 0dh, 0ah
				BYTE "  'l': load " , 0dh, 0ah
				BYTE "  'v': save " , 0dh, 0ah
				BYTE "  spacebar : toggle grow / not grow", 0dh, 0ah
				BYTE "  ESC : quit the program", 0dh, 0ah, 0dh, 0ah
				BYTE " Mouse usages: ", 0dh, 0ah, 0dh, 0ah
				BYTE "  passive mouse movement: show the mouse cursor", 0dh, 0ah
				BYTE "  left mouse button: set target", 0dh, 0ah, 0dh, 0ah
				BYTE "Enjoy playing!", 0

CaptionString_EndingMessage BYTE "Student Name: Chia-Yu, Sun",0
MessageString_EndingMessage BYTE "Thanks for playing...", 0dh, 0ah, 0dh, 0ah
				BYTE "My Student ID is 0416045", 0dh, 0ah, 0dh, 0ah
				BYTE "My Email is: cysun0226@gmail.com", 0dh, 0ah, 0dh, 0ah
				BYTE "See you!", 0

EndingMsg BYTE "Thanks for playing.", 0

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

mouseX		SDWORD 0	; mouse x-coordinate
mouseY		SDWORD 0	; mouse y-coordinate

maxNumSnakeObj	DWORD	1000
numSnakeObj	DWORD	1
snakeObjPosX SDWORD	1024 DUP(0)
snakeObjPosY SDWORD	1024 DUP(0)
snakeLife	DWORD	0
snakeLifeCycle	DWORD	25

cur_snakeObjPosX DWORD 0
cur_snakeObjPosY DWORD 0

default_snakeLifeCycle	DWORD 25

snakeSpeed				DWORD 100
Default_SnakeMaxSpeed	DWORD 200

snakeMoveDirection	DWORD	MOVE_RIGHT

flg_target	DWORD	0		; is the target set? true or false
target_x	DWORD	?		; target x-coordinate
target_y	DWORD	?		; target y-coordinate
flgQuit		DWORD	0
maxNumObjects	DWORD 512
numObjects	DWORD	300
objPosX		SDWORD	2048 DUP(0)
objPosY		SDWORD	2048 DUP(0)
objTypes	BYTE	2048 DUP(1)
objSpeedX	SDWORD	1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20
			SDWORD	2048 DUP(?)
objSpeedY	SDWORD	2, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20
			SDWORD	2048 DUP(?)
objColor	DWORD	0, 254, 254,
					254, 254, 254,
					0, 127, 0,
					2048*3 DUP(128)
studentObjColor	DWORD	1024 DUP(?)
goMsg		BYTE "I love assembly programming. Let's start...", 0
bell		BYTE 0,0, 0

testDBL	REAL4	3.141592654
zero REAL8 0.0

particleState BYTE 0
negOne REAL8 -1.0

openingMsg	BYTE	"This program allows a user to draw a picture using spheres......", 0dh
			BYTE	"Great programming.", 0
movementDIR	BYTE	0
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

				;x, y, width, height
mSubImage		DWORD	0, 0, 30, 30
mShowAtLocation	DWORD	30, 30
;
;

;width and height
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
FlgShowGrid			BYTE	0	;2
FlgYellowFlower		BYTE	0	;3
FlgBrigtenImage		BYTE	0	;4
FlgDarkenImage		BYTE	0	;5
FlgGrayLevelImage	BYTE	0	;6

programState		BYTE	0

; LABEL my var
IMAGE_HEIGHT	DWORD ?
IMAGE_WIDTH	DWORD ?

.code

; ===========================================
; void asm_ClearScreen()
;
; Clear the screen.
; We can set text color if you want.
; ===========================================
asm_ClearScreen PROC C
	mov al, 0
	mov ah, 0
	call SetTextColor
	call clrscr
	ret
asm_ClearScreen ENDP
; ===========================================

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void asm_ShowTitle()
;
;Show the title of the program
;at the beginning.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_ShowTitle PROC C USES edx
	mov dx, 0
	call GotoXY
	call resetColor
	mov edx, offset MyMsg
	call WriteString
	ret
asm_ShowTitle ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void asm_InitializeApp()
;
;This function is called
;at the beginning of the program.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_InitializeApp PROC C USES ebx edi esi edx
	call AskForInput_Initialization
	call initSnake
	ret
asm_InitializeApp ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void asm_EndingMessage()
;
;This function is called
;when the program exits.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_EndingMessage PROC C USES ebx edx
	mov ebx, OFFSET CaptionString_EndingMessage
	mov edx, OFFSET MessageString_EndingMessage
	call MsgBox
	ret
asm_EndingMessage ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void asm_updateSimulationNow()
;
;Update the simulation.
;For example,
;we can update the positions of the objects.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_updateSimulationNow PROC C USES edi esi ebx
	;
	call updateSnake
	;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;DO NOT REMOVE THE FOLLOWING LINE
	call c_updatePositionsOfAllObjects
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ret
asm_updateSimulationNow ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void setCursor(int x, int y)
;
;Set the position of the cursor
;in the console (text) window.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
setCursor PROC C USES edx,
	x:DWORD, y:DWORD
	mov edx, y
	shl edx, 8
	xor edx, x
	call Gotoxy
	ret
setCursor ENDP

; == asm_GetMouseXY =========================
; LABEL asm_GetMouseXY
; -------------------------------------------
; void asm_GetMouseXY(int &out_mouseX, int &out_mouseY)
;
; Get the mouse coordinates
;   out_mouseX = mouseX;	// or *out_mouseX = mouseX;
;   out_mouseY = mouseY;	// or *out_mouseY = mouseY;
; -------------------------------------------
asm_GetMouseXY PROC C USES edi,
	out_mouseX: PTR SDWORD, out_mouseY: PTR SDWORD
	;;;;;;;;;;;;;;;;;;;;;;;
	; TODO get mouse xy
	;;;;;;;;;;;;;;;;;;;;;;;
	mov eax, 250
	mov ebx, out_mouseX
	mov [ebx], eax
	mov ebx, out_mouseY
	mov [ebx], eax
	ret
asm_GetMouseXY ENDP
; == asm_GetMouseXY =========================

; == asm_GetTargetXY ========================
; LABEL asm_GetTargetXY
; -------------------------------------------
; bool asm_GetTargetXY(int &out_mouseX, int &out_mouseY)
;
; Get the target coordinates and also return a flag.
; Return true if the target is set and false otherwise.
;
; out_mouseX = target_x;	// or *out_mouseX = target_x
; out_mouseY = target_y;	// or *out_mouseY = target_y
;
; return flg_target
; -------------------------------------------
asm_GetTargetXY PROC C USES edi,
	out_mouseX: PTR SDWORD, out_mouseY: PTR SDWORD
	;;;;;;;;;;;;;;;;;;;;;;;
	; TODO get target xy
	;;;;;;;;;;;;;;;;;;;;;;;
	mov eax, 0
	ret
asm_GetTargetXY ENDP
; == asm_GetTargetXY ========================

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_GetNumParticles PROC C
	mov eax, numParticles
	ret
asm_GetNumParticles ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_GetParticleMaxSpeed PROC C
	mov eax, particleMaxSpeed
	ret
asm_GetParticleMaxSpeed ENDP

;
;int asm_GetParticleSize()
;
;Return the particle size.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_GetParticleSize PROC C
	;modify this procedure
	mov eax, 1
	ret
asm_GetParticleSize ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void asm_handleMousePassiveEvent( int x, int y )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	mov ebx, canvasMaxX
	sub ebx, canvasMinX
	mov eax, x
	mul ebx
	div windowWidth
	add eax, canvasMinX
	mov mouseX, eax
	;
	mov ebx, canvasMaxY
	sub ebx, canvasMinY
	mov eax, windowHeight
	sub eax, y
	mul ebx
	div windowHeight
	add eax, canvasMinY
	mov mouseY, eax
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	mov eax, windowHeight
	cdq
	mov ecx, GridDimensionH
	div ecx
	mov ebx, eax	; ebx = y

	mov eax, windowWidth
	cdq
	mov ecx, GridDimensionW
	div ecx			; eax = x

	mov ecx, eax
	mov eax, x
	cmp mFlipX, 0
	je L0
	mov edx, windowWidth
	sub edx, eax
	mov eax, edx
L0:
	cdq
	div ecx
	mov CurGridX, eax
	;
	mov ecx, ebx
	mov eax, y
;
	cmp mFlipY, 1
	je L1
	mov edx, windowHeight
	sub edx, eax
	mov eax, edx
;
L1:
	cdq
	div ecx
	mov CurGridY, eax

	ret
asm_handleMousePassiveEvent ENDP

; == asm_handleMouseEvent ===================
; LABEL asm_handleMouseEvent
; -------------------------------------------
; void asm_handleMouseEvent(int button, int status, int x, int y)
; -------------------------------------------
asm_handleMouseEvent PROC C USES ebx,
	button : DWORD, status : DWORD, x : DWORD, y : DWORD

	mWriteln "asm_handleMouseEvent"
	mov eax, button
	mWrite "button:"
	call WriteDec
	mWriteln " "
	mov eax, status
	mWrite "status:"
	call WriteDec
	mov eax, x
	mWriteln " "
	mWrite "x:"
	call WriteDec
	mWriteln " "
	mov eax, y
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
	;
	;mov flg_target, 0
	cmp button, 0
	jne exit0
	cmp status, 0
	jne exit0
	;
	mov flg_target, 1
	mov ebx, canvasMaxX
	sub ebx, canvasMinX
	mov eax, x
	mul ebx
	div windowWidth
	add eax, canvasMinX
	mov target_x, eax
	;
	mov ebx, canvasMaxY
	sub ebx, canvasMinY
	mov eax, windowHeight
	sub eax, y
	mul ebx
	div windowHeight
	add eax, canvasMinY
	mov target_y, eax
exit0:
	ret
asm_handleMouseEvent ENDP
; == asm_handleMouseEvent ===================

; == asm_HandleKey ==========================
; LABEL asm_HandleKey
; -------------------------------------------
; int asm_HandleKey(int key)
; Handle key events.
; Return 1 if the key has been handled.
; Return 0, otherwise.
; -------------------------------------------
asm_HandleKey PROC C,
	key : DWORD
	mov eax, key
	;;;;;;;;;;;;;;;;;;;;;;;
	; TODO Handle Key
	;;;;;;;;;;;;;;;;;;;;;;;
	ret
asm_HandleKey ENDP
; == asm_HandleKey ==========================

; ===========================================
; void asm_SetWindowDimension(int w, int h, int scaledWidth, int scaledHeight)
; -------------------------------------------
; w: window resolution (i.e. number of pixels) along the x-axis.
; h: window resolution (i.e. number of pixels) along the y-axis.
; scaledWidth : scaled up width
; scaledHeight : scaled up height
; -------------------------------------------
asm_SetWindowDimension PROC C USES ebx,
	w: DWORD, h: DWORD, scaledWidth : DWORD, scaledHeight : DWORD
	mov ebx, offset windowWidth
	mov eax, w
	mov [ebx], eax
	mov eax, scaledWidth
	shr eax, 1	; divide by 2, i.e. eax = eax/2
	mov ebx, offset canvasMaxX
	mov [ebx], eax
	neg eax
	mov ebx, offset canvasMinX
	mov [ebx], eax
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	mov ebx, offset windowHeight
	mov eax, h
	mov [ebx], eax
	mov eax, scaledHeight
	shr eax, 1	; divide by 2, i.e. eax = eax/2
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
;	call asm_ComputeGridCellDimension
	ret
asm_SetWindowDimension ENDP
; ===========================================


; == asm_GetNumOfObjects ====================
; LABEL asm_GetNumOfObjects
; -------------------------------------------
; int asm_GetNumOfObjects()
; Return the number of objects
; -------------------------------------------
asm_GetNumOfObjects PROC C
	;mov eax, maxNumObjects
	;;;;;;;;;;;;;;;;;;;;;;;
	; TODO Get Num Of Objects
	;;;;;;;;;;;;;;;;;;;;;;;
	mov eax, 1
	ret
asm_GetNumOfObjects ENDP
; == asm_GetNumOfObjects ====================


; ===========================================
; int asm_GetObjectType(int objID)
; Return the object type
; ===========================================
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
; ===========================================


; == asm_GetObjectColor =====================
; LABEL asm_GetObjectColor
; -------------------------------------------
; void asm_GetObjectColor (int &r, int &g, int &b, int objID)
; Input : objID, the ID of the object
; Return: the color three color components
;         red, green and blue.
; -------------------------------------------
asm_GetObjectColor  PROC C USES ebx edi esi,
	r: PTR DWORD, g: PTR DWORD, b: PTR DWORD, objID: DWORD
	;;;;;;;;;;;;;;;;;;;;;;;
	; TODO Get Obj Color
	;;;;;;;;;;;;;;;;;;;;;;;
	mov ebx, r
	mov eax, 255
	mov [ebx], eax
	ret
asm_GetObjectColor ENDP
; == asm_GetObjectColor =====================

; ===========================================
; int asm_ComputeRotationAngle(a, b)
; return an angle*10.
; ===========================================
asm_ComputeRotationAngle PROC C USES ebx,
	a: DWORD, b: DWORD
	mov ebx, b
	shl ebx, 1
	mov eax, a
	add eax, 10
	ret
asm_ComputeRotationAngle ENDP
; ===========================================


; == asm_ComputeObjPositionX ================
; LABEL asm_ComputeObjPositionX
; -------------------------------------------
; int asm_ComputeObjPositionY(int x, int objID)
; Return the x-coordinate.
; -------------------------------------------
asm_ComputeObjPositionX PROC C USES edi esi,
	x: DWORD, objID: DWORD
	;;;;;;;;;;;;;;;;;;;;;;;
	; TODO Obj Position X
	;;;;;;;;;;;;;;;;;;;;;;;
	mov eax, 0
	ret
asm_ComputeObjPositionX ENDP
; == asm_ComputeObjPositionX ================

; == asm_ComputeObjPositionY ================
; LABEL asm_ComputeObjPositionY
; -------------------------------------------
; int asm_ComputeObjPositionY(int y, int objID)
; Return the y-coordinate.
; -------------------------------------------
asm_ComputeObjPositionY PROC C USES ebx esi edx,
	y: DWORD, objID: DWORD
	;;;;;;;;;;;;;;;;;;;;;;;
	; TODO Obj Position Y
	;;;;;;;;;;;;;;;;;;;;;;;
	mov eax, 0
	ret
asm_ComputeObjPositionY ENDP
; == asm_ComputeObjPositionY ================

ASM_setText PROC C
	;mov al, 0e1h
	mov al, 01eh
	call SetTextColor
	ret
ASM_setText ENDP

asm_ComputeParticlePosX PROC C,
xPtr : PTR REAL8
ret
asm_ComputeParticlePosX ENDP

asm_ComputeParticlePosY PROC C,
x : DWORD, yPtr : PTR REAL8, yVelocityPtr : PTR REAL8
ret
asm_ComputeParticlePosY ENDP

; == asm_SetImageInfo =======================
; LABEL asm_SetImageInfo
; -------------------------------------------
; void asm_SetImageInfo(
;		int imageindex,
;		char *imagePtr,
;		unsigned int w, // width
;		unsigned int h, // height
;		unsigned int bytesPerPixel
; )
; Assume bytesPerPixel = 3
; Save the image to a buffer, e.g., mImagePtr0
; The buffer must be large enough to store all the bytes
; Set mImageWidth and mImageHeight.
; -------------------------------------------
asm_SetImageInfo PROC C USES esi edi ebx,
	imageIndex : DWORD,
	imagePtr : PTR BYTE, w : DWORD, h : DWORD,
	bytesPerPixel : DWORD

	; CHANGED Set Image Info

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

	call waitKey

	ret
asm_SetImageInfo ENDP
; == asm_SetImageInfo =======================

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

; == asm_GetImageColour =====================
; LABEL asm_GetImageColour
; -------------------------------------------
; asm_GetImageColour(int imageIndex, int ix, int iy, int &r, int &g, int &b)
; -------------------------------------------
asm_GetImageColour PROC C USES ebx esi,
	imageIndex : DWORD,
	ix: DWORD, iy : DWORD,
	r: PTR DWORD, g: PTR DWORD, b: PTR DWORD

	; TODO Get Image Colour
	mov ebx, mImageWidth; index = iy*w + ix
	mov eax, iy
	mov edx, mImageHeight
	sub edx, eax
	mov eax, edx
	mul ebx ; eax = iy*w
	mov ebx, ix
	add eax, ebx ; eax = iy*w + ix
	; call WriteHex
	; call Crlf
	; call waitKey
	mov ebx, 3
	mul ebx ; eax = 3* (iy*w + ix)

	mov esi, eax
	mov ebx, offset mImagePtr0
	add esi, ebx

	; mov eax, 255
	mov ebx, r
	mov al, BYTE PTR [esi]
	mov BYTE PTR [ebx], al
	; call WriteHex
	; mWrite " "

	; mov eax, 50
	inc esi
	mov ebx, g
	mov al, BYTE PTR [esi]
	mov BYTE PTR [ebx], al
	; call WriteHex
	; mWrite " "

	; mov eax, 255
	inc esi
	mov al, BYTE PTR [esi]
	mov ebx, b
	mov BYTE PTR [ebx], al
	; call WriteHex
	; call Crlf

	ret
asm_GetImageColour ENDP
; == asm_GetImageColour =====================


; == asm_getStudentInfoString ===============
; LABEL asm_getStudentInfoString
; -------------------------------------------
; const char *asm_getStudentInfoString()
; return pointer in eax
; -------------------------------------------
asm_getStudentInfoString PROC C
	mov eax, offset MYINFO
	ret
asm_getStudentInfoString ENDP
; == asm_getStudentInfoString ===============


; == asm_GetImageDimension ==================
; LABEL asm_GetImageDimension
; -------------------------------------------
; void asm_GetImageDimension(int &iw, int &ih)
; iw : mImageWidth
; ih : mImageHeight
; -------------------------------------------
asm_GetImageDimension PROC C USES ebx,
iw : PTR DWORD, ih : PTR DWORD
	; DONE Get Image Dimension
	mov ebx, iw
	mov eax, mImageWidth
	mov [ebx], eax
	mov ebx, ih
	mov eax, mImageHeight
	mov [ebx], eax
	ret
asm_GetImageDimension ENDP
; == asm_GetImageDimension ==================

; == asm_GetImagePos ========================
; LABEL asm_GetImagePos
; -------------------------------------------
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
; == asm_GetImagePos ========================

; == AskForInput_Initialization =============
; LABEL AskForInput_Initialization
; -------------------------------------------
AskForInput_Initialization PROC USES ebx edi esi
	; DONE Ask For Input Init
	mWrite " Initialization setting: "
	call Crlf
	call Crlf
	mWrite "  ( If the user does not input anything,"
	call Crlf
	mWrite "    the program will use the default value. )"
	call Crlf
	mWrite "  > please input snake speed: "
	call readInt
	.if eax == 0
	mov snakeSpeed, 100
	.else
	mov snakeSpeed, eax
	.endif

	mWrite "  > please input snake life cycle: "
	call readInt
	.if eax == 0
	mov snakeLifeCycle, 25
	.else
	mov snakeLifeCycle, eax
	.endif

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
AskForInput_Initialization ENDP
; == AskForInput_Initialization ============

; == initSnake =============================
; LABEL initSnake
; -------------------------------------------
initSnake PROC USES ebx edi esi
	; TODO initSnake
	ret
initSnake ENDP
; == initSnake =============================

; == updateSnake ===========================
; LABEL updateSnake
; -------------------------------------------
updateSnake PROC USES ebx edx edi esi
	; TODO updateSnake
	ret
updateSnake ENDP
; == updateSnake ===========================

; =================================================================
; LABEL my functions
; =================================================================

; == restore color ==========================
resetColor PROC
	mov eax, 00001111b ; black background, white text
	call SetTextColor
	ret
resetColor ENDP
; == restore color ==========================

; == get key ================================
; NOTE get_key
; parameters: the result of key will store in al
; -------------------------------------------
getKey PROC
L_wait_key:
	mov eax, 50
	call Delay
	call ReadKey
	jz L_wait_key
	ret
getKey ENDP
; == get key =================================

; == set background color ====================
; calling-request: put color into eax.
; -------------------------------------------
setBackgroundColor PROC
	shl eax, 4
	call SetTextColor
	ret
setBackgroundColor ENDP
; == set background color ====================

; == waitKey =====================
waitKey PROC USES eax edx
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




END
