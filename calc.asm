; Calculator in x86_64 Linux Assembly
;
; Author: SnowzNZ
;

; aliases
SYS_READ    equ 0
SYS_WRITE   equ 1
SYS_EXIT    equ 60
STDIN       equ 0
STDOUT      equ 1

section .bss
    ; variables/buffers
    first_num_len equ 32
    first_num resb first_num_len

    option_len equ 2
    option resb option_len

    second_num_len equ 32
    second_num resb second_num_len

    result_len equ 1024
    result resb result_len

section .data
    ; constants
    ask_first_num db "First Number: "
    ask_first_num_len equ $-ask_first_num

    ask_option db "Add (1)", 0dh, 0ah, "Subtract (2)", 0dh, 0ah, "Multiply (3)", 0dh, 0ah, "Divide (4)", 0dh, 0ah, "Exit (5)", 0dh, 0ah
    ask_option_len equ $-ask_option

    ask_second_num db "Second Number: "
    ask_second_num_len equ $-ask_second_num

section .text
    global _start

    _start:
        ; ask for option
        mov rax, SYS_WRITE
        mov rdi, STDOUT
        mov rsi, ask_option
        mov rdx, ask_option_len
        syscall

        ; read option
        mov rax, SYS_READ
        mov rdi, STDIN
        mov rsi, option
        mov rdx, option_len
        syscall
        
        cmp byte [option], '1'
        je add_

        cmp byte [option], '5'
        je exit

    add_:
        ; ask for first number
        mov rax, SYS_WRITE
        mov rdi, STDOUT
        mov rsi, ask_first_num
        mov rdx, ask_first_num_len
        syscall

        ; read first number
        mov rax, SYS_READ
        mov rdi, STDIN
        mov rsi, first_num
        mov rdx, first_num_len
        syscall

        ; ask for second number
        mov rax, SYS_WRITE
        mov rdi, STDOUT
        mov rsi, ask_second_num
        mov rdx, ask_second_num_len
        syscall

        ; read second number
        mov rax, SYS_READ
        mov rdi, STDIN
        mov rsi, second_num
        mov rdx, second_num_len
        syscall

        ; convert ASCII to numerical values
        sub byte [first_num], '0'
        sub byte [second_num], '0'

        ; load numbers into registers
        mov al, [first_num]
        mov bl, [second_num]

        ; add the numbers together
        add al, bl

        ; store the result into result
        mov [result], al

        ; convert number back into ASCII
        add byte [result], '0'

        ; add new line to result
        mov byte [result + 1], 0ah

        ; print result
        mov rax, SYS_WRITE
        mov rdi, STDOUT
        mov rsi, result
        mov rdx, result_len
        syscall

    exit:
        mov rax, SYS_EXIT
        xor rdi, rdi
        syscall
