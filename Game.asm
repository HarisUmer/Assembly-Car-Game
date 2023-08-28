[org 0x0100]
jmp start1
;--------------------------------------making int----------------------------------
kbsir:
push bp
mov bp,sp
push ax
push bx
push cx
push dx
push di
push si
push ds
push es
jmp sss
upmov1:
mov ax,1534;making indicaters
shl ax,1
push ax
mov ax,0
push ax
mov ax,0
push ax
mov al,'<'
mov ah,001110101b
push ax
mov bp,sp
call ract
mov ax,1535
shl ax,1
push ax
mov ax,0
push ax
mov ax,0
push ax
mov al,'='
mov ah,001110101b
push ax
mov bp,sp
call ract
mov ax,1584;making indicaters
shl ax,1
push ax
mov ax,0
push ax
mov ax,0
push ax
mov al,'>'
mov ah,01110101b
push ax
mov bp,sp
call ract
mov ax,1583
shl ax,1
push ax
mov ax,0
push ax
mov ax,0
push ax
mov al,'='
mov ah,01110101b
push ax
mov bp,sp
call ract
jmp upmov
nomatch1:
jmp nomatch

sss:
mov ax,0xb800
mov es,ax
mov ax,cs
mov ds,ax
mov ax,word[bp+4]											 ; taking input from port
;in al,0x60		
cmp al,0xc8
jne relese
mov word[speed],0
call printspeed
jmp exitt	
relese:							 ; taking input from port
;--------------------------------------up movment-------------------------------
cmp al,0x48
je  upmov1
 ;-----------------------------------------left movment------------------------
cmp al,0x4b
je leftmov
;------------------------------------------right movment------------------------
cmp al,0x4d
je rightmov
;-------------------------------------------------------------------------------

;------------------------------------------exit----------------------------------
cmp al,0x01
jne nomatch1
mov al,0x20
out 0x20,al
mov byte[cs:terminate],1
pop es
pop ds
pop si
pop di
pop dx
pop cx
pop bx
pop ax
pop bp									  ; End of Interrupt signal											  ;  										  ;  
ret 2

;------------------------------------------right mov----------------------------------
rightmov:
mov ax,[cs:right]
add ax,2
cmp ax,word[cs:rightlim]
jg pos
mov [cs:right],ax
mov ax,[cs:left]
add ax,2
mov [cs:left],ax
mov ax,0xb800
mov es,ax
mov di,1584;making indicaters
shl di,1
mov al,'>'
mov ah,11110101b
mov word[es:di],ax
mov di,1583
shl di,1
mov al,'='
mov ah,01110101b
mov word[es:di],ax
jmp upmov
pos:
call paus
jmp exitt
;------------------------------------------left mov------------------------------------
leftmov:
mov ax,[cs:left]
sub ax,2
cmp ax,word[cs:leftlim]
jl pos1
mov word[cs:left],ax
mov ax,[cs:right]
sub ax,2
mov word[cs:right],ax
mov ax,1534;making indicaters
shl ax,1
push ax
mov ax,0
push ax
mov ax,0
push ax
mov al,'<'
mov ah,10000111b
push ax
mov bp,sp
call ract
mov ax,1535
shl ax,1
push ax
mov ax,0
push ax
mov ax,0
push ax
mov al,'='
mov ah,10000111b
push ax
mov bp,sp
call ract
jmp upmov
pos1:
call paus
jmp exitt

;----------------------------------------up mov--------------------------------------
upmov:
mov word[speed],260
call movment
jmp updatemap
inc word[speed]
call printspeed
com:
jmp exitt
;---------------------------------------------------------------------------------------------------------
notstriht:
mov word[cs:boool],3131h
mov ax,[cs:speed]
add ax,1
mov word[cs:speed],ax
call movment
cmp word[num],13
jg lap
add word[currpos],160
mov di,word[currpos]
mov al,'*'
mov ah,11001111b
mov word[es:di],ax
jmp updatemap
lap:
sub word[currpos],160
mov di,word[currpos]
mov al,'*'
mov ah,11001111b
mov word[es:di],ax
jmp updatemap
jmp exitt
;--------------------------------------------------------------------------
;-------------------------------------update map------------------------------------------
updatemap:
mov di,[cs:currpos]
cmp di,18
je notstriht
cmp di,498
je notstriht
cmp di,640
je notstriht
cmp di,0
je check9
jmp  yes
check9:
cmp word[num],0
jg no
jmp yes
no:
mov byte[terminate],1
jmp exitt
yes:
;--------------------------------------------------------------------------------
mov ah,11001111b
mov al,'*'
mov word[es:di],ax
inc word[cs:trackcou]
cmp word[cs:trackcou],7
jl com
inc word[num]
mov word[cs:trackcou],0
mov word[boool],3232h
call loadDs
;-----------------------------------------------------------------------------------
cmp word[currpos],18
jge check2
add word[currpos],2
jmp exitt
check2:
cmp word[cs:num],13
jg check3
cmp word[currpos],498
jge check3
add word[currpos],160
jmp exitt
check3:
cmp word[currpos],640
jle check4
sub word[currpos],2
jmp exitt
check4:
cmp word[currpos],0
jl termi
sub word[currpos],160
jmp exitt

termi:
mov byte[terminate],1
jmp exitt
;-------------------------------------------------------------------------------
nomatch:
;mov al,0x20
;out 0x20,al							  ; calls the subroutine
pop es
pop ds
pop si
pop di
pop dx
pop cx
pop bx
pop ax
pop bp
ret 2
;---------------------------------------------------------------------------
exitt:
;mov al,0x20
;out 0x20,al									  ; End of Interrupt signal											  ;  										  ;  
pop es
pop ds
pop si
pop di
pop dx
pop cx
pop bx
pop ax
pop bp
ret 2
;-----------------------------------terminate----------------------------
;--------------------------------------making maps-----------------------
maps:
mov ax,0xb800
mov es,ax
mov ax,0;making big left rect
push ax
mov ax,6
push ax
mov ax,20
push ax
mov ah,00000001b
mov al,20h
push ax
mov bp,sp
call ract
mov di,0
mov al,'*'
mov ah,01001000b
mov cx,10
nnn:
mov word[es:di],ax
add di,2
loop nnn
add di,158
mov cx,3
nnn1:
mov word[es:di],ax
add di,160
loop nnn1
mov cx,10
nnn2:
mov word[es:di],ax
sub di,2
loop nnn2
add di,2
sub di,160
mov cx,3
nnn3:
mov word[es:di],ax
sub di,160
loop nnn3
ret 
strt: db 'start'
stopit: db 'P: 01  L: 01 00 w 00 . 0 s 00 w 00 . 0 s'
;------------------------------------------------------------ractangle---------------------
ract:
push ax
push si
push bp
push dx
push cx
push bx
push di
mov ax,0xb800
mov es,ax
mov ax,[bp]
mov di,[bp+6]
mov cx,0
mov bx,di
add bx,[bp+2]
lop2:
lop:
mov word[es:di],ax
add di,2
cmp di,bx
jle lop
sub bx,[bp+2]
mov di,bx
mov bx,80
shl bx,1
add di,bx
mov bx,di
add bx,[bp+2]
add cx,1
cmp cx,[bp+4]
jle lop2
pop di
pop bx
pop cx
pop dx
pop bp
pop si
pop ax
ret 8
secmak:
mov ax,0;making sky
push ax
mov ax,4
push ax
mov ax,158
push ax
mov al,20h
mov ah,00110111b
push ax
mov bp,sp
call ract
mov ax,0;making big left rect
push ax
mov ax,6
push ax
mov ax,20
push ax
mov ah,00000001b
mov al,20h
push ax
mov bp,sp
call ract
mov ax,0; making 1st small rect
add ax,80
shl ax,1
add ax,2
push ax
mov ax,0
push ax
mov ax,2
push ax
mov ah,11000100b
mov al,20h
push ax
mov bp,sp
call ract
mov ax,0; making 2nd small rect
add ax,80
shl ax,1
add ax,10
push ax
mov ax,0
push ax
mov ax,2
push ax
mov ah,11000100b
mov al,20h
push ax
mov bp,sp
call ract
mov ax,0; making 3rd small rect
add ax,240
shl ax,1
add ax,2
push ax
mov ax,0
push ax
mov ax,2
push ax
mov ah,11000100b
mov al,20h
push ax
mov bp,sp
call ract
mov ax,0; making 4th small rect
add ax,240
shl ax,1
add ax,10
push ax
mov ax,0
push ax
mov ax,2
push ax
mov ah,11000100b
mov al,20h
push ax
mov bp,sp
call ract
mov ax,400; making 5th small rect
shl ax,1
add ax,2
push ax
mov ax,0
push ax
mov ax,2
push ax
mov ah,11110111b
mov al,20h
push ax
mov bp,sp
call ract
mov ax,400; making 6th small rect
shl ax,1
add ax,10
push ax
mov ax,0
push ax
mov ax,2
push ax
mov ah,11110111b
mov al,20h
push ax
mov bp,sp
call ract
mov ax,12; makining long rect
shl ax,1
push ax
mov ax,0
push ax
mov ax,80
push ax
mov ah,01111100b
mov al,20h
push ax
mov bp,sp
call ract
mov ax,110;color right box
push ax
mov ax,4
push ax
mov ax,48
push ax 
mov al,20h
mov ah,01101111b
push ax
mov bp,sp
call ract
mov bx,0
mov ax,112
loip:
mov cx,ax  ;writing in middle
push ax
mov ax,0
push ax
mov ax,0
push ax
mov al,[stopit+bx]
mov ah,01101111b
push ax
mov bp,sp
call ract
mov ax,cx
add ax,2
add bx,1
cmp bx,12
jle loip
mov cx,0
mov ax,272
loip1:
mov cx,ax  ;writing in middle
push ax
mov ax,0
push ax
mov ax,0
push ax
mov al,[stopit+bx]
mov ah,01101111b
push ax
mov bp,sp
call ract
mov ax,cx
add ax,2
add bx,1
cmp bx,26
jle loip1
mov cx,0
mov ax,432
loip3:
mov cx,ax  ;writing in middle
push ax
mov ax,0
push ax
mov ax,0
push ax
mov al,[stopit+bx]
mov ah,01101111b
push ax
mov bp,sp
call ract
mov ax,cx
add ax,2
add bx,1
cmp bx,39
jle loip3
mov cx,0
mov ax,110;making length of ractangle at left corner
mov bx,ax
lope:
mov bx,ax
push ax
mov ax,1
push ax
mov ax,1
push ax
mov ah,11110111b
mov al,20
push ax
mov bp,sp
call ract
mov dx,80
shl dx,1
add bx,dx
mov ax,bx
add cx,1
cmp cx,3
jle lope
add ax,2;making width of rectangle
push ax
mov ax,0
push ax
mov ax,46
push ax
mov ah,11110111b
mov al,20h
push ax
mov bp,sp
call ract
mov ax,158;making right length ractangle at left corner
push ax
mov ax,4
push ax
mov ax,1
push ax
mov ah,11111111b
mov al,20h
push ax
mov bp,sp
call ract
mov ax,51;making sky betwwn long rect and right ract
shl ax,1
push ax
mov ax,6
push ax
mov ax,6
push ax
mov al,20h
mov ah,00110111b
push ax
mov bp,sp
call ract
mov ax,160;making sky in between road and bord
shl ax,1
add ax,20
push ax
mov ax,4
push ax
mov ax,80
push ax
mov ah,00110111b
mov al,20h
push ax
mov bp,sp
call ract
mov ax,560;mkaing a bit mor sky under left box
shl ax,1
push ax
mov ax,0
push ax
mov ax,26
push ax
mov ah,00110111b
mov al,20h
push ax
mov bp,sp
call ract
mov ax,455;making sky under right boxes
shl ax,1
push ax
mov ax,2
push ax
mov ax,48
push ax
mov ah,00110111b
mov al,20h
push ax
mov bp,sp
call ract
call makestad
mov ax,640;making grass at left side
mov bx,38
ll1:
mov cx,ax
shl ax,1
push ax
mov ax,0
push ax
mov ax,bx
push ax
mov ah,20h
mov al,20h
push ax
mov bp,sp
call ract
mov ax,cx
add ax,80
sub bx,2
cmp bx,24
jge ll1
mov bx,0
mov ax,701;making grass at rit side
mov bx,38
ll2:
mov cx,ax
shl ax,1
push ax
mov ax,0
push ax
mov ax,bx
push ax
mov ah,20h
mov al,20h
push ax
mov bp,sp
call ract
mov ax,cx
add ax,81
sub bx,2
cmp bx,24
jge ll2
mov bx,0
mov ax,1103;white line on road
lopp:
mov cx,ax
shl ax,1
push ax
mov ax,0
push ax
mov ax,3
push ax
mov ah,01111111b
mov al,20h
push ax
mov bp,sp
call ract
add bx,1
cmp cx,1103
jle c2
mov ax,cx
sub ax,82
jmp looo3
c2:
mov ax,cx
add ax,80
sub ax,2
looo3:
cmp bx,24
jle lopp
mov bx,0
mov ax,563 ;making piller in left corner
shl ax,1
push ax
mov ax,4
push ax
mov ax,4
push ax
mov al,20h
mov ah,11110111b
push ax
mov bp,sp
call ract
mov ax,467 ;making piller in right corner
shl ax,1
push ax
mov ax,7
push ax
mov ax,4
push ax
mov al,20h
mov ah,01110111b
push ax
mov bp,sp
call ract
;making dashbord ---------------------------------------------------------
mov ax,1280
shl ax,1
push ax
mov ax,0
push ax
mov ax,160
push ax
mov ah,01111000b
mov al ,20h
push ax
mov bp,sp
call ract
mov ax,1360;making dash bord
shl ax,1
push ax
mov ax,7
push ax
mov ax,160
push ax
mov ax,0x08db
push ax
mov bp,sp
call ract
mov ax,1440 ;making left side mirror
shl ax,1
push ax
mov ax,2
push ax
mov ax,12
push ax
mov al,20h
mov ah,01110111b
push ax
mov bp,sp
call ract
mov ax,1600
shl ax,1
push ax
mov ax,0
push ax
mov ax,12
push ax
mov al,'@'
mov ah, 01111010b
push ax
mov bp,sp
call ract
mov ax,1513 ;making rit side mirror
shl ax,1
push ax
mov ax,2
push ax
mov ax,12
push ax
mov al,20h
mov ah,01110111b
push ax
mov bp,sp
call ract
mov ax,1673
shl ax,1
push ax
mov ax,0
push ax
mov ax,12
push ax
mov al,'@'
mov ah, 01111010b
push ax
mov bp,sp
call ract
mov bx,0
mov ax,1472  ;staring making 
shl ax,1
push ax
mov ax,0
push ax
mov ax,26
push ax
mov al,20h
mov ah,00000011b
push ax
mov bp,sp
call ract
mov bx,0
mov ax,1550; making staring 
shl ax,1
push ax
mov ax,0
push ax
mov ax,2
push ax
mov al,20h
mov ah,00000011b
push ax
mov bp,sp
call ract
mov ax,1628   ;making staring
mov bx,0
lloo:
mov cx,ax
shl ax,1
push ax
mov ax,bx
push ax
mov ax,2
push ax
mov al,20h
mov ah,00000011b
push ax
mov bp,sp
call ract
add cx,78
mov ax,cx
add bx,1
cmp bx,3
jl lloo
mov ax,1566; making staring 
shl ax,1
push ax
mov ax,0
push ax
mov ax,2
push ax
mov al,20h
mov ah,00000011b
push ax
mov bp,sp
call ract
mov bx,0
mov ax,1648   ;making staring
mov bx,0
lloo1:
mov cx,ax
shl ax,1
push ax
mov ax,bx
push ax
mov ax,2
push ax
mov al,20h
mov ah,00000011b
push ax
mov bp,sp
call ract
add cx,82
mov ax,cx
add bx,1
cmp bx,3
jl lloo1
mov ax,1946,;making staring
shl ax,1
push ax
mov ax,0
push ax
mov ax,52
push ax
mov al,20h
mov ah,00000011b
push ax
mov bp,sp
call ract
mov ax,1478; staring
shl ax,1
push ax
mov ax,5
push ax
mov ax,0
push ax
mov al,20h
mov ah,00000011b
push ax
mov bp,sp
call ract
mov ax,1368;making speed shower
shl ax,1
push ax
mov ax,0
push ax
mov ax,4
push ax
mov al,'0'
mov ah,00001111b
push ax
mov bp,sp
call ract
mov ax,1534;making indicaters
shl ax,1
push ax
mov ax,0
push ax
mov ax,0
push ax
mov al,'<'
mov ah,001110101b
push ax
mov bp,sp
call ract
mov ax,1535
shl ax,1
push ax
mov ax,0
push ax
mov ax,0
push ax
mov al,'='
mov ah,001110101b
push ax
mov bp,sp
call ract
mov ax,1584;making indicaters
shl ax,1
push ax
mov ax,0
push ax
mov ax,0
push ax
mov al,'>'
mov ah,01110101b
push ax
mov bp,sp
call ract
mov ax,1583
shl ax,1
push ax
mov ax,0
push ax
mov ax,0
push ax
mov al,'='
mov ah,01110101b
push ax
mov bp,sp
call ract
mov ax,1656 ;start button
mov bx,0
loot:
mov cx,ax
shl ax,1
push ax
mov ax,0
push ax
mov ax,0
push ax
mov al,[strt+bx]
mov ah,10000111b
push ax
mov bp,sp
call ract
add bx,1
mov ax,cx
add ax,1
cmp bx,5
jl loot
ret
;making stadium--------------------------------------------------
makestad:
mov ax,260
shl ax,1
push ax
mov ax,1
push ax
mov ax,50
push ax
mov al,'#'
mov ah,01000101b
push ax
mov bp,sp
call ract
mov ax,414
shl ax,1
push ax
mov ax,1
push ax
mov ax,80
push ax
mov al,'#'
mov ah,01000101b
push ax
mov bp,sp
call ract
mov ax,560
shl ax,1
push ax
mov ax,0
push ax
mov ax,158
push ax
mov al,'#'
mov ah,01000101b
push ax
mov bp,sp
call ract
mov ax,494
shl ax,1
push ax
mov ax,0
push ax
mov ax,80
push ax
mov al,'#'
mov ah,01000000b
push ax
mov bp,sp
call ract
mov ax,340
shl ax,1
push ax
mov ax,0
push ax
mov ax,50
push ax
mov al,'#'
mov ah,01000000b
push ax
mov bp,sp
call ract
ret
;------------------------------------------ making red boundry at road
redwit:
push bp
mov bp,sp
push ax
push bx 
push cx
push dx
push ds
push si
push di
mov ax,0xb800
mov es ,ax
mov ah,00010000b
mov al,20h
mov di,[bp+4]
mov word[es:di],ax
sub di,2
mov ah,01110111b
mov word[es:di],ax
mov ah,01110111b
mov al,20h
mov di,[bp+6]
mov word[es:di],ax
add di,2
mov ah,00010000b
mov word[es:di],ax
pop di
pop si
pop ds 
pop dx
pop cx
pop bx
pop ax
pop bp
ret 4
;Put spaces------------------------------------------------------------
;------------------------------------------------------------------------------
putspace:
push ax
push bx 
push cx
push dx
push bp
push ds
push si
push di
mov ax,0xb800
mov es,ax
mov di,640
shl di,1
mov si,di
mov cx,di
mov dx,di
mov ax,0
mov al,20h
lop3:
add di,2
add si,80
add cx,[cs:left]
add dx,[cs:right]
mov bx,0
lop33:
cmp di,si
je pp1
cmp di,cx
jle green
mov ah,00000000b
oo1:
cmp di,dx
jge green
mov ah,00000000b
jmp prints
green:                       ;green color
mov ah,00101000b
jmp prints
prints:
push cx
mov cx,si
sub cx,80 
add  cx,158
cmp di,cx
pop cx
je pp1
mov word[es:di],ax
pp1:
add di,2
add bx,1
cmp bx,79
jl lop33
push cx
push dx
call redwit
cmp word[cs:boool],3131h
je lll1
sub cx,[cs:left]
add cx,158
sub dx,[cs:right]
add dx,162
sub si,80
add si,160
jmp rttt
lll1:
sub cx,[cs:left]
add cx,158
sub dx,[cs:right]
add dx,158
sub si,80
add si,158
rttt:
cmp di,2556
jl  lop3
pop di
pop si
pop ds 
pop bp
pop dx
pop cx
pop bx
pop ax
ret 
;----------------------------------------------------------------------------------
scroolDown:
push ax
push bx 
push cx
push dx
push bp
push ds
push si
push di
mov ax,80
mov bl,1
mul bl
push ax
shl ax,1
mov si,1278
shl si,1
sub si,ax
mov cx,638
sub cx,80
mov ax,0xb800
mov ds,ax
mov es,ax
mov di,1278
shl di,1
std
rep movsw
rep  stosw
pop cx
mov bx,cx
shl bx,1
sub cx,1
popi:
mov ax,2020h
mov word[es:di],ax
sub bx,2
sub di,2
loop popi
mov di,1280
add di,80
cmp word[tickcount],2020h
jne ooo
mov ah,00000000b
mov word[es:di],ax
mov word[tickcount],3030h
jmp ppp
ooo:
mov ah,11111111b
mov word[es:di],ax
mov word[tickcount],2020h
ppp:
call putspace
exi:
pop di
pop si
pop ds 
pop bp
pop dx
pop cx
pop bx
pop ax
ret 
;---------------------------------------------------------------------------------------------
;loading data segment ------------------------------------------------------------------------
;---------------------------------------------------------------------------------------------
loadDs:
push ax
push bx 
push cx
push dx
push bp
push ds
push si
push di
call maps
mov ax,0xb800
mov es,ax
mov di,1280
mov ax,word[cs:tickcount]
loP:
mov word[es:di],ax
add di,2
cmp di,2556
jl loP
mov di,1280
mov ah,01110111b
add di,80
cmp word[boool],3131h
je curv
lolo:
mov word[es:di],ax
add di,160
cmp di,2556
jl lolo
mov di,1280
add di,80
looP2:
add di,160
cmp di,2556
jge exit
add di,160
mov ah,00000000b
mov word[es:di],ax
cmp di,2556
jl looP2
jmp exit
curv:
llo:
mov ah,01110111b
mov word[es:di],ax
add di,158
cmp di,2556
jl llo
mov di,1280
add di,80
loo2:
add di,158
cmp di,2556
jge exit
add di,158
mov ah,00000000b
mov word[es:di],ax
cmp di,2556
jl loo2
exit:
call putspace
call makeboard
pop di
pop si
pop ds 
pop bp
pop dx
pop cx
pop bx
pop ax
ret
makeboard:
push ax
push bx 
push cx
push dx
push bp
push ds
push si
push di
mov ax,0xb800
mov es,ax
mov al,'R'
mov ah,00010111b
mov di,1280
mov word[es:di],ax
add di,160
mov al,'a'
mov word[es:di],ax
add di,160
mov al,'c'
mov word[es:di],ax
add di,160
mov al,'e'
mov word[es:di],ax
add di,160
mov al,' '
mov word[es:di],ax
add di,160
mov al,'R'
mov word[es:di],ax
add di,160
mov al,'a'
mov word[es:di],ax
add di,160
mov al,'c'
mov word[es:di],ax
;second
mov al,'R'
mov di,1438
mov word[es:di],ax
add di,160
mov al,'a'
mov word[es:di],ax
add di,160
mov al,'c'
mov word[es:di],ax
add di,160
mov al,'e'
mov word[es:di],ax
add di,160
mov al,' '
mov word[es:di],ax
add di,160
mov al,'R'
mov word[es:di],ax
add di,160
mov al,'a'
mov word[es:di],ax
add di,160
mov al,'c'
mov word[es:di],ax
pop di
pop si
pop ds 
pop bp
pop dx
pop cx
pop bx
pop ax
ret
;--------------------------------------------------------------------------------------
;---------------------------------------------------------------------------------------
longdelay:
            push bp
		push es
		push ax
		push bx
		push cx
		push dx
		push di
mov ax,1000
lop2211:
mov cx,4000
loop11:
dec cx
cmp cx,0
jg loop11
dec ax
cmp ax,0
jg lop2211
   pop di
		pop dx
		pop cx
		pop bx
		pop ax
		pop es
		pop bp
ret

delay:
            push bp
            mov bp,sp
		push es
		push ax
		push bx
		push cx
		push dx
		push di

mov ax,300
cmp ax,[cs:speed]
jg subt
mov ax,0
jmp lop221
subt: 
sub ax,[cs:speed]
lop221:
mov cx,4000
loop1:
dec cx
cmp cx,0
jg loop1
dec ax
cmp ax,0
jg lop221
            pop di
		pop dx
		pop cx
		pop bx
		pop ax
		pop es
		pop bp
ret 2

;-------------------------------------movment ---------------------------------------
movment:
push bp
push ax
push bx
push cx 
push dx 
push ds
push di
push si
call scroolDown
push word[cs:speed]
call delay
;inc word[cs:trackcou]
pop si
pop di
pop ds
pop dx
pop cx
pop bx
pop ax
pop bp
ret 
;------------------------------------pause game-------------------------------------
paus:
 push bp
		push es
		push ax
		push bx
		push cx
		push dx
		push di
mov ax,28
mov [cs:left],ax
mov bx,138
mov [cs:right],bx
mov ax,[cs:left]
sub ax,10
mov [cs:leftlim],ax
mov ax,[cs:right]
sub ax,10
mov [cs:rightlim],ax
mov ax,250
mov [cs:speed],ax
mov word[cs:trackcou],0
sub word[currpos],2
dec word[num]
call loadDs
call longdelay
pop di
		pop dx
		pop cx
		pop bx
		pop ax
		pop es
		pop bp
ret
;------------------------------------------------------------------------------------
startscreen:
push es
		push ax
		push bx
		push cx
		push dx
		push di
       call Intro
fuv:
	mov ah,00									; getcha
int 16h
call secmak
call longdelay
mov ax,3232h
push ax
mov bp,sp
call loadDs

            pop di
		pop dx
		pop cx
		pop bx
		pop ax
		pop es
		pop bp
ret

;-------------------------------------timer------------------------------------

printnum:	push bp
		mov bp, sp
		push es
		push ax
		push bx
		push cx
		push dx
		push di

		mov ax, 0xb800
		mov es, ax
		mov ax, [bp+4]
		mov bx, 10
		mov cx, 0

nextdigit:	mov dx, 0
		div bx
		add dl, 0x30
		push dx
		inc cx
		cmp ax, 0
		jnz nextdigit

		mov di, 140

nextpos:	pop dx
		mov dh, 0x07
		mov [es:di], dx
		add di, 2
		loop nextpos

		pop di
		pop dx
		pop cx
		pop bx
		pop ax
		pop es
		pop bp
		ret 2


; veriable---------------------------------------------------------------------------
timestart: db 0
tickcount:  dw  2020h
tickcount1: dd 0
boool: dw 3232h
trackcou: dw 0
boool2: dw 2121h
num: dw 0
mii: dw 0
oldisr: dd 0
left: dw 28
right: dw 138
speed: dw 230
leftlim: dw 18 
rightlim: dw 148
terminate: db 0
currpos: dw 0
timer1: dd 0
;----------------------------------------------------------------------------------------7
res: db ' AUTO RACING GAME',0
res1: db 'QUALIFYING  SHEET',0
res2: db 'Pos',0
res3: db 'Name',0
res4:db 'No',0
res5: db 'Time',0
Mappositioner: dw 0    ;To Store Position of Map,and then update it Accordingly
Needleposition: dw 160
flag: dw 0
name_ask: db "Enter Your Name User :",0
message: db 10,13,'Player1: $',0,0
name_pos: dw  2444     ;Starting position
name_save: db 0
name_len: dw 0
second_save: dw 0
seconds: dw 0
timer_flag: dw 0
welcome:  db 'Hello ', 0 
whale:  db ' Welcome to CAR.io ', 0 
msg:  db 'Press any key to Continue  !', 0 
guide: db 'INSTRUCTIONS', 0
move: db 'Use UP ,DOWN,LEFT ,RIGHT arrow Keys to Move CAR ', 0
msg0: db 'CREATED BY: ', 0
msg1: db 'M.haris umer 21L-5269', 0
msg2: db 'M.bilal 21L-5499', 0
last: db 'Are you sure you Want to Exit ?', 0
last2: db 'Yes (y) / No (n) ', 0
buffer:		db 80
		db 0
		times 80 db 0
