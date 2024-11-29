.MODEL SMALL
.STACK 100h

.DATA
operand1 DB ?
operand2 DB ?
result DB ?
operator DB ?
divisor DB ?
msg1 DB "Enter the first operand: $"
msg2 DB "Enter the second operand: $"
msg3 DB "Enter the operator (+, -, *, /): $"
msg4 DB "I can't divide by zero. I Quit.$"

.CODE
MAIN PROC

    MOV AX, @DATA
    MOV DS, AX
    
    ; Input first operand
    MOV AH, 09h
    LEA DX, msg1
    INT 21h
    
    ; Read first operand
    MOV AH, 01h
    INT 21h
    SUB AL, '0'
    MOV operand1, AL
    
    ; Input second operand
    MOV AH, 09h
    LEA DX, msg2
    INT 21h
    
    ; Read second operand
    MOV AH, 01h
    INT 21h
    SUB AL, '0'
    MOV operand2, AL
    
    ; Input operator
    MOV AH, 09h
    LEA DX, msg3
    INT 21h
    
    ; Read operator
    MOV AH, 01h
    INT 21h
    MOV operator, AL
    
    ; Perform calculation based on operator
    CMP operator, '+'
    JE ADDITION
    CMP operator, '-'
    JE SUBTRACTION
    CMP operator, '*'
    JE MULTIPLICATION
    CMP operator, '/'
    JE DIVISION
    
    ; Invalid operator
    MOV AH, 09h
    LEA DX, msg4
    INT 21h
    JMP END_PROGRAM
    
ADDITION:
    MOV AL, operand1
    ADD AL, operand2
    MOV result, AL
    JMP DISPLAY_RESULT

SUBTRACTION:
    MOV AL, operand1
    SUB AL, operand2
    MOV result, AL
    JMP DISPLAY_RESULT

MULTIPLICATION:
    MOV AL, operand1
    MOV BL, operand2
    MUL BL
    MOV result, AL
    JMP DISPLAY_RESULT

DIVISION:
    MOV AL, operand1
    MOV BL, operand2
    CMP BL, 0
    JE HANDLE_ZERO_DIVISION
    DIV BL
    MOV result, AL
    JMP DISPLAY_RESULT

HANDLE_ZERO_DIVISION:
    
    mov ax, 0       
    mov es, ax

    mov al, 60h    

    mov bl, 4h       
    mul bl          
    mov bx, ax

    mov si, offset [ZERO_DIVISION_MSG]
    mov es:[bx], si
    add bx, 2   
    
    mov ax, cs     
    mov es:[bx], ax
         

    int 60h    ;
    
    JMP END_PROGRAM

ZERO_DIVISION_MSG:
    ; Display error message
    MOV AH, 09h
    LEA DX, msg4
    INT 21h
    jmp END_PROGRAM

DISPLAY_RESULT:
    ; Display result
    ADD result, '0'
    MOV DL, result
    MOV AH, 02h
    INT 21h

END_PROGRAM:
    MOV AH, 4Ch
    INT 21h
    
MAIN ENDP

END MAIN