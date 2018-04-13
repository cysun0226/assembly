TITLE Bouncing Ball                          (bouncingBall.asm)

COMMENT !---------------------------------------------------------

Write a program that simulates a ball bouncing within a rectangle. Your
rectangle will be the size of the standard MS-DOS screen: 25 rows by 80
columns (X = 0-79, and Y = 0-24). The rectangle should contain an internal
vertical wall consisting of a single column of block characters (ASCII code
0DBh) starting at row 5, column 40, extending down to row 19, column 40.
The background should be blue, and the wall and ball should be white.

The ball travels at a constant speed, determined by a delay value of 20
milliseconds inside the loop that displays, erases, and moves the ball. The
following sequence of actions will be in the loop:

	display, delay, erase, move

The ball is just a single character, drawn with the ASCII code 2. To 'move'
the ball, you write over it with a blank, move the cursor position to a new
location, and redraw the ball. The ball can only move 1 row and 1 column
during each loop cycle. You will need to call the following library procedures:
Clrscr, Delay, SetTextColor, WriteChar, and Gotoxy. You will (probably) need
to use the high-level .IF, .ELSE, and .ENDIF directives explained at the end
of Chapter 6.

Suggested Algorithm:

Suppose you have a current location (X, Y), and two direction values, dX,
and dY. The latter control the ball's movement. For example, if dX =1 and
dY = 1, the ball is moving downward and to the right.

Evaluate the potential new X and Y location:
1. If the new location is outside the rectangle's X and Y coordinates, reverse
the ball's direction by negating dX or dY, whichever is appropriate.
2. If the new location is in the middle of the vertical wall, negate dX.
3. If the new location is either the top or the bottom of the vertical wall,
negate dY.

Next, add dX and dY to your current X and Y coordinates, generating
the ball's new location. Redraw the ball at this new location.

-------------------- (end comment)--------------------------------!

; Solution program.
; Original by Alejandro Presto - Feb 2003
; Version 2, Gerald. Cahill
; Version 3, Kip. Irvine (2/17/2003)

INCLUDE Irvine32.inc

; dl = current x
; dh = current y

; bl = next x
; bh = next y

ball = 2     	;a happy face (1) looks good too.
drawDelay = 20 	;milliseconds between redrawing the ball

; Define the wall
wallTop = 5      	;top row number
wallBottom = 19  	;bottom row number
wall_X = 40      	;x position (column number)

; Define the window size
xmin = 0         	;left edge
xmax = 79        	;right edge
ymin = 0         	;top
ymax = 24        	;bottom

.data
ddx BYTE 1     	;x increment per iteration
ddy BYTE 1     	;y increment per iteration
greeting   BYTE "DEMO program for Bouncing Ball",0dh,0ah,
	"Close the window to end the program",0dh,0ah,0

.code

main PROC
;---------- intro stuff, just for my demo
	call Clrscr
	mov  edx,offset greeting
	call WriteString
	call WaitMsg
	call Clrscr

; PROGRAM STARTS HERE
;---------------------------------------------------------------
 	mov eax,white + (blue * 16)
 	call SetTextColor
 	call Clrscr

;----- hides the cursor ----------------------------------------
.data
cursorInfo CONSOLE_CURSOR_INFO <>
outHandle  DWORD ?
.code
	INVOKE GetStdHandle, STD_OUTPUT_HANDLE
	mov  outHandle,eax
	INVOKE GetConsoleCursorInfo, outHandle, ADDR cursorInfo
	mov  cursorInfo.bVisible,0
	INVOKE SetConsoleCursorInfo, outHandle, ADDR cursorInfo
;---------------------------------------------------------------

;------ Draw the Wall ----------------------------------------
; from (40,5) -- to (40,19)

	mov  dl,wall_X
	mov  dh,wallTop
	mov  ecx,wallBottom - wallTop + 1
	mov  al,0DBh	; solid block character

DrawWall:
	call Gotoxy
	call WriteChar
	inc  dh
	loop DrawWall
;-------------------------------------------------------------


	mov dl,21          ;Initial value for X ball coordinate
	mov dh,8           ;Initial value for Y ball coordinate

loop1:                     ;Infinite loop ball moving

	mov bl,dl
	add bl,ddx         ;get potential next x
	mov bh,dh
	add bh,ddy         ;get potential next y

	.IF bl != wall_X || bh < wallTop || bh > wallBottom
	  jmp Check_rectangle_boundaries
	.ENDIF

	; striking the top or bottom of the wall?
	.IF bh == wallTop || bh == wallBottom
	  neg ddy
	  jmp redraw
	.ELSE	; striking the middle of the wall
	  neg ddx
	  jmp redraw
	.ENDIF

Check_rectangle_boundaries:
	.IF bl < xmin || bl > xmax
	  neg ddx
	.ENDIF

	.IF bh < ymin || bh > ymax
	  neg ddy
	.ENDIF

redraw:
	call Gotoxy        	;erase the ball
	mov  al,' '
	call WriteChar

	add  dl,ddx         	;get new x
	add  dh,ddy         	;get new y

	call Gotoxy        	;print the ball
	mov  al,ball
	call WriteChar

	mov  eax,drawDelay  	;delay
	call Delay

	jmp  loop1

;------------------------------------------

main ENDP

END main
