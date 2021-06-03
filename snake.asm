org 0x100
jmp start
;---------------------------------------
snakePreserve: dw 1040,1038,1036,1034,1032,1030,1028,1026,1024,1022,1020,1018,1016,1014,1012,1010,1008,1006,1004,1002
			times 220 dw 0;the full length of the snake

snake: 		dw 1040,1038,1036,1034,1032,1030,1028,1026,1024,1022,1020,1018,1016,1014,1012,1010,1008,1006,1004,1002
			times 220 dw 0;the full length of the snake
sizesnake:	dw 20
sizecounter: dw 0
time: dw 0
time2: dw 0
smoothnes: dw 0
timecounter: db 0
snakecounter: db 0
Ssnake: db 'SSSSSSnake'
printTime: db 'time:'
printScore: db 'score:'
winGame: db 'Yay You Won'
endGame: db 'Game Over' ; all these end atributess are used in game over sub
endScore:db 'Your Score:'
endTime:db 'Your Time:'
speed: db 10;initial speed in 100 seconds you acheive maximum speed
movementflag: dw 2
fruit: dw 0
fruitvalue:	dw 0
fruit1: dw 0
fruit2: dw 0
fruitflag: dw 0
randRow: dw 9
randCol: dw 37
m1: dw 19
a1: dw 5
c1: dw 4
seed1: dw 9
m2: dw 72
a2: dw 13
c2: dw 11
seed2: dw 37
level: dw 0
level1: 
		dw	2458,2460,2462,2464,2466,2468,2470,2472,2474,2476,2478,2480,2482,2484,2486,2488
		dw	2490,2492,2494,2496,2498,2500,2502,2504,2506
		dw	2298,2138,1978,1818
		dw	2346,2186,2026,1866
		dw	1820,1822,1824,1826
		dw	1864,1862,1860,1858

		
		dw	3044,3046,3048,3050,3052,3054,3056,3058,3060,3062,3064,3066,3068,3070,3072,3074
		dw	3076,3078,3080,3082,3084,3086,3088,3090,3092,3094,3096,3098,3100,3102
		dw	3144,3146,3148,3150,3152,3154,3156,3158,3160,3162,3164,3166,3168,3170,3172,3174
		dw	3176,3178,3180,3182,3184,3186,3188,3190,3192,3194
		score: dw 0
life: db 3
win: db 0; boolean to check if the game is over becasue player won or not 
welcomeMessage: db 'This is the SSSSSSnake Game';27
welcomeMessage2: db 'Press Any Key to Start the Game';31
welcomeMessage3: db 'Press X on the right corner to Exit';35
welcomeMessage4: db 'You have played Snake on nokia 3310 so you know basic rules';59
welcomeMessage5: db 'This game gives you 3 extra life and some bonus features';56
welcomeMessage6: db 'Eat 12 fruits basic Fruits before the timer runs out';52


;---------------------------------------


;subroutine to get random col and rows
Random:
	
	push ax
	push bx
	push dx
	
	xor dx, dx
	mov word ax, [a1]
	mov word bx, [seed1]
	mul bx
	add word ax, [c1]
	mov word bx, [m1]
	div bx
	mov word [seed1], dx
	add dx, 5
	mov word [randRow], dx
	
	xor dx, dx
	mov word ax, [a2]
	mov word bx, [seed2]
	mul bx
	add word ax, [c2]
	mov word bx, [m2]
	div bx
	mov word [seed2], dx
	add dx, 4
	mov word [randCol], dx
	
	pop dx
	pop bx
	pop ax
	ret
	
;----------------------------------	
	




; subroutine to print a number at top left of screen
; takes the number to be printed as its parameter
printnum:
		push bp
		mov bp, sp
		push es
		push ax
		push bx
		push cx
		push dx
		push di
		mov ax, 0xb800
		mov es, ax ; point es to video base
		mov ax, [bp+4] ; load number in ax
		mov bx, 10 ; use base 10 for division
		mov cx, 0 ; initialize count of digits
nextdigit:
		mov dx, 0 ; zero upper half of dividend
		div bx ; divide by 10
		add dl, 0x30 ; convert digit into ascii value
		push dx ; save ascii value on stack
		inc cx ; increment count of values
		cmp ax, 0 ; is the quotient zero
		jnz nextdigit ; if no divide it again
		mov di, [bp + 6] ; point di to 70th column
nextpos:
		pop dx ; remove a digit from the stack
		mov dh, 0x07 ; use normal attribute
		mov [es:di], dx ; print char on screen
		add di, 2 ; move to next screen location
		loop nextpos ; repeat for all digits on stack
		pop di
		pop dx
		pop cx
		pop bx
		pop ax 
		pop es
		pop bp
		ret 4 
;---------------------------------------------



;subroutine to print sanke
printsnake: 	push ax
				push cx
				push si
				push di
				push es
				push bx


				mov cx,[sizesnake]
				dec cx
				mov bx,snake
				xor si,si
				mov ax,0xb800
				mov es,ax
				mov ah,64
				mov al,' '
				mov di,[bx+si]
				mov word [es:di],ax
				mov ah,07
				mov al, 4
				
l1_printsnake:	add si,2
				mov di,[bx+si]
				mov word [es:di],ax
				loop l1_printsnake

				pop bx
				pop	es
				pop di
				pop si
				pop cx
				pop ax
				ret
				
;-------------------------------
printfruit: push bp
			mov bp,sp
			push ax
			push bx
			push di
			push es
			push cx
			push dx
			
			

			;in al,61h
			;and al,11111100b
			;out 61h,al
			push 4304
			call soundcreate
			mov ax,0xb800
			mov es,ax
			mov ax,[bp+4];row
			mov bx,160
			mul bx
			mov bx,[bp+6];col
			shl bx,1
			add ax,bx
			mov di,[fruit]
			mov di,ax
						cmp word [bp+8],0
						jne s1_printfruit
						mov al,254
						mov ah,160
						
s1_printfruit:			cmp word [bp+8],1
						jne s2_printfruit
						mov al,2
						mov ah,164
						mov word [fruit1],di
						mov word [fruitvalue],0
s2_printfruit:			cmp word [bp+8],2
						jne s3_printfruit
						mov al,20
						mov ah,176
						mov word [fruit2],di
						mov word [fruitvalue],0
						
s3_printfruit:			mov word [es:di],ax
						mov word [fruit],di
			
			pop dx
			pop cx
			pop es
			pop di
			pop bx
			pop ax
			pop bp
			ret 6

;----------------------------------
; sub to reset the game for one life
lifeReset: 
		
		push ax
		push bx
		push cx
		push di
		push si
		push es
		
		mov ax,0xb800
		mov es,ax
		mov si, snakePreserve
		mov di, snake
		xor bx, bx
		mov cx, 120
L1_lifeReset:
		mov ax, [si + bx]
		mov [di + bx], ax
		add bx, 2
		loop L1_lifeReset
		
		
		mov word [sizesnake], 20
		mov word [snakecounter], 0
		mov word [sizecounter] , 0
		mov byte [speed],10;initial speed in 100 seconds you acheive maximum speed
		mov word [movementflag]	,2
		mov word [fruit],0
		mov word [randRow],9
		mov word [randCol], 37
		mov word [time],0
		
		
		
		
		
		call printBorder
		call printsnake
		push word [fruitvalue]
		push word [randCol]
		push word [randRow]
		call printfruit
		cmp word [level],1
		jne s1_lifeReset
				mov bx,level1
				mov cx,97
L2_lifeReset:	mov di,[bx]
				mov word [es:di],0x1020
				add bx,2
				loop L2_lifeReset
		
s1_lifeReset:	
		pop es
		pop si
		pop di
		pop cx
		pop bx
		pop ax
		
		
		ret
		
;----------------
; a sub sub to deduct life
lifeDeduct:
		push ax
				xor ax, ax
				mov byte al, [life]
				shl ax, 1
				add ax, 160
				push ax
				call deletelife
				sub byte [life], 1
		pop ax
		ret
;------------------------------
;sub to detect collision

colisionDetection:
		
		push ax
		push bx
		push dx
		push cx
		push si
		
							cmp word [level],2
							jb s10_colisionDetection
							cmp word [sizesnake],32
							jne s14_colisionDetection
							mov word [win],1
							call gameOver
s14_colisionDetection:		cmp word [snake],804 ; left top
							ja s11_colisionDetection;lifeReset
							add word [snake],3040
s11_colisionDetection:		cmp word [snake], 3836; right bottom
							jb s12_colisionDetection;lifeReset
							sub word [snake],3040
s12_colisionDetection		xor dx,dx
							mov word ax, [snake]
							mov bx, 160
							div bx
		
							cmp dx, 4 ; left border
							jae s13_colisionDetection;lifeReset
							add word [snake],152
s13_colisionDetection:		cmp dx, 154 ; right border
							jbe s10_colisionDetection;lifeReset
							sub word [snake],152
							
s10_colisionDetection:							
							cmp word [snake],804 ; left top
							jb s2_colisionDetection;lifeReset
							cmp word [snake], 3836; right bottom
							ja s2_colisionDetection;lifeReset
							xor dx,dx
							mov word ax, [snake]
							mov bx, 160
							div bx
		
							cmp dx, 4 ; left border
							jb s2_colisionDetection;lifeReset
							cmp dx, 154 ; right border
							ja s2_colisionDetection;lifeReset
		
							
							mov ax,[snake]
							cmp ax,[fruit1]
							jne s5_colisionDetection
							add word [sizecounter],20
							
s5_colisionDetection:		cmp ax,[fruit2]
							jne s7_colisionDetection
							call lifeReset
s7_colisionDetection:		cmp ax,[fruit];checks if the fruit is eaten
							jne s8_colisionDetection
							add word [score], 10
							cmp word [score],80
							jne s4_colisionDetection
							mov word [fruitvalue],1
s4_colisionDetection:		add word [sizecounter],4
							jmp s3_colisionDetection
s2_colisionDetection:		jmp colision
s3_colisionDetection:
							
l3_colisionDetection:		call Random
							mov ax,[randRow];row
							mov bx,160
							mul bx
							mov bx,[randCol];col
							shl bx,1
							add ax,bx
							jmp s9_colisionDetection
s8_colisionDetection:		jmp s1_colisionDetection					
s9_colisionDetection:		mov cx,97
							mov bx,level1
							xor si,si
l5_colisionDetection:		cmp [bx+si],ax
							je l3_colisionDetection
							add si,2
							loop l5_colisionDetection
							mov cx,[sizesnake];check if fruit lies on snake himself
							sub cx,1
							mov si,2
l2_colisionDetection:		cmp ax,[snake+si]
							je l3_colisionDetection;if lies on snake generates another one
							add si,2
							loop l2_colisionDetection
							cmp word [fruitflag],1
							jne s6_colisionDetection
							mov word [fruitflag],0
							mov word [fruitvalue],2
							push word [fruitvalue]
							push word [randCol]
							push word [randRow]
							call printfruit;creates new fruit
							jmp l3_colisionDetection
s6_colisionDetection:		push word [fruitvalue]
							push word [randCol]
							push word [randRow]
							call printfruit;creates new fruit
		
s1_colisionDetection:		mov cx,[sizesnake];check if snakes bites himself
							sub cx,1
							mov ax,[snake]
							mov si,2
l1_colisionDetection:		cmp ax,[snake+si]
							je colision
							add si,2
							loop l1_colisionDetection
							
							cmp word[level],1
							jne colisoinBack
							mov cx,97
							mov ax,[snake]
							mov bx,level1
							xor si,si
l4_colisionDetection:		cmp [bx+si],ax
							je colision
							add si,2
							loop l4_colisionDetection
							jmp colisoinBack

colision: 
				cmp byte [life], 0
				je over
				call lifeDeduct
				call lifeReset
				jmp colisoinBack
over:
				call gameOver
				
colisoinBack:		
				pop si
				pop cx
				pop dx
				pop bx
				pop ax
				ret
		


;-----------------
; sub to check time
timeCheck:
		push ax
		push bx
		push cx
		Push dx
		
		mov ax, [time]
		cmp word ax, 100
		jne time_Back
		jmp timeDO
timeCheck1:
		cmp word ax, 200
		jne timeCheck2
		jmp timeDO
timeCheck2:
		cmp word ax, 299
		jne timeCheck3
		jmp timeDO
timeCheck3:
		cmp word ax, 399
		jne time_Back
timeDO:
		cmp byte [life], 0
		je overu
		call lifeDeduct
		call lifeReset
		;mov [time], ax
time_Back:	
		pop dx
		pop cx
		pop bx
		pop ax
		ret
overu: ;another version of over in this sub
			call gameOver		
;-----------------
timer: 
		push ax
		push dx
		push bx
		push es
		push di
		
		;out 42h, al
		;mov al, ah
		;out 42h, al
		
		inc byte [cs:timecounter]; increment tick count
		cmp byte[cs:timecounter] , 100
		jne s4_timer
		mov bx,154 ; position of time , this is for printnum 
		push bx
		inc word [cs:time]
		inc word [cs:time2]
		cmp word [cs:score],140
		jne s3_timer
		mov word [fruitvalue],1
s3_timer:		mov bx,20;speed change after 20 seconds
		xor dx,dx
		mov ax,[cs:time]
		div bx
		cmp dx,0
		jne s1_timer
		mov ax,0xb800
		mov es,ax
		mov di,[fruit2]
		mov word [es:di],0x2020
		mov word [cs:fruit2],0
		mov byte [cs:snakecounter], 0
		cmp byte [cs:speed],6;max speed
		je s1_timer
		sub byte [cs:speed],4;increase in speed
		jmp s1_timer
s4_timer:		jmp snakemover
s1_timer:		mov bx,50;speed change after 20 seconds
				xor dx,dx
				mov ax,[cs:time]
				div bx
				cmp dx,0
				jne s2_timer
				mov word [fruitflag],1
s2_timer:			
			mov ax, 101
			sub ax, [cs:time]
			cmp ax, 100
			jae resume
			cmp ax, 10
			jae singleZero
			push 0
			call printnum
			mov bx, 154
			add bx, 2
			push bx
			push 0
			call printnum
			add bx, 2
			push bx
			jmp resume
			
singleZero:			
			push 0
			call printnum
			mov bx, 154
			add bx, 2
			push bx
			
			
resume:			
			push ax
			call printnum ; print tick count
			mov byte [cs:timecounter], 0
snakemover: 
			inc byte [cs:snakecounter]; increment tick count
			mov bh,[speed]
			cmp byte[cs:snakecounter] ,bh 
			jne exit_timer
			mov byte [cs:snakecounter], 0
			mov bx,[movementflag]
			push bx
			call movsnake
			call colisionDetection
		
			call printsnake
			push 314 ; position of score
			push word[cs:score]
			call printnum; print the score
			xor ax, ax

		call timeCheck

		
exit_timer:

		call timeCheck
		mov al, 0x20
		out 0x20, al ; end of interrupt
		pop di
		pop es
		pop bx
		pop dx
		pop ax
		iret ; return from interrupt 
		


;------------------------------------
;sub to end it all
gameOver:	


	; TODO play some sound
	call clrscr;
	mov ax, 0xb800;
	mov es, ax
	mov di, 1992
	
	
	cmp byte [win], 0
	jne winner

		mov si, endGame
		mov cx, 9
		mov ah, 0x04
		cld ; auto increment mode
		nextGame: 
		lodsb ; load next char in al
		stosw ; print char/attribute pair
		loop nextGame ; repeat for the whole string 
		jmp theRest
		;----- printing ssssssnake ends here
		
winner:
		mov si, winGame
		mov cx, 11
		mov ah, 0x02
		cld ; auto increment mode
		nextGame2: 
		lodsb ; load next char in al
		stosw ; print char/attribute pair
		loop nextGame2 ; repeat for the whole string 
		jmp theRest
		;----- printing ssssssnake ends here
theRest:	
	mov ah, 0x07
	add di, 142
	mov si, endScore
		mov cx, 11
		mov ah, 0x04
		cld ; auto increment mode
		nextYourScore: 
		lodsb ; load next char in al
		stosw ; print char/attribute pair
		loop nextYourScore ; repeat for the whole string 
		;----- printing ssssssnake ends here
		

	add di, 138
	mov si, endTime
		mov cx, 10
		mov ah, 0x04
		cld ; auto increment mode
		nextYourTime: 
		lodsb ; load next char in al
		stosw ; print char/attribute pair
		loop nextYourTime ; repeat for the whole string 
		;----- printing ssssssnake ends here
	
	push 2174; location to print score;
	push word [score]
	call printnum;
	
	push 2336
	push word [time2]
	call printnum
	
	
		
		call here;

	
;--------------------------------
soundcreate: pusha
mov     al, 182         ; Prepare the speaker for the
        out     43h, al         ;  note.
        mov     ax, [bp+4]        ; Frequency number (in decimal)
                                ;  for middle C.
        out     42h, al         ; Output low byte.
        mov     al, ah          ; Output high byte.
        out     42h, al 
        in      al, 61h         ; Turn on note (get value from
                                ;  port 61h).
        or      al, 00000011b   ; Set bits 1 and 0.
        out     61h, al         ; Send new value.
        mov     bx, 25          ; Pause for duration of note.
.pause1:
        mov     cx, 4000
.pause2:
        dec     cx
        jne     .pause2
        dec     bx
        jne     .pause1
        in      al, 61h         ; Turn off note (get value from
                                ;  port 61h).
        and     al, 11111100b   ; Reset bits 1 and 0.
        out     61h, al         ; Send new value.
			popa
			ret 2
;--------------------------------
;subroutine to move snake left
movsnake:		push bp
				mov bp,sp
				push ax
				push bx
				push cx
				push di
				push si
				push es
				
				mov bx,snake
				mov cx,[sizesnake]
				dec cx
				mov si,cx
				shl si,1
				mov di,[bx+si]
				cmp word [sizecounter],0;checks if the size is to be increased
				jne s5_movsnake
				mov ax,0xb800
				mov es,ax
				mov word [es:di],0x2020
				jmp l1_movsnake
s5_movsnake:	dec word [sizecounter]
				inc word [sizesnake]
				add si,2
				mov word [snake+si],di
				sub si,2
				
l1_movsnake:	sub si,2
				mov ax,[bx+si]
				add si,2
				mov word [bx+si],ax
				sub si,2
				loop l1_movsnake
				cmp word [bp+4],2
				jne s1_movsnake
				add word [bx],2
s1_movsnake:
				cmp word [bp+4],4
				jne s2_movsnake
				sub word [bx],2

s2_movsnake:	cmp word [bp+4],1
				jne s3_movsnake
				sub word [bx],160

s3_movsnake:	cmp word [bp+4],3
				jne s4_movsnake
				add word [bx],160

s4_movsnake:	
				cmp word [sizesnake],32
				jne s6_movsnake
				call nextlevel
				
s6_movsnake:	pop es
				pop si
				pop di
				pop cx
				pop bx
				pop ax
				pop bp
				ret 2
;-------------------------------
nextlevel:
			push ax
			push cx
			push di
			push es
			push bx
			
			
			inc word [level]
			cmp word [level],1
			jne s1_nextlevel
			mov ax,0xb800
			mov es,ax
			mov di,156
			mov word [es:di],0x0720
			mov word [es:di+2],0x0720
			mov word [es:di+4],0x0720
			mov di,314
			mov word [es:di],0x0720
			mov word [es:di+2],0x0720
			mov word [es:di+4],0x0720
			mov word [time],0
			call lifeReset
			mov bx,level1
			mov cx,97
l1_nextlevel:	mov di,[bx]
				mov word [es:di],0x1020
				add bx,2
				loop l1_nextlevel
				jmp s2_nextlevel
s1_nextlevel:	
			cmp word [level],2
			jne s2_nextlevel
				mov ax,0xb800
			mov es,ax
			mov di,156
			mov word [es:di],0x0720
			mov word [es:di+2],0x0720
			mov word [es:di+4],0x0720
			mov di,314
			mov word [es:di],0x0720
			mov word [es:di+2],0x0720
			mov word [es:di+4],0x0720
			mov word [time],0
			call lifeReset
				mov bx,level1
				mov cx,97
l2_nextlevel:	mov di,[bx]
				mov word [es:di],0x2020
				add bx,2
				loop l2_nextlevel
					
			
s2_nextlevel:			
			pop bx
			pop es
			pop di
			pop cx
			pop ax
			ret
			

;-------------------------------
; subroutine to clear the screen
clrscr:
 push es
 push ax
 push cx
 push di
 mov ax, 0xb800
 mov es, ax ; point es to video base
 xor di, di ; point di to top left column
 mov ax, 0x0720 ; space char in normal attribute
 mov cx, 2000 ; number of screen locations
 cld ; auto increment mode
 rep stosw ; clear the whole screen
 pop di 
 pop cx
 pop ax
 pop es
 ret 
;-----------------------------------

; sub to print life at the given location of parameter
drawlife:
		push bp
		mov bp, sp
		push ax
		push es
		push di


		mov ax, 0xb800
		mov es, ax
		mov  di , [bp + 4]
		mov word [es:di] , 0x0403
		
		pop di
		pop es
		pop ax
		pop bp
		ret 2
;-----------------------------

deletelife:
		push bp
		mov bp, sp
		push ax
		push es
		push di


		mov ax, 0xb800
		mov es, ax
		mov di , [bp + 4]
		mov word[es:di] , 0x0720
		
		pop di
		pop es
		pop ax
		pop bp
		ret 2
;-----------------------------
	

;Sub to print header
printHeader:
		
		push ax
		push cx
		push di
		push si
		push es
		
	
		xor ax, 0xb800
		mov es, ax
		mov di , 70; priting ssssssnake starts here
		mov si, Ssnake
		mov cx, 10
		mov ah, 0x07
		cld ; auto increment mode
		nextsnake: 
		lodsb ; load next char in al
		stosw ; print char/attribute pair
		loop nextsnake ; repeat for the whole string 
		;----- printing ssssssnake ends here
		
		mov di, 144; priting time: starts here
		mov si, printTime
		mov cx, 5
		mov ah, 0x07
		cld ; auto increment mode
		nexttimer: 
		lodsb ; load next char in al
		stosw ; print char/attribute pair
		loop nexttimer ; repeat for the whole string 
		
		
		mov di, 302; priting score: starts here
		mov si, printScore
		mov cx, 6
		mov ah, 0x07
		cld ; auto increment mode
		nextscore: 
		lodsb ; load next char in al
		stosw ; print char/attribute pair
		loop nextscore ; repeat for the whole string 
		
		push 162
		call drawlife
		push 164
		call drawlife
		push 166
		call drawlife
		
		pop es
		pop si
		pop di 
		pop cx
		pop ax
		ret

;----------------------------

;Sub to print the borders
printBorder:
		push ax
		push di
		push si
		push es
	
		xor ax, 0xb800
		mov es, ax
		mov di, 640; start of the third line
		mov ah, 16 ; back ground color blue
		mov al, ' '
L1_printBorder:
			cmp di, 800; loop to print the first line of border horizontal
			je L2_printBorder
			mov word [es:di], ax
			add di, 2
			jmp L1_printBorder
L2_printBorder:
			cmp di, 3840; loop to print the two border lines vertical
			je L3_printBorder
			mov word [es:di], ax
			add di, 2
			mov word [es:di], ax
			;add di, 154
			add di, 2
			mov si, di
			add si, 152
			mov ah, 32
			L2_2printBorder: ;make it green
				mov word [es:di], ax
				add di, 2		
				cmp di, si
				jne L2_2printBorder	
					
			mov ah, 16		
			mov word [es:di], ax
			add di, 2
			mov word [es:di], ax
			add di, 2
			jmp L2_printBorder
L3_printBorder:
			cmp di, 4000; loop to print the last line of border horizontal
			je back_printBorder
			mov word [es:di], ax
			add di, 2
			jmp L3_printBorder

back_printBorder:
		
		pop es
		pop si
		pop di
		pop ax
		ret
;------------------------------


start:	
		
			
			call startGameScreen

		int 0x16
		xor ax, ax
		call clrscr
		
		
		
		call printHeader
		call printBorder
		call printsnake
		push word [fruitvalue]
		push word [randCol]
		push word [randRow]
		call printfruit
		
		mov ax,11800
		out 0x40,al
		mov al,ah
		out 0x40,al
		xor ax, ax
		mov es, ax ; point es to IVT base
		cli ; disable interrupts
		mov word [es:8*4], timer; store offset at n*4
		mov [es:8*4+2], cs ; store segment at n*4+2
		sti ; enable interrupts
l1:
		
		call timeCheck
		mov ah,0; Get keystroke
		int 0x16; AH = BIOS scan code
		cmp ah,0x48;up
		jne skip1
		cmp word [cs:movementflag],3;checks bakward motion
		je skip1
		mov word [cs:movementflag],1
skip1:
		call timeCheck
		cmp ah,0x4D;right
		jne skip2
		cmp word [cs:movementflag],4;checks bakward motion
		je skip2
		mov word [cs:movementflag],2
skip2:	
		call timeCheck
		cmp ah,0x50;down
		jne skip3
		cmp word [cs:movementflag],1;checks bakward motion
		je skip3
		mov word [cs:movementflag],3
skip3:
		call timeCheck
		cmp ah,0x4B;left
		jne skip4
		cmp word [cs:movementflag],2;checks bakward motion
		je skip4
		mov word [cs:movementflag],4
