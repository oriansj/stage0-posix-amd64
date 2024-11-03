# SPDX-FileCopyrightText: 2017 Jeremiah Orians <jeremiah@pdp10.guru>
# SPDX-FileCopyrightText: 2023 Andrius Štikonas <andrius@stikonas.eu>
#
# SPDX-License-Identifier: GPL-3.0-or-later

.intel_syntax noprefix
.global _start
.text

# Where the ELF Header is going to hit
# Simply jump to _start
# Our main function
_start:
	pop rax                     # Get the number of arguments
	pop rdi                     # Get the program name
	pop rdi                     # Get the actual input name
	xor esi, esi                # prepare read_only, rsi = 0
	push 2                      # prepare syscall number
	pop rax                     # the syscall number for open()
	cdq                         # Extra sure, rdx = 0
	syscall                     # Now open that damn file
	pop rdi                     # Get the actual output name
	push rax                    # Preserve the file pointer we were given
	mov si, 577                 # Prepare file as O_WRONLY|O_CREAT|O_TRUNC
	mov dx, 448                 # Prepare file as RWX for owner only (700 in octal)
	push 2                      # prepare syscall number
	pop rax                     # the syscall number for open()
	syscall                     # Now open that damn file
	xchg ebx, eax               # Preserve the file pointer we were given
	cdq                         # rdx = 0 since file descriptor is nonnegative
	inc edx                     # rdx = 1 (count for read/write)

loop_reset_all:
	xor ebp, ebp                # ebp = 0 (no prior hex val)

# Comment tracking is done with ecx.
# ecx is decremented if we hit a
# comment (';' or '#') and reset
# if we hit a new-line.
loop_reset_comment:
	push rdx
	pop rcx                     # Set no current comment
loop_add_comment:
	dec ecx
loop:

	# Read a byte
	pop rdi                     # Get infile
	push rsp
	pop rsi                     # Set buffer
	# rdx is already set to 1.
	xor eax, eax                # Set read syscall in rax
	push rcx                    # Save comment tracking
	syscall                     # Do the actual read
	pop rcx                     # Restore comment tracking
	push rdi                    # Re-save infile
	test eax, eax               # Check what we got
	jne cont                    # No EOF

	# Exit successfully
	mov al, 60                  # Set exit syscall in rax
	xor edi, edi                # Set return success (rdi = 0)
	syscall                     # Exit

cont:
	mov al,[rsi]                # Move prog byte in eax

	# New line check
	cmp al, 10                  # Check new-line
	je loop_reset_comment       # If new-line, end comment handling

	# In comment check
	test ecx, ecx               # Skip byte if we are in a comment
	jne loop

	# Start comment check
	cmp al, 35                  # Start of '#' comment
	je loop_add_comment

	cmp al, 59                  # Start of ';' comment
	je loop_add_comment

	# Start of hex str to int
	sub al, 48                  # Subtract ascii '0' from al
	sub al, 10                  # Check for value in '0'-'9'
	jb write                    # We have hex value, write it

	sub al, 7                   # Subtract ('A'-'0') from al
	and al, ~32                 # Remove lower case bit
	cmp al, 7                   # Check for value 'A'-'F'
	jae loop                    # We have hex value, write it

write:
	shl ebp, 4                  # Shift up existing hex digit
	add al, 10                  # Finish converting ascii to raw value
	add ebp, eax                # Combine the hex digits

	# Check if this is first digit in hex val
	neg ebx                     # Flip sign of r10 to indicate we got a digit
	jl loop                     # Negative -> first digit, get another one

	# We have both digits in low byte of ebp, good to write
	mov [rsi], ebp              # Move edge to buffer
	mov edi, ebx                # Move outfile to rdi
	mov al, 1                   # Set write syscall in rax
	syscall                     # Do the write
	jmp loop_reset_all          # Start a fresh byte
ELF_end:
