
TITLE fac

include Irvine32.inc
include Macros.inc

.data
arr DWORD 1, 2, 3, 4, 5, 6

fac PROTO,
array: PTR DWORD,
n: DWORD

.code
main PROC
  mWrite "Input n: "
  call ReadInt
  call Crlf
  call Crlf
  mov ebx, eax

  mWrite "n! = "
  mov edx, offset arr
  INVOKE fac, edx, ebx
  call WriteInt

  exit
main ENDP


fac PROC,
	array: PTR DWORD,
	n: DWORD

  .if n <= 0
    jmp L_ret_a0
  .endif

  ; ecx = a[n]*factorial(a, n-1)
  ; eax = factorial(a, n-1)
  mov esi, array
  mov ebx, n
  dec ebx
  INVOKE fac, array, ebx
  ; eax = factorial(a, n-1)
  mov ebx, eax
  mov ecx, 4
  mov eax, n
  mul ecx ; eax = n*4
  add eax, esi

  ; ecx = a[n]
  mov ecx, DWORD PTR [eax]
  mov eax, ebx
  mul ecx
  jmp L_ret

  L_ret_a0:
    mov eax, DWORD PTR [esi]
  L_ret:
    ret
fac ENDP

end main
