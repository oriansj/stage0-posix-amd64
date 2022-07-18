;; Copyright (C) 2017 Jeremiah Orians
;; This file is part of stage0.
;;
;; stage0 is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; stage0 is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with stage0.  If not, see <http://www.gnu.org/licenses/>.

	section .text
	global _start

; Where the ELF Header is going to hit
; Simply jump to _start
; Our main function
_start:
	pop rax                     ; Get the number of arguments
	pop rdi                     ; Get the program name
	pop rdi                     ; Get the actual input name
	xor esi, esi                ; prepare read_only, rsi = 0
	push 2                      ; prepare syscall number
	pop rax                     ; the syscall number for open()
	syscall                     ; Now open that damn file
	mov r9, rax                 ; Preserve the file pointer we were given

	pop rdi                     ; Get the actual output name
	mov rsi, 577                ; Prepare file as O_WRONLY|O_CREAT|O_TRUNC
	mov rdx, 448                ; Prepare file as RWX for owner only (700 in octal)
	push 2                      ; prepare syscall number
	pop rax                     ; the syscall number for open()
	syscall                     ; Now open that damn file
	mov r10, rax                ; Preserve the file pointer we were given

	; Our flag for byte processing
	push -1
	pop r15                     ; r15 = -1

	; tmp storage for the sum
	xor r14d, r14d              ; r14 = 0

loop:
	; Read a byte
	call Read_byte

	; process byte
	call hex

	; Deal with -1 values
	test rax, rax
	jl loop

	; deal with toggle
	test r15, r15               ; jump if r15 >= 0
	jge print

	; process first byte of pair
	mov r14, rax
	xor r15d, r15d              ; r15 = 0
	jmp loop

; process second byte of pair
print:
	; update the sum and store in output
	shl r14, 4
	add rax, r14

	; flip the toggle
	push -1
	pop r15                     ; r15 = -1

	call write_byte

	jmp loop

hex:
	; Purge Comment Lines (#)
	cmp rax, 35
	je purge_comment

	; Purge Comment Lines (;)
	cmp rax, 59
	je purge_comment

	; deal all ascii less than 0
	cmp rax, 48
	jl ascii_other

	; deal with 0-9
	cmp rax, 58
	jl ascii_num

	; deal with all ascii less than A
	cmp rax, 65
	jl ascii_other

	; deal with A-F
	cmp rax, 71
	jl ascii_high

	;deal with all ascii less than a
	cmp rax, 97
	jl ascii_other

	;deal with a-f
	cmp rax, 103
	jl ascii_low

	; The rest that remains needs to be ignored
	jmp ascii_other

purge_comment:
	; Read a byte
	call Read_byte

	; Loop if not LF
	cmp rax, 10
	jne purge_comment

	; Otherwise return -1
	push -1
	pop rax                     ; rax = -1
	ret

ascii_num:
	sub rax, 48
	ret

ascii_low:
	sub rax, 87
	ret

ascii_high:
	sub rax, 55
	ret

ascii_other:
	push -1
	pop rax                     ; rax = -1
	ret

Done:
	; program completed Successfully
	xor edi, edi                ; All is well, rdi = 0
	push 60                     ; sycall number for exit is 60
	pop rax                     ; put the exit syscall number in eax
	syscall                     ; Call it a good day

; Writes byte stored in al
write_byte:
	; Print our Hex
	push 1                      ; prepare to set rdx to 1
	pop rdx                     ; set the size of chars we want
	push rax                    ; Move output to stack
	mov rsi, rsp                ; What we are writing
	mov rdi, r10                ; Where are we writing to
	push 1                      ; prepare syscall number for write
	pop rax                     ; get the syscall number for write
	syscall                     ; call the Kernel
	pop rbx                     ; deallocate stack
	ret

Read_byte:
	; Attempt to read 1 byte from STDIN
	push 1                      ; prepare to set rdx to 1
	pop rdx                     ; set the size of chars we want
	push rbx                    ; allocate stack
	mov rsi, rsp                ; Where to put it
	mov rdi, r9                 ; Where are we reading from
	xor eax, eax                ; the syscall number for read, rax = 0
	syscall                     ; call the Kernel

	test rax, rax               ; check what we got
	je Done                     ; Got EOF call it done

	; load byte
	pop rax                     ; load char
	ret


section .data
ELF_end:
