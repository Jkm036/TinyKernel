ORG 0
;; loading adress for operating systems 
BITS 16
_start:
    jmp short start
    nop
times 33 db 0 ; certain computers require this of bootloaders
start:
    jmp 0x7c0:start_program ; ensure code segment is set to 0x7c0 segment:offset
start_program:
    cli ;clear interrupts
    mov ax, 0x7c0  ; setting segments 
    mov ds, ax     ; data segment
    mov es, ax     ; extra segment
    mov ax, 0x00 
    mov ss, ax     ; stack segment
    mov sp, 0x7c00 ; stack offset
    sti            ; enables interrupts
    ;----------------------------------------------------------------------


    mov ah, 2       ; read sector command
    mov al, 1       ; reading one sctor
    mov ch, 0       ; cylinder low 8 bits
    mov cl, 2       ; read cylinder 2 (1-indexed)
    mov dh, 0       ; Head number
    mov bx, buffer  ; must be where we write the memory to
    int 0x13        ; interupt for reading form a disk
    jc error
    
    mov si, buffer
    call print
    jmp $
    
error:
mov si, error_message
call print
jmp$

print:
mov bx, 0
.loop:
lodsb
cmp al, 0
je .done
call print_char
jmp .loop
.done:
ret
print_char: 
    mov ah, 0eh
    int 0x10
    ret

error_message: db 'Failed'
times 510-($-$$) db 0
dw 0xAA55

buffer:
