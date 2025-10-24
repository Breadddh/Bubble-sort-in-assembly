section .data

	loop_index db 0
	len db 1
	read_len db 2
	nl db 0xa
	nl_len equ $ - nl
	
section .bss

	array resb 5
	buffer resb 2

section .text
	
global _start
_start:

	input_loop:

		mov edi, buffer
		movzx esi, byte [read_len]
		call input

		xor ebx, ebx
		mov al, [buffer]
		mov bl, [loop_index]
		mov [array + ebx], al

	
		add bl, 1
		mov [loop_index], bl
		cmp bl, 5
		jl input_loop

	mov byte [loop_index], 0

	sort_loop:

		mov edx, 0
		
		inner_loop:

			mov al, [array + edx]
			mov bl, [array + edx + 1]
			
			cmp al, bl
			jl dont_swap
			
			mov byte [array + edx], bl
			mov byte [array + edx + 1], al

			dont_swap:

			inc edx
			cmp edx, 4
			jl inner_loop

		
		call check_sort
		cmp eax, 0
		je sort_loop

	print_loop:

		xor ebx, ebx
		mov bl, [loop_index]
		mov al, [array + ebx]
		mov [buffer], al
		mov edi, buffer
		movzx esi, byte [len]
		call print

		mov edi, nl
		mov esi, nl_len
		call print

		inc byte [loop_index]
		cmp byte [loop_index], 5
		jl print_loop
	
	mov eax, 1
	mov ebx, 0
	int 0x80

	
input:

	push ebp
	mov ebp, esp

	mov eax, 3
	mov ebx, 0
	mov ecx, edi
	mov edx, esi

	int 0x80

	mov esp, ebp
	pop ebp
	ret

print:
	push ebp
	mov ebp, esp

	mov eax, 4
	mov ebx, 1
	mov ecx, edi
	mov edx, esi

	int 0x80

	mov esp, ebp
	pop ebp
	ret

check_sort:

	push ebp
	mov ebp, esp

	mov ecx, 0
	jmp check_loop

	check_loop:

		mov al, [array + ecx]
		cmp al, [array + ecx + 1]
		jg return_false

		inc ecx
		cmp ecx, 4
		jl check_loop
	
	return_true:
		
		mov eax, 1

		mov esp, ebp
		pop ebp
		ret

	return_false:

		mov eax, 0
		
		mov esp, ebp
		pop ebp
		ret

