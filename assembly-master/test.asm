code segment		; @author Muhammed HALAS,Salih Ozcelik
startlabel:
mov bx,'!'			;dummy character to know stack's bottom
push bx 			;push it to stack
mov bx,0h 			;our current number is kept here( initially zero )
readachar:
mov ah,01h			;
int 21h				;	read a character
mov ah,0			;
isnumber:
	cmp ax,'0'		; not a number if lesser than ascii '0'
	jb isabcdef		; check if letter
	cmp ax,'9'		; not a number if greater than ascii '9'
	ja isabcdef		; check if letter
	sub ax,'0'		; lower it to its actual number value
	mov cx,ax		; save it
	mov ax,bx		; get current number
	mov dx,10h		; get 16
	mul dx			; multiply them
	add ax,cx		; add our new digit
	mov bx,ax		; put it back to where it will be kept (bx)
	jmp readachar	; read another character
isabcdef:
	cmp ax,'A'		; if it's not one of A,B,C,D,E 
	jb isampersand	; check if it's ampersand
	cmp ax,'F'		; if it's not one of A,B,C,D,E 
	ja isampersand	; check if it's ampersand
	sub ax,55		; it's value is it's 
	mov cx,ax		; ascii value - 'A' + 10 
	mov ax,bx		; get current integer
	mov bx,10h		; get 16
	mul bx			; multiply
	add ax,cx		; add new digit
	mov bx,ax		; save it to bx again
	jmp readachar	; read another character
isampersand:		
	cmp ax,'&'		; if not star
	jne isstar		; jump to check if amp.
	pop dx			; get last two integers from stack
	pop ax			; //
	and ax,dx		; do the operation
	push ax			; put the result back to stack
	jmp readachar	; read another one
isstar:
	cmp ax,'*'		; same procedure  
	jne isplus		; with above except
	pop ax			; do a multiplication 
	pop dx			; operation instead
	mul dx			; of and
	push ax			; put the value back
	jmp readachar	; read another char
isplus:
	cmp ax,'+'		; the
	jne isslash		; excact
	pop ax			; same 
	pop dx			; procedure 
	add ax,dx		; but with sum opration
	push ax			; put it back
	jmp readachar	; another one
isslash:
	cmp ax,'/'		; if not slash	
	jne iscaret		; skip.
	pop bx			; get the last
	pop ax			; two numbers
	div bx 			; do the op.
	push ax 		; put it to stack
	mov bx,0h 		; clear the reg for caution
	jmp readachar	; read a char again
iscaret:
	cmp ax,'^'		; if not ^ 
	jne isbar		; skip to next 
	pop dx			; get the last
	pop ax			; two integers
	xor ax,dx		; do the xor
	push ax			; save the value to stack
	jmp readachar	; read another char
isbar:
	cmp ax,'|'		; if not |
	jne isspace		; skip
	pop dx			; get last
	pop ax			; numbrs
	or ax,dx		; do the or 
	push ax			; save it 
	jmp readachar	; read another
isspace:
	cmp ax,32		; if not space 
	jne isenter 	; skip
	cmp bx,0h 		; IF THE LAST INPUT WAS NOT A NUMBER 
	je isenter		; SKIP THIS PART else:
	push bx			; push the number we just read to stack
	mov bx,0h 		; zero bx out for the next check
isenter:
	cmp ax,13		; if enter 
	je printresult	; print the result
	jmp readachar	; not a valid input read another char
printresult:
	mov dl,10 		; we tested in xp and it was writing 
	mov ah,02h 		; the output over the input so we print a
	int 21h 		; new line here new line char is 10.
	mov ax,0h 		; clear ax
	mov bx,10h   	; get 16
	pop ax 			; get the result from stack
stackdigit:
    mov dx,0h 		; dx <= 0
	cmp ax,bx 		; if number smaller than 16
	jb printlast 	; print it in hex
	div bx	 		; else: divide it by 16 and 
	push dx 		; put the remainder in stack
	jmp stackdigit 	; until number is smaller than 16
printlast:
	cmp al,10 		; if digit is numeric
	jb normaldigit 	; go to normal print else :(A,B,C,D,E,F) 
	add ax,55		; add 55.(10 becomes 'A' and so forth)
	mov dl,al 		; ready the char to print
	mov ah,02h		; ready print action 
	int 21h			; PRINT! (BRAVO!!)
	jmp printstack	; repeat until all digits are printed
normaldigit:
	add ax,'0' 		; '2' becomes 2 etc.
	mov dl,al 		; ready char
	mov ah,02h 		; ready print
	int 21h 		; do print
printstack:
	pop dx 			; pop a char from stack
	cmp dx,'!'		; if the stack is empty 
	je exitlabel 	; exit the program
	cmp dx,10 		; if it's numeric will add'0'
	jb regular 		; 
	add dx,55 		; else: add 55 ('A' is 65)
	jmp printit 	; skip to print
	regular: 		
	add dx,'0' 		; add '0' to make 1 into '1' etc.
	printit:
	mov ah,02h 		; ready
	int 21h 		; print 
 	jmp printstack	; repeat until stack empty
exitlabel:  		
int 20h 			; exit to dos 
code ends 