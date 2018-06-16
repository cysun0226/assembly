
TITLE tmp_test

include Irvine32.inc
include Macros.inc


rs = 5
nn TEXTEQU %(6*rs/2)

.data

v1 DWORD 12h, 10 dup(10h), 34h, 7fh
v2 DWORD ?
v3 DWORD ?
v4 DWORD 12345678h

w0 SBYTE 1, -1, 0fh
w1 BYTE "ABCD", 0abh, 0cdh
w2 WORD 5678h, 0ABh
w3 DWORD 23h, 456789abh

arr1 DWORD 1, 2, 3, 4, 5
arr2 DWORD 5 dup(?)

var1 DWORD 10
var2 DWORD 7

s = ($-var1)

rec PROTO,
n: DWORD,
b: PTR DWORD,
cc: PTR DWORD,
sign: DWORD

t_equ DWORD nn dup(?)

.code
main PROC
  ; mov eax, lengthof v1
  ; mov eax, TYPE v1
  ; mov v2, (lengthof v1)*TYPE v1
  ; mov eax, sizeof v1
  ; mov v3, (sizeof v1)/TYPE v1

  ; mov esi, offset v4
  ; mov al, [esi]
  ; mov bx, [esi]
  ; mov ecx, [esi]
  ; add esi, 2
  ; mov dl, [esi]

;   mov ecx, (sizeof w0) + (sizeof w1) + (sizeof w2) + (sizeof w3)
;   mov esi, offset w0
; L_loop:
;   mov al, BYTE PTR [esi]
;   inc esi
;   loop L_loop

  ; mov edi, 12345678h
  ; mov eax, edi
  ; mov bh, ah
  ; mov cl, al
  ; shr eax, 16

  ; mov ebx, 40
  ; mov ecx, 2
  ;
  ; shl ecx, 4
  ; mov eax, ebx
  ; sub eax, ecx
  ;
  ; mov eax, 16
  ; mov edx, 3
  ;
  ; shr eax, 3
  ; shl edx, 2
  ; add eax, edx
  ; shl eax, 4

  ; L1: mov ecx, lengthof arr1
  ; L2: mov esi, offset arr1
  ; L3: mov edi, offset arr2
  ; L4: cld
  ; L5: xor ebx, ebx
  ; L6: lodsd
  ; L7: imul eax
  ; L8: add ebx, eax
  ; L9: stosd
  ; L10: loop L6

  mov eax, lengthof t_equ
  mov eax, s
  mov eax, var1
  sub eax, var2
  imul eax

  exit
main ENDP

; int foo (int n, int *b, int *c, int sign) {
;   if (b[n] == 0) return (*c);
;   *c = (*c) + b[n] * sign;
;   sign *= -1;
;   return foo(n+1, b, c, sign);
; }

rec PROC,
n: DWORD,
b: PTR DWORD,
cc: PTR DWORD,
sign: DWORD

  mov eax, n
  shl eax, 2
  mov esi, b
  add esi, eax ; b[n]
  mov eax, [esi]
  .if eax == 0
    jmp L_ret_c
  .endif
  mov ebx, [cc]
  imul sign ; b[n]*sign
  add eax, ebx ; b[n]*sign + *c
  mov [cc], eax
  mov ebx, sign
  neg sign
  mov edx, n
  inc edx
  INVOKE rec, edx, b, cc, sign

L_ret_c:
  mov eax, [cc]
L_ret:
  ret
rec ENDP


end main