;----------------------------------------------------------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       SUBROUTINE FOR NAME ASK             ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
printstr:   push bp
            mov bp,sp
            push es
            push ax
            push cx
            push si
            push di

            push ds
            pop es
            mov di,[bp+4]
            mov cx,0xffff
            xor al,al
            repne scasb
            mov ax,0xffff
            sub ax,cx
            dec ax
            
            mov cx,ax
            mov ax,0xb800
            mov es,ax
            mov al,80
            mul byte [bp+8]
            add ax,[bp+10]
            shl ax,1
            mov di,ax
            mov si,[bp+4]
            mov ah,[bp+6]
            
            cld
nextchar:   lodsb
            stosw
            loop nextchar

exit_str:   pop di
            pop si
            pop cx
            pop ax
            pop es
            pop bp
            ret 8
printspeed:
push bp
            mov bp,sp
            push es
            push ax
            push cx
            push si
            push di
mov ax,1280
shl ax,1
push ax
mov ax,[speed]
push ax
call printnumber
 pop di
            pop si
            pop cx
            pop ax
            pop es
            pop bp
ret
;-------------------------------------------------
clrscr_gray: push es
		push ax
		push cx
		push di
		mov ax, 0xb800
		mov es, ax 			; point es to video base
		xor di, di 			; point di to top left column
		mov al,20h 			; space char in normal attribute
mov ah,01110011b
		mov cx, 2000 			; number of screen locations
		cld 				; auto increment mode
		rep stosw 			; clear the whole screen
		pop di 
		pop cx
		pop ax
		pop es
		ret 

;----------------------------------------------------
Welcome_Logo:
		
		pusha 

		mov ax, 0xb800
		mov es, ax
		mov ax, 0x0000
		mov di, 194
		mov word[es:di], ax
		add di, 160
		mov word[es:di], ax
		add di, 160
		mov word[es:di], ax
		add di, 160
		mov word[es:di], ax
		add di, 160
		mov word[es:di], ax
		add di, 2
		mov word[es:di], ax
		add di, 2
		mov word[es:di], ax
		add di, 2
		mov word[es:di], ax
		add di, 2
		mov word[es:di], ax
		sub di, 160
		mov word[es:di], ax
		sub di, 160
		mov word[es:di], ax
		add di, 322
		mov word[es:di], ax
		add di, 2
		mov word[es:di], ax
		add di, 2
		mov word[es:di], ax
		add di, 2
		mov word[es:di], ax
		sub di, 160
		mov word[es:di], ax
		sub di, 160
		mov word[es:di], ax
		sub di, 160
		mov word[es:di], ax
		sub di, 160
		mov word[es:di], ax

		add di, 4
		mov word[es:di], ax
		add di, 160
		mov word[es:di], ax
		add di, 160
		mov word[es:di], ax
		add di, 2
		mov word[es:di], ax
		add di, 2
		mov word[es:di], ax
		add di, 2
		mov word[es:di], ax
		add di, 2
		mov word[es:di], ax
		push di
		sub di, 8
		add di, 160
		mov word[es:di], ax
		add di, 160
		mov word[es:di], ax
		pop di
		add di, 2
		mov word[es:di], ax
		sub di, 160
		mov word[es:di], ax
		sub di, 160
		mov word[es:di], ax
		add di, 320
		add di, 160
		mov word[es:di], ax
		add di, 160
		mov word[es:di], ax
		add di, 4
		
		mov word[es:di], ax
		sub di, 160
		mov word[es:di], ax
		sub di, 160
		mov word[es:di], ax
		sub di, 160
		mov word[es:di], ax
		sub di, 160
		mov word[es:di], ax
		add di, 2
		mov word[es:di], ax
		add di, 2
		mov word[es:di], ax
		add di, 2
		mov word[es:di], ax
		add di, 2
		mov word[es:di], ax

		add di, 160	
		mov word[es:di], ax
		
		add di, 160	
		mov word[es:di], ax
		push di
		sub di, 2
		mov word[es:di], ax
		sub di, 2
		mov word[es:di], ax
		sub di, 2
		mov word[es:di], ax
		pop di
		add di, 160	
		mov word[es:di], ax

		add di, 160	
		mov word[es:di], ax
		
		add di, 4
		mov word[es:di], ax
		push di
		sub di, 160
		mov word[es:di], ax
		sub di, 160
		mov word[es:di], ax
		sub di, 160
		mov word[es:di], ax
		sub di, 160
		mov word[es:di], ax
		pop di
		add di, 2
		mov word[es:di], ax
		add di, 2
		mov word[es:di], ax
		add di, 2
		mov word[es:di], ax
		add di, 2
		mov word[es:di], ax
	
		add di, 4
		mov word[es:di], ax
		push di
		sub di, 160
		mov word[es:di], ax
		sub di, 160
		mov word[es:di], ax
		add di, 2
		mov word[es:di], ax
		add di, 2
		mov word[es:di], ax
		add di, 2
		mov word[es:di], ax
		sub di, 6
		sub di, 160
		mov word[es:di], ax
		sub di, 160
		mov word[es:di], ax
		add di, 2
		mov word[es:di], ax
		add di, 2
		mov word[es:di], ax
		add di, 2
		mov word[es:di], ax
		sub di, 6
		pop di
		add di, 2
		mov word[es:di], ax
		add di, 2
		mov word[es:di], ax
		add di, 2
		mov word[es:di], ax
		add di, 6
		mov word[es:di], ax
		add di, 6
		mov word[es:di], ax
		push di
		sub di, 160
		mov word[es:di], ax
		sub di, 160
		mov word[es:di], ax
		sub di, 320
		mov word[es:di], ax
		
		pop di
		add di, 4
		mov word[es:di], ax

		sub di, 160
		mov word[es:di], ax
		sub di, 160
		mov word[es:di], ax
		add di, 2
		mov word[es:di], ax
		add di, 2
		mov word[es:di], ax
		add di, 2
		mov word[es:di], ax
		add di, 160
		mov word[es:di], ax
		add di, 160
		mov word[es:di], ax
		sub di, 2
		mov word[es:di], ax
		sub di, 2
		mov word[es:di], ax
		sub di, 2
		mov word[es:di], ax
		
		
		
			
		popa 
		ret
;------------------------------------------------
;----------------------------------------------------
Welcome_Screen:	
		
		pusha
		
		mov ax, 38
		push ax 	; push x position
		mov ax, 8
		push ax 	; push y position
		mov ax, 0x30    ; blue on white
		push ax 	; push attribute
		mov ax, buffer+2
		push ax 	; push offset of string
		call printstr   ; print the string
		

		mov ax, 32
		push ax 	; push x position
		mov ax, 8
		push ax 	; push y position
		mov ax, 0x30   ; blue on white
		push ax 	; push attribute
		mov ax, welcome
		push ax 	; push offset of string
		call printstr   ; print the string


		
		mov ax, 29
		push ax 	; push x position
		mov ax, 10
		push ax 	; push y position
		mov ax, 0x30   ; blue on white
		push ax 	; push attribute
		mov ax, whale
		push ax 	; push offset of string
		call printstr   ; print the string

		mov ax, 31
		push ax 	; push x position
		mov ax, 12
		push ax 	; push y position
		mov ax, 0x34    ; blue on white
		push ax 	; push attribute
		mov ax, guide
		push ax 	; push offset of string
		call printstr   ; print the string

		mov ax, 18
		push ax 	; push x position
		mov ax, 14
		push ax 	; push y position
		mov ax, 0x30    ; blue on white
		push ax 	; push attribute
		mov ax, move
		push ax 	; push offset of string
		call printstr   ; print the string


		


		
		mov ax,22
		push ax 	; push x position
		mov ax, 20
		push ax 	; push y position
		mov ax, 0xF4   ; blue on white
		push ax 	; push attribute
		mov ax, msg
		push ax 	; push offset of string
		call printstr   ; print the string

		mov ax, 40
		push ax 	; push x position
		mov ax, 22
		push ax 	; push y position
		mov ax, 0x30    ; blue on white
		push ax 	; push attribute
		mov ax, msg0
		push ax 	; push offset of string
		call printstr   ; print the string

		mov ax, 54
		push ax 	; push x position
		mov ax, 23
		push ax 	; push y position
		mov ax, 0x30   ; blue on white
		push ax 	; push attribute
		mov ax, msg1
		push ax 	; push offset of string
		call printstr   ; print the string
	


		mov ax,54
		push ax 	; push x position
		mov ax, 24
		push ax 	; push y position
		mov ax, 0x30   ; red on white blinkingF4
		push ax 	; push attribute
		mov ax, msg2
		push ax 	; push offset of string
		call printstr 	; print the string

		call Welcome_Logo

		popa
		
	ret
;-----------------------------------------------------

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;      SUBROUTINE TO WRITE NAME             ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Name: 
	call clrscr
       
	 
		
		pusha
		
		mov ax, 0
		push ax 	; push x position
		mov ax, 22
		push ax 	; push y position
		mov ax, 07 	; blue on black
		push ax 	; push attribute
		mov ax, name_ask
		push ax 	; push offset of string
		call printstr  ; print the stri
		mov dx, buffer
		mov ah, 0x0A
		int 0x21

		mov bh, 0
		mov bl, [buffer +1]
		mov byte[buffer+2+bx], '$'

		
		mov dx, message		;;storing User Input in Buffer
					;; You can can print anytime Buffer anywhere because UserInput is Stored in Buffer
		mov ah, 9
		int 0x21
		mov dx,buffer 
		mov ah, 9
		int 0x21 
		
		mov ah, 0 		; service 0 – get keystroke
		int 0x16 		; call BIOS keyboard service

		popa
		ret


;---------------------------------------------------------
Intro:
		call clrscr
		call Name
		call clrscr_gray
		call Welcome_Screen	
		ret
;-------------------------------------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       SUBROUTINE TO CLEAR SCREEN           ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

clrscr: 
    push es
    push ax
    push di
    mov ax,0xb800
    mov es,ax
    mov di,0

nextloc:
	mov word [es:di],0x0720
	add di,2
	cmp di,4000
	jne nextloc
	
	pop di
	pop ax
	pop es
	ret
;-----------------------------------------------
;-------------------------------------------------
clrscr_: push es
		push ax
		push cx
		push di
		mov ax, 0xb800
		mov es, ax 			; point es to video base
		xor di, di 			; point di to top left column
		mov al,'|'			; space char in normal attribute
