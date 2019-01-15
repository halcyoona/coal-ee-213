;program to print Hello world on screen at desired location using string instruction


[org 0x0100]

	jmp	start

message:	db 'Hello World',0		;null terminated string

;sub routine to clear the screen
clrscr:
			push es
			push ax
			push cx
			push di



			mov ax, 0xb800				;load video base in ax
			mov es, ax					;point es to video base
			mov di, di					;point di to top left column

			mov ax, 0x0720				;clear next char on screen
			mov cx, 2000				;number of screen location
			cld							;auto increment mode
			rep stow

			pop di
			pop ax
			pop cx
			pop es
			ret


;subroutine to print the a string at the top left corner
;takes address of the string 
;and also x position and y position and attribute as a parameter

printstr:
				push bp
				mov bp, sp
				push es
				push ax
				push cx
				push si
				push di


				push ds
				pop es						;load ds in es
				mov di, [bp+4]				;point di to string
				mov cx, 0xffff				;load maximum number in cx
				xor al, al 					;load zero in al
				repne scansb				;find zero in the string
				mov ax, 0xffff 				;load maximum number in ax
				sub ax, cx					;find change in cx
				dec ax						;exclude null from length
				jz exit						;no printing if the string is empty

				mov cx, ax
				mov ax, 0xb800				;load video base in ax
				mov es, ax					;point es to video base
				mov al, 80					;load al with column per row
				mul byte [bp+8]				;multiply with y position
				add ax, [bp+10]				;add x position
				shl ax, 1					;turn into byte offset
				mov di, ax					;point di to required location
				mov si, [bp+4]				;point si to string
				mov cx, 					;load length of the string in cx
				mov ah, [bp+6] 				;normal attribute fixed in al

				cld							;auto increment mode
nextchar:		lodsb						;load next char in al
				stosw						;print char/attribute pair
				loop nextchar				;repeat the operation cx times

exit:
				pop di
				pop si
				pop cx
				pop ax
				pop es
				pop bp
				ret 8


start:
				call clrscr

				mov ax, 30					
				push ax						;push x position
				mov ax, 20					
				push ax						;push y position
				mov ax, 1					;blue on black attribute
				push ax						;push attribute

				mov ax, message
				push ax						;push string address
				
				call printstr 				;call the print subroutine


				mov ax, 0x4c00				;terminate program
				int 0x21