skip4:
		call timeCheck
		cmp ah,1
		jne l1  ; loop until Esc is pressed		
		
here:
mov ax,0x4c00
int 21h

;-------------------------------------------------



; subroutine to print a string
; takes row no, column no, address of string, and its length
; as parameters
printString: push bp
 mov bp, sp
 push es
 push ax
 push bx
 push cx
 push dx
 push si
 push di
 mov ax, 0xb800
 mov es, ax ; point es to video base
 mov di, 80 ; load di with columns per row
 mov ax, [bp+10] ; load ax with row number
 mul di ; multiply with columns per row
 mov di, ax ; save result in di
 add di, [bp+12] ; add column number
 shl di, 1 ; turn into byte count
 mov si, [bp+6] ; string to be printed
 mov cx, [bp+4] ; length of string
 mov ah, [bp + 8] ; normal attribute is fixed
nextchar: mov al, [si] ; load next char of string
 mov [es:di], ax ; show next char on screen
 add di, 2 ; move to next screen location
 add si, 1 ; move to next char
 loop nextchar ; repeat the operation cx times
 pop di
 pop si
 pop dx
 pop cx
 pop bx
 pop ax 
 pop es
 pop bp
 ret 10 


 
 ; subroutine to print blue the screen
Blue:
 push es
 push ax
 push cx
 push di
 mov ax, 0xb800
 mov es, ax ; point es to video base
 xor di, di ; point di to top left column
 mov ax, 0x3020 ; space char in normal attribute
 mov cx, 2000 ; number of screen locations
 cld ; auto increment mode
 rep stosw ; clear the whole screen
 pop di 
 pop cx
 pop ax
 pop es
 ret 
;-----------------------------------
 
;subroutine to print start screen
startGameScreen:
		push ax
		push dx
		push es
		push di
		push si
		
		;push 0x1020
		call Blue
		mov ax,0xb800
		mov es,ax
	
		mov di,0
	startBorderUp:
		mov word[es:di],0x1020
		add di,2
		cmp di,160
		jne startBorderUp
		
		mov di,3840
	startBorderDown:
		mov word[es:di],0x1020
		add di,2
		cmp di,4000
		jne startBorderDown
		
		mov di,318
	startBorderRight:
		mov word[es:di],0x1020
		add di,160
		cmp di,3998
		jne startBorderRight
		
		mov di,160
	startBorderLeft:
		mov word[es:di],0x1020
		add di,160
		cmp di,3840
		jne startBorderLeft
		
		mov di,316
	startBorderRight1:
		mov word[es:di],0x1020
		add di,160
		cmp di,3996
		jne startBorderRight1
		
		mov di,162
	startBorderLeft2:
		mov word[es:di],0x1020
		add di,160
		cmp di,3842
		jne startBorderLeft2
	
	;center box top bar
		mov di,660
		mov si,di
		add si,120
	nextchar1a:
		mov word [es:di],0x6020
		add di,2
		cmp di,si
		jne nextchar1a
		
		mov di,820
		mov si,di
		add si,120
	
	;center box main
	nextchar1b:
		mov word [es:di],0x0020
		add di,2
		cmp di,si
		jne nextchar1b
		add di,40
		mov si,di
		add si,120
		cmp di,2000
		jle nextchar1b
		
		;printString takes the x position, y position, attribute, address of string and its length as parameters
		;print all welcome messages
		push 28
		push 4
		push 0x6A
		push welcomeMessage
		push 27
		call printString
		
		push 25
		push 6
		push 0x04
		push welcomeMessage2
		push 31
		call printString
		
		push 25
		push 7
		push 0x04
		push welcomeMessage3
		push 35
		call printString
		
		
		
		mov ah,0x02
		mov al,'*'
		mov word[es:1620],ax
		push 11
		push 10
		push 0x02
		push welcomeMessage4
		push 59
		call printString
		
		mov ah,0x02
		mov al,'*'
		mov word[es:1780],ax
		push 11
		push 11
		push 0x02
		push welcomeMessage5
		push 56
		call printString
		
		mov ah,0x02
		mov al,'*'
		mov word[es:1940],ax
		push 11
		push 12
		push 0x02
		push welcomeMessage6
		push 52
		call printString
		
		
		
		pop si
		pop di
		pop es
		pop dx
		pop ax
		ret
;-------------------------------------------------------------