mov ah,11000000b
		mov cx, 2000 			; number of screen locations
		cld 				; auto increment mode
		rep stosw 			; clear the whole screen
		pop di 
		pop cx
		pop ax
		pop es
		ret 
;-------------------------------------------------
endscreen:
            push bp
		push es
		push ax
		push bx
		push cx
		push dx
		push di
call clrscr_
mov ax,330
push ax
mov ax,20
push ax
mov ax,140
push ax
mov al,20h
mov ah,00000000b
push ax
mov bp,sp
call ract
mov ax,6
push ax
mov ax,2
push ax
mov ax,0
mov ah,00001111b
push ax
mov ax,line1
push ax
call printstr2
call printPos
call printname
call printTime
mov ah,00
int 16h
   pop di
		pop dx
		pop cx
		pop bx
		pop ax
		pop es
		pop bp
ret
bool2: db 0
printTime:
push bp
            mov bp,sp
            push es
            push ax
            push cx
            push si
            push di
;1---------------------------------------------------------------

mov ax,730
push ax
mov ax,[time1]
cmp ax,[tickcount1]
jge change1
ch12:
push ax
call printnumber
jmp  ch2
change1:
cmp byte[bool2],0
jne ch12
mov ax,[tickcount1]
push ax
call printnumber
mov ax,11
push ax
mov ax,20
push ax
mov ax,0
mov ah,00001111b
push ax
mov ax,buffer
push ax
call printstr2
;2---------------------------------------------------------------
ch2:
mov ax,1040
push ax
mov ax,[time2]
cmp ax,[tickcount1]
jge change2
ch23:
push ax
call printnumber
jmp ch3
change2:
cmp byte[bool2],0
jne ch23
mov ax,[tickcount1]
push ax
call printnumber
mov ax,11
push ax
mov ax,20
push ax
mov ax,0
mov ah,00001111b
push ax
mov ax,buffer
push ax
call printstr2
;3---------------------------------------------------------------
ch3:
mov ax,1360
push ax
mov ax,[time3]
cmp ax,[tickcount1]
jge change3
ch34:
push ax
call printnumber
jmp ch4
change3:
cmp byte[bool2],0
jne ch34
mov ax,[tickcount1]
push ax
call printnumber
mov ax,11
push ax
mov ax,20
push ax
mov ax,0
mov ah,00001111b
push ax
mov ax,buffer
push ax
call printstr2
;4---------------------------------------------------------------
ch4:
mov ax,1680
push ax
mov ax,[time4]
cmp ax,[tickcount1]
jge change4
ch45:
push ax
call printnumber
jmp ch5
change4:
cmp byte[bool2],0
jne ch45
mov ax,[tickcount1]
push ax
call printnumber
mov ax,11
push ax
mov ax,20
push ax
mov ax,0
mov ah,00001111b
push ax
mov ax,buffer
push ax
call printstr2
;5---------------------------------------------------------------
ch5:
mov ax,2000
push ax
mov ax,[time5]
cmp ax,[tickcount1]
jge change5
ch56:
push ax
 call printnumber
jmp ch6
change5:
cmp byte[bool2],0
jne ch56
mov ax,[tickcount1]
push ax
call printnumber
mov ax,11
push ax
mov ax,20
push ax
mov ax,0
mov ah,00001111b
push ax
mov ax,buffer
push ax
call printstr2
;6---------------------------------------------------------------
ch6:
mov ax,2320
push ax
mov ax,[time6]
cmp ax,[tickcount1]
jge change6
ch67:
push ax
call printnumber
jmp ch7
change6:
cmp byte[bool2],0
jne ch67
mov ax,[tickcount1]
push ax
call printnumber
mov ax,11
push ax
mov ax,14
push ax
mov ax,0
mov ah,00001111b
push ax
mov ax,buffer
push ax
call printstr2
;7---------------------------------------------------------------
ch7:
mov ax,2640
push ax
mov ax,[time7]
cmp ax,[tickcount1]
jge change7
ch78:
push ax
call printnumber
jmp ch8
change7:
cmp byte[bool2],0
jne ch78
mov ax,[tickcount1]
push ax
call printnumber
mov ax,11
push ax
mov ax,16
push ax
mov ax,0
mov ah,00001111b
push ax
mov ax,buffer
push ax
call printstr2
;8---------------------------------------------------------------
ch8:
mov ax,2960
push ax
mov ax,[time8]
cmp ax,[tickcount1]
jge change8
ch89:
push ax
call printnumber
jmp ch9
change8:
cmp byte[bool2],0
jne ch89
mov ax,[tickcount1]
push ax
call printnumber
mov ax,11
push ax
mov ax,18
push ax
mov ax,0
mov ah,00001111b
push ax
mov ax,buffer
push ax
call printstr2
;9---------------------------------------------------------------
ch9:
mov ax,3280
push ax
mov ax,[time9]
cmp ax,[tickcount1]
jge change9
push ax
call printnumber
jmp exitt4
change9:
cmp byte[bool2],0
jne exitt4
mov ax,[tickcount1]
push ax
call printnumber
mov ax,11
push ax
mov ax,20
push ax
mov ax,0
mov ah,00001111b
push ax
mov ax,buffer
push ax
call printstr2

exitt4:
pop di
            pop si
            pop cx
            pop ax
            pop es
            pop bp
ret
printname:
push bp
            mov bp,sp
            push es
            push ax
            push cx
            push si
            push di
;1--------------------------------------------------------
mov ax,11
push ax
mov ax,4
push ax
mov ax,0
mov ah,00001111b
push ax
mov ax,name1 
push ax
call printstr2
;2---------------------------------------------------------
mov ax,11
push ax
mov ax,6
push ax
mov ax,0
mov ah,00001111b
push ax
mov ax,name2
push ax
call printstr2
;3-----------------------------------------------------------
mov ax,11
push ax
mov ax,8
push ax
mov ax,0
mov ah,00001111b
push ax
mov ax,name3
push ax
call printstr2
;4-----------------------------------------------------------
mov ax,11
push ax
mov ax,10
push ax
mov ax,0
mov ah,00001111b
push ax
mov ax,name4 
push ax
call printstr2
;5-----------------------------------------------------------
mov ax,11
push ax
mov ax,12
push ax
mov ax,0
mov ah,00001111b
push ax
mov ax,name5
push ax
call printstr2
;6-----------------------------------------------------------
mov ax,11
push ax
mov ax,14
push ax
mov ax,0
mov ah,00001111b
push ax
mov ax,name6
push ax
call printstr2
;7-----------------------------------------------------------
mov ax,11
push ax
mov ax,16
push ax
mov ax,0
mov ah,00001111b
push ax
mov ax,name8
push ax
call printstr2
;8-----------------------------------------------------------
mov ax,11
push ax
mov ax,18
push ax
mov ax,0
mov ah,00001111b
push ax
mov ax,name8
push ax
call printstr2
;9-----------------------------------------------------------
mov ax,11
push ax
mov ax,20
push ax
mov ax,0
mov ah,00001111b
push ax
mov ax,name10
push ax
call printstr2



pop di
            pop si
            pop cx
            pop ax
            pop es
            pop bp
ret
;------------------------------------------------------------------

printPos:
push bp
            mov bp,sp
            push es
            push ax
            push cx
            push si
            push di
mov ax,cs
mov ds,ax
;1--------------------------------------------------------
mov di,332
mov ax,0xb800
mov es,ax
mov ah,00001111b
mov al,byte[posi]
add al,30h
inc byte[posi]
add di,160
add di,160
mov word[es:di],ax
mov ax,11
push ax
mov ax,4
push ax
mov ax,0
mov ah,00001111b
push ax
mov ax,posi 
add ax,1
push ax
call printstr2
;2---------------------------------------------------------
mov ah,00001111b
mov al,byte[posi]
add al,30h
inc byte[posi]
add di,160
add di,160
mov word[es:di],ax
mov ax,11
push ax
mov ax,6
push ax
mov ax,0
mov ah,00001111b
push ax
mov ax,posi 
add ax,1
push ax
call printstr2
;3-----------------------------------------------------------
mov ah,00001111b
mov al,byte[posi]
add al,30h
inc byte[posi]
add di,160
add di,160
mov word[es:di],ax
mov ax,11
push ax
mov ax,8
push ax
mov ax,0
mov ah,00001111b
push ax
mov ax,posi 
add ax,1
push ax
call printstr2
;4-----------------------------------------------------------
mov ah,00001111b
mov al,byte[posi]
add al,30h
inc byte[posi]
add di,160
add di,160
mov word[es:di],ax
mov ax,11
push ax
mov ax,10
push ax
mov ax,0
mov ah,00001111b
push ax
mov ax,posi 
add ax,1
push ax
call printstr2
;5-----------------------------------------------------------
mov ah,00001111b
mov al,byte[posi]
add al,30h
inc byte[posi]
add di,160
add di,160
mov word[es:di],ax
mov ax,11
push ax
mov ax,12
push ax
mov ax,0
mov ah,00001111b
push ax
mov ax,posi 
add ax,1
push ax
call printstr2
;6-----------------------------------------------------------
mov ah,00001111b
mov al,byte[posi]
add al,30h
inc byte[posi]
add di,160
add di,160
mov word[es:di],ax
mov ax,11
push ax
mov ax,14
push ax
mov ax,0
mov ah,00001111b
push ax
mov ax,posi 
add ax,1
push ax
call printstr2
;7-----------------------------------------------------------
mov ah,00001111b
mov al,byte[posi]
add al,30h
inc byte[posi]
add di,160
add di,160
mov word[es:di],ax
mov ax,11
push ax
mov ax,16
push ax
mov ax,0
mov ah,00001111b
push ax
mov ax,posi 
add ax,1
push ax
call printstr2
;8-----------------------------------------------------------
mov ah,00001111b
mov al,byte[posi]
add al,30h
inc byte[posi]
add di,160
add di,160
mov word[es:di],ax
mov ax,11
push ax
mov ax,18
push ax
mov ax,0
mov ah,00001111b
push ax
mov ax,posi 
add ax,1
push ax
call printstr2
;9-----------------------------------------------------------
mov ah,00001111b
mov al,byte[posi]
add al,30h
inc byte[posi]
add di,160
add di,160
mov word[es:di],ax
mov ax,11
push ax
mov ax,20
push ax
mov ax,0
mov ah,00001111b
push ax
mov ax,posi 
add ax,1
push ax
call printstr2

pop di
            pop si
            pop cx
            pop ax
            pop es
            pop bp
ret
printnumber:	
push bp
		mov bp, sp
		push es
		push ax
		push bx
		push cx
		push dx
		push di

		mov ax, 0xb800
		mov es, ax
		mov ax, [bp+4]
		mov bx, 10
		mov cx, 0

nextdigit1:	mov dx, 0
		div bx
		add dl, 0x30
		push dx
		inc cx
		cmp ax, 0
		jnz nextdigit1

		mov di, [bp+6]

nextpos1:	pop dx
		mov dh, 0x07
		mov [es:di], dx
		add di, 2
		loop nextpos1

		pop di
		pop dx
		pop cx
		pop bx
		pop ax
		pop es
		pop bp
		ret 4
;=======================================================================


;----------------------------variable----------------------------------
line1: db 'Pos          Name                    time',0 
posi: db 1,'    |',0
name1: db 'Joseph Joestar  |',0 
name2: db 'Hikigaya        |',0
name3: db 'Rimru tempist   |',0
name4: db 'Vinsmok Sanji   |',0
name5: db 'Roronoa Zoro    |',0
name6: db 'Homelender      |',0
name7: db 'Peter Grifen    |',0
name8: db 'Son Goku        |',0
;name8: db 'Asta Reaper    |',0
name9: db 'Light yagami    |',0
name10:db 'Monkey D luffy  |',0
time1: dd  14708
time2: dd  27849
time3: dd  28239
time4: dd  29329
time5: dd  31829
time6: dd  33239
time7: dd  42909
time8: dd  50349
time9: dd  53929
time10: dd 53949
;--------------------------------------------------------------------------------
printstr2:   push bp
            mov bp,sp
            push es
            push ax
            push cx
            push si
            push di

            push ds
            pop es
            mov di,[bp+4]
            mov cx,0xffff
            mov al,0
            repne scasb
            mov ax,0xffff
            sub ax,cx
            dec ax
            
            mov cx,ax
            mov ax,0xb800
            mov es,ax
            mov al,80
            mul byte [bp+8]
            add ax,[bp+10]
            shl ax,1
            mov di,ax
            mov si,[bp+4]
            mov ax,[bp+6]
            

            cld
nextchar2:   
mov al,[si]
            stosw
add si,1
            loop nextchar2

exit_str4:   pop di
            pop si
            pop cx
            pop ax
            pop es
            pop bp
            ret 8
;--------------------------------start--------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;start;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
start1:
call startscreen
mov byte[timestart],1
l1:
mov ax,0
in al,0x60
inc word [cs:tickcount1]
push word [cs:tickcount1]
call printnum
push ax
call kbsir
cmp byte[cs:terminate],0
je l1
call endscreen
mov ax,0x4c00
int 21h