
SCROLL MACRO X, Y, EX, EY
	MOV AX, 0601h    ; Scroll up function
	MOV CH, Y     ; Upper left corner CH=row, CL=column
	MOV CL, X
	MOV DH, EY   ; lower right corner DH=row, DL=column
	MOV DL, EX
	MOV BH, 07    
	INT 10H
ENDM SCROLL


SENDING MACRO VALUE
LOCAL AGAINsend
;PUSHA
;Check that Transmitter Holding Register is Empty
	mov dx,3FDH		; Line Status Register
AGAINsend:
	In al,dx 			;Read Line Status
  	AND al,00100000b
  	JZ AGAINsend

;If empty put the VALUE in Transmit data register
  	mov dx,3F8H		; Transmit data register
  	mov al,VALUE
  	out dx,al 
;POPA
ENDM SENDING

RECEIVING MACRO VALUE
LOCAL FINISHrec
LOCAL READrecc
	;PUSHA
  ;CHECK THAT DATA READY
  MOV DX,3FDH		; LINE STATUS REGISTER
  IN AL,DX 
  AND AL,1
  JNZ READrecc 
  JMP FINISHrec

  READrecc:
  ;IF READY READ THE VALUE IN RECEIVE DATA REGISTER
	MOV DX,03F8H
	IN AL,DX 
	MOV VALUE,AL

  FINISHrec:
	;POPA
ENDM RECEIVING

setCursor MACRO x,y
mov ah,2
mov bh,0
mov dl,x
mov dh,y
int 10h
ENDM setCursor
;=================================== End of chat macros =========================================

bstatusbar macro string
push ax
push dx
mov ah,2
mov dl,226
mov dh,10
int 10h

mov ah,9 
mov dx,offset string
int 21h

pop dx
pop ax
endm

wstatusbar macro string
push ax
push dx
mov ah,2
mov dl,226
mov dh,23
int 10h

mov ah,9 
mov dx,offset string
int 21h

pop dx
pop ax
endm

drawstatline macro x,y,max
local line
push ax
push cx
push dx

    mov ah,0ch 
    mov al,0fh 
    mov cx,x
    mov dx,y
    line:
    int 10h
    inc cx
    cmp cx,max
    jnz line
    pop dx
    pop cx
    pop ax
endm

drawvertline macro x,y,max
local line
push ax
push cx
push dx

    mov ah,0ch 
    mov al,0fh 
    mov cx,x
    mov dx,y
    line:
    int 10h
    inc dx
    cmp dx,max
    jnz line
    pop dx
    pop cx
    pop ax
endm

printwhitestatus macro
    mov ah,2
    mov dl,226
    mov dh,13
    int 10h

    mov ah,9 
    mov dx,offset nowpawnkill
    int 21h

    mov ah,2
    mov dl,227
    mov dh,13
    int 10h

    mov ah,9 
    mov dx,offset wpawnid
    int 21h
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    mov ah,2
    mov dl,226
    mov dh,15
    int 10h

    mov ah,9 
    mov dx,offset nowknightkill
    int 21h

    mov ah,2
    mov dl,227
    mov dh,15
    int 10h

    mov ah,9 
    mov dx,offset wknightid
    int 21h
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    mov ah,2
    mov dl,226
    mov dh,17
    int 10h

    mov ah,9 
    mov dx,offset nowbishopkill
    int 21h

    mov ah,2
    mov dl,227
    mov dh,17
    int 10h

    mov ah,9 
    mov dx,offset wbishopid
    int 21h
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    mov ah,2
    mov dl,226
    mov dh,19
    int 10h

    mov ah,9 
    mov dx,offset nowqueenkill
    int 21h

    mov ah,2
    mov dl,227
    mov dh,19
    int 10h

    mov ah,9 
    mov dx,offset wqueenid
    int 21h
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    mov ah,2
    mov dl,226
    mov dh,21
    int 10h

    mov ah,9 
    mov dx,offset nowrookkill
    int 21h

    mov ah,2
    mov dl,227
    mov dh,21
    int 10h

    mov ah,9 
    mov dx,offset wrookid
    int 21h
    endm

printblackstatus macro
    mov ah,2
    mov dl,226
    mov dh,0
    int 10h

    mov ah,9 
    mov dx,offset nobpawnkill
    int 21h

    mov ah,2
    mov dl,227
    mov dh,0
    int 10h

    mov ah,9 
    mov dx,offset bpawnid
    int 21h
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    mov ah,2
    mov dl,226
    mov dh,2
    int 10h

    mov ah,9 
    mov dx,offset nobknightkill
    int 21h

    mov ah,2
    mov dl,227
    mov dh,2
    int 10h

    mov ah,9 
    mov dx,offset bknightid
    int 21h
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    mov ah,2
    mov dl,226
    mov dh,4
    int 10h

    mov ah,9 
    mov dx,offset nobbishopkill
    int 21h

    mov ah,2
    mov dl,227
    mov dh,4
    int 10h

    mov ah,9 
    mov dx,offset bbishopid
    int 21h
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    mov ah,2
    mov dl,226
    mov dh,6
    int 10h

    mov ah,9 
    mov dx,offset nobqueenkill
    int 21h

    mov ah,2
    mov dl,227
    mov dh,6
    int 10h

    mov ah,9 
    mov dx,offset bqueenid
    int 21h
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    mov ah,2
    mov dl,226
    mov dh,8
    int 10h

    mov ah,9 
    mov dx,offset nobrookkill
    int 21h

    mov ah,2
    mov dl,227
    mov dh,8
    int 10h

    mov ah,9 
    mov dx,offset brookid
    int 21h
    endm

stringcolour macro string,place,length,colour ;macro to print string with colour
    local print
    push es ;save segment register
    mov ax,0b800h
    mov es,ax
    lea si,string ;string to be printed
    mov cx,length ;length of string
    mov ah,colour ;white colour
    mov di,place  ;adjusts the place where the string should be printed
    
    print:
    lodsb
    stosw     ;loop to print string
    dec cx
    jne print
    pop es 
    ENDM

drawpicture macro filename,filehandle,width,height,data,x,y
    push ax
    push bx
    push cx
    push dx
    push di 
    push si

    mov  dx ,offset filename
    mov di , offset filehandle
    CALL OpenFile
    mov cx ,width*height
    lea DX,data
    mov bx ,offset filehandle
    CALL ReadData
    
    mov ax,00h
    MOV CX,x
    MOV DX,y
    mov di , cx
    MOV AH,0ch
    mov si,offset data
    ;mov BX , si ; BL contains index at the current drawn pixel
	  mov bx ,00h
    mov bl ,height
    mov bp , bx
    add bp , dx
    add bx,cx
  
    ;mov di,0
    call Drawing

  MOV BX,[filehandle]
    call CloseFile

    pop si
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    endm
;------------------------------------------convert25toindex---------------------------------------------
  ; function convert (cx,dx) coordinates into arrayboard index without affecting cx or dx 
  ; store the index in di and store the piece code of this index in bl (affects di and bl)

  convert25toindex macro 
  push cx
  push dx
  push ax
  push si
  push bp

  mov di,cx
  mov bx,dx
    mov dx, 0000h
    ; take the index of piece saved in di and bx
     mov ax,di
     mov si,25
     div si
     
     mov di,0000h
     mov di, ax
     
     mov ax,bx
     mov si,25
     div si 
     
     mov bp,8
     mul bp

     add di, ax
     mov bx,0 
     mov bl, arrayboard[di]   ; using bl to check the piece 

pop bp
pop si
pop ax     
pop dx
pop cx
     endm

     ;-------------------------------------------draw piece------------------------------------------------
Drawpiece macro pieceData
    push ax
    push bx
    push si
    push bp
    push di
    push cx
    push dx

    call clearCellWithGreenOrWhite
    ;call DrawFrame

    mov ax, 00h
    mov di, cx
    mov ah, 0ch
    mov si, offset pieceData
    ;mov BX , si ; BL contains index at the current drawn pixel
	  mov bx, 00h
    
    mov bl, pieceHeight
    mov bp, bx
    add bp, dx
    add bx, cx

    call Drawing
   
    pop dx
    pop cx
    pop di
    pop bp
    pop si
    pop bx
    pop ax
endm 
;---------------------------------------------------------------------------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  End of macros  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;include utility.inc
.Model Small
.Stack 64
.Data
;chat module
    LINE  DB 80 DUP('-'),'$'
    value db ?
    ys db 0
    xs db 0
    xr db 0
    yr db 0DH
    SPACE DB ' ', '$'
    CHAR DB '$', '$'
    REsCHAR DB '$', '$'
;;;;;;;;;;;;;;;;;;;
;Inline chat 
    ysInline db 2
    xsInline db 229
    xrInline db 229
    yrInline db 13
;;;;;;;;;;;;;;;;;;;
hblx dw   0              
hbly dw   0                

 oneThirdtimeWidth EQU 15
 oneThirdtimeHeight EQU 15
 oneThirdtimeFilename DB 'images\clk1.bin', 0
 oneThirdtimeFilehandle DW ?
 oneThirdtimeData DB oneThirdtimeWidth*oneThirdtimeWidth dup(0)

 TwoThirdtimeWidth EQU 15
 TwoThirdtimeHeight EQU 15
 TwoThirdtimeFilename DB 'images\clk2.bin', 0
 TwoThirdtimeFilehandle DW ?
 TwoThirdtimeData DB TwoThirdtimeWidth*TwoThirdtimeWidth dup(0)

 FulltimeWidth EQU 15
 FulltimeHeight EQU 15
 FulltimeFilename DB 'images\clk4.bin', 0
 FulltimeFilehandle DW ?
 FulltimeData DB FulltimeHeight*FulltimeWidth dup(0)

 zero db 1
one db 1
two db 1
three db 1
four db 1
five db 1
six db 1
seven db 1
eight db 1
nine db 1
ten db 1

eleven db 1
twelve db 1
thirteen db 1
fourteen db 1
fifteen db 1
sixteen db 1
seventeen db 1
eighten db 1
nineteen db 1

twenty db 1
twentyone db 1
twentytwo db 1
twentythr db 1
twentyfou db 1
twentyfiv db 1
twentysix db 1
twentysev db 1
twentyeig db 1
twentynin db 1

thirty db 1
thirtyon db 1
thirtytw db 1
thirtythr db 1
thirtyfou db 1
thirtyfiv db 1
thirtysix db 1
thirtysev db 1
thirtyeig db 1
thirtynin db 1

fourty db 1
fourtyon db 1
fourtytw db 1
fourtythr db 1
fourtyfou db 1
fourtyfiv db 1
fourtysix db 1
fourtysev db 1
fourtyeig db 1
fourtynin db 1

fifty db 1
fiftyon db 1
fiftytw db 1
fiftythr db 1
fiftyfou db 1
fiftyfiv db 1
fiftysix db 1
fiftysev db 1
fiftyeig db 1
fiftynin db 1

sixty db 1
sixtyon db 1
sixtytw db  1
sixtythr db 1

TimerArray db 64 dup(3)
currentTime db 99
previousTime db 99
;board 
arrayboard  db 64 dup (0)
arrvalid  db 64 dup (0)                  ;0 means not valid but 1 means valid
arrvalidwhite  db 64 dup (0)             ;0 means not valid but 1 means valid
xWhite dw 175
yWhite dw 175
xBlack dw 0
yBlack dw 0
xWhiteOld dw 175
yWhiteOld dw 175
xBlackOld dw 0
yBlackOld dw 0
qFlag db 0000h                ;indicate weather player 2 has selected or not
mFlag db 0000h        
whichQ db 0000h               ;first q = 0              second q = 1
whichM db 0000h 
firstToMoveFlag db 0000h      ; if(1)->black is the first  ,but if(2)->white is the first

boardWidth EQU 200
boardHeight EQU 200
boardFilename DB 'images\new.bin', 0
boardFilehandle DW ?
boardData DB boardWidth*boardHeight dup(0)
;blackrook
pieceWidth EQU 25
pieceHeight EQU 25
blackrookFilename DB 'images\bbr.bin', 0
blackrookFilehandle DW ?
blackrookData DB pieceWidth*pieceHeight dup(0)
;blackhorse
pieceWidth EQU 25
pieceHeight EQU 25
blackhorseFilename DB 'images\bbkn.bin', 0
blackhorseFilehandle DW ?
blackhorseData DB pieceWidth*pieceHeight dup(0)
;blackbishop
pieceWidth EQU 25
pieceHeight EQU 25
blackbishopFilename DB 'images\bii.bin', 0
blackbishopFilehandle DW ?
blackbishopData DB pieceWidth*pieceHeight dup(0)
;blackqueen
pieceWidth EQU 25
pieceHeight EQU 25
blackqueenFilename DB 'images\bbq.bin', 0
blackqueenFilehandle DW ?
blackqueenData DB pieceWidth*pieceHeight dup(0)
;blackking
pieceWidth EQU 25
pieceHeight EQU 25
blackkingFilename DB 'images\bbk.bin', 0
blackkingFilehandle DW ?
blackkingData DB pieceWidth*pieceHeight dup(0)
;blackpawn
pieceWidth EQU 25
pieceHeight EQU 25
blackpawnFilename DB 'images\bbp.bin', 0
blackpawnFilehandle DW ?
blackpawnData DB pieceWidth*pieceHeight dup(0)
;--------------------------------------------------------
;whiterook
pieceWidth EQU 25
pieceHeight EQU 25
whiterookFilename DB 'images\wbr.bin', 0
whiterookFilehandle DW ?
whiterookData DB pieceWidth*pieceHeight dup(0)
;whiteknight
pieceWidth EQU 25
pieceHeight EQU 25
whiteknightFilename DB 'images\wbk.bin', 0
whiteknightFilehandle DW ?
whiteknightData DB pieceWidth*pieceHeight dup(0)
;whitebishop
pieceWidth EQU 25
pieceHeight EQU 25
whitebishopFilename DB 'images\wbi.bin', 0
whitebishopFilehandle DW ?
whitebishopData DB pieceWidth*pieceHeight dup(0)
;whitequeen
pieceWidth EQU 25
pieceHeight EQU 25
whitequeenFilename DB 'images\wbq.bin', 0
whitequeenFilehandle DW ?
whitequeenData DB pieceWidth*pieceHeight dup(0)
;whiteking
pieceWidth EQU 25
pieceHeight EQU 25
whitekingFilename DB 'images\wbkin.bin', 0
whitekingFilehandle DW ?
whitekingData DB pieceWidth*pieceHeight dup(0)
;whitepawn
pieceWidth EQU 25
pieceHeight EQU 25
whitepawnFilename DB 'images\wbp.bin', 0
whitepawnFilehandle DW ?
whitepawnData DB pieceWidth*pieceHeight dup(0)

reachingPieceFlag db 0

;GreenCell
pieceWidth EQU 25
pieceHeight EQU 25
GreenCellFilename DB 'images\Green.bin', 0
GreenCellFilehandle DW ?
GreenCellData DB pieceWidth*pieceHeight dup(0)

;GreyCell
pieceWidth EQU 25
pieceHeight EQU 25
GreyCellFilename DB 'images\Grey.bin', 0
GreyCellFilehandle DW ?
GreyCellData DB pieceWidth*pieceHeight dup(0)
;;;;;;;;;;;;;;;;;;;;;main screen;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
nam db 'Player 1, Please Enter your Name:','$'  
nam1 db 'Player 2, Please Enter your Name:','$'
vnm db 'Kindly Please Enter a valid Name:','$'
username db 16,?,30 dup('$')
username1 db 16,?,30 dup('$')
cont db 'Press Enter key to continue'
mes  db 'To start chatting press F1','$'
mes1 db 'To start the game press F2','$'
mes2 db 'To end the program press ESC','$'
mes3 db '--------------------------------------------------------------------------------','$'
mes4 db ' Has sent an invitation to start chat with ','$'
mes5 db ' Has sent an invitation to start game with ','$'
mes6 db '- To accept the invitation of chatting, Press F1     ','$'
mes7 db '- To accept the invitation of starting game, Press F2','$'
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;status bar;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
wpawn db ' wpawn->lost ','$'
wknight db 'wknight->lost','$'
wbishop db 'wbishop->lost','$'
wqueen db 'wqueen->lost ','$'
wrook db ' wrook->lost ','$'

bpaw db ' bpawn->lost ','$'
bhorse db 'bknight->lost','$'
bbshop db 'bbishop->lost','$'
Bquen db 'bqueen->lost ','$'
Brok db 'brook->lost','$'

gameover db '  GAME OVER  ','$'
wingame db '   YOU WON   ','$'

nowpawnkill db '0','$'
wpawnid db 'P','$'

nowknightkill db '0','$'
wknightid db 'K','$'

nowbishopkill db '0','$'
wbishopid db 'B','$'

nowqueenkill db '0','$'
wqueenid db 'Q','$'

nowrookkill db '0','$'
wrookid db 'R','$'

nobpawnkill db '0','$'
bpawnid db 'P','$'

nobknightkill db '0','$'
bknightid db 'K','$'

nobbishopkill db '0','$'
bbishopid db 'B','$'

nobqueenkill db '0','$'
bqueenid db 'Q','$'

nobrookkill db '0','$'
brookid db 'R','$'

whiteteam db 'white','$'
blackteam db 'black','$'

wkCheckmate db 'WK checkmate ','$'
bKcheckmate db 'BK checkmate','$'
gameoverFlag db 0            ;To be one if game ended

RESAH DB '$', '$'
SENDAH DB '$', '$'
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.Code
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; MAIN ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MAIN PROC FAR
    MOV AX , @DATA
    MOV DS , AX

push ax
push bx
push cx
push dx
push si
push di
push bp
;go to text mode
    mov ah, 0
    mov al, 3h
    int 10h 

stringcolour nam,0000,33,0fh

;set cursor position
mov ah,2
mov dx ,0102h
int 10h

; get the username
mov ah,0Ah
mov dx,offset username
int 21h  
cmp username+2,'A'
jc nvalid  
cmp username+2,'z'
jnc nvalid 
mov cx,6 
mov al,'['
mov dl,username+2
loop1:     
mov dl,username+2
     sub dl,al
     jz nvalid   
     inc al 
     dec cx  
     jnz loop1
jmp valid
nvalid:  
mov ax,0003h
int 10h
     stringcolour vnm,0000,33,0fh
     ;set cursor position
mov ah,2
mov dx ,0102h
int 10h
mov ah,0Ah
mov dx,offset username1
int 21h
cmp username+2,'A'
jc nvalid  
cmp username+2,'z'
jnc nvalid 
mov cx,6
mov al,'['
loop2:     
mov dl,username+2
     sub dl,al
     jz nvalid   
     inc al 
     dec cx  
     jnz loop2
;jmp nvalid
valid:
mov dx,0
mov bx,2
count:
lea si,username+[bx]
    lodsb
    cmp bx,17
    jz colour
    cmp al,32d
    jb colour
    cmp al,255d
    ja colour
    inc dx
    inc bx
    jmp count

colour:
stringcolour username+2,0164,dx,0fh
stringcolour cont,0640,27,0fh

mov ah,2
mov dx ,041Bh
int 10h

entr:
mov ah,0
int 16h
cmp al,0Dh
jnz entr

   call mainscreen
    
    call beforeEnd
MAIN ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;---------------------------------------initialize the game------------------------------------------
initializeTheGame proc

    ; call Graphics mode
    MOV AH, 0
    MOV AL, 13h
    INT 10h

;;;;;;;;;;;;;;;;;;;;;;;;prints the lines of the status bar;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    drawvertline 200,0,200
    drawvertline 319,0,200

    drawstatline 200,99,320
    drawstatline 200,80,320

    drawstatline 200,199,320
    drawstatline 200,181,320

    drawvertline 227,0,80
    drawvertline 227,99,181

;;;;;;;;;;;;;;;;;;;;;;;;;;prints status of pieces in status bar;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    mov ah,2
    mov dl,230
    mov dh,0
    int 10h

    mov ah,9 
    mov dx,offset blackteam
    int 21h

    mov ah,2
    mov dl,230
    mov dh,12
    int 10h

    mov ah,9 
    mov dx,offset whiteteam
    int 21h

    printblackstatus
    printwhitestatus
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  

    mov arrayboard[0],1d              ;bRook(1)
    mov arrayboard[1],2d              ;bKnight(2)
    mov arrayboard[2],3d              ;bBishop(3)
    mov arrayboard[3],4d              ;bQueeen(4)
    mov arrayboard[4],5d              ;bKing(5)
    mov arrayboard[5],3d          
    mov arrayboard[6],2d
    mov arrayboard[7],1d
    mov arrayboard[8],6d              ;bPawn(6)
    mov arrayboard[9],6d
    mov arrayboard[10],6d
    mov arrayboard[11],6d
    mov arrayboard[12],6d
    mov arrayboard[13],6d
    mov arrayboard[14],6d
    mov arrayboard[15],6d

    push di                           ;To put zero in empty cells after return to the game from main screen
    mov di,16
    nextEmptyCell:
    mov arrayboard[di],0
    inc di
    cmp di,48
    jne nextEmptyCell
    pop di

    mov arrayboard[63],7d              ;wRook(7)
    mov arrayboard[62],8d              ;wKnight(8)
    mov arrayboard[61],9d              ;wBishop(9)
    mov arrayboard[60],10d             ;wKing(10)
    mov arrayboard[59],11d             ;wQueen(11)
    mov arrayboard[58],9d
    mov arrayboard[57],8d
    mov arrayboard[56],7d
    mov arrayboard[55],12d             ;wPawn(12)
    mov arrayboard[54],12d
    mov arrayboard[53],12d
    mov arrayboard[52],12d
    mov arrayboard[51],12d
    mov arrayboard[50],12d
    mov arrayboard[49],12d
    mov arrayboard[48],12d

	  ;push all reg to be able to use them
    ;save file name in dx as the interupt need this
    ;save file handle in di to carry then file 
   
  drawpicture boardFilename,boardFilehandle,200,200,boardData,0,0 ;board
  ;-----------------------------------------------Black Pieces----------------------------------------
  drawpicture blackrookFilename,blackrookFilehandle,25,25,blackrookData,0,0 ;left blackrook
  drawpicture blackrookFilename,blackrookFilehandle,25,25,blackrookData,175,0 ;right blackrook

  drawpicture blackhorseFilename,blackhorseFilehandle,25,25,blackhorseData,25,0 ;left blackhorse
  drawpicture blackhorseFilename,blackhorseFilehandle,25,25,blackhorseData,150,0 ;right blackhorse

  drawpicture blackbishopFilename,blackbishopFilehandle,25,25,blackbishopData,50,0 ;left blackbishop
  drawpicture blackbishopFilename,blackbishopFilehandle,25,25,blackbishopData,125,0 ;right blackbishop

  drawpicture blackqueenFilename,blackqueenFilehandle,25,25,blackqueenData,75,0 ;blackqueen

  drawpicture blackkingFilename,blackkingFilehandle,25,25,blackkingData,100,0 ;blackking
  
   drawpicture blackpawnFilename,blackpawnFilehandle,25,25,blackpawnData,0,25 ;blackpawn
   drawpicture blackpawnFilename,blackpawnFilehandle,25,25,blackpawnData,25,25 ;blackpawn
   drawpicture blackpawnFilename,blackpawnFilehandle,25,25,blackpawnData,50,25 ;blackpawn
   drawpicture blackpawnFilename,blackpawnFilehandle,25,25,blackpawnData,75,25 ;blackpawn
   drawpicture blackpawnFilename,blackpawnFilehandle,25,25,blackpawnData,100,25 ;blackpawn
   drawpicture blackpawnFilename,blackpawnFilehandle,25,25,blackpawnData,125,25 ;blackpawn
   drawpicture blackpawnFilename,blackpawnFilehandle,25,25,blackpawnData,150,25 ;blackpawn
   drawpicture blackpawnFilename,blackpawnFilehandle,25,25,blackpawnData,175,25 ;blackpawn
;-----------------------------------------------------------------------------------------------------
;-----------------------------------------------White Pieces----------------------------------------
drawpicture whiterookFilename,whiterookFilehandle,25,25,whiterookData,175,175 ;left whiterook
drawpicture whiterookFilename,whiterookFilehandle,25,25,whiterookData,0,175 ;right whiterook

drawpicture whiteknightFilename,whiteknightFilehandle,25,25,whiteknightData,150,175 ;left whiteknight
drawpicture whiteknightFilename,whiteknightFilehandle,25,25,whiteknightData,25,175 ;right whiteknight

drawpicture whitebishopFilename,whitebishopFilehandle,25,25,whitebishopData,125,175 ;left whitebishop
drawpicture whitebishopFilename,whitebishopFilehandle,25,25,whitebishopData,50,175 ;right whitebishop

drawpicture whitequeenFilename,whitequeenFilehandle,25,25,whitequeenData,75,175 ;whitequeen

drawpicture whitekingFilename,whitekingFilehandle,25,25,whitekingData,100,175 ;whitequeen

drawpicture whitepawnFilename,whitepawnFilehandle,25,25,whitepawnData,0,150 ;whitepawn
drawpicture whitepawnFilename,whitepawnFilehandle,25,25,whitepawnData,25,150 ;whitepawn
drawpicture whitepawnFilename,whitepawnFilehandle,25,25,whitepawnData,50,150 ;whitepawn
drawpicture whitepawnFilename,whitepawnFilehandle,25,25,whitepawnData,75,150 ;whitepawn
drawpicture whitepawnFilename,whitepawnFilehandle,25,25,whitepawnData,100,150 ;whitepawn
drawpicture whitepawnFilename,whitepawnFilehandle,25,25,whitepawnData,125,150 ;whitepawn
drawpicture whitepawnFilename,whitepawnFilehandle,25,25,whitepawnData,150,150 ;whitepawn
drawpicture whitepawnFilename,whitepawnFilehandle,25,25,whitepawnData,175,150 ;whitepawn


RET                 
initializeTheGame ENDP
;---------------------------------------------------------------------------------------------

;-----------------------------------------befor end-------------------------------------------
beforeEnd PROC 
    ; Press any key to exit
    MOV AH , 0
    INT 16h
    
    ;Change to Text MODE
    MOV AH,0          
    MOV AL,03h
    INT 10h 

    ; return control to operating system
    MOV AH , 4ch
    INT 21H
RET                 
beforeEnd ENDP
;---------------------------------------------------------------------------------------------

;-------------------------------------------drawing-----------------------------------------
Drawing PROC 
; Drawing loop
increment:
INC CX
INC si
CMP CX,bx
jz cont50
drawLoop:
    MOV AL,[si]
    cmp al,1d
    je increment
    INT 10h 
    INC CX
    INC si
    CMP CX,bx
JNE drawLoop 
	cont50:
    MOV CX , di
    inc dx
    CMP DX , bp
JNE drawLoop

RET                 
Drawing ENDP  
;-----------------------------------------------------------------------------------------------

;------------------------------------open file--------------------------------------------------
OpenFile PROC 
    ; Open file 
    
    MOV AH, 3Dh
    MOV AL, 0 ; read only
    ;mov DX, bx
    INT 21h
    MOV [di], AX
    RET
OpenFile ENDP
;------------------------------------------------------------------------------------------------

;--------------------------------------read data-------------------------------------------------
ReadData PROC
    MOV AH,3Fh
    MOV BX,[di]
    ;MOV CX,boardHeight*boardHeight ; number of bytes to read
    ;lea DX, boardData
    INT 21h
    RET
ReadData ENDP 
;-------------------------------------------------------------------------------------------------

;----------------------------------------close file-----------------------------------------------
CloseFile PROC
	MOV AH, 3Eh
	;MOV BX,[boardFilehandle]
	INT 21h
	RET
CloseFile ENDP
;-------------------------------------------------------------------------------------------------

pushingA proc 
   push ax 
   push bx 
   push CX
   push dx
 ret
pushingA endp

popingA proc 
   pop ax 
   pop bx 
   pop CX
   pop dx
 ret
popingA endp
;-----------------------------------------------------------------------------------------------
;--------------------------------------------move------------------------------------------------
move proc 

; Draw The fram at   (0 ,0) location in start of the program
mov cx, xBlack
mov Dx ,yBlack
call DrawFrame

; Draw The fram at   (175 ,175) location in start of the program
mov cx, xWhite
mov Dx ,yWhite
call DrawFrameWhite


looptomoveagin:

      mov RESAH, '$'
      mov REsCHAR , '$'
			mov AH, 1
			int 16H  
			jnz SendBlack ;Ther is a key pressed = sending ah or closing game
			JMP ResWhite  ;No key pressed then recieving ah

;================================================ Send =============================================
SendBlack:
  call checkTimer

  mov ah,0
  int 16h 

  cmp ah,48h ;check if w
  jnz pss52
  jmp w
  pss52:

  cmp ah,4Dh ;check if d
  jnz pss28
  jmp d
  pss28:

  cmp ah,4Bh ;check if a
  jnz pss27
  jmp a
pss27:
  cmp ah,50h ;check if s
  jnz pss26
  jmp s
pss26:
  cmp ah,2Bh ;check if q (backSlash)
  jnz pss25
  jmp  q
pss25:
  cmp ah,3Dh ;check if f3 (wants to go to mainscreen)
  jnz pss54
  jmp  f3cond
pss54:

  ;-----------------------------------------------inline chatting
  push ax
  push si

    MOV CHAR, AL
				setCursor xsInline, ysInline
				MOV SI, OFFSET CHAR
				CALL DISPLAYMESSAGE
				SENDING CHAR

    inc xsInline
				CMP xsInline, 239
				JE akhrsatrInline
				BACKSENDInline:
        ;jmp lastofInline
				JMP endsendInline
                tempInline:
                jmp endsendInline
akhrsatrInline:
        MOV xsInline, 229
				INC ysInline
				CMP ysInline, 9
				JE khlstInline
        ;jmp lastofInline
				BACKakhrsatrInline:
				JMP BACKSENDInline
			khlstInline:
			SCROLL 229, 2, 239, 9
			MOV ysInline, 9
			 	JMP BACKakhrsatrInline
      lastofInline:

temp2Inline:
jmp BACKSPACEInline
 newlineInline:    
 inc  ysInline
mov xsInline,229
CMP ysInline, 9
				JE linegdedInline
				CONTSENInline:
				setCursor xsInline, ysInline
				SENDING 0CH
				JMP endsendInline
linegdedInline:
				SCROLL 229, 2, 239, 8
				MOV ys, 8
				JMP CONTSENInline
temp3Inline:
jmp endsendInline
BACKSPACEInline:
setCursor xsInline, ysInline
				MOV SI, OFFSET SPACE
				CALL DISPLAYMESSAGE
				DEC xsInline
				setCursor xsInline, ysInline
				SENDING SPACE
				JMP endsendInline

endsendInline:
;jmp receivelabel

    pop si
    pop ax
  ;--------------------------------------------------------------

  jmp looptomoveagin

f3cond:
  SENDING 3Dh
  call mainscreen

  jmp looptomoveagin

  w:
    SENDING 48h
    mov dx,yBlack
    mov cx,xBlack 
    cmp dx,00h
    jnz pss53
    jmp looptomoveagin
    pss53:

    push di
    push bx
    convert25toindex
    pop bx
    cmp arrvalid[di],0
    je notvalidw
    jmp validw
    
    notvalidw:
      pop di 
      call CLEARFRAM
      jmp finishvalidw
    validw:
      pop di
      call DrawFrameRed

    finishvalidw: 
    sub dx,25
    call DrawFrame
    mov yBlack,dx
    mov xBlack,cx
    jmp looptomoveagin


  s:  
    SENDING 50h
    mov dx,yBlack
    mov cx,xBlack 
    cmp dx,175d
    jnz pss24
    jmp looptomoveagin
    pss24:
    push di
    push bx
    convert25toindex
    pop bx
    cmp arrvalid[di],0
    je notvalids
    jmp valids
    
    notvalids:
      pop di 
      call CLEARFRAM
      jmp finishvalids
    valids:
      pop di
      call DrawFrameRed

    finishvalids: 
    add dx,25d
    call DrawFrame
    mov yBlack,dx
    mov xBlack,cx
    jmp looptomoveagin

  a:  
    SENDING 4Bh
    mov dx,yBlack
    mov cx,xBlack 
    cmp cx,0d
    jnz pss23
    jmp looptomoveagin
    pss23:
    push di
    push bx
    convert25toindex
    pop bx
    cmp arrvalid[di],0
    je notvalida
    jmp valida
    
    notvalida:
      pop di 
      call CLEARFRAM
      jmp finishvalida
    valida:
      pop di
      call DrawFrameRed

    finishvalida: 
    sub cx,25d
    call DrawFrame
    mov yBlack,dx
    mov xBlack,cx
    jmp looptomoveagin


  d: 
    SENDING 4Dh
    mov dx,yBlack
    mov cx,xBlack 
    cmp cx,175d
    jnz pss22
    jmp looptomoveagin
    pss22:
    push di
    push bx
    convert25toindex
    pop bx
    cmp arrvalid[di],0
    je notvalidd
    jmp validd
    
    notvalidd:
      pop di 
      call CLEARFRAM
      jmp finishvalidd
    validd:
      pop di
      call DrawFrameRed

    finishvalidd: 
    add cx,25d
    call DrawFrame
    mov yBlack,dx
    mov xBlack,cx
    jmp looptomoveagin

  

    ;============================================ q ==================================================
 looptomoveagin1235: jmp looptomoveagin
  q:
  SENDING 2Bh

  mov dx,yBlack
  mov cx,xBlack
  
  cmp whichQ,0
  je firstq
  jmp secondq


firstq:
    call checkTimer

      push bx 
      push di 
      convert25toindex
      cmp TimerArray[di],2
      pop di
      pop bx
      jbe looptomoveagin1235

    mov whichQ,1

    mov xBlackOld , cx 
    mov yBlackOld , dx

    call validateBlackPiece

    jmp looptomoveagin

secondq:

    call checkTimer
    mov whichQ,0

      ; check for the valid dest or not
      push di
      push bx
      convert25toindex
      pop bx
      cmp arrvalid[di],0
      je notValidDest
      jmp validDest

      notValidDest:
      pop di
      mov yBlack,dx
      mov xBlack,cx
      call removeAnyHighlights
      jmp looptomoveagin

      validDest:
      pop di
      ;end of check dest without affecting any register
   
    push cx
    push dx

    mov cx, xBlackOld                ;carry location of the old x ax
    mov dx, yBlackOld                ;carry location of the old y ax

    call clearCellWithGreenOrWhite

      push di
      convert25toindex   ;To get piece code in bl
      mov arrayboard[di],0
      pop di

     pop dx
     pop cx
     ;check which to draw -------------------------------------------------------

      cmp bl,0 ;check if empty
        jne pss21
        jmp finishmoving1
        pss21:
      cmp bl,1 ;check if Rook
        jne pss20
        jmp bRook1
        pss20:
      cmp bl,2 ;check if kinght
        jne pss19
        jmp bknight1
        pss19:
      cmp bl,3 ;check if Bishop
        jne pss18
        jmp bBishop1
        pss18:
      cmp bl,4 ;check if Queen
        jne pss17
        jmp  bQueen1
        pss17:
      cmp bl,5 ;check if King
        jne pss16
        jmp bKing1
        pss16:
      cmp bl,6 ;check if Pawn
        jne pss15
        jmp bPawn1
        pss15:
        jmp finishmoving1
      
      bRook1:
        push bx                   ;these four lines for getting the index of cell and put the piece code in it
        convert25toindex
        call fillTheStatusBar
        pop bx
        mov arrayboard[di], bl
        mov TimerArray[di],0
        Drawpiece blackrookData
        call DrawFrame
        jmp finishmoving1
      
      bknight1:
        push bx
        convert25toindex
        call fillTheStatusBar
        pop bx
        mov arrayboard[di], bl
        mov TimerArray[di],0
        Drawpiece blackhorseData
        
        call DrawFrame
        jmp finishmoving1
      
      bBishop1:
        push bx
        convert25toindex
        call fillTheStatusBar
        pop bx
        mov arrayboard[di], bl
        mov TimerArray[di],0
        Drawpiece blackbishopData
        call DrawFrame
        jmp finishmoving1
      
      bQueen1:
        push bx
        convert25toindex
        call fillTheStatusBar
        pop bx
        mov arrayboard[di], bl
        mov TimerArray[di],0
        Drawpiece blackqueenData
        call DrawFrame
        jmp finishmoving1
      
      bKing1:
        push bx
        convert25toindex
        call fillTheStatusBar
        pop bx
        mov arrayboard[di], bl
        mov TimerArray[di],0
        Drawpiece blackkingData
        call DrawFrame
        jmp finishmoving1
        
      bPawn1:
        push bx
        convert25toindex
        call fillTheStatusBar
        pop bx
        mov arrayboard[di], bl
        mov TimerArray[di],0
        Drawpiece blackpawnData
        call Promotion
        
        call DrawFrame
        jmp finishmoving1

   finishmoving1: 

   call removeAnyHighlights
   call falseAllTheValidArray
   call checkTimer

  jmp looptomoveagin


;=============================================recieve ===================================================
ResWhite:

    call checkTimer

  RECEIVING RESAH
	CMP RESAH, '$'
	JnE pss13
  jmp looptomoveagin
  pss13:

  cmp RESAH,48h ;check if up
  jnz pss65
  jmp upArrow
  pss65:

  cmp RESAH,4Dh ;check if right
  jnz pss12
  jmp rightArrow
  pss12:
  cmp RESAH,4Bh ;check if left
  jnz pss11
  jmp leftArrow
  pss11:
  cmp RESAH,50h ;check if down
  jnz pss10
  jmp downArrow
  pss10:
  cmp RESAH,2Bh ;check if m (select for the white player) (backslash)
  jnz pss14
  jmp m
  pss14:
  cmp RESAH,3Dh ;check if f3 (wants to go to mainscreen)
  jz f3condw

  receivelabel:

  ;RECEIVING REsCHAR
				CMP RESAH, '$'
        jne mmccc
				jmp looptomoveagin
				mmccc:
				; CMP REsCHAR, 0CH
				; JE enterr
				
				; CMP REsCHAR, 32
				; JE BACKSPACERER
				
				setCursor xrInline, yrInline
				MOV SI, OFFSET RESAH
				CALL DISPLAYMESSAGE
				INC xrInline
				CMP xrInline, 239
				JE akhrsatr2Inline
				BACKSENDRECInline:
				JMP looptomoveagin
        akhrsatr2Inline:
				MOV xrInline, 229
				INC yrInline
				; CMP yrInline, 22
				; JE khlst2Inline
				; akhrsatr2backInline:
				; JMP BACKSENDRECInline
				
			; khlst2Inline:
				; SCROLL 0, 0DH, 79, 24
				; setCursor 0, 12
				; ;MOV SI, OFFSET SPLIT
				; ;CALL DISPLAYMESSAGE
				; MOV yrInline, 23
				; JMP akhrsatr2backInline

  jmp looptomoveagin

f3condw:
  call mainscreen
  jmp looptomoveagin


  upArrow:
    mov cx,xWhite
    mov dx,ywhite
    cmp dx,00h
    jnz pss9
    jmp looptomoveagin
    pss9:
    push di
    push bx
    convert25toindex
    pop bx
    cmp arrvalidwhite[di],0
    je notvalidww
    jmp validww
    
    notvalidww:
      pop di 
      call clearFrameWhite
      jmp finishvalidww
    validww:
      pop di
      call DrawFrameBlue

    finishvalidww: 
    sub dx,25
    call DrawFrameWhite
    mov xWhite,cx
    mov ywhite,dx
    jmp looptomoveagin


downArrow:
    mov cx,xWhite
    mov dx,ywhite
    cmp dx,175d
    jnz pss8
    jmp looptomoveagin
    pss8:
    push di
    push bx
    convert25toindex
    pop bx
    cmp arrvalidwhite[di],0
    je notvalidsw
    jmp validsw
    
    notvalidsw:
      pop di 
      call clearFrameWhite
      jmp finishvalidsw
    validsw:
      pop di
      call DrawFrameBlue

    finishvalidsw: 
    add dx,25d
    call DrawFrameWhite
    mov xWhite,cx
    mov ywhite,dx
    jmp looptomoveagin

leftArrow: 
    mov cx,xWhite
    mov dx,ywhite 
    cmp cx,0d
    jnz pss7
    jmp looptomoveagin
    pss7:
    push di
    push bx
    convert25toindex
    pop bx
    cmp arrvalidwhite[di],0
    je notvalidaw
    jmp validaw
    
    notvalidaw:
      pop di 
      call clearFrameWhite
      jmp finishvalidaw
    validaw:
      pop di
      call DrawFrameBlue

    finishvalidaw: 
    sub cx,25d
    call DrawFrameWhite
    mov xWhite,cx
    mov ywhite,dx
    jmp looptomoveagin

rightArrow: 
    mov cx,xWhite
    mov dx,ywhite
    cmp cx,175d
    jz looptomoveagin1

    push di
    push bx
    convert25toindex
    pop bx
    cmp arrvalidwhite[di],0
    je notvaliddw
    jmp validdw
    
    notvaliddw:
      pop di 
      call clearFrameWhite
      jmp finishvaliddw
    validdw:
      pop di
      call DrawFrameBlue

    finishvaliddw: 
    add cx,25d
    call DrawFrameWhite
    mov xWhite,cx
    mov ywhite,dx
    jmp looptomoveagin

 ;============================================ m ==================================================
 looptomoveagin1:jmp looptomoveagin
  m:

  mov dx,yWhite
  mov cx,xWhite
  
  cmp whichM,0
  je firstm
  jmp secondm


firstm:
    call checkTimer

      push bx 
      push di 
      convert25toindex
      cmp TimerArray[di],2
      pop di
      pop bx
      jbe looptomoveagin1

    mov whichM,1

    mov xWhiteOld , cx 
    mov yWhiteOld , dx

    call validateWhitePiece

    jmp looptomoveagin

secondm:
    call checkTimer
    mov whichM,0

      ; check for the valid dest or nor 
      push di
      push bx 
      convert25toindex
      pop bx
      cmp arrvalidwhite[di],0
      je notValidDestw
      jmp validDestw

      notValidDestw:
      pop di
      mov ywhite,dx
      mov xWhite,cx
      call removeAnyHighlightswhite
      jmp looptomoveagin

      validDestw:
      pop di
      ;end of check dest without affecting any register

    push cx
    push dx

      mov cx, xWhiteOld                ;carry location of the old x ax
      mov dx, yWhiteOld                ;carry location of the old y ax

      call clearCellWithGreenOrWhite

        push di
        convert25toindex   ;To get piece code in bl
        mov arrayboard[di],0
        pop di

    pop dx
    pop cx
    
;check which to draw -------------------------------------------------------

      cmp bl,0 ;check if empty
        jne pss
        jmp finishmoving1w
        pss:
      cmp bl,7 ;check if Rook
        jne pss1
        jmp wRook1
        pss1:
      cmp bl,8 ;check if kinght
        jne pss2
        jmp wknight1
        pss2:
      cmp bl,9 ;check if Bishop
        jne  pss3
        jmp wBishop1
        pss3:
      cmp bl,11 ;check if Queen
        jne pss4
        jmp wQueen1
        pss4:
      cmp bl,10 ;check if King
        jne pss5
        jmp wKing1
        pss5:
      cmp bl,12 ;check if Pawn
         jne pss6
         jmp wPawn1
         pss6:
      jmp finishmoving1w

      
      wRook1:
        push bx                   ;these four lines for getting the index of cell and put the piece code in it
        convert25toindex
        call fillTheStatusBar
        pop bx
        mov arrayboard[di], bl
        mov TimerArray[di],0
        Drawpiece whiterookData
        call DrawFrameWhite
        jmp finishmoving1w
      
      wknight1:
        push bx
        convert25toindex
        call fillTheStatusBar
        pop bx
        mov arrayboard[di], bl
        mov TimerArray[di],0
        Drawpiece whiteknightData
        call DrawFrameWhite
        jmp finishmoving1w
      
      wBishop1:
        push bx
        convert25toindex
        call fillTheStatusBar
        pop bx
        mov arrayboard[di], bl
        mov TimerArray[di],0
        Drawpiece whitebishopData
        call DrawFrameWhite
        jmp finishmoving1w
      
      wQueen1:
        push bx
        convert25toindex
        call fillTheStatusBar
        pop bx
        mov arrayboard[di], bl
        mov TimerArray[di],0
        Drawpiece whitequeenData
        call DrawFrameWhite
        jmp finishmoving1w
      
      wKing1:
        push bx
        convert25toindex
        call fillTheStatusBar
        pop bx
        mov arrayboard[di], bl
        mov TimerArray[di],0
        Drawpiece whitekingData
        call DrawFrameWhite
        jmp finishmoving1w
        
      wPawn1:
        push bx
        convert25toindex
        call fillTheStatusBar
        pop bx
        mov arrayboard[di], bl
        mov TimerArray[di],0
        Drawpiece whitepawnData
        call Promotion
        call DrawFrameWhite
        jmp finishmoving1w

   finishmoving1w: 
      
   call removeAnyHighlightswhite
   call falseAllTheValidArrayWhite
      
  jmp looptomoveagin

ret
move endp
;------------------------------------------------------------------------------------------------------

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                               vGraphics                                             ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;-----------------------------------------------draw frame---------------------------------------------
DrawFrame proc
push ax
push bx 
push si
push di
push bp


mov si ,cx
mov di,dx
mov bp,cx
mov bx,dx

add bp,24d
add bx,24d

mov al,00h
mov ah,0ch
back1: int 10h
 inc cx
 cmp cx,bp
jnz back1

mov al,00h
mov ah,0ch
back2: int 10h
 inc dx
 cmp dx,bx
jnz back2

mov al,00h
mov ah,0ch
back3: int 10h
 dec cx
 cmp cx,si
jnz back3

mov al,00h
mov ah,0ch
back4: int 10h
 dec dx
 cmp dx,di
jnz back4

pop bp
pop di
pop si
pop bx
pop ax

ret
DrawFrame  endp
;---------------------------------------------------------------------------------------------------

;----------------------------------------clear frame------------------------------------------------
CLEARFRAM proc
push ax
push bx 
push si
push di
push bp

; check if red finish
    mov ah,0Dh              ;interrupt to get the pexel color
    int 10H                 ; AL = COLOR
    cmp al,04h              ;compare it with the highlighting color(red)
    je finishClearFrame


;checking the color of drawing (white or black)
MOV bp,dx

mov si,cx
add si,dx

mov dx, 0000h
mov ax,si
MOV bx,2d 
DIV bx

mov al,07h
CMP DL,1
jz odd
jmp pass
odd: mov al,07h
pass:
;end checking
mov dx,bp
;clear before drawing
mov si,cx
mov di,dx
mov bp,cx
mov bx,dx

add bp,24d
add bx,24d


mov ah,0ch
back11: int 10h
  inc cx
  cmp cx,bp
jnz back11

mov ah,0ch
back22: int 10h
 inc dx
 cmp dx,bx
jnz back22

mov ah,0ch
back33: int 10h
 dec cx
 cmp cx,si
jnz back33

mov ah,0ch
back44: int 10h
 dec dx
 cmp dx,di
jnz back44

finishClearFrame:

pop bp
pop di
pop si
pop bx
pop ax
ret
CLEARFRAM  endp
;-----------------------------------------------------------------------------------------------------------

;-----------------------------------------draw frame for white player --------------------------------------
DrawFrameWhite proc
push ax
push bx 
push si
push di
push bp
push cx
push dx

inc cx
inc dx

mov si,cx
mov di,dx
mov bp,cx
mov bx,dx

add bp,22
add bx,22

mov al,02h
mov ah,0ch
back1w: int 10h
 inc cx
 cmp cx,bp
jnz back1w

mov al,02h
mov ah,0ch
back2w: int 10h
 inc dx
 cmp dx,bx
jnz back2w

mov al,02h
mov ah,0ch
back3w: int 10h
 dec cx
 cmp cx,si
jnz back3w

mov al,02h
mov ah,0ch
back4w: int 10h
 dec dx
 cmp dx,di
jnz back4w

pop dx
pop cx
pop bp
pop di
pop si
pop bx
pop ax

ret
DrawFrameWhite  endp
;-----------------------------------------------------------------------------------------------------------

;-------------------------------------clear frame for the white player--------------------------------------
clearFrameWhite proc
push ax
push bx 
push si
push di
push bp
push cx
push dx

inc cx
inc dx

; check if blue finish
    mov ah,0Dh              ;interrupt to get the pexel color
    int 10H                 ; AL = COLOR
    cmp al,01h              ;compare it with the highlighting color(blue)
    je finishClearFramew

;checking the color of drawing (white or black)
push cx
push dx

dec cx
dec dx
MOV bp,dx

mov si,cx
add si,dx

mov dx, 0000h
mov ax,si
MOV bx,2d 
DIV bx

mov al,07h
CMP DL,1
jz oddw
jmp passw
oddw: mov al,07h
passw:
;end checking
mov dx,bp
;clear before drawing
pop dx
pop cx

mov si,cx
mov di,dx
mov bp,cx
mov bx,dx

add bp,22
add bx,22


mov ah,0ch
back11w: int 10h
  inc cx
  cmp cx,bp
jnz back11w

mov ah,0ch
back22w: int 10h
 inc dx
 cmp dx,bx
jnz back22w

mov ah,0ch
back33w: int 10h
 dec cx
 cmp cx,si
jnz back33w

mov ah,0ch
back44w: int 10h
 dec dx
 cmp dx,di
jnz back44w

finishClearFramew:
pop dx
pop cx
pop bp
pop di
pop si
pop bx
pop ax
ret
clearFrameWhite  endp
;-----------------------------------------------------------------------------------------------------------

;-----------------------------------draw frame for highlighting black pieces--------------------------------
DrawFrameRed proc
push ax
push bx 
push si
push di
push bp

mov si ,cx
mov di,dx
mov bp,cx
mov bx,dx

add bp,24d
add bx,24d

mov al,04h
mov ah,0ch
back1r: int 10h
 inc cx
 cmp cx,bp
jnz back1r

mov al,04h
mov ah,0ch
back2r: int 10h
 inc dx
 cmp dx,bx
jnz back2r

mov al,04h
mov ah,0ch
back3r: int 10h
 dec cx
 cmp cx,si
jnz back3r

mov al,04h
mov ah,0ch
back4r: int 10h
 dec dx
 cmp dx,di
jnz back4r

pop bp
pop di
pop si
pop bx
pop ax

ret
DrawFrameRed  endp
;---------------------------------------------------------------------------------------------------

;-------------------------------clear highlighted frame for black pieces----------------------------
ClearFrameRed proc
push ax
push bx 
push si
push di
push bp
;checking the color of drawing (white or black)
MOV bp,dx

mov si,cx
add si,dx

mov dx, 0000h
mov ax,si
MOV bx,2d 
DIV bx

mov al,07h
CMP DL,1
jz oddr
jmp passr
oddr: mov al,07h
passr:
;end checking
mov dx,bp
;clear before drawing
mov si,cx
mov di,dx
mov bp,cx
mov bx,dx

add bp,24d
add bx,24d


mov ah,0ch
back11r: int 10h
  inc cx
  cmp cx,bp
jnz back11r

mov ah,0ch
back22r: int 10h
 inc dx
 cmp dx,bx
jnz back22r

mov ah,0ch
back33r: int 10h
 dec cx
 cmp cx,si
jnz back33r

mov ah,0ch
back44r: int 10h
 dec dx
 cmp dx,di
jnz back44r

pop bp
pop di
pop si
pop bx
pop ax
ret
ClearFrameRed  endp
;------------------------------------------------------------------------------------------------------


;-----------------------------------draw frame for highlighting white pieces--------------------------------
DrawFrameBlue proc
push ax
push bx 
push si
push di
push bp
push cx
push dx

inc dx
inc cx

mov si ,cx
mov di,dx
mov bp,cx
mov bx,dx

add bp,22d
add bx,22d

mov al,01h
mov ah,0ch
back1rb: int 10h
 inc cx
 cmp cx,bp
jnz back1rb

mov al,01h
mov ah,0ch
back2rb: int 10h
 inc dx
 cmp dx,bx
jnz back2rb

mov al,01h
mov ah,0ch
back3rb: int 10h
 dec cx
 cmp cx,si
jnz back3rb

mov al,01h
mov ah,0ch
back4rb: int 10h
 dec dx
 cmp dx,di
jnz back4rb


pop dx
pop cx
pop bp
pop di
pop si
pop bx
pop ax

ret
DrawFrameBlue  endp
;---------------------------------------------------------------------------------------------------

;-------------------------------clear highlighted frame for white pieces----------------------------
ClearFrameBlue proc

push ax
push bx 
push si
push di
push bp
push cx
push dx


inc dx
inc cx

mov si ,cx
mov di,dx
mov bp,cx
mov bx,dx

add bp,22d
add bx,22d

mov al,07h
mov ah,0ch
back1rbg: int 10h
 inc cx
 cmp cx,bp
jnz back1rbg

mov al,07h
mov ah,0ch
back2rbg: int 10h
 inc dx
 cmp dx,bx
jnz back2rbg

mov al,07h
mov ah,0ch
back3rbg: int 10h
 dec cx
 cmp cx,si
jnz back3rbg

mov al,07h
mov ah,0ch
back4rbg: int 10h
 dec dx
 cmp dx,di
jnz back4rbg


pop dx
pop cx
pop bp
pop di
pop si
pop bx
pop ax
ret

ClearFrameBlue  endp
;------------------------------------------------------------------------------------------------------
wPStatus1: jmp wPStatus
wQStatus1: jmp wQStatus
wKStatus1: jmp wKStatus
wBStatus1: jmp wBStatus
wHStatus1: jmp wHStatus
wRStatus1: jmp wRStatus
bRStatus1: jmp bRStatus
bHStatus1: jmp bHStatus
bBStatus1: jmp bBStatus
bQStatus1: jmp bQStatus
bKStatus1: jmp bKStatus
bPStatus1: jmp bPStatus
;-------------------------------------------fill the status bar----------------------------------------
;function to send lost pieces after moving using bl to check the removed piece id
fillTheStatusBar proc
  push bx
    ;black pieces
    cmp bl,1
    je bRStatus1
    cmp bl,2
    je bHStatus1
    cmp bl,3
    je bBStatus1
    cmp bl,4
    je bQStatus1
    cmp bl,5
    je bKStatus1
    cmp bl,6
    je bPStatus1

    ;white pieces
    cmp bl,7
    je wRStatus1
    cmp bl,8
    je wHStatus1
    cmp bl,9
    je wBStatus1
    cmp bl,10
    je wKStatus1
    cmp bl,11
    je wQStatus1
    cmp bl,12
    je wPStatus1
    jmp finishFillingStatus

    ;black
    bRStatus:
      bstatusbar Brok
      inc nobrookkill
      jmp finishFillingStatus
    bHStatus:
      bstatusbar bhorse
      inc nobknightkill
      jmp finishFillingStatus
    bBStatus:
      bstatusbar bbshop
      inc nobbishopkill
      jmp finishFillingStatus
    bQStatus:
      bstatusbar Bquen
      inc nobqueenkill
      jmp finishFillingStatus
    bKStatus:
      bstatusbar gameover
      wstatusbar wingame
      mov gameoverFlag,1
      jmp finishFillingStatus
    bPStatus:
      bstatusbar bpaw
      inc nobpawnkill
      jmp finishFillingStatus

    ;white
    wRStatus:
      wstatusbar wrook
      inc nowrookkill
      jmp finishFillingStatus
    wHStatus:
      wstatusbar wknight
      inc nowknightkill
      jmp finishFillingStatus
    wBStatus:
      wstatusbar wbishop
      inc nowbishopkill
      jmp finishFillingStatus
    wQStatus:
      wstatusbar wqueen
      inc nowqueenkill
      jmp finishFillingStatus
    wKStatus:
      wstatusbar gameover
      bstatusbar wingame
      mov gameoverFlag,1
      jmp finishFillingStatus
    wPStatus:
      wstatusbar wpawn
      inc nowpawnkill
      jmp finishFillingStatus

    finishFillingStatus:
    push ax
    push dx
    printwhitestatus
    printblackstatus
    pop dx
    pop ax

  pop bx
ret
fillTheStatusBar endp
;------------------------------------------------------------------------------------------------------

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;            validation for each piece destination and highlight available destinations               ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;balck pieces;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
notempty21: jmp notempty2
;--------------------------------------------validate black Pawn ----------------------------------------
ValidateBPawn proc
push cx
push dx

add cx,25                        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;lower right
add dx,25
cmp dx,175
jg notempty21                     ; means reaching the last row of the board, So return fom proc
cmp cx,175
jg notwhitep1
;check if white piece in this position
mov di,12
    push di
    convert25toindex
    pop di
    mov bh,0
    againp1:
    cmp bx,di
    je whitep1                      ;(jump if white piece)
    dec di
    cmp di,6
    jne againp1
  
    jmp notwhitep1
  whitep1:                    
    call DrawFrameRed                ;highlight because it is white (could be attacked)
  notwhitep1:

sub cx,50                       ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;lower left
cmp cx,0
jl notwhitep2
;check if white piece in this position
mov di,12
    push di
    convert25toindex
    pop di
    mov bh,0
    againp2:
    cmp bx,di
    je whitep2                      ;(jump if white piece)
    dec di
    cmp di,6
    jne againp2
  
    jmp notwhitep2
  whitep2:                    
    call DrawFrameRed                ;highlight because it is white (could be attacked)
  notwhitep2:

add cx,25                       ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;lower 
;check if empty position
    push di
    convert25toindex
    pop di
    mov bh,0
    cmp bx,0
    je empty                      ;(jump if empty piece)

    jmp notempty
  empty:                    
    call DrawFrameRed              ;highlight because it is empty (could move to it)
    jmp lowerIsEmpty
  notempty:
  add dx,25                        ;To cancel drawing in lower lower


lowerIsEmpty:

add dx,25                       ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;lower lower 
cmp dx,75
jne notempty2 
;check if empty position
    push di
    convert25toindex
    pop di
    mov bh,0
    cmp bx,0
    je empty2                      ;(jump if empty piece)
  
   jmp notempty2
  empty2:                    
    call DrawFrameRed                ;highlight because it is empty (could move to it)
  notempty2:

pop dx
pop cx
ret
ValidateBPawn  endp


;--------------------------------------------validate black Rook ----------------------------------------
ValidateBRook proc
push cx
push dx
push bx

push dx
lower:                            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;lower 
  add dx,25

  call HighlightBlack
  mov bl,reachingPieceFlag
  cmp bl , 1                      ;break the loop if reaching a piece
  je finishR1 

  cmp dx,175                      ;break the loop if dx reaches border
  jl lower
finishR1:
pop dx

push dx
upper:                            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;upper 
  sub dx,25

  call HighlightBlack
  mov bl,reachingPieceFlag
  cmp bl , 1                      ;break the loop if reaching a piece
  je finishR2 

  cmp dx,0                        ;break the loop if dx reaches border
  jg upper 
finishR2:
pop dx

push cx
right:                            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;right 
  add cx,25

  call HighlightBlack
  mov bl,reachingPieceFlag
  cmp bl , 1                      ;break the loop if reaching a piece
  je finishR3 

  cmp cx,175                      ;break the loop if cx reaches border
  jl right 
finishR3:
pop cx

push cx
left:                            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;left 
  sub cx,25

  call HighlightBlack
  mov bl,reachingPieceFlag
  cmp bl , 1                      ;break the loop if reaching a piece
  je finishR4 

  cmp cx,0                      ;break the loop if cx reaches border
  jg left 
finishR4:
pop cx

pop bx
pop dx
pop cx
ret
ValidateBRook  endp

;--------------------------------------------validate black Bishop ----------------------------------------
ValidateBBishop proc
push cx
push dx
push bx

push cx
push dx
lowerright:                            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;lowerright 
  add cx,25
  add dx,25

  call HighlightBlack
  mov bl,reachingPieceFlag
  cmp bl , 1                      ;break the loop if reaching a piece
  je finishB1 

  cmp cx,175
  jge finishB1
  cmp dx,175
  jnge lowerright                    ;niether cx nor dx reaches border ,so loop again
finishB1:
pop dx
pop cx

push cx
push dx
lowerleft:                            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;lowerleft 
  sub cx,25
  add dx,25
  
  call HighlightBlack
  mov bl,reachingPieceFlag
  cmp bl , 1                      ;break the loop if reaching a piece
  je finishB2 

  cmp cx,0
  jle finishB2
  cmp dx,175
  jnge lowerleft                    ;niether cx nor dx reaches border ,so loop again
 finishB2:
pop dx
pop cx

push cx
push dx
upperright:                            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;upperright 
  add cx,25
  sub dx,25
  
  call HighlightBlack
  mov bl,reachingPieceFlag
  cmp bl , 1                      ;break the loop if reaching a piece
  je finishB3 

  cmp cx,175
  jge finishB3
  cmp dx,0
  jnle upperright                    ;niether cx nor dx reaches border ,so loop again
 finishB3:
pop dx
pop cx

push cx
push dx
upperleft:                            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;upperleft 
  sub cx,25
  sub dx,25
  
  call HighlightBlack
  mov bl,reachingPieceFlag
  cmp bl , 1                       ;break the loop if reaching a piece
  je finishB4 

  cmp cx,0
  jle finishB4
  cmp dx,0
  jnle upperleft                    ;niether cx nor dx reaches border ,so loop again
 finishB4:
pop dx
pop cx

pop bx
pop dx
pop cx
ret
ValidateBBishop  endp


;--------------------------------------------validate black Queen ----------------------------------------
ValidateBQueen proc
push cx
push dx
push bx

;main directions (like rook)---------------------------------------------------
push dx
lowerQ:                            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;lower 
  add dx,25
  
  call HighlightBlack
  mov bl,reachingPieceFlag
  cmp bl , 1                      ;break the loop if reaching a piece
  je finishQ1 

  cmp dx,175
  jl lowerQ 
finishQ1:
pop dx

push dx
upperQ:                            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;upper 
  sub dx,25
  
  call HighlightBlack
  mov bl,reachingPieceFlag
  cmp bl , 1                      ;break the loop if reaching a piece
  je finishQ2 

  cmp dx,0
  jg upperQ 
finishQ2:
pop dx

push cx
rightQ:                            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;right 
  add cx,25
  
  call HighlightBlack
  mov bl,reachingPieceFlag
  cmp bl , 1                      ;break the loop if reaching a piece
  je finishQ3 

  cmp cx,175
  jl rightQ 
finishQ3:
pop cx

push cx
leftQ:                            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;left 
  sub cx,25
  
  call HighlightBlack
  mov bl,reachingPieceFlag
  cmp bl , 1                      ;break the loop if reaching a piece
  je finishQ4 

  cmp cx,0
  jg leftQ 
finishQ4:
pop cx

;sub directions (like bishop)-----------------------------------------------------------
push cx
push dx
lowerrightQ:                            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;lowerright 
  add cx,25
  add dx,25
  
  call HighlightBlack
  mov bl,reachingPieceFlag
  cmp bl , 1                      ;break the loop if reaching a piece
  je finishQ5 

  cmp cx,175
  jge finishQ5
  cmp dx,175
  jnge lowerrightQ                    ;niether cx nor dx reaches border ,so loop again
finishQ5:
pop dx
pop cx

push cx
push dx
lowerleftQ:                            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;lowerleft 
  sub cx,25
  add dx,25
  
  call HighlightBlack
  mov bl,reachingPieceFlag
  cmp bl , 1                      ;break the loop if reaching a piece
  je finishQ6 

  cmp cx,0
  jle finishQ6
  cmp dx,175
  jnge lowerleftQ                    ;niether cx nor dx reaches border ,so loop again
 finishQ6:
pop dx
pop cx

push cx
push dx
upperrightQ:                            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;upperright 
  add cx,25
  sub dx,25
  
  call HighlightBlack
  mov bl,reachingPieceFlag
  cmp bl , 1                      ;break the loop if reaching a piece
  je finishQ7 

  cmp cx,175
  jge finishQ7
  cmp dx,0
  jnle upperrightQ                    ;niether cx nor dx reaches border ,so loop again
 finishQ7:
pop dx
pop cx

push cx
push dx
upperleftQ:                            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;upperleft 
  sub cx,25
  sub dx,25
  
  call HighlightBlack
  mov bl,reachingPieceFlag
  cmp bl , 1                      ;break the loop if reaching a piece
  je finishQ8 

  cmp cx,0
  jle finishQ8
  cmp dx,0
  jnle upperleftQ                    ;niether cx nor dx reaches border ,so loop again
 finishQ8:
pop dx
pop cx

pop bx
pop dx
pop cx
ret
ValidateBQueen  endp

;--------------------------------------------validate black King ----------------------------------------
ValidateBKing proc
push cx
push dx

  add cx,25                             ;the lower right position
  add dx,25
  call HighlightBlack

  sub cx,25                             ;the lower position
  call HighlightBlack

  sub cx,25                             ;the lower left position
  call HighlightBlack

  sub dx,25                             ;the left position
  call HighlightBlack

  sub dx,25                             ;the upper left position
  call HighlightBlack

  add cx,25                             ;the upper position
  call HighlightBlack

  add cx,25                             ;the upper right position
  call HighlightBlack

  add dx,25                             ;the right position
  call HighlightBlack

pop dx
pop cx
ret
ValidateBKing  endp

;--------------------------------------------validate black knight ----------------------------------------
ValidateBKnight proc
push cx
push dx

  add cx,25                             ;the lower right position
  add dx,50
  call HighlightBlack

  sub cx,50                             ;the lower left position
  call HighlightBlack

  sub cx,25                             ;the left lower position
  sub dx,25
  call HighlightBlack

  sub dx,50                             ;the left upper position
  call HighlightBlack

  sub dx,25                             ;the upper left position
  add cx,25
  call HighlightBlack

  add cx,50                             ;the upper right position
  call HighlightBlack

  add cx,25                             ;the right upper position
  add dx,25
  call HighlightBlack

  add dx,50                             ;the right lower position
  call HighlightBlack

pop dx
pop cx
ret
ValidateBKnight  endp

finish12:   jmp finish
;--------------------------------------------Highlight black pieces----------------------------------------
HighlightBlack proc
push cx
push dx
push bx
push di

mov bx,0000h
mov di,0000h
mov reachingPieceFlag,bl          ;set reachingPieceFlag = 0  (false by default)
  ;check for the borders
  cmp cx,0
  jl finish12                       ;do nothing if (cx < 0)
  cmp cx,175
  jg finish12                       ;do nothing if (cx > 175)
  cmp dx,0
  jl finish12                     ;do nothing if (dx < 0)
  cmp dx,175
  jg finish12                       ;do nothing if (dx > 175)

  ;check if white piece in this position
    mov di,12
    push di
    convert25toindex
    pop di
    mov bh,0
    again:
    cmp bx,di
    je white                      ;(jump if white piece)
    dec di
    cmp di,6
    jne again
  
    jmp notwhite
  white:                    
    call DrawFrameRed             ;highlight because it is white (could be attacked)
      cmp bl,10                   ;check if white king
      jne continuewhite
      wstatusbar wkCheckmate
      continuewhite:
    mov bl,1                      
    mov reachingPieceFlag,bl      ;set reachingPieceFlag = 1  (true)
    jmp finish
  notwhite:
  

  ;check if black piece in this position
    mov di,7
    push di
    convert25toindex
    pop di
    mov bh,0
    againn:
    dec di
    cmp bx,di
    je black                      ;(jump if black piece)
    cmp di,1
    jne againn

    jmp notblack
  black:                          
    mov bl,1
    mov reachingPieceFlag,bl     ;set reachingPieceFlag = 1  (true)
    jmp finish
  notblack:

  call DrawFrameRed                 ;highlight because no white or black
 
  finish:

pop di
pop bx
pop dx
pop cx
ret
HighlightBlack  endp


;--------------------------------Remove any highlights in the board--------------------------------------
removeAnyHighlights proc
push cx
push dx

  ; Function will be called immediately after moving the piece to the new position to remove any highlight
  ; in the board and not to appear in the next piece selection

;black
  mov cx,0000h
  mov dx,0000h

outer:                   ;loop on the y coordinates

  inner:                 ;loop on the x coordinates
    
    mov ah,0Dh              ;interrupt to get the pexel color
    int 10H                 ; AL = COLOR
    cmp al,04h              ;compare it with the highlighting color(red)
    jne notHighlghted
    call ClearFrameRed
    notHighlghted:
      cmp cx,175
      je inner_end
      add cx,25
      jmp inner

  inner_end:
    add dx,25
    mov cx,0 
    cmp dx,175         
    jle outer            

outer_end:
pop dx
pop cx

; push cx
; pop dx
ret
removeAnyHighlights endp
;-------------------------------------------------------------------------------------------------------

removeAnyHighlightswhite proc

push cx
push dx


;white
  mov cx,0
  mov dx,0

outerwk:                   ;loop on the y coordinates

  innerwk:                 ;loop on the x coordinates
    add cx,1
    add dx,1
    mov ah,0Dh              ;interrupt to get the pexel color
    int 10H                 ; AL = COLOR
    dec cx
    dec dx
    cmp al,01h              ;compare it with the highlighting color(blue)
    jne notHighlghtedwk
    call ClearFrameBlue
    notHighlghtedwk:
      cmp cx,175
      je inner_endwk
      add cx,25
      jmp innerwk

  inner_endwk:
    add dx,25
    mov cx,0 
    cmp dx,175         
    jle outerwk           

outer_endwk:

pop dx
pop cx
ret
removeAnyHighlightswhite endp
;-------------------------------------------------------------------------------------------------------

;--------------------------------------false all The ValidArray-----------------------------------------
falseAllTheValidArray proc
push di

  mov di,64
nextZ:                   ;loop on the index
  dec di
  mov arrvalid[di] , 0
  cmp di,0
  jg nextZ

pop di 

ret
falseAllTheValidArray endp
;-------------------------------------------------------------------------------------------------------

;--------------------------------------True The ValidArray---------------------------------------------
TrueTheValidArray proc
push cx
push dx
push di

  mov cx,0000h
  mov dx,0000h

outerT:                   ;loop on the y coordinates

  innerT:                 ;loop on the x coordinates
    
    mov ah,0Dh              ;interrupt to get the pexel color
    int 10H                 ; AL = COLOR
    cmp al,04h              ;compare it with the highlighting color(red)
    jne notHighlghtedT

    push bx
    convert25toindex
    pop bx
    mov arrvalid[di] , 1

    notHighlghtedT:
      cmp cx,175
      je inner_endT
      add cx,25
      jmp innerT

  inner_endT:
    add dx,25
    mov cx,0 
    cmp dx,175         
    jle outerT            

outer_endT:

pop di
pop dx
pop cx
ret
TrueTheValidArray endp
;-------------------------------------------------------------------------------------------------------

;-------------------------------- Validate the Black piece ---------------------------------------------
validateBlackPiece proc
; To know which white piece to validate and true its validarray
push bx
    push di
    convert25toindex
    pop di
      cmp bl,0 ;check if empty
        je finishHighlighting
      cmp bl,1 ;check if Rook
        je bRook
      cmp bl,2 ;check if kinght
        je bknight
      cmp bl,3 ;check if Bishop
        je bBishop
      cmp bl,4 ;check if Queen
        je bQueen
      cmp bl,5 ;check if King
        je bKing
      cmp bl,6 ;check if Pawn
        je bPawn
        jmp finishHighlighting    ;White piece

      
      bRook:
        call ValidateBRook
        call TrueTheValidArray
        jmp finishHighlighting
      bknight:
        call ValidateBKnight
        call TrueTheValidArray
        jmp finishHighlighting
      bBishop:
        call ValidateBBishop
        call TrueTheValidArray
        jmp finishHighlighting
      bQueen:
        call ValidateBQueen
        call TrueTheValidArray
        jmp finishHighlighting
      bKing:
        call ValidateBKing
        call TrueTheValidArray
        jmp finishHighlighting
      bPawn:
        call ValidateBPawn
        call TrueTheValidArray
        jmp finishHighlighting

   finishHighlighting: 
  pop bx

ret
validateBlackPiece endp
;------------------------------------------------------------------------------------------------------

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;white pieces;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
notempty2ww1:  jmp notempty2ww
;--------------------------------------------validate white Pawn ----------------------------------------

ValidatewPawn proc
push cx
push dx

add cx,25                        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;upper right
sub dx,25
cmp dx,0
jl notempty2ww1                    ; means reaching the last row of the board, So return fom proc
cmp cx,175
jg notblackp1
;check if black piece in this position
mov di,6
    push di
    convert25toindex
    pop di
    mov bh,0
    againp1w:
    cmp bx,di
    je blackp1                      ;(jump if black piece)
    dec di
    cmp di,0
    jne againp1w
  
    jmp notblackp1
  blackp1:                    
    call DrawFrameBlue                ;highlight because it is balck (could be attacked)
  notblackp1:

sub cx,50                       ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;lower left
cmp cx,0
jl notblackp2
;check if white piece in this position
mov di,6
    push di
    convert25toindex
    pop di
    mov bh,0
    againp2w:
    cmp bx,di
    je blackp2                      ;(jump if black piece)
    dec di
    cmp di,0
    jne againp2w
  
    jmp notblackp2
  blackp2:                    
    call DrawFrameBlue                ;highlight because it is balck (could be attacked)
  notblackp2:

add cx,25                       ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;upper 
;check if empty position
    push di
    convert25toindex
    pop di
    mov bh,0
    cmp bx,0
    je emptyww                      ;(jump if empty piece)

    jmp notemptyww
  emptyww:                    
    call DrawFrameBlue              ;highlight because it is empty (could move to it)
    jmp upperIsEmptyww
  notemptyww:
  sub dx,25                        ;To cancel drawing in upper upper


upperIsEmptyww:

sub dx,25                       ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;upper upper 
cmp dx,100
jne notempty2ww 
;check if empty position
    push di
    convert25toindex
    pop di
    mov bh,0
    cmp bx,0
    je empty2ww                      ;(jump if empty piece)
  
   jmp notempty2ww
  empty2ww:                    
    call DrawFrameBlue                ;highlight because it is empty (could move to it)
  notempty2ww:

pop dx
pop cx
ret
ValidatewPawn  endp


;--------------------------------------------validate white Rook ----------------------------------------
ValidatewRook proc
push cx
push dx
push bx

push dx
lowerw:                            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;lower 
  add dx,25

  call HighlightWhite
  mov bl,reachingPieceFlag
  cmp bl , 1                      ;break the loop if reaching a piece
  je finishR1w 

  cmp dx,175                      ;break the loop if dx reaches border
  jl lowerw
finishR1w:
pop dx

push dx
upperw:                            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;upper 
  sub dx,25

  call HighlightWhite
  mov bl,reachingPieceFlag
  cmp bl , 1                      ;break the loop if reaching a piece
  je finishR2w

  cmp dx,0                        ;break the loop if dx reaches border
  jg upperw 
finishR2w:
pop dx

push cx
rightw:                            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;right 
  add cx,25

  call HighlightWhite
  mov bl,reachingPieceFlag
  cmp bl , 1                      ;break the loop if reaching a piece
  je finishR3w 

  cmp cx,175                      ;break the loop if cx reaches border
  jl rightw 
finishR3w:
pop cx

push cx
leftw:                            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;left 
  sub cx,25

  call HighlightWhite
  mov bl,reachingPieceFlag
  cmp bl , 1                      ;break the loop if reaching a piece
  je finishR4w 

  cmp cx,0                      ;break the loop if cx reaches border
  jg leftw 
finishR4w:
pop cx

pop bx
pop dx
pop cx
ret
ValidatewRook  endp

;--------------------------------------------validate white Bishop ----------------------------------------
ValidatewBishop proc
push cx
push dx
push bx

push cx
push dx
lowerrightw:                            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;lowerright 
  add cx,25
  add dx,25

  call HighlightWhite
  mov bl,reachingPieceFlag
  cmp bl , 1                      ;break the loop if reaching a piece
  je finishB1w 

  cmp cx,175
  jge finishB1w
  cmp dx,175
  jnge lowerrightw                    ;niether cx nor dx reaches border ,so loop again
finishB1w:
pop dx
pop cx

push cx
push dx
lowerleftw:                            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;lowerleft 
  sub cx,25
  add dx,25
  
  call HighlightWhite
  mov bl,reachingPieceFlag
  cmp bl , 1                      ;break the loop if reaching a piece
  je finishB2w 

  cmp cx,0
  jle finishB2w
  cmp dx,175
  jnge lowerleftw                    ;niether cx nor dx reaches border ,so loop again
 finishB2w:
pop dx
pop cx

push cx
push dx
upperrightw:                            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;upperright 
  add cx,25
  sub dx,25
  
  call HighlightWhite
  mov bl,reachingPieceFlag
  cmp bl , 1                      ;break the loop if reaching a piece
  je finishB3w 

  cmp cx,175
  jge finishB3w
  cmp dx,0
  jnle upperrightw                    ;niether cx nor dx reaches border ,so loop again
 finishB3w:
pop dx
pop cx

push cx
push dx
upperleftw:                            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;upperleft 
  sub cx,25
  sub dx,25
  
  call HighlightWhite
  mov bl,reachingPieceFlag
  cmp bl , 1                       ;break the loop if reaching a piece
  je finishB4w 

  cmp cx,0
  jle finishB4w
  cmp dx,0
  jnle upperleftw                    ;niether cx nor dx reaches border ,so loop again
 finishB4w:
pop dx
pop cx

pop bx
pop dx
pop cx
ret
ValidatewBishop  endp


;--------------------------------------------validate white Queen ----------------------------------------
ValidatewQueen proc
push cx
push dx
push bx

;main directions (like rook)---------------------------------------------------
push dx
lowerQw:                            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;lower 
  add dx,25
  
  call HighlightWhite
  mov bl,reachingPieceFlag
  cmp bl , 1                      ;break the loop if reaching a piece
  je finishQ1w 

  cmp dx,175
  jl lowerQw 
finishQ1w:
pop dx

push dx
upperQw:                            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;upper 
  sub dx,25
  
  call HighlightWhite
  mov bl,reachingPieceFlag
  cmp bl , 1                      ;break the loop if reaching a piece
  je finishQ2w 

  cmp dx,0
  jg upperQw 
finishQ2w:
pop dx

push cx
rightQw:                            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;right 
  add cx,25
  
  call HighlightWhite
  mov bl,reachingPieceFlag
  cmp bl , 1                      ;break the loop if reaching a piece
  je finishQ3w 

  cmp cx,175
  jl rightQw 
finishQ3w:
pop cx

push cx
leftQw:                            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;left 
  sub cx,25
  
  call HighlightWhite
  mov bl,reachingPieceFlag
  cmp bl , 1                      ;break the loop if reaching a piece
  je finishQ4w 

  cmp cx,0
  jg leftQw 
finishQ4w:
pop cx

;sub directions (like bishop)-----------------------------------------------------------
push cx
push dx
lowerrightQw:                            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;lowerright 
  add cx,25
  add dx,25
  
  call HighlightWhite
  mov bl,reachingPieceFlag
  cmp bl , 1                      ;break the loop if reaching a piece
  je finishQ5w 

  cmp cx,175
  jge finishQ5w
  cmp dx,175
  jnge lowerrightQw                    ;niether cx nor dx reaches border ,so loop again
finishQ5w:
pop dx
pop cx

push cx
push dx
lowerleftQw:                            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;lowerleft 
  sub cx,25
  add dx,25
  
  call HighlightWhite
  mov bl,reachingPieceFlag
  cmp bl , 1                      ;break the loop if reaching a piece
  je finishQ6w 

  cmp cx,0
  jle finishQ6w
  cmp dx,175
  jnge lowerleftQw                    ;niether cx nor dx reaches border ,so loop again
 finishQ6w:
pop dx
pop cx

push cx
push dx
upperrightQw:                            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;upperright 
  add cx,25
  sub dx,25
  
  call HighlightWhite
  mov bl,reachingPieceFlag
  cmp bl , 1                      ;break the loop if reaching a piece
  je finishQ7w 

  cmp cx,175
  jge finishQ7w
  cmp dx,0
  jnle upperrightQw                    ;niether cx nor dx reaches border ,so loop again
 finishQ7w:
pop dx
pop cx

push cx
push dx
upperleftQw:                            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;upperleft 
  sub cx,25
  sub dx,25
  
  call HighlightWhite
  mov bl,reachingPieceFlag
  cmp bl , 1                      ;break the loop if reaching a piece
  je finishQ8w 

  cmp cx,0
  jle finishQ8w
  cmp dx,0
  jnle upperleftQw                    ;niether cx nor dx reaches border ,so loop again
 finishQ8w:
pop dx
pop cx

pop bx
pop dx
pop cx
ret
ValidatewQueen  endp

;--------------------------------------------validate white King ----------------------------------------
ValidatewKing proc
push cx
push dx

  add cx,25                             ;the lower right position
  add dx,25
  call HighlightWhite

  sub cx,25                             ;the lower position
  call HighlightWhite

  sub cx,25                             ;the lower left position
  call HighlightWhite

  sub dx,25                             ;the left position
  call HighlightWhite

  sub dx,25                             ;the upper left position
  call HighlightWhite

  add cx,25                             ;the upper position
  call HighlightWhite

  add cx,25                             ;the upper right position
  call HighlightWhite

  add dx,25                             ;the right position
  call HighlightWhite

pop dx
pop cx
ret
ValidatewKing  endp

;--------------------------------------------validate white knight ----------------------------------------
ValidatewKnight proc
push cx
push dx

  add cx,25                             ;the lower right position
  add dx,50
  call HighlightWhite

  sub cx,50                             ;the lower left position
  call HighlightWhite

  sub cx,25                             ;the left lower position
  sub dx,25
  call HighlightWhite

  sub dx,50                             ;the left upper position
  call HighlightWhite

  sub dx,25                             ;the upper left position
  add cx,25
  call HighlightWhite

  add cx,50                             ;the upper right position
  call HighlightWhite

  add cx,25                             ;the right upper position
  add dx,25
  call HighlightWhite

  add dx,50                             ;the right lower position
  call HighlightWhite

pop dx
pop cx
ret
ValidatewKnight  endp

;--------------------------------------------Highlight white pieces----------------------------------------
finishww1: jmp finishww
HighlightWhite proc
push cx
push dx
push bx
push di

mov bx,0000h
mov di,0000h
mov reachingPieceFlag,bl          ;set reachingPieceFlag = 0  (false by default)
  ;check for the borders
  cmp cx,0
  jl finishww1                       ;do nothing if (cx < 0)
  cmp cx,175
  jg finishww1                       ;do nothing if (cx > 175)
  cmp dx,0
  jl finishww1                       ;do nothing if (dx < 0)
  cmp dx,175
  jg finishww1                       ;do nothing if (dx > 175)

  ;check if white piece in this position
    mov di,12
    push di
    convert25toindex
    pop di
    mov bh,0
    againw:
    cmp bx,di
    je whitew                      ;(jump if white piece)
    dec di
    cmp di,6
    jne againw
  
    jmp notwhitew
  whitew:                    
    mov bl,1                      
    mov reachingPieceFlag,bl      ;set reachingPieceFlag = 1  (true)
    jmp finishww
  notwhitew:
  

  ;check if black piece in this position
    mov di,7
    push di
    convert25toindex
    pop di
    mov bh,0
    againnw:
    dec di
    cmp bx,di
    je blackw                      ;(jump if black piece)
    cmp di,1
    jne againnw

    jmp notblackw
  blackw: 
    call DrawFrameBlue             ;highlight because it is black (could be attacked)     
      cmp bl,5                    ;check if black king
      jne continueblack
      bstatusbar bkCheckmate
      continueblack:               
    mov bl,1
    mov reachingPieceFlag,bl     ;set reachingPieceFlag = 1  (true)
    jmp finishww
  notblackw:

  call DrawFrameBlue                 ;highlight because no white or black
 
  finishww:

pop di
pop bx
pop dx
pop cx
ret
HighlightWhite  endp
;-------------------------------------------------------------------------------------------------------

;--------------------------------------false all The arrvalidwhite--------------------------------------
falseAllTheValidArrayWhite proc
push di

  mov di,64
nextZw:                   ;loop on the index
  dec di
  mov arrvalidwhite[di] , 0
  cmp di,0
  jg nextZw

pop di 



ret
falseAllTheValidArrayWhite endp
;-------------------------------------------------------------------------------------------------------

;--------------------------------------True The arrvalidwhite-------------------------------------------
TrueTheValidArrayWhite proc
push cx
push dx
push di

  
    
  mov cx,1
  mov dx,1

outerTw:                   ;loop on the y coordinates

  innerTw:                 ;loop on the x coordinates
    
    mov ah,0Dh              ;interrupt to get the pexel color
    int 10H                 ; AL = COLOR
    cmp al,01h              ;compare it with the highlighting color(blue)
    jne notHighlghtedTw
    push bx
    sub cx,1
    sub dx,1
    convert25toindex
    add cx,1
    add dx,1
    pop bx
    
    mov arrvalidwhite[di] , 1

    notHighlghtedTw:
      cmp cx,176
      je inner_endTw
      add cx,25
      jmp innerTw

  inner_endTw:
    add dx,25
    mov cx,1 
    cmp dx,176         
    jle outerTw            

outer_endTw:

pop di
pop dx
pop cx
ret
TrueTheValidArrayWhite endp
;-------------------------------------------------------------------------------------------------------

;-------------------------------- Validate the white piece ---------------------------------------------

validateWhitePiece proc
; To know which white piece to validate and true its validarray
    push bx
    push di
    convert25toindex
    pop di
      cmp bl,0 ;check if empty
        je finishHighlightingw
      cmp bl,7 ;check if Rook
        je wRook50
      cmp bl,8 ;check if kinght
        je wknight50
      cmp bl,9 ;check if Bishop
        je wBishop50
      cmp bl,11 ;check if Queen
        je wQueen50
      cmp bl,10 ;check if King
        je wKing50
      cmp bl,12 ;check if Pawn
        je wPawn50
        jmp finishHighlightingw

      wRook50:
        call ValidatewRook
        call TrueTheValidArrayWhite
        jmp finishHighlightingw
      wknight50:
        call ValidatewKnight
        call TrueTheValidArrayWhite
        jmp finishHighlightingw
      wBishop50:
        call ValidatewBishop
        call TrueTheValidArrayWhite
        jmp finishHighlightingw
      wQueen50:
        call ValidatewQueen
        call TrueTheValidArrayWhite
        jmp finishHighlightingw
      wKing50:
        call ValidatewKing
        call TrueTheValidArrayWhite
        jmp finishHighlightingw
      wPawn50:
        call ValidatewPawn
        call TrueTheValidArrayWhite
        jmp finishHighlightingw

   finishHighlightingw: 
    pop bx

ret
validateWhitePiece endp
;------------------------------------------------------------------------------------------------------


;-----------------------------------clear Cell With Green Or White--------------------------------------
clearCellWithGreenOrWhite proc
      ; clear the cell in the position (cx,dx) of the piece after move check if even draw Dark green else draw white
push si
push bp
push cx
push dx
push ax
     
     mov si,cx                        ;carry location of x (To know which cell we will clear)
     mov bp,dx                        ;carry location of y
     push bp
     push si                      
      mov dx,0000h
      add si,bp
      mov ax,si
      mov bp,2
      div bp
      
      cmp dl,1
      jz odd1macro
      jmp even1macro
      odd1macro:
     pop si 
     pop bp
    
    drawpicture GreenCellFilename,GreenCellFilehandle,25,25,GreenCellData,si,bp ;Green cell 
      jmp pass1macro
      even1macro:
     mov si,0000h
     mov bp ,0000h
     pop si 
     pop bp
     drawpicture GreyCellFilename,GreyCellFilehandle,25,25,GreyCellData,si,bp ;Grey cell  
      pass1macro:
  
  pop ax
  pop dx
  pop cx
  pop bp
  pop si

  ret
  clearCellWithGreenOrWhite endp
;--------------------------------------------------------------------------------------------------

;----------------------------------------promotion-------------------------------------------------
Promotion proc
; we have cx and dx 
push bx 
push di 

convert25toindex
cmp bl,6 ;check if its bpawn
jnz checkifItsWhitePawn
cmp dx,175d
jne leave1
mov arrayboard[di],4d
call clearCellWithGreenOrWhite
Drawpiece blackqueenData
jmp leave1
checkifItsWhitePawn:
cmp bl,12 ;check if its bpawn
jnz leave1
cmp dx,0d
jne leave1
mov arrayboard[di],11d
call clearCellWithGreenOrWhite
Drawpiece whitequeenData
leave1:
pop di 
pop bx

ret
Promotion endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                            Timer                                                    ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  exitcheckTimer1: jmp  exitcheckTimer
   ; Timer
   checkTimer proc
   
 push bx 
 push cx 
 push dx
   
 mov AH,2Ch
     int 21h
     mov currentTime,dh
     mov bl,currentTime     ;To compere with the previous second
     cmp bl ,previousTime
     pop dx
     pop cx
     jz exitcheckTimer1
    

     cmp TimerArray[0],3
      push cx 
      push dx
      mov cx ,0      ; change cx
      mov dx ,0        ; change dx
      push bx 
      push di
    jb do0             ; change number
    convert25toindex
    cmp zero,1        ; Create variable its name like loop in .data =1
    je DontDraw0
     call CheckWhichToDrawForTimer
      mov zero,1      ; change variable name
    DontDraw0:
     jmp inc0          ;change name
     do0:
      call CheckWhichToDrawForTimer
      ; ;TWo Third
       cmp TimerArray[0],1    ; change number 
       jz notTWoThird0          
       convert25toindex
       drawpicture  TwoThirdtimeFilename,TwoThirdtimeFilehandle,TwoThirdtimeWidth,TwoThirdtimeHeight,TwoThirdtimeData,0000,0   ;chnge cx and dx
       notTWoThird0:
      ;One Third
       cmp TimerArray[0],2              ;change number
       jz notoneThird0     
       drawpicture  oneThirdtimeFilename,oneThirdtimeFilehandle,oneThirdtimeWidth,oneThirdtimeHeight,oneThirdtimeData,0000,0    ;chnge cx and dx
       mov zero,0      ;change number
       notoneThird0:
  
     inc TimerArray[0]         ; change number
     
    inc0:               ; change number
    pop di
    pop bx
    pop dx 
    pop cx

      cmp TimerArray[1],3
      push cx 
      push dx
      mov cx ,25     ; change cx
      mov dx ,0        ; change dx
      push bx 
      push di
    jb do1             ; change number
    convert25toindex
    cmp one,1        ; Create variable its name like loop in .data =1
    je DontDraw1
     call CheckWhichToDrawForTimer
      mov one,1      ; change variable name
    DontDraw1:
     jmp inc1          ;change name
     do1:
      call CheckWhichToDrawForTimer
      ; ;TWo Third
       cmp TimerArray[1],1    ; change number 
       jz notTWoThird1         
       convert25toindex
       drawpicture  TwoThirdtimeFilename,TwoThirdtimeFilehandle,TwoThirdtimeWidth,TwoThirdtimeHeight,TwoThirdtimeData,25,0   ;chnge cx and dx
       notTWoThird1:
      ;One Third
       cmp TimerArray[1],2              ;change number
       jz notoneThird1     
       drawpicture  oneThirdtimeFilename,oneThirdtimeFilehandle,oneThirdtimeWidth,oneThirdtimeHeight,oneThirdtimeData,25,0    ;chnge cx and dx
       mov one,0      ;change number
       notoneThird1:
  
     inc TimerArray[1]         ; change number
     
    inc1:               ; change number
    pop di
    pop bx
    pop dx 
    pop cx

    cmp TimerArray[2],3
      push cx 
      push dx
      mov cx ,50     ; change cx
      mov dx ,0        ; change dx
      push bx 
      push di
    jb do2             ; change number
    convert25toindex
    cmp two,1        ; Create variable its name like loop in .data =1
    je DontDraw2
     call CheckWhichToDrawForTimer
      mov two,1      ; change variable name
    DontDraw2:
     jmp inc2          ;change name
     do2:
      call CheckWhichToDrawForTimer
      ; ;TWo Third
       cmp TimerArray[2],1    ; change number 
       jz notTWoThird2         
       convert25toindex
       drawpicture  TwoThirdtimeFilename,TwoThirdtimeFilehandle,TwoThirdtimeWidth,TwoThirdtimeHeight,TwoThirdtimeData,50,0   ;chnge cx and dx
       notTWoThird2:
      ;One Third
       cmp TimerArray[2],2              ;change number
       jz notoneThird2     
       drawpicture  oneThirdtimeFilename,oneThirdtimeFilehandle,oneThirdtimeWidth,oneThirdtimeHeight,oneThirdtimeData,50,0    ;chnge cx and dx
       mov two,0      ;change number
       notoneThird2:
  
     inc TimerArray[2]         ; change number
     
    inc2:               ; change number
    pop di
    pop bx
    pop dx 
    pop cx

    cmp TimerArray[3],3
      push cx 
      push dx
      mov cx ,75     ; change cx
      mov dx ,0        ; change dx
      push bx 
      push di
    jb do3             ; change number
    convert25toindex
    cmp three,1        ; Create variable its name like loop in .data =1
    je DontDraw3
     call CheckWhichToDrawForTimer
      mov three,1      ; change variable name
    DontDraw3:
     jmp inc3          ;change name
     do3:
      call CheckWhichToDrawForTimer
      ; ;TWo Third
       cmp TimerArray[3],1    ; change number 
       jz notTWoThird3         
       convert25toindex
       drawpicture  TwoThirdtimeFilename,TwoThirdtimeFilehandle,TwoThirdtimeWidth,TwoThirdtimeHeight,TwoThirdtimeData,75,0   ;chnge cx and dx
       notTWoThird3:
      ;One Third
       cmp TimerArray[3],2              ;change number
       jz notoneThird3     
       drawpicture  oneThirdtimeFilename,oneThirdtimeFilehandle,oneThirdtimeWidth,oneThirdtimeHeight,oneThirdtimeData,75,0    ;chnge cx and dx
       mov three,0      ;change number
       notoneThird3:
  
     inc TimerArray[3]         ; change number
     
    inc3:               ; change number
    pop di
    pop bx
    pop dx 
    pop cx

    cmp TimerArray[4],3
      push cx 
      push dx
      mov cx ,100     ; change cx
      mov dx ,0        ; change dx
      push bx 
      push di
    jb do4             ; change number
    convert25toindex
    cmp four,1        ; Create variable its name like loop in .data =1
    je DontDraw4
     call CheckWhichToDrawForTimer
      mov four,1      ; change variable name
    DontDraw4:
     jmp inc4          ;change name
     do4:
      call CheckWhichToDrawForTimer
      ; ;TWo Third
       cmp TimerArray[4],1    ; change number 
       jz notTWoThird4         
       convert25toindex
       drawpicture  TwoThirdtimeFilename,TwoThirdtimeFilehandle,TwoThirdtimeWidth,TwoThirdtimeHeight,TwoThirdtimeData,100,0   ;chnge cx and dx
       notTWoThird4:
      ;One Third
       cmp TimerArray[4],2              ;change number
       jz notoneThird4     
       drawpicture  oneThirdtimeFilename,oneThirdtimeFilehandle,oneThirdtimeWidth,oneThirdtimeHeight,oneThirdtimeData,100,0    ;chnge cx and dx
       mov four,0      ;change number
       notoneThird4:
  
     inc TimerArray[4]         ; change number
     
    inc4:               ; change number
    pop di
    pop bx
    pop dx 
    pop cx

    cmp TimerArray[5],3
      push cx 
      push dx
      mov cx ,125     ; change cx
      mov dx ,0        ; change dx
      push bx 
      push di
    jb do5             ; change number
    convert25toindex
    cmp five,1        ; Create variable its name like loop in .data =1
    je DontDraw5
     call CheckWhichToDrawForTimer
      mov five,1      ; change variable name
    DontDraw5:
     jmp inc5          ;change name
     do5:
      call CheckWhichToDrawForTimer
      ; ;TWo Third
       cmp TimerArray[5],1    ; change number 
       jz notTWoThird5         
       convert25toindex
       drawpicture  TwoThirdtimeFilename,TwoThirdtimeFilehandle,TwoThirdtimeWidth,TwoThirdtimeHeight,TwoThirdtimeData,125,0   ;chnge cx and dx
       notTWoThird5:
      ;One Third
       cmp TimerArray[5],2              ;change number
       jz notoneThird5     
       drawpicture  oneThirdtimeFilename,oneThirdtimeFilehandle,oneThirdtimeWidth,oneThirdtimeHeight,oneThirdtimeData,125,0    ;chnge cx and dx
       mov five,0      ;change number
       notoneThird5:
  
     inc TimerArray[5]         ; change number
     
    inc5:               ; change number
    pop di
    pop bx
    pop dx 
    pop cx

     cmp TimerArray[6],3
      push cx 
      push dx
      mov cx ,150     ; change cx
      mov dx ,0        ; change dx
      push bx 
      push di
    jb do6             ; change number
    convert25toindex
    cmp six,1        ; Create variable its name like loop in .data =1
    je DontDraw6
     call CheckWhichToDrawForTimer
      mov six,1      ; change variable name
    DontDraw6:
     jmp inc6          ;change name
     do6:
      call CheckWhichToDrawForTimer
      ; ;TWo Third
       cmp TimerArray[6],1    ; change number 
       jz notTWoThird6         
       convert25toindex
       drawpicture  TwoThirdtimeFilename,TwoThirdtimeFilehandle,TwoThirdtimeWidth,TwoThirdtimeHeight,TwoThirdtimeData,150,0   ;chnge cx and dx
       notTWoThird6:
      ;One Third
       cmp TimerArray[6],2              ;change number
       jz notoneThird6     
       drawpicture  oneThirdtimeFilename,oneThirdtimeFilehandle,oneThirdtimeWidth,oneThirdtimeHeight,oneThirdtimeData,150,0    ;chnge cx and dx
       mov six,0      ;change number
       notoneThird6:
  
     inc TimerArray[6]         ; change number
     
    inc6:               ; change number
    pop di
    pop bx
    pop dx 
    pop cx
    
   cmp TimerArray[7],3
      push cx 
      push dx
      mov cx ,175     ; change cx
      mov dx ,0        ; change dx
      push bx 
      push di
    jb do7             ; change number
    convert25toindex
    cmp seven,1        ; Create variable its name like loop in .data =1
    je DontDraw7
     call CheckWhichToDrawForTimer
      mov seven,1      ; change variable name
    DontDraw7:
     jmp inc7          ;change name
     do7:
      call CheckWhichToDrawForTimer
      ; ;TWo Third
       cmp TimerArray[7],1    ; change number 
       jz notTWoThird7         
       convert25toindex
       drawpicture  TwoThirdtimeFilename,TwoThirdtimeFilehandle,TwoThirdtimeWidth,TwoThirdtimeHeight,TwoThirdtimeData,175,0   ;chnge cx and dx
       notTWoThird7:
      ;One Third
       cmp TimerArray[7],2              ;change number
       jz notoneThird7     
       drawpicture  oneThirdtimeFilename,oneThirdtimeFilehandle,oneThirdtimeWidth,oneThirdtimeHeight,oneThirdtimeData,175,0    ;chnge cx and dx
       mov seven,0      ;change number
       notoneThird7:
  
     inc TimerArray[7]         ; change number
     
    inc7:               ; change number
    pop di
    pop bx
    pop dx 
    pop cx
    

    cmp TimerArray[8],3
      push cx 
      push dx
      mov cx ,0     ; change cx
      mov dx ,25       ; change dx
      push bx 
      push di
    jb do8             ; change number
    convert25toindex
    cmp eight,1        ; Create variable its name like loop in .data =1
    je DontDraw8
     call CheckWhichToDrawForTimer
      mov eight,1      ; change variable name
    DontDraw8:
     jmp inc8          ;change name
     do8:
      call CheckWhichToDrawForTimer
      ; ;TWo Third
       cmp TimerArray[8],1    ; change number 
       jz notTWoThird8         
       convert25toindex
       drawpicture  TwoThirdtimeFilename,TwoThirdtimeFilehandle,TwoThirdtimeWidth,TwoThirdtimeHeight,TwoThirdtimeData,0,25   ;chnge cx and dx
       notTWoThird8:
      ;One Third
       cmp TimerArray[8],2              ;change number
       jz notoneThird8    
       drawpicture  oneThirdtimeFilename,oneThirdtimeFilehandle,oneThirdtimeWidth,oneThirdtimeHeight,oneThirdtimeData,0,25    ;chnge cx and dx
       mov eight,0      ;change number
       notoneThird8:
  
     inc TimerArray[8]         ; change number
     
    inc8:               ; change number
    pop di
    pop bx
    pop dx 
    pop cx

   cmp TimerArray[9],3
      push cx 
      push dx
      mov cx ,25     ; change cx
      mov dx ,25       ; change dx
      push bx 
      push di
    jb do9             ; change number
    convert25toindex
    cmp nine,1        ; Create variable its name like loop in .data =1
    je DontDraw9
     call CheckWhichToDrawForTimer
      mov nine,1      ; change variable name
    DontDraw9:
     jmp inc9          ;change name
     do9:
      call CheckWhichToDrawForTimer
      ; ;TWo Third
       cmp TimerArray[9],1    ; change number 
       jz notTWoThird9         
       convert25toindex
       drawpicture  TwoThirdtimeFilename,TwoThirdtimeFilehandle,TwoThirdtimeWidth,TwoThirdtimeHeight,TwoThirdtimeData,25,25   ;chnge cx and dx
       notTWoThird9:
      ;One Third
       cmp TimerArray[9],2              ;change number
       jz notoneThird9   
       drawpicture  oneThirdtimeFilename,oneThirdtimeFilehandle,oneThirdtimeWidth,oneThirdtimeHeight,oneThirdtimeData,25,25    ;chnge cx and dx
       mov nine,0      ;change number
       notoneThird9:
  
     inc TimerArray[9]         ; change number
     
    inc9:               ; change number
    pop di
    pop bx
    pop dx 
    pop cx

    cmp TimerArray[10],3
      push cx 
      push dx
      mov cx ,50     ; change cx
      mov dx ,25       ; change dx
      push bx 
      push di
    jb do10             ; change number
    convert25toindex
    cmp ten,1        ; Create variable its name like loop in .data =1
    je DontDraw10
     call CheckWhichToDrawForTimer
      mov ten,1      ; change variable name
    DontDraw10:
     jmp inc10          ;change name
     do10:
      call CheckWhichToDrawForTimer
      ; ;TWo Third
       cmp TimerArray[10],1    ; change number 
       jz notTWoThird10        
       convert25toindex
       drawpicture  TwoThirdtimeFilename,TwoThirdtimeFilehandle,TwoThirdtimeWidth,TwoThirdtimeHeight,TwoThirdtimeData,50,25   ;chnge cx and dx
       notTWoThird10:
      ;One Third
       cmp TimerArray[10],2              ;change number
       jz notoneThird10   
       drawpicture  oneThirdtimeFilename,oneThirdtimeFilehandle,oneThirdtimeWidth,oneThirdtimeHeight,oneThirdtimeData,50,25    ;chnge cx and dx
       mov ten,0      ;change number
       notoneThird10:
  
     inc TimerArray[10]         ; change number
     
    inc10:               ; change number
    pop di
    pop bx
    pop dx 
    pop cx

    cmp TimerArray[11],3
      push cx 
      push dx
      mov cx ,75     ; change cx
      mov dx ,25       ; change dx
      push bx 
      push di
    jb do11             ; change number
    convert25toindex
    cmp eleven,1        ; Create variable its name like loop in .data =1
    je DontDraw11
     call CheckWhichToDrawForTimer
      mov eleven,1      ; change variable name
    DontDraw11:
     jmp inc11          ;change name
     do11:
      call CheckWhichToDrawForTimer
      ; ;TWo Third
       cmp TimerArray[11],1    ; change number 
       jz notTWoThird11        
       convert25toindex
       drawpicture  TwoThirdtimeFilename,TwoThirdtimeFilehandle,TwoThirdtimeWidth,TwoThirdtimeHeight,TwoThirdtimeData,75,25   ;chnge cx and dx
       notTWoThird11:
      ;One Third
       cmp TimerArray[11],2              ;change number
       jz notoneThird11   
       drawpicture  oneThirdtimeFilename,oneThirdtimeFilehandle,oneThirdtimeWidth,oneThirdtimeHeight,oneThirdtimeData,75,25    ;chnge cx and dx
       mov eleven,0      ;change number
       notoneThird11:
  
     inc TimerArray[11]         ; change number
     
    inc11:               ; change number
    pop di
    pop bx
    pop dx 
    pop cx

    cmp TimerArray[12],3
      push cx 
      push dx
      mov cx ,100    ; change cx
      mov dx ,25       ; change dx
      push bx 
      push di
    jb do12             ; change number
    convert25toindex
    cmp twelve,1        ; Create variable its name like loop in .data =1
    je DontDraw12
     call CheckWhichToDrawForTimer
      mov twelve,1      ; change variable name
    DontDraw12:
     jmp inc12          ;change name
     do12:
      call CheckWhichToDrawForTimer
      ; ;TWo Third
       cmp TimerArray[12],1    ; change number 
       jz notTWoThird12        
       convert25toindex
       drawpicture  TwoThirdtimeFilename,TwoThirdtimeFilehandle,TwoThirdtimeWidth,TwoThirdtimeHeight,TwoThirdtimeData,100,25   ;chnge cx and dx
       notTWoThird12:
      ;One Third
       cmp TimerArray[12],2              ;change number
       jz notoneThird12   
       drawpicture  oneThirdtimeFilename,oneThirdtimeFilehandle,oneThirdtimeWidth,oneThirdtimeHeight,oneThirdtimeData,100,25    ;chnge cx and dx
       mov twelve,0      ;change number
       notoneThird12:
  
     inc TimerArray[12]         ; change number
     
    inc12:               ; change number
    pop di
    pop bx
    pop dx 
    pop cx 

  cmp TimerArray[13],3
      push cx 
      push dx
      mov cx ,125    ; change cx
      mov dx ,25       ; change dx
      push bx 
      push di
    jb do13             ; change number
    convert25toindex
    cmp thirteen,1        ; Create variable its name like loop in .data =1
    je DontDraw13
     call CheckWhichToDrawForTimer
      mov thirteen,1      ; change variable name
    DontDraw13:
     jmp inc13          ;change name
     do13:
      call CheckWhichToDrawForTimer
      ; ;TWo Third
       cmp TimerArray[13],1    ; change number 
       jz notTWoThird13        
       convert25toindex
       drawpicture  TwoThirdtimeFilename,TwoThirdtimeFilehandle,TwoThirdtimeWidth,TwoThirdtimeHeight,TwoThirdtimeData,125,25   ;chnge cx and dx
       notTWoThird13:
      ;One Third
       cmp TimerArray[13],2              ;change number
       jz notoneThird13   
       drawpicture  oneThirdtimeFilename,oneThirdtimeFilehandle,oneThirdtimeWidth,oneThirdtimeHeight,oneThirdtimeData,125,25    ;chnge cx and dx
       mov thirteen,0      ;change number
       notoneThird13:
  
     inc TimerArray[13]         ; change number
     
    inc13:               ; change number
    pop di
    pop bx
    pop dx 
    pop cx 

     cmp TimerArray[14],3
      push cx 
      push dx
      mov cx ,150   ; change cx
      mov dx ,25       ; change dx
      push bx 
      push di
    jb do14             ; change number
    convert25toindex
    cmp fourteen,1        ; Create variable its name like loop in .data =1
    je DontDraw14
     call CheckWhichToDrawForTimer
      mov fourteen,1      ; change variable name
    DontDraw14:
     jmp inc14          ;change name
     do14:
      call CheckWhichToDrawForTimer
      ; ;TWo Third
       cmp TimerArray[14],1    ; change number 
       jz notTWoThird14        
       convert25toindex
       drawpicture  TwoThirdtimeFilename,TwoThirdtimeFilehandle,TwoThirdtimeWidth,TwoThirdtimeHeight,TwoThirdtimeData,150,25   ;chnge cx and dx
       notTWoThird14:
      ;One Third
       cmp TimerArray[14],2              ;change number
       jz notoneThird14  
       drawpicture  oneThirdtimeFilename,oneThirdtimeFilehandle,oneThirdtimeWidth,oneThirdtimeHeight,oneThirdtimeData,150,25    ;chnge cx and dx
       mov fourteen,0      ;change number
       notoneThird14:
  
     inc TimerArray[14]         ; change number
     
    inc14:               ; change number
    pop di
    pop bx
    pop dx 
    pop cx 

    cmp TimerArray[15],3
      push cx 
      push dx
      mov cx ,175   ; change cx
      mov dx ,25       ; change dx
      push bx 
      push di
    jb do15            ; change number
    convert25toindex
    cmp fifteen,1        ; Create variable its name like loop in .data =1
    je DontDraw15
     call CheckWhichToDrawForTimer
      mov fifteen,1      ; change variable name
    DontDraw15:
     jmp inc15          ;change name
     do15:
      call CheckWhichToDrawForTimer
      ; ;TWo Third
       cmp TimerArray[15],1    ; change number 
       jz notTWoThird15        
       convert25toindex
       drawpicture  TwoThirdtimeFilename,TwoThirdtimeFilehandle,TwoThirdtimeWidth,TwoThirdtimeHeight,TwoThirdtimeData,175,25   ;chnge cx and dx
       notTWoThird15:
      ;One Third
       cmp TimerArray[15],2              ;change number
       jz notoneThird15  
       drawpicture  oneThirdtimeFilename,oneThirdtimeFilehandle,oneThirdtimeWidth,oneThirdtimeHeight,oneThirdtimeData,175,25    ;chnge cx and dx
       mov fifteen,0      ;change number
       notoneThird15:
  
     inc TimerArray[15]         ; change number
     
    inc15:               ; change number
    pop di
    pop bx
    pop dx 
    pop cx 

 
     cmp TimerArray[16],3
      push cx 
      push dx
      mov cx ,0000      ; change cx
      mov dx ,50        ; change dx
      push bx 
      push di
    jb do16              ; change number
    convert25toindex
    cmp sixteen,1        ; Create variable its name like loop in .data =1
    je DontDraw
     call CheckWhichToDrawForTimer
      mov sixteen,1      ; change variable name
    DontDraw:
     jmp inc16           ;change name
     do16:
      call CheckWhichToDrawForTimer
      ; ;TWo Third
       cmp TimerArray[16],1    ; change number 
       jz notTWoThird          
       convert25toindex
       drawpicture  TwoThirdtimeFilename,TwoThirdtimeFilehandle,TwoThirdtimeWidth,TwoThirdtimeHeight,TwoThirdtimeData,0000,50   ;chnge cx and dx
       notTWoThird:
      ;One Third
       cmp TimerArray[16],2              ;change number
       jz notoneThird      
       drawpicture  oneThirdtimeFilename,oneThirdtimeFilehandle,oneThirdtimeWidth,oneThirdtimeHeight,oneThirdtimeData,0000,50    ;chnge cx and dx
       mov sixteen,0      ;change number
       notoneThird:
  
     inc TimerArray[16]         ; change number
     
    inc16:               ; change number
    pop di
    pop bx
    pop dx 
    pop cx
    
    
    cmp TimerArray[17],3
     push cx 
      push dx
      mov cx ,0025      ; change cx
      mov dx ,50        ; change dx
      push bx 
      push di
    jb do17              ; change number
    convert25toindex
    cmp seventeen,1        ; Create variable its name like loop in .data =1
    je DontDraw17         ; change lable name
     call CheckWhichToDrawForTimer
      mov seventeen,1      ; change variable name
    DontDraw17:
     jmp inc17           ;change name
     do17:
      call CheckWhichToDrawForTimer
      ; ;TWo Third
       cmp TimerArray[17],1    ; change number 
       jz notTWoThird17        ;change lable name 
       convert25toindex
       drawpicture  TwoThirdtimeFilename,TwoThirdtimeFilehandle,TwoThirdtimeWidth,TwoThirdtimeHeight,TwoThirdtimeData,0025,50   ;chnge cx and dx
       notTWoThird17:
      ;One Third
       cmp TimerArray[17],2              ;change number
       jz notoneThird17                  ;change lable name
       drawpicture  oneThirdtimeFilename,oneThirdtimeFilehandle,oneThirdtimeWidth,oneThirdtimeHeight,oneThirdtimeData,0025,50    ;chnge cx and dx
       mov seventeen,0      ;change number
       notoneThird17:
  
     inc TimerArray[17]         ; change number
     
    inc17:               ; change number
    pop di
    pop bx
    pop dx 
    pop cx

    cmp TimerArray[18],3
    push cx 
      push dx
      mov cx ,0050      ; change cx
      mov dx ,50        ; change dx
      push bx 
      push di
    jb do18              ; change number
    convert25toindex
    cmp eighten,1        ; Create variable its name like loop in .data =1
    je DontDraw18         ; change lable name
     call CheckWhichToDrawForTimer
      mov eighten,1      ; change variable name
    DontDraw18:            ; change lable name
     jmp inc18           ;change name
     do18:
      call CheckWhichToDrawForTimer
      ; ;TWo Third
       cmp TimerArray[18],1    ; change number 
       jz notTWoThird18        ;change lable name 
       convert25toindex
       drawpicture  TwoThirdtimeFilename,TwoThirdtimeFilehandle,TwoThirdtimeWidth,TwoThirdtimeHeight,TwoThirdtimeData,0050,50   ;chnge cx and dx
       notTWoThird18:
      ;One Third
       cmp TimerArray[18],2              ;change number
       jz notoneThird18                  ;change lable name
       drawpicture  oneThirdtimeFilename,oneThirdtimeFilehandle,oneThirdtimeWidth,oneThirdtimeHeight,oneThirdtimeData,0050,50    ;chnge cx and dx
       mov eighten,0      ;change number
       notoneThird18:
  
     inc TimerArray[18]         ; change number
     
    inc18:               ; change number
    pop di
    pop bx
    pop dx 
    pop cx

     cmp TimerArray[19],3
    push cx 
      push dx
      mov cx ,0075      ; change cx
      mov dx ,50        ; change dx
      push bx 
      push di
    jb do19              ; change number
    convert25toindex
    cmp nineteen,1        ; Create variable its name like loop in .data =1
    je DontDraw19         ; change lable name
     call CheckWhichToDrawForTimer
      mov nineteen,1      ; change variable name
    DontDraw19:            ; change lable name
     jmp inc19           ;change name
     do19:
      call CheckWhichToDrawForTimer
      ; ;TWo Third
       cmp TimerArray[19],1    ; change number 
       jz notTWoThird19        ;change lable name 
       convert25toindex
       drawpicture  TwoThirdtimeFilename,TwoThirdtimeFilehandle,TwoThirdtimeWidth,TwoThirdtimeHeight,TwoThirdtimeData,0075,50   ;chnge cx and dx
       notTWoThird19:
      ;One Third
       cmp TimerArray[19],2              ;change number
       jz notoneThird19                  ;change lable name
       drawpicture  oneThirdtimeFilename,oneThirdtimeFilehandle,oneThirdtimeWidth,oneThirdtimeHeight,oneThirdtimeData,0075,50    ;chnge cx and dx
       mov nineteen,0      ;change number
       notoneThird19:
  
     inc TimerArray[19]         ; change number
     
    inc19:               ; change number
    pop di
    pop bx
    pop dx 
    pop cx

     cmp TimerArray[20],3
   
    push cx 
      push dx
      mov cx ,100      ; change cx
      mov dx ,50        ; change dx
      push bx 
      push di
    jb do20              ; change number
    convert25toindex
    cmp twenty,1        ; Create variable its name like loop in .data =1
    je DontDraw20       ; change lable name
     call CheckWhichToDrawForTimer
      mov twenty,1      ; change variable name
    DontDraw20:            ; change lable name
     jmp inc20           ;change name
     do20:
      call CheckWhichToDrawForTimer
      ; ;TWo Third
       cmp TimerArray[20],1    ; change number 
       jz notTWoThird20    ;change lable name 
       convert25toindex
       drawpicture  TwoThirdtimeFilename,TwoThirdtimeFilehandle,TwoThirdtimeWidth,TwoThirdtimeHeight,TwoThirdtimeData,0100,50   ;chnge cx and dx
       notTWoThird20:
      ;One Third
       cmp TimerArray[20],2              ;change number
       jz notoneThird20                 ;change lable name
       drawpicture  oneThirdtimeFilename,oneThirdtimeFilehandle,oneThirdtimeWidth,oneThirdtimeHeight,oneThirdtimeData,0100,50    ;chnge cx and dx
       mov twenty,0      ;change number
       notoneThird20:
  
     inc TimerArray[20]         ; change number
     
    inc20:               ; change number
    pop di
    pop bx
    pop dx 
    pop cx

    cmp TimerArray[21],3
   
    push cx 
      push dx
      mov cx ,125     ; change cx
      mov dx ,50        ; change dx
      push bx 
      push di
    jb do21              ; change number
    convert25toindex
    cmp twentyone,1        ; Create variable its name like loop in .data =1
    je DontDraw21       ; change lable name
     call CheckWhichToDrawForTimer
      mov twentyone,1      ; change variable name
    DontDraw21:            ; change lable name
     jmp inc21           ;change name
     do21:
      call CheckWhichToDrawForTimer
      ; ;TWo Third
       cmp TimerArray[21],1    ; change number 
       jz notTWoThird21   ;change lable name 
       convert25toindex
       drawpicture  TwoThirdtimeFilename,TwoThirdtimeFilehandle,TwoThirdtimeWidth,TwoThirdtimeHeight,TwoThirdtimeData,0125,50   ;chnge cx and dx
       notTWoThird21:
      ;One Third
       cmp TimerArray[21],2              ;change number
       jz notoneThird21                ;change lable name
       drawpicture  oneThirdtimeFilename,oneThirdtimeFilehandle,oneThirdtimeWidth,oneThirdtimeHeight,oneThirdtimeData,0125,50    ;chnge cx and dx
       mov twentyone,0      ;change number
       notoneThird21:
  
     inc TimerArray[21]         ; change number
     
    inc21:               ; change number
    pop di
    pop bx
    pop dx 
    pop cx

     cmp TimerArray[22],3
   
    push cx 
      push dx
      mov cx ,150     ; change cx
      mov dx ,50        ; change dx
      push bx 
      push di
    jb do22              ; change number
    convert25toindex
    cmp twentytwo,1        ; Create variable its name like loop in .data =1
    je DontDraw22      ; change lable name
     call CheckWhichToDrawForTimer
      mov twentytwo,1      ; change variable name
    DontDraw22:            ; change lable name
     jmp inc22           ;change name
     do22:
      call CheckWhichToDrawForTimer
      ; ;TWo Third
       cmp TimerArray[22],1    ; change number 
       jz notTWoThird22   ;change lable name 
       convert25toindex
       drawpicture  TwoThirdtimeFilename,TwoThirdtimeFilehandle,TwoThirdtimeWidth,TwoThirdtimeHeight,TwoThirdtimeData,0150,50   ;chnge cx and dx
       notTWoThird22:
      ;One Third
       cmp TimerArray[22],2              ;change number
       jz notoneThird22                ;change lable name
       drawpicture  oneThirdtimeFilename,oneThirdtimeFilehandle,oneThirdtimeWidth,oneThirdtimeHeight,oneThirdtimeData,0150,50    ;chnge cx and dx
       mov twentytwo,0      ;change number
       notoneThird22:
  
     inc TimerArray[22]         ; change number
     
    inc22:               ; change number
    pop di
    pop bx
    pop dx 
    pop cx

      cmp TimerArray[23],3
   
    push cx 
      push dx
      mov cx ,175     ; change cx
      mov dx ,50        ; change dx
      push bx 
      push di
    jb do23              ; change number
    convert25toindex
    cmp twentythr,1        ; Create variable its name like loop in .data =1
    je DontDraw23      ; change lable name
     call CheckWhichToDrawForTimer
      mov twentythr,1      ; change variable name
    DontDraw23:            ; change lable name
     jmp inc23           ;change name
     do23:
      call CheckWhichToDrawForTimer
      ; ;TWo Third
       cmp TimerArray[23],1    ; change number 
       jz notTWoThird23   ;change lable name 
       convert25toindex
       drawpicture  TwoThirdtimeFilename,TwoThirdtimeFilehandle,TwoThirdtimeWidth,TwoThirdtimeHeight,TwoThirdtimeData,0175,50   ;chnge cx and dx
       notTWoThird23:
      ;One Third
       cmp TimerArray[23],2              ;change number
       jz notoneThird23                ;change lable name
       drawpicture  oneThirdtimeFilename,oneThirdtimeFilehandle,oneThirdtimeWidth,oneThirdtimeHeight,oneThirdtimeData,0175,50    ;chnge cx and dx
       mov twentythr,0      ;change number
       notoneThird23:
  
     inc TimerArray[23]         ; change number
     
    inc23:               ; change number
    pop di
    pop bx
    pop dx 
    pop cx

     cmp TimerArray[24],3
   
    push cx 
      push dx
      mov cx ,0     ; change cx
      mov dx ,75        ; change dx
      push bx 
      push di
    jb do24              ; change number
    convert25toindex
    cmp twentyfou,1        ; Create variable its name like loop in .data =1
    je DontDraw24     ; change lable name
     call CheckWhichToDrawForTimer
      mov twentyfou,1      ; change variable name
    DontDraw24:            ; change lable name
     jmp inc24           ;change name
     do24:
      call CheckWhichToDrawForTimer
      ; ;TWo Third
       cmp TimerArray[24],1    ; change number 
       jz notTWoThird24   ;change lable name 
       convert25toindex
       drawpicture  TwoThirdtimeFilename,TwoThirdtimeFilehandle,TwoThirdtimeWidth,TwoThirdtimeHeight,TwoThirdtimeData,00,75   ;chnge cx and dx
       notTWoThird24:
      ;One Third
       cmp TimerArray[24],2              ;change number
       jz notoneThird24                ;change lable name
       drawpicture  oneThirdtimeFilename,oneThirdtimeFilehandle,oneThirdtimeWidth,oneThirdtimeHeight,oneThirdtimeData,00,75    ;chnge cx and dx
       mov twentyfou,0      ;change number
       notoneThird24:
  
     inc TimerArray[24]         ; change number
     
    inc24:               ; change number
    pop di
    pop bx
    pop dx 
    pop cx

     cmp TimerArray[25],3
   
    push cx 
      push dx
      mov cx ,25    ; change cx
      mov dx ,75        ; change dx
      push bx 
      push di
    jb do25              ; change number
    convert25toindex
    cmp twentyfiv,1        ; Create variable its name like loop in .data =1
    je DontDraw25    ; change lable name
     call CheckWhichToDrawForTimer
      mov twentyfiv,1      ; change variable name
    DontDraw25:            ; change lable name
     jmp inc25           ;change name
     do25:
      call CheckWhichToDrawForTimer
      ; ;TWo Third
       cmp TimerArray[25],1    ; change number 
       jz notTWoThird25   ;change lable name 
       convert25toindex
       drawpicture  TwoThirdtimeFilename,TwoThirdtimeFilehandle,TwoThirdtimeWidth,TwoThirdtimeHeight,TwoThirdtimeData,25,75   ;chnge cx and dx
       notTWoThird25:
      ;One Third
       cmp TimerArray[25],2              ;change number
       jz notoneThird25                ;change lable name
       drawpicture  oneThirdtimeFilename,oneThirdtimeFilehandle,oneThirdtimeWidth,oneThirdtimeHeight,oneThirdtimeData,25,75    ;chnge cx and dx
       mov twentyfiv,0      ;change number
       notoneThird25:
  
     inc TimerArray[25]         ; change number
     
    inc25:               ; change number
    pop di
    pop bx
    pop dx 
    pop cx

     cmp TimerArray[26],3
   
    push cx 
      push dx
      mov cx ,50    ; change cx
      mov dx ,75        ; change dx
      push bx 
      push di
    jb do26              ; change number
    convert25toindex
    cmp twentysix,1        ; Create variable its name like loop in .data =1
    je DontDraw26    ; change lable name
     call CheckWhichToDrawForTimer
      mov twentysix,1      ; change variable name
    DontDraw26:            ; change lable name
     jmp inc26           ;change name
     do26:
      call CheckWhichToDrawForTimer
      ; ;TWo Third
       cmp TimerArray[26],1    ; change number 
       jz notTWoThird26   ;change lable name 
       convert25toindex
       drawpicture  TwoThirdtimeFilename,TwoThirdtimeFilehandle,TwoThirdtimeWidth,TwoThirdtimeHeight,TwoThirdtimeData,50,75   ;chnge cx and dx
       notTWoThird26:
      ;One Third
       cmp TimerArray[26],2              ;change number
       jz notoneThird26                ;change lable name
       drawpicture  oneThirdtimeFilename,oneThirdtimeFilehandle,oneThirdtimeWidth,oneThirdtimeHeight,oneThirdtimeData,50,75    ;chnge cx and dx
       mov twentysix,0      ;change number
       notoneThird26:
  
     inc TimerArray[26]         ; change number
     
    inc26:               ; change number
    pop di
    pop bx
    pop dx 
    pop cx

     cmp TimerArray[27],3
   
    push cx 
      push dx
      mov cx ,75    ; change cx
      mov dx ,75        ; change dx
      push bx 
      push di
    jb do27              ; change number
    convert25toindex
    cmp twentysev,1        ; Create variable its name like loop in .data =1
    je DontDraw27    ; change lable name
     call CheckWhichToDrawForTimer
      mov twentysev,1      ; change variable name
    DontDraw27:            ; change lable name
     jmp inc27           ;change name
     do27:
      call CheckWhichToDrawForTimer
      ; ;TWo Third
       cmp TimerArray[27],1    ; change number 
       jz notTWoThird27   ;change lable name 
       convert25toindex
       drawpicture  TwoThirdtimeFilename,TwoThirdtimeFilehandle,TwoThirdtimeWidth,TwoThirdtimeHeight,TwoThirdtimeData,75,75   ;chnge cx and dx
       notTWoThird27:
      ;One Third
       cmp TimerArray[27],2              ;change number
       jz notoneThird27                ;change lable name
       drawpicture  oneThirdtimeFilename,oneThirdtimeFilehandle,oneThirdtimeWidth,oneThirdtimeHeight,oneThirdtimeData,75,75    ;chnge cx and dx
       mov twentysev,0      ;change number
       notoneThird27:
  
     inc TimerArray[27]         ; change number
     
    inc27:               ; change number
    pop di
    pop bx
    pop dx 
    pop cx

     cmp TimerArray[28],3
   
    push cx 
      push dx
      mov cx ,100    ; change cx
      mov dx ,75        ; change dx
      push bx 
      push di
    jb do28              ; change number
    convert25toindex
    cmp twentyeig,1        ; Create variable its name like loop in .data =1
    je DontDraw28    ; change lable name
     call CheckWhichToDrawForTimer
      mov twentyeig,1      ; change variable name
    DontDraw28:            ; change lable name
     jmp inc28           ;change name
     do28:
      call CheckWhichToDrawForTimer
      ; ;TWo Third
       cmp TimerArray[28],1    ; change number 
       jz notTWoThird28   ;change lable name 
       convert25toindex
       drawpicture  TwoThirdtimeFilename,TwoThirdtimeFilehandle,TwoThirdtimeWidth,TwoThirdtimeHeight,TwoThirdtimeData,100,75   ;chnge cx and dx
       notTWoThird28:
      ;One Third
       cmp TimerArray[28],2              ;change number
       jz notoneThird28                ;change lable name
       drawpicture  oneThirdtimeFilename,oneThirdtimeFilehandle,oneThirdtimeWidth,oneThirdtimeHeight,oneThirdtimeData,100,75    ;chnge cx and dx
       mov twentyeig,0      ;change number
       notoneThird28:
  
     inc TimerArray[28]         ; change number
     
    inc28:               ; change number
    pop di
    pop bx
    pop dx 
    pop cx

     cmp TimerArray[29],3
   
    push cx 
      push dx
      mov cx ,125    ; change cx
      mov dx ,75        ; change dx
      push bx 
      push di
    jb do29              ; change number
    convert25toindex
    cmp twentynin,1        ; Create variable its name like loop in .data =1
    je DontDraw29    ; change lable name
     call CheckWhichToDrawForTimer
      mov twentynin,1      ; change variable name
    DontDraw29:            ; change lable name
     jmp inc29           ;change name
     do29:
      call CheckWhichToDrawForTimer
      ; ;TWo Third
       cmp TimerArray[29],1    ; change number 
       jz notTWoThird29   ;change lable name 
       convert25toindex
       drawpicture  TwoThirdtimeFilename,TwoThirdtimeFilehandle,TwoThirdtimeWidth,TwoThirdtimeHeight,TwoThirdtimeData,125,75   ;chnge cx and dx
       notTWoThird29:
      ;One Third
       cmp TimerArray[29],2              ;change number
       jz notoneThird29                ;change lable name
       drawpicture  oneThirdtimeFilename,oneThirdtimeFilehandle,oneThirdtimeWidth,oneThirdtimeHeight,oneThirdtimeData,125,75    ;chnge cx and dx
       mov twentynin,0      ;change number
       notoneThird29:
  
     inc TimerArray[29]         ; change number
     
    inc29:               ; change number
    pop di
    pop bx
    pop dx 
    pop cx

      cmp TimerArray[30],3
   
    push cx 
      push dx
      mov cx ,150    ; change cx
      mov dx ,75        ; change dx
      push bx 
      push di
    jb do30              ; change number
    convert25toindex
    cmp thirty,1        ; Create variable its name like loop in .data =1
    je DontDraw30    ; change lable name
     call CheckWhichToDrawForTimer
      mov thirty,1      ; change variable name
    DontDraw30:            ; change lable name
     jmp inc30           ;change name
     do30:
      call CheckWhichToDrawForTimer
      ; ;TWo Third
       cmp TimerArray[30],1    ; change number 
       jz notTWoThird30   ;change lable name 
       convert25toindex
       drawpicture  TwoThirdtimeFilename,TwoThirdtimeFilehandle,TwoThirdtimeWidth,TwoThirdtimeHeight,TwoThirdtimeData,150,75   ;chnge cx and dx
       notTWoThird30:
      ;One Third
       cmp TimerArray[30],2              ;change number
       jz notoneThird30                ;change lable name
       drawpicture  oneThirdtimeFilename,oneThirdtimeFilehandle,oneThirdtimeWidth,oneThirdtimeHeight,oneThirdtimeData,150,75    ;chnge cx and dx
       mov thirty,0      ;change number
       notoneThird30:
  
     inc TimerArray[30]         ; change number
     
    inc30:               ; change number
    pop di
    pop bx
    pop dx 
    pop cx

    cmp TimerArray[31],3
   
    push cx 
      push dx
      mov cx ,175    ; change cx
      mov dx ,75        ; change dx
      push bx 
      push di
    jb do31             ; change number
    convert25toindex
    cmp thirtyon,1        ; Create variable its name like loop in .data =1
    je DontDraw31    ; change lable name
     call CheckWhichToDrawForTimer
      mov thirtyon,1      ; change variable name
    DontDraw31:            ; change lable name
     jmp inc31           ;change name
     do31:
      call CheckWhichToDrawForTimer
      ; ;TWo Third
       cmp TimerArray[31],1    ; change number 
       jz notTWoThird31  ;change lable name 
       convert25toindex
       drawpicture  TwoThirdtimeFilename,TwoThirdtimeFilehandle,TwoThirdtimeWidth,TwoThirdtimeHeight,TwoThirdtimeData,175,75   ;chnge cx and dx
       notTWoThird31:
      ;One Third
       cmp TimerArray[31],2              ;change number
       jz notoneThird31                ;change lable name
       drawpicture  oneThirdtimeFilename,oneThirdtimeFilehandle,oneThirdtimeWidth,oneThirdtimeHeight,oneThirdtimeData,175,75    ;chnge cx and dx
       mov thirtyon,0      ;change number
       notoneThird31:
  
     inc TimerArray[31]         ; change number
     
    inc31:               ; change number
    pop di
    pop bx
    pop dx 
    pop cx

     cmp TimerArray[32],3
   
    push cx 
      push dx
      mov cx ,0    ; change cx
      mov dx ,100        ; change dx
      push bx 
      push di
    jb do32             ; change number
    convert25toindex
    cmp thirtytw,1        ; Create variable its name like loop in .data =1
    je DontDraw32   ; change lable name
     call CheckWhichToDrawForTimer
      mov thirtytw,1      ; change variable name
    DontDraw32:            ; change lable name
     jmp inc32           ;change name
     do32:
      call CheckWhichToDrawForTimer
      ; ;TWo Third
       cmp TimerArray[32],1    ; change number 
       jz notTWoThird32  ;change lable name 
       convert25toindex
       drawpicture  TwoThirdtimeFilename,TwoThirdtimeFilehandle,TwoThirdtimeWidth,TwoThirdtimeHeight,TwoThirdtimeData,0,100   ;chnge cx and dx
       notTWoThird32:
      ;One Third
       cmp TimerArray[32],2              ;change number
       jz notoneThird32                ;change lable name
       drawpicture  oneThirdtimeFilename,oneThirdtimeFilehandle,oneThirdtimeWidth,oneThirdtimeHeight,oneThirdtimeData,0,100    ;chnge cx and dx
       mov thirtytw,0      ;change number
       notoneThird32:
  
     inc TimerArray[32]         ; change number
     
    inc32:               ; change number
    pop di
    pop bx
    pop dx 
    pop cx

     cmp TimerArray[33],3
   
    push cx 
      push dx
      mov cx ,25   ; change cx
      mov dx ,100        ; change dx
      push bx 
      push di
    jb do33             ; change number
    convert25toindex
    cmp thirtythr,1        ; Create variable its name like loop in .data =1
    je DontDraw33   ; change lable name
     call CheckWhichToDrawForTimer
      mov thirtythr,1      ; change variable name
    DontDraw33:            ; change lable name
     jmp inc33           ;change name
     do33:
      call CheckWhichToDrawForTimer
      ; ;TWo Third
       cmp TimerArray[33],1    ; change number 
       jz notTWoThird33  ;change lable name 
       convert25toindex
       drawpicture  TwoThirdtimeFilename,TwoThirdtimeFilehandle,TwoThirdtimeWidth,TwoThirdtimeHeight,TwoThirdtimeData,25,100   ;chnge cx and dx
       notTWoThird33:
      ;One Third
       cmp TimerArray[33],2              ;change number
       jz notoneThird33                ;change lable name
       drawpicture  oneThirdtimeFilename,oneThirdtimeFilehandle,oneThirdtimeWidth,oneThirdtimeHeight,oneThirdtimeData,25,100    ;chnge cx and dx
       mov thirtythr,0      ;change number
       notoneThird33:
  
     inc TimerArray[33]         ; change number
     
    inc33:               ; change number
    pop di
    pop bx
    pop dx 
    pop cx

     cmp TimerArray[34],3
   
    push cx 
      push dx
      mov cx ,50   ; change cx
      mov dx ,100        ; change dx
      push bx 
      push di
    jb do34             ; change number
    convert25toindex
    cmp thirtyfou,1        ; Create variable its name like loop in .data =1
    je DontDraw34   ; change lable name
     call CheckWhichToDrawForTimer
      mov thirtyfou,1      ; change variable name
    DontDraw34:            ; change lable name
     jmp inc34           ;change name
     do34:
      call CheckWhichToDrawForTimer
      ; ;TWo Third
       cmp TimerArray[34],1    ; change number 
       jz notTWoThird34  ;change lable name 
       convert25toindex
       drawpicture  TwoThirdtimeFilename,TwoThirdtimeFilehandle,TwoThirdtimeWidth,TwoThirdtimeHeight,TwoThirdtimeData,50,100   ;chnge cx and dx
       notTWoThird34:
      ;One Third
       cmp TimerArray[34],2              ;change number
       jz notoneThird34                ;change lable name
       drawpicture  oneThirdtimeFilename,oneThirdtimeFilehandle,oneThirdtimeWidth,oneThirdtimeHeight,oneThirdtimeData,50,100    ;chnge cx and dx
       mov thirtyfou,0      ;change number
       notoneThird34:
  
     inc TimerArray[34]         ; change number
     
    inc34:               ; change number
    pop di
    pop bx
    pop dx 
    pop cx

     cmp TimerArray[35],3
   
    push cx 
      push dx
      mov cx ,75   ; change cx
      mov dx ,100        ; change dx
      push bx 
      push di
    jb do35             ; change number
    convert25toindex
    cmp thirtyfiv,1        ; Create variable its name like loop in .data =1
    je DontDraw35   ; change lable name
     call CheckWhichToDrawForTimer
      mov thirtyfiv,1      ; change variable name
    DontDraw35:            ; change lable name
     jmp inc35           ;change name
     do35:
      call CheckWhichToDrawForTimer
      ; ;TWo Third
       cmp TimerArray[35],1    ; change number 
       jz notTWoThird35  ;change lable name 
       convert25toindex
       drawpicture  TwoThirdtimeFilename,TwoThirdtimeFilehandle,TwoThirdtimeWidth,TwoThirdtimeHeight,TwoThirdtimeData,75,100   ;chnge cx and dx
       notTWoThird35:
      ;One Third
       cmp TimerArray[35],2              ;change number
       jz notoneThird35                ;change lable name
       drawpicture  oneThirdtimeFilename,oneThirdtimeFilehandle,oneThirdtimeWidth,oneThirdtimeHeight,oneThirdtimeData,75,100    ;chnge cx and dx
       mov thirtyfiv,0      ;change number
       notoneThird35:
  
     inc TimerArray[35]         ; change number
     
    inc35:               ; change number
    pop di
    pop bx
    pop dx 
    pop cx

     cmp TimerArray[36],3
   
    push cx 
      push dx
      mov cx ,100   ; change cx
      mov dx ,100        ; change dx
      push bx 
      push di
    jb do36             ; change number
    convert25toindex
    cmp thirtysix,1        ; Create variable its name like loop in .data =1
    je DontDraw36   ; change lable name
     call CheckWhichToDrawForTimer
      mov thirtysix,1      ; change variable name
    DontDraw36:            ; change lable name
     jmp inc36           ;change name
     do36:
      call CheckWhichToDrawForTimer
      ; ;TWo Third
       cmp TimerArray[36],1    ; change number 
       jz notTWoThird36  ;change lable name 
       convert25toindex
       drawpicture  TwoThirdtimeFilename,TwoThirdtimeFilehandle,TwoThirdtimeWidth,TwoThirdtimeHeight,TwoThirdtimeData,100,100   ;chnge cx and dx
       notTWoThird36:
      ;One Third
       cmp TimerArray[36],2              ;change number
       jz notoneThird36                ;change lable name
       drawpicture  oneThirdtimeFilename,oneThirdtimeFilehandle,oneThirdtimeWidth,oneThirdtimeHeight,oneThirdtimeData,100,100    ;chnge cx and dx
       mov thirtysix,0      ;change number
       notoneThird36:
  
     inc TimerArray[36]         ; change number
     
    inc36:               ; change number
    pop di
    pop bx
    pop dx 
    pop cx

     cmp TimerArray[37],3
   
    push cx 
      push dx
      mov cx ,125   ; change cx
      mov dx ,100        ; change dx
      push bx 
      push di
    jb do37             ; change number
    convert25toindex
    cmp thirtysev,1        ; Create variable its name like loop in .data =1
    je DontDraw37   ; change lable name
     call CheckWhichToDrawForTimer
      mov thirtysev,1      ; change variable name
    DontDraw37:            ; change lable name
     jmp inc37           ;change name
     do37:
      call CheckWhichToDrawForTimer
      ; ;TWo Third
       cmp TimerArray[37],1    ; change number 
       jz notTWoThird37  ;change lable name 
       convert25toindex
       drawpicture  TwoThirdtimeFilename,TwoThirdtimeFilehandle,TwoThirdtimeWidth,TwoThirdtimeHeight,TwoThirdtimeData,125,100   ;chnge cx and dx
       notTWoThird37:
      ;One Third
       cmp TimerArray[37],2              ;change number
       jz notoneThird37                ;change lable name
       drawpicture  oneThirdtimeFilename,oneThirdtimeFilehandle,oneThirdtimeWidth,oneThirdtimeHeight,oneThirdtimeData,125,100    ;chnge cx and dx
       mov thirtysev,0      ;change number
       notoneThird37:
  
     inc TimerArray[37]         ; change number
     
    inc37:               ; change number
    pop di
    pop bx
    pop dx 
    pop cx

     cmp TimerArray[38],3
   
    push cx 
      push dx
      mov cx ,150   ; change cx
      mov dx ,100        ; change dx
      push bx 
      push di
    jb do38             ; change number
    convert25toindex
    cmp thirtyeig,1        ; Create variable its name like loop in .data =1
    je DontDraw38   ; change lable name
     call CheckWhichToDrawForTimer
      mov thirtyeig,1      ; change variable name
    DontDraw38:            ; change lable name
     jmp inc38           ;change name
     do38:
      call CheckWhichToDrawForTimer
      ; ;TWo Third
       cmp TimerArray[38],1    ; change number 
       jz notTWoThird38  ;change lable name 
       convert25toindex
       drawpicture  TwoThirdtimeFilename,TwoThirdtimeFilehandle,TwoThirdtimeWidth,TwoThirdtimeHeight,TwoThirdtimeData,150,100   ;chnge cx and dx
       notTWoThird38:
      ;One Third
       cmp TimerArray[38],2              ;change number
       jz notoneThird38                ;change lable name
       drawpicture  oneThirdtimeFilename,oneThirdtimeFilehandle,oneThirdtimeWidth,oneThirdtimeHeight,oneThirdtimeData,150,100    ;chnge cx and dx
       mov thirtyeig,0      ;change number
       notoneThird38:
  
     inc TimerArray[38]         ; change number
     
    inc38:               ; change number
    pop di
    pop bx
    pop dx 
    pop cx

     cmp TimerArray[39],3
   
    push cx 
      push dx
      mov cx ,175   ; change cx
      mov dx ,100        ; change dx
      push bx 
      push di
    jb do39             ; change number
    convert25toindex
    cmp thirtynin,1        ; Create variable its name like loop in .data =1
    je DontDraw39   ; change lable name
     call CheckWhichToDrawForTimer
      mov thirtynin,1      ; change variable name
    DontDraw39:            ; change lable name
     jmp inc39           ;change name
     do39:
      call CheckWhichToDrawForTimer
      ; ;TWo Third
       cmp TimerArray[39],1    ; change number 
       jz notTWoThird39  ;change lable name 
       convert25toindex
       drawpicture  TwoThirdtimeFilename,TwoThirdtimeFilehandle,TwoThirdtimeWidth,TwoThirdtimeHeight,TwoThirdtimeData,175,100   ;chnge cx and dx
       notTWoThird39:
      ;One Third
       cmp TimerArray[39],2              ;change number
       jz notoneThird39               ;change lable name
       drawpicture  oneThirdtimeFilename,oneThirdtimeFilehandle,oneThirdtimeWidth,oneThirdtimeHeight,oneThirdtimeData,175,100    ;chnge cx and dx
       mov thirtynin,0      ;change number
       notoneThird39:
  
     inc TimerArray[39]         ; change number
     
    inc39:               ; change number
    pop di
    pop bx
    pop dx 
    pop cx

     cmp TimerArray[40],3
   
    push cx 
      push dx
      mov cx ,0   ; change cx
      mov dx,125        ; change dx
      push bx 
      push di
    jb do40             ; change number
    convert25toindex
    cmp fourty,1        ; Create variable its name like loop in .data =1
    je DontDraw40   ; change lable name
     call CheckWhichToDrawForTimer
      mov fourty,1      ; change variable name
    DontDraw40:            ; change lable name
     jmp inc40           ;change name
     do40:
      call CheckWhichToDrawForTimer
      ; ;TWo Third
       cmp TimerArray[40],1    ; change number 
       jz notTWoThird40  ;change lable name 
       convert25toindex
       drawpicture  TwoThirdtimeFilename,TwoThirdtimeFilehandle,TwoThirdtimeWidth,TwoThirdtimeHeight,TwoThirdtimeData,0,125   ;chnge cx and dx
       notTWoThird40:
      ;One Third
       cmp TimerArray[40],2              ;change number
       jz notoneThird40               ;change lable name
       drawpicture  oneThirdtimeFilename,oneThirdtimeFilehandle,oneThirdtimeWidth,oneThirdtimeHeight,oneThirdtimeData,0,125    ;chnge cx and dx
       mov fourty,0      ;change number
       notoneThird40:
  
     inc TimerArray[40]         ; change number
     
    inc40:               ; change number
    pop di
    pop bx
    pop dx 
    pop cx

     cmp TimerArray[41],3
   
    push cx 
      push dx
      mov cx ,25   ; change cx
      mov dx,125        ; change dx
      push bx 
      push di
    jb do41             ; change number
    convert25toindex
    cmp fourtyon,1        ; Create variable its name like loop in .data =1
    je DontDraw41   ; change lable name
     call CheckWhichToDrawForTimer
      mov fourtyon,1      ; change variable name
    DontDraw41:            ; change lable name
     jmp inc41           ;change name
     do41:
      call CheckWhichToDrawForTimer
      ; ;TWo Third
       cmp TimerArray[41],1    ; change number 
       jz notTWoThird41  ;change lable name 
       convert25toindex
       drawpicture  TwoThirdtimeFilename,TwoThirdtimeFilehandle,TwoThirdtimeWidth,TwoThirdtimeHeight,TwoThirdtimeData,25,125   ;chnge cx and dx
       notTWoThird41:
      ;One Third
       cmp TimerArray[41],2              ;change number
       jz notoneThird41               ;change lable name
       drawpicture  oneThirdtimeFilename,oneThirdtimeFilehandle,oneThirdtimeWidth,oneThirdtimeHeight,oneThirdtimeData,25,125    ;chnge cx and dx
       mov fourtyon,0      ;change number
       notoneThird41:
  
     inc TimerArray[41]         ; change number
     
    inc41:               ; change number
    pop di
    pop bx
    pop dx 
    pop cx

    cmp TimerArray[42],3
   
    push cx 
      push dx
      mov cx ,50   ; change cx
      mov dx,125        ; change dx
      push bx 
      push di
    jb do42             ; change number
    convert25toindex
    cmp fourtytw,1        ; Create variable its name like loop in .data =1
    je DontDraw42   ; change lable name
     call CheckWhichToDrawForTimer
      mov fourtytw,1      ; change variable name
    DontDraw42:            ; change lable name
     jmp inc42           ;change name
     do42:
      call CheckWhichToDrawForTimer
      ; ;TWo Third
       cmp TimerArray[42],1    ; change number 
       jz notTWoThird42  ;change lable name 
       convert25toindex
       drawpicture  TwoThirdtimeFilename,TwoThirdtimeFilehandle,TwoThirdtimeWidth,TwoThirdtimeHeight,TwoThirdtimeData,50,125   ;chnge cx and dx
       notTWoThird42:
      ;One Third
       cmp TimerArray[42],2              ;change number
       jz notoneThird42               ;change lable name
       drawpicture  oneThirdtimeFilename,oneThirdtimeFilehandle,oneThirdtimeWidth,oneThirdtimeHeight,oneThirdtimeData,50,125    ;chnge cx and dx
       mov fourtytw,0      ;change number
       notoneThird42:
  
     inc TimerArray[42]         ; change number
     
    inc42:               ; change number
    pop di
    pop bx
    pop dx 
    pop cx

     cmp TimerArray[43],3
   
    push cx 
      push dx
      mov cx ,75   ; change cx
      mov dx,125        ; change dx
      push bx 
      push di
    jb do43             ; change number
    convert25toindex
    cmp fourtythr,1        ; Create variable its name like loop in .data =1
    je DontDraw43   ; change lable name
     call CheckWhichToDrawForTimer
      mov fourtythr,1      ; change variable name
    DontDraw43:            ; change lable name
     jmp inc43           ;change name
     do43:
      call CheckWhichToDrawForTimer
      ; ;TWo Third
       cmp TimerArray[43],1    ; change number 
       jz notTWoThird43  ;change lable name 
       convert25toindex
       drawpicture  TwoThirdtimeFilename,TwoThirdtimeFilehandle,TwoThirdtimeWidth,TwoThirdtimeHeight,TwoThirdtimeData,75,125   ;chnge cx and dx
       notTWoThird43:
      ;One Third
       cmp TimerArray[43],2              ;change number
       jz notoneThird43               ;change lable name
       drawpicture  oneThirdtimeFilename,oneThirdtimeFilehandle,oneThirdtimeWidth,oneThirdtimeHeight,oneThirdtimeData,75,125    ;chnge cx and dx
       mov fourtythr,0      ;change number
       notoneThird43:
  
     inc TimerArray[43]         ; change number
     
    inc43:               ; change number
    pop di
    pop bx
    pop dx 
    pop cx

     cmp TimerArray[44],3
   
    push cx 
      push dx
      mov cx ,100   ; change cx
      mov dx,125        ; change dx
      push bx 
      push di
    jb do44             ; change number
    convert25toindex
    cmp fourtyfou,1        ; Create variable its name like loop in .data =1
    je DontDraw44   ; change lable name
     call CheckWhichToDrawForTimer
      mov fourtyfou,1      ; change variable name
    DontDraw44:            ; change lable name
     jmp inc44           ;change name
     do44:
      call CheckWhichToDrawForTimer
      ; ;TWo Third
       cmp TimerArray[44],1    ; change number 
       jz notTWoThird44  ;change lable name 
       convert25toindex
       drawpicture  TwoThirdtimeFilename,TwoThirdtimeFilehandle,TwoThirdtimeWidth,TwoThirdtimeHeight,TwoThirdtimeData,100,125   ;chnge cx and dx
       notTWoThird44:
      ;One Third
       cmp TimerArray[44],2              ;change number
       jz notoneThird44               ;change lable name
       drawpicture  oneThirdtimeFilename,oneThirdtimeFilehandle,oneThirdtimeWidth,oneThirdtimeHeight,oneThirdtimeData,100,125    ;chnge cx and dx
       mov fourtyfou,0      ;change number
       notoneThird44:
  
     inc TimerArray[44]         ; change number
     
    inc44:               ; change number
    pop di
    pop bx
    pop dx 
    pop cx

     cmp TimerArray[45],3
   
    push cx 
      push dx
      mov cx ,125   ; change cx
      mov dx,125        ; change dx
      push bx 
      push di
    jb do45             ; change number
    convert25toindex
    cmp fourtyfiv,1        ; Create variable its name like loop in .data =1
    je DontDraw45   ; change lable name
     call CheckWhichToDrawForTimer
      mov fourtyfiv,1      ; change variable name
    DontDraw45:            ; change lable name
     jmp inc45           ;change name
     do45:
      call CheckWhichToDrawForTimer
      ; ;TWo Third
       cmp TimerArray[45],1    ; change number 
       jz notTWoThird45  ;change lable name 
       convert25toindex
       drawpicture  TwoThirdtimeFilename,TwoThirdtimeFilehandle,TwoThirdtimeWidth,TwoThirdtimeHeight,TwoThirdtimeData,125,125   ;chnge cx and dx
       notTWoThird45:
      ;One Third
       cmp TimerArray[45],2              ;change number
       jz notoneThird45               ;change lable name
       drawpicture  oneThirdtimeFilename,oneThirdtimeFilehandle,oneThirdtimeWidth,oneThirdtimeHeight,oneThirdtimeData,125,125    ;chnge cx and dx
       mov fourtyfiv,0      ;change number
       notoneThird45:
  
     inc TimerArray[45]         ; change number
     
    inc45:               ; change number
    pop di
    pop bx
    pop dx 
    pop cx

     cmp TimerArray[46],3
   
    push cx 
      push dx
      mov cx ,150   ; change cx
      mov dx,125        ; change dx
      push bx 
      push di
    jb do46             ; change number
    convert25toindex
    cmp fourtysix,1        ; Create variable its name like loop in .data =1
    je DontDraw46   ; change lable name
     call CheckWhichToDrawForTimer
      mov fourtysix,1      ; change variable name
    DontDraw46:            ; change lable name
     jmp inc46           ;change name
     do46:
      call CheckWhichToDrawForTimer
      ; ;TWo Third
       cmp TimerArray[46],1    ; change number 
       jz notTWoThird46 ;change lable name 
       convert25toindex
       drawpicture  TwoThirdtimeFilename,TwoThirdtimeFilehandle,TwoThirdtimeWidth,TwoThirdtimeHeight,TwoThirdtimeData,150,125   ;chnge cx and dx
       notTWoThird46:
      ;One Third
       cmp TimerArray[46],2              ;change number
       jz notoneThird46               ;change lable name
       drawpicture  oneThirdtimeFilename,oneThirdtimeFilehandle,oneThirdtimeWidth,oneThirdtimeHeight,oneThirdtimeData,150,125    ;chnge cx and dx
       mov fourtysix,0      ;change number
       notoneThird46:
  
     inc TimerArray[46]         ; change number
     
    inc46:               ; change number
    pop di
    pop bx
    pop dx 
    pop cx

    cmp TimerArray[47],3
   
    push cx 
      push dx
      mov cx ,175   ; change cx
      mov dx,125        ; change dx
      push bx 
      push di
    jb do47             ; change number
    convert25toindex
    cmp fourtysev,1        ; Create variable its name like loop in .data =1
    je DontDraw47   ; change lable name
     call CheckWhichToDrawForTimer
      mov fourtysev,1      ; change variable name
    DontDraw47:            ; change lable name
     jmp inc47           ;change name
     do47:
      call CheckWhichToDrawForTimer
      ; ;TWo Third
       cmp TimerArray[47],1    ; change number 
       jz notTWoThird47 ;change lable name 
       convert25toindex
       drawpicture  TwoThirdtimeFilename,TwoThirdtimeFilehandle,TwoThirdtimeWidth,TwoThirdtimeHeight,TwoThirdtimeData,175,125   ;chnge cx and dx
       notTWoThird47:
      ;One Third
       cmp TimerArray[47],2              ;change number
       jz notoneThird47               ;change lable name
       drawpicture  oneThirdtimeFilename,oneThirdtimeFilehandle,oneThirdtimeWidth,oneThirdtimeHeight,oneThirdtimeData,175,125    ;chnge cx and dx
       mov fourtysev,0      ;change number
       notoneThird47:
  
     inc TimerArray[47]         ; change number
     
    inc47:               ; change number
    pop di
    pop bx
    pop dx 
    pop cx

     cmp TimerArray[48],3
   
    push cx 
      push dx
      mov cx ,0   ; change cx
      mov dx,150        ; change dx
      push bx 
      push di
    jb do48             ; change number
    convert25toindex
    cmp fourtyeig,1        ; Create variable its name like loop in .data =1
    je DontDraw48  ; change lable name
     call CheckWhichToDrawForTimer
      mov fourtyeig,1      ; change variable name
    DontDraw48:            ; change lable name
     jmp inc48           ;change name
     do48:
      call CheckWhichToDrawForTimer
      ; ;TWo Third
       cmp TimerArray[48],1    ; change number 
       jz notTWoThird48 ;change lable name 
       convert25toindex
       drawpicture  TwoThirdtimeFilename,TwoThirdtimeFilehandle,TwoThirdtimeWidth,TwoThirdtimeHeight,TwoThirdtimeData,0,150   ;chnge cx and dx
       notTWoThird48:
      ;One Third
       cmp TimerArray[48],2              ;change number
       jz notoneThird48               ;change lable name
       drawpicture  oneThirdtimeFilename,oneThirdtimeFilehandle,oneThirdtimeWidth,oneThirdtimeHeight,oneThirdtimeData,0,150    ;chnge cx and dx
       mov fourtyeig,0      ;change number
       notoneThird48:
  
     inc TimerArray[48]         ; change number
     
    inc48:               ; change number
    pop di
    pop bx
    pop dx 
    pop cx
        ;can be done through loop 
     cmp TimerArray[49],3
   
    push cx 
      push dx
      mov cx ,25   ; change cx
      mov dx,150        ; change dx
      push bx 
      push di
    jb do49             ; change number
    convert25toindex
    cmp fourtynin,1        ; Create variable its name like loop in .data =1
    je DontDraw49  ; change lable name
     call CheckWhichToDrawForTimer
      mov fourtynin,1      ; change variable name
    DontDraw49:            ; change lable name
     jmp inc49           ;change name
     do49:
      call CheckWhichToDrawForTimer
      ; ;TWo Third
       cmp TimerArray[49],1    ; change number 
       jz notTWoThird49 ;change lable name 
       convert25toindex
       drawpicture  TwoThirdtimeFilename,TwoThirdtimeFilehandle,TwoThirdtimeWidth,TwoThirdtimeHeight,TwoThirdtimeData,25,150   ;chnge cx and dx
       notTWoThird49:
      ;One Third
       cmp TimerArray[49],2              ;change number
       jz notoneThird49               ;change lable name
       drawpicture  oneThirdtimeFilename,oneThirdtimeFilehandle,oneThirdtimeWidth,oneThirdtimeHeight,oneThirdtimeData,25,150    ;chnge cx and dx
       mov fourtynin,0      ;change number
       notoneThird49:
  
     inc TimerArray[49]         ; change number
     
    inc49:               ; change number
    pop di
    pop bx
    pop dx 
    pop cx

     cmp TimerArray[50],3
   
    push cx 
      push dx
      mov cx ,50   ; change cx
      mov dx,150        ; change dx
      push bx 
      push di
    jb do50             ; change number
    convert25toindex
    cmp fifty,1        ; Create variable its name like loop in .data =1
    je DontDraw50  ; change lable name
     call CheckWhichToDrawForTimer
      mov fifty,1      ; change variable name
    DontDraw50:            ; change lable name
     jmp inc50           ;change name
     do50:
      call CheckWhichToDrawForTimer
      ; ;TWo Third
       cmp TimerArray[50],1    ; change number 
       jz notTWoThird50 ;change lable name 
       convert25toindex
       drawpicture  TwoThirdtimeFilename,TwoThirdtimeFilehandle,TwoThirdtimeWidth,TwoThirdtimeHeight,TwoThirdtimeData,50,150   ;chnge cx and dx
       notTWoThird50:
      ;One Third
       cmp TimerArray[50],2              ;change number
       jz notoneThird50               ;change lable name
       drawpicture  oneThirdtimeFilename,oneThirdtimeFilehandle,oneThirdtimeWidth,oneThirdtimeHeight,oneThirdtimeData,50,150    ;chnge cx and dx
       mov fifty,0      ;change number
       notoneThird50:
  
     inc TimerArray[50]         ; change number
     
    inc50:               ; change number
    pop di
    pop bx
    pop dx 
    pop cx

     cmp TimerArray[51],3
   
    push cx 
      push dx
      mov cx ,75   ; change cx
      mov dx,150        ; change dx
      push bx 
      push di
    jb do51             ; change number
    convert25toindex
    cmp fiftyon,1        ; Create variable its name like loop in .data =1
    je DontDraw51  ; change lable name
     call CheckWhichToDrawForTimer
      mov fiftyon,1      ; change variable name
    DontDraw51:            ; change lable name
     jmp inc51           ;change name
     do51:
      call CheckWhichToDrawForTimer
      ; ;TWo Third
       cmp TimerArray[51],1    ; change number 
       jz notTWoThird51 ;change lable name 
       convert25toindex
       drawpicture  TwoThirdtimeFilename,TwoThirdtimeFilehandle,TwoThirdtimeWidth,TwoThirdtimeHeight,TwoThirdtimeData,75,150   ;chnge cx and dx
       notTWoThird51:
      ;One Third
       cmp TimerArray[51],2              ;change number
       jz notoneThird51               ;change lable name
       drawpicture  oneThirdtimeFilename,oneThirdtimeFilehandle,oneThirdtimeWidth,oneThirdtimeHeight,oneThirdtimeData,75,150    ;chnge cx and dx
       mov fiftyon,0      ;change number
       notoneThird51:
  
     inc TimerArray[51]         ; change number
     
    inc51:               ; change number
    pop di
    pop bx
    pop dx 
    pop cx

      cmp TimerArray[52],3
   
    push cx 
      push dx
      mov cx ,100  ; change cx
      mov dx,150        ; change dx
      push bx 
      push di
    jb do52             ; change number
    convert25toindex
    cmp fiftytw,1        ; Create variable its name like loop in .data =1
    je DontDraw52  ; change lable name
     call CheckWhichToDrawForTimer
      mov fiftytw,1      ; change variable name
    DontDraw52:            ; change lable name
     jmp inc52           ;change name
     do52:
      call CheckWhichToDrawForTimer
      ; ;TWo Third
       cmp TimerArray[52],1    ; change number 
       jz notTWoThird52 ;change lable name 
       convert25toindex
       drawpicture  TwoThirdtimeFilename,TwoThirdtimeFilehandle,TwoThirdtimeWidth,TwoThirdtimeHeight,TwoThirdtimeData,100,150   ;chnge cx and dx
       notTWoThird52:
      ;One Third
       cmp TimerArray[52],2              ;change number
       jz notoneThird52               ;change lable name
       drawpicture  oneThirdtimeFilename,oneThirdtimeFilehandle,oneThirdtimeWidth,oneThirdtimeHeight,oneThirdtimeData,100,150    ;chnge cx and dx
       mov fiftytw,0      ;change number
       notoneThird52:
  
     inc TimerArray[52]         ; change number
     
    inc52:               ; change number
    pop di
    pop bx
    pop dx 
    pop cx

     cmp TimerArray[53],3
   
    push cx 
      push dx
      mov cx ,125  ; change cx
      mov dx,150        ; change dx
      push bx 
      push di
    jb do53             ; change number
    convert25toindex
    cmp fiftythr,1        ; Create variable its name like loop in .data =1
    je DontDraw53  ; change lable name
     call CheckWhichToDrawForTimer
      mov fiftythr,1      ; change variable name
    DontDraw53:            ; change lable name
     jmp inc53           ;change name
     do53:
      call CheckWhichToDrawForTimer
      ; ;TWo Third
       cmp TimerArray[53],1    ; change number 
       jz notTWoThird53 ;change lable name 
       convert25toindex
       drawpicture  TwoThirdtimeFilename,TwoThirdtimeFilehandle,TwoThirdtimeWidth,TwoThirdtimeHeight,TwoThirdtimeData,125,150   ;chnge cx and dx
       notTWoThird53:
      ;One Third
       cmp TimerArray[53],2              ;change number
       jz notoneThird53               ;change lable name
       drawpicture  oneThirdtimeFilename,oneThirdtimeFilehandle,oneThirdtimeWidth,oneThirdtimeHeight,oneThirdtimeData,125,150    ;chnge cx and dx
       mov fiftythr,0      ;change number
       notoneThird53:
  
     inc TimerArray[53]         ; change number
     
    inc53:               ; change number
    pop di
    pop bx
    pop dx 
    pop cx

    cmp TimerArray[54],3
   
    push cx 
      push dx
      mov cx ,150  ; change cx
      mov dx,150        ; change dx
      push bx 
      push di
    jb do54             ; change number
    convert25toindex
    cmp fiftyfou,1        ; Create variable its name like loop in .data =1
    je DontDraw54  ; change lable name
     call CheckWhichToDrawForTimer
      mov fiftyfou,1      ; change variable name
    DontDraw54:            ; change lable name
     jmp inc54           ;change name
     do54:
      call CheckWhichToDrawForTimer
      ; ;TWo Third
       cmp TimerArray[54],1    ; change number 
       jz notTWoThird54 ;change lable name 
       convert25toindex
       drawpicture  TwoThirdtimeFilename,TwoThirdtimeFilehandle,TwoThirdtimeWidth,TwoThirdtimeHeight,TwoThirdtimeData,150,150   ;chnge cx and dx
       notTWoThird54:
      ;One Third
       cmp TimerArray[54],2              ;change number
       jz notoneThird54               ;change lable name
       drawpicture  oneThirdtimeFilename,oneThirdtimeFilehandle,oneThirdtimeWidth,oneThirdtimeHeight,oneThirdtimeData,150,150    ;chnge cx and dx
       mov fiftyfou,0      ;change number
       notoneThird54:
  
     inc TimerArray[54]         ; change number
     
    inc54:               ; change number
    pop di
    pop bx
    pop dx 
    pop cx

    cmp TimerArray[55],3
   
    push cx 
      push dx
      mov cx ,175  ; change cx
      mov dx,150        ; change dx
      push bx 
      push di
    jb do55             ; change number
    convert25toindex
    cmp fiftyfiv,1        ; Create variable its name like loop in .data =1
    je DontDraw55  ; change lable name
     call CheckWhichToDrawForTimer
      mov fiftyfiv,1      ; change variable name
    DontDraw55:            ; change lable name
     jmp inc55           ;change name
     do55:
      call CheckWhichToDrawForTimer
      ; ;TWo Third
       cmp TimerArray[55],1    ; change number 
       jz notTWoThird55 ;change lable name 
       convert25toindex
       drawpicture  TwoThirdtimeFilename,TwoThirdtimeFilehandle,TwoThirdtimeWidth,TwoThirdtimeHeight,TwoThirdtimeData,175,150   ;chnge cx and dx
       notTWoThird55:
      ;One Third
       cmp TimerArray[55],2              ;change number
       jz notoneThird55               ;change lable name
       drawpicture  oneThirdtimeFilename,oneThirdtimeFilehandle,oneThirdtimeWidth,oneThirdtimeHeight,oneThirdtimeData,175,150    ;chnge cx and dx
       mov fiftyfiv,0      ;change number
       notoneThird55:
  
     inc TimerArray[55]         ; change number
     
    inc55:               ; change number
    pop di
    pop bx
    pop dx 
    pop cx

     cmp TimerArray[56],3
   
    push cx 
      push dx
      mov cx ,0  ; change cx
      mov dx,175        ; change dx
      push bx 
      push di
    jb do56             ; change number
    convert25toindex
    cmp fiftysix,1        ; Create variable its name like loop in .data =1
    je DontDraw56  ; change lable name
     call CheckWhichToDrawForTimer
      mov fiftysix,1      ; change variable name
    DontDraw56:            ; change lable name
     jmp inc56           ;change name
     do56:
      call CheckWhichToDrawForTimer
      ; ;TWo Third
       cmp TimerArray[56],1    ; change number 
       jz notTWoThird56 ;change lable name 
       convert25toindex
       drawpicture  TwoThirdtimeFilename,TwoThirdtimeFilehandle,TwoThirdtimeWidth,TwoThirdtimeHeight,TwoThirdtimeData,0,175   ;chnge cx and dx
       notTWoThird56:
      ;One Third
       cmp TimerArray[56],2              ;change number
       jz notoneThird56               ;change lable name
       drawpicture  oneThirdtimeFilename,oneThirdtimeFilehandle,oneThirdtimeWidth,oneThirdtimeHeight,oneThirdtimeData,0,175   ;chnge cx and dx
       mov fiftysix,0      ;change number
       notoneThird56:
  
     inc TimerArray[56]         ; change number
     
    inc56:               ; change number
    pop di
    pop bx
    pop dx 
    pop cx

     cmp TimerArray[57],3
   
    push cx 
      push dx
      mov cx ,25 ; change cx
      mov dx,175        ; change dx
      push bx 
      push di
    jb do57             ; change number
    convert25toindex
    cmp fiftysev,1        ; Create variable its name like loop in .data =1
    je DontDraw57  ; change lable name
     call CheckWhichToDrawForTimer
      mov fiftysev,1      ; change variable name
    DontDraw57:            ; change lable name
     jmp inc57           ;change name
     do57:
      call CheckWhichToDrawForTimer
      ; ;TWo Third
       cmp TimerArray[57],1    ; change number 
       jz notTWoThird57 ;change lable name 
       convert25toindex
       drawpicture  TwoThirdtimeFilename,TwoThirdtimeFilehandle,TwoThirdtimeWidth,TwoThirdtimeHeight,TwoThirdtimeData,25,175   ;chnge cx and dx
       notTWoThird57:
      ;One Third
       cmp TimerArray[57],2              ;change number
       jz notoneThird57               ;change lable name
       drawpicture  oneThirdtimeFilename,oneThirdtimeFilehandle,oneThirdtimeWidth,oneThirdtimeHeight,oneThirdtimeData,25,175   ;chnge cx and dx
       mov fiftysev,0      ;change number
       notoneThird57:
  
     inc TimerArray[57]         ; change number
     
    inc57:               ; change number
    pop di
    pop bx
    pop dx 
    pop cx

     cmp TimerArray[58],3
   
    push cx 
      push dx
      mov cx ,50 ; change cx
      mov dx,175        ; change dx
      push bx 
      push di
    jb do58             ; change number
    convert25toindex
    cmp fiftyeig,1        ; Create variable its name like loop in .data =1
    je DontDraw58  ; change lable name
     call CheckWhichToDrawForTimer
      mov fiftyeig,1      ; change variable name
    DontDraw58:            ; change lable name
     jmp inc58           ;change name
     do58:
      call CheckWhichToDrawForTimer
      ; ;TWo Third
       cmp TimerArray[58],1    ; change number 
       jz notTWoThird58 ;change lable name 
       convert25toindex
       drawpicture  TwoThirdtimeFilename,TwoThirdtimeFilehandle,TwoThirdtimeWidth,TwoThirdtimeHeight,TwoThirdtimeData,50,175   ;chnge cx and dx
       notTWoThird58:
      ;One Third
       cmp TimerArray[58],2              ;change number
       jz notoneThird58               ;change lable name
       drawpicture  oneThirdtimeFilename,oneThirdtimeFilehandle,oneThirdtimeWidth,oneThirdtimeHeight,oneThirdtimeData,50,175   ;chnge cx and dx
       mov fiftyeig,0      ;change number
       notoneThird58:
  
     inc TimerArray[58]         ; change number
     
    inc58:               ; change number
    pop di
    pop bx
    pop dx 
    pop cx

     cmp TimerArray[59],3
   
    push cx 
      push dx
      mov cx ,75 ; change cx
      mov dx,175        ; change dx
      push bx 
      push di
    jb do59             ; change number
    convert25toindex
    cmp fiftynin,1        ; Create variable its name like loop in .data =1
    je DontDraw59  ; change lable name
     call CheckWhichToDrawForTimer
      mov fiftynin,1      ; change variable name
    DontDraw59:            ; change lable name
     jmp inc59           ;change name
     do59:
      call CheckWhichToDrawForTimer
      ; ;TWo Third
       cmp TimerArray[59],1    ; change number 
       jz notTWoThird59 ;change lable name 
       convert25toindex
       drawpicture  TwoThirdtimeFilename,TwoThirdtimeFilehandle,TwoThirdtimeWidth,TwoThirdtimeHeight,TwoThirdtimeData,75,175   ;chnge cx and dx
       notTWoThird59:
      ;One Third
       cmp TimerArray[59],2              ;change number
       jz notoneThird59               ;change lable name
       drawpicture  oneThirdtimeFilename,oneThirdtimeFilehandle,oneThirdtimeWidth,oneThirdtimeHeight,oneThirdtimeData,75,175   ;chnge cx and dx
       mov fiftynin,0      ;change number
       notoneThird59:
  
     inc TimerArray[59]         ; change number
     
    inc59:               ; change number
    pop di
    pop bx
    pop dx 
    pop cx

    cmp TimerArray[60],3
   
    push cx 
      push dx
      mov cx ,100 ; change cx
      mov dx,175        ; change dx
      push bx 
      push di
    jb do60             ; change number
    convert25toindex
    cmp sixty,1        ; Create variable its name like loop in .data =1
    je DontDraw60  ; change lable name
     call CheckWhichToDrawForTimer
      mov sixty,1      ; change variable name
    DontDraw60:            ; change lable name
     jmp inc60           ;change name
     do60:
      call CheckWhichToDrawForTimer
      ; ;TWo Third
       cmp TimerArray[60],1    ; change number 
       jz notTWoThird60 ;change lable name 
       convert25toindex
       drawpicture  TwoThirdtimeFilename,TwoThirdtimeFilehandle,TwoThirdtimeWidth,TwoThirdtimeHeight,TwoThirdtimeData,100,175   ;chnge cx and dx
       notTWoThird60:
      ;One Third
       cmp TimerArray[60],2              ;change number
       jz notoneThird60               ;change lable name
       drawpicture  oneThirdtimeFilename,oneThirdtimeFilehandle,oneThirdtimeWidth,oneThirdtimeHeight,oneThirdtimeData,100,175   ;chnge cx and dx
       mov sixty,0      ;change number
       notoneThird60:
  
     inc TimerArray[60]         ; change number
     
    inc60:               ; change number
    pop di
    pop bx
    pop dx 
    pop cx

     cmp TimerArray[61],3
   
    push cx 
      push dx
      mov cx ,125 ; change cx
      mov dx,175        ; change dx
      push bx 
      push di
    jb do61             ; change number
    convert25toindex
    cmp sixtyon,1        ; Create variable its name like loop in .data =1
    je DontDraw61  ; change lable name
     call CheckWhichToDrawForTimer
      mov sixtyon,1      ; change variable name
    DontDraw61:            ; change lable name
     jmp inc61           ;change name
     do61:
      call CheckWhichToDrawForTimer
      ; ;TWo Third
       cmp TimerArray[61],1    ; change number 
       jz notTWoThird61 ;change lable name 
       convert25toindex
       drawpicture  TwoThirdtimeFilename,TwoThirdtimeFilehandle,TwoThirdtimeWidth,TwoThirdtimeHeight,TwoThirdtimeData,125,175   ;chnge cx and dx
       notTWoThird61:
      ;One Third
       cmp TimerArray[61],2              ;change number
       jz notoneThird61               ;change lable name
       drawpicture  oneThirdtimeFilename,oneThirdtimeFilehandle,oneThirdtimeWidth,oneThirdtimeHeight,oneThirdtimeData,125,175   ;chnge cx and dx
       mov sixtyon,0      ;change number
       notoneThird61:
  
     inc TimerArray[61]         ; change number
     
    inc61:               ; change number
    pop di
    pop bx
    pop dx 
    pop cx

     cmp TimerArray[62],3
   
    push cx 
      push dx
      mov cx ,150 ; change cx
      mov dx,175        ; change dx
      push bx 
      push di
    jb do62            ; change number
    convert25toindex
    cmp sixtytw,1        ; Create variable its name like loop in .data =1
    je DontDraw62 ; change lable name
     call CheckWhichToDrawForTimer
      mov sixtytw,1      ; change variable name
    DontDraw62:            ; change lable name
     jmp inc62           ;change name
     do62:
      call CheckWhichToDrawForTimer
      ; ;TWo Third
       cmp TimerArray[62],1    ; change number 
       jz notTWoThird62 ;change lable name 
       convert25toindex
       drawpicture  TwoThirdtimeFilename,TwoThirdtimeFilehandle,TwoThirdtimeWidth,TwoThirdtimeHeight,TwoThirdtimeData,150,175   ;chnge cx and dx
       notTWoThird62:
      ;One Third
       cmp TimerArray[62],2              ;change number
       jz notoneThird62               ;change lable name
       drawpicture  oneThirdtimeFilename,oneThirdtimeFilehandle,oneThirdtimeWidth,oneThirdtimeHeight,oneThirdtimeData,150,175   ;chnge cx and dx
       mov sixtytw,0      ;change number
       notoneThird62:
  
     inc TimerArray[62]         ; change number
     
    inc62:               ; change number
    pop di
    pop bx
    pop dx 
    pop cx

     cmp TimerArray[63],3
   
    push cx 
      push dx
      mov cx ,175 ; change cx
      mov dx,175        ; change dx
      push bx 
      push di
    jb do63            ; change number
    convert25toindex
    cmp sixtythr,1        ; Create variable its name like loop in .data =1
    je DontDraw63 ; change lable name
     call CheckWhichToDrawForTimer
      mov sixtythr,1      ; change variable name
    DontDraw63:            ; change lable name
     jmp inc63           ;change name
     do63:
      call CheckWhichToDrawForTimer
      ; ;TWo Third
       cmp TimerArray[63],1    ; change number 
       jz notTWoThird63 ;change lable name 
       convert25toindex
       drawpicture  TwoThirdtimeFilename,TwoThirdtimeFilehandle,TwoThirdtimeWidth,TwoThirdtimeHeight,TwoThirdtimeData,175,175   ;chnge cx and dx
       notTWoThird63:
      ;One Third
       cmp TimerArray[63],2              ;change number
       jz notoneThird63               ;change lable name
       drawpicture  oneThirdtimeFilename,oneThirdtimeFilehandle,oneThirdtimeWidth,oneThirdtimeHeight,oneThirdtimeData,175,175   ;chnge cx and dx
       mov sixtythr,0      ;change number
       notoneThird63:
  
     inc TimerArray[63]         ; change number
     
    inc63:               ; change number
    pop di
    pop bx
    pop dx 
    pop cx

exitcheckTimer:
mov previousTime,bl
pop bx

ret
checkTimer   endp
;-------------------------------------------------------------------------------------------

;----------------------------------- CheckWhichToDrawForTimer -----------------------------
CheckWhichToDrawForTimer proc 

mov bl ,arrayboard[di]

;black
 cmp bl,6
 jnz DontDrwBpawn
 call clearCellWithGreenOrWhite
 Drawpiece blackpawnData
 DontDrwBpawn:

 cmp bl,4
 jnz DontDrwBQueen
 call clearCellWithGreenOrWhite
 Drawpiece blackqueenData
 DontDrwBQueen:

 cmp bl,1
 jnz DontDrwBRook
 call clearCellWithGreenOrWhite
 Drawpiece blackrookData
 DontDrwBRook:

 cmp bl,2
 jnz DontDrwBKhignht
 call clearCellWithGreenOrWhite
 Drawpiece blackhorseData
 DontDrwBKhignht:

 cmp bl,3
 jnz DontDrwBbishop
 call clearCellWithGreenOrWhite
 Drawpiece blackbishopData
 DontDrwBbishop:

 cmp bl,5
 jnz DontDrwBKing
 call clearCellWithGreenOrWhite
 Drawpiece blackkingData
 DontDrwBKing:

 ;White
 cmp bl,12
 jnz DontDrwwpawn
 call clearCellWithGreenOrWhite
 Drawpiece WhitepawnData
 DontDrwwpawn:

 cmp bl,11
 jnz DontDrwwQueen
 call clearCellWithGreenOrWhite
 Drawpiece whitequeenData
 DontDrwwQueen:

 cmp bl,7
 jnz DontDrwwRook
 call clearCellWithGreenOrWhite
 Drawpiece whiterookData
 DontDrwwRook:

 cmp bl,8
 jnz DontDrwwKhignht
 call clearCellWithGreenOrWhite
 Drawpiece whiteknightData
 DontDrwwKhignht:

 cmp bl,9
 jnz DontDrwwbishop
 call clearCellWithGreenOrWhite
 Drawpiece whitebishopData
 DontDrwwbishop:

 cmp bl,10
 jnz DontDrwwKing
 call clearCellWithGreenOrWhite
 Drawpiece whitekingData
 DontDrwwKing:

ret 
 CheckWhichToDrawForTimer endp
 ;-------------------------------------------------------------------------------------------

;--------------------------------------drawFullTimer-----------------------------------------
 drawFullTimer proc
  mov cx,0000h
  mov dx,0050h
  ret
drawFullTimer  endp
  ;----------------------------------------------------------------------------------------------------------
  
  ;--------------------------------------------Clear the buffer ---------------------------------------------
  clearkeyboardbuffer		proc	

	mov ax,0C00h ;equivalent of "mov ah,0Ch mov al,0"
  int 21h

	ret
  clearkeyboardbuffer		endp
  ;----------------------------------------------------------------------------------------------------------

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;                                             MAIN SCREEN                                                 ;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

mainscreen proc

push ax
push bx
push cx
push dx
push si
push di
push bp

    mov ah, 0
    mov al, 3h
    int 10h 

stringcolour mes,1330,26,0fh ;prints 1st message
stringcolour mes1,1650,26,0fh ;prints 2nd message
stringcolour mes2,1970,28,0fh ;prints 3rd message
    
mov ah,2  ;moves the cursor for the notification bar
mov dl,0  ;x coordinate   
mov dh,20 ;y coordinate
int 10h ;executes the interrupt
    
mov ah, 9h ;display --- of the notification bar  
mov dx, offset mes3 ;message to be displayed
int 21h ;executes the interrupt

mov al,00
terminate11: 
cmp al,27d
jnz select
jmp terminate 
select: ;label to check for selected key
mov ah,0 ;waits for user click (F1,F2,ESC)
int 16h ;executes the interrupt
cmp al,27d ;ascii of esc  
jz terminate11 ;esc function
cmp ah,3Bh
jz chat
cmp ah,3Ch
jz game
jmp select
;;;;;;;;;;;;;;;;;;;;;;;for chat mode;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
chat:
; mov ah,2  
; mov dl,1
; mov dh,21
; int 10h 

; mov ah, 9h  
; lea dx, username+2
; int 21h 

; mov ah,2  
; mov dl,0
; mov dh,22
; int 10h 

; mov ah, 9h  
; mov dx, offset mes4
; int 21h 

; mov ah, 9h  
; lea dx, username1+2
; int 21h 

; mov ah,2  
; mov dl,0 
; mov dh,24 
; int 10h 
    
; mov ah, 9h
; mov dx, offset mes6
; int 21h 

; mov ah,2  
; mov dl,48
; mov dh,24 
; int 10h 

call ChatModule

select1:
mov ah,0
int 16h 
cmp al,27d 
jz terminate 
cmp ah,3Bh
jz chat
cmp ah,3Ch
jz game
jmp select1
;;;;;;;;;;;;;;;;;;;;;;for game mode;;;;;;;;;;;;;;;;;;;;;;;;;;
game:
mov ah,2  
mov dl,1
mov dh,21
int 10h 

mov ah, 9h  
lea dx, username+2
int 21h 

mov ah,2  
mov dl,0
mov dh,22
int 10h 

mov ah, 9h  
mov dx, offset mes5
int 21h 

mov ah, 9h  
lea dx, username1+2
int 21h 

mov ah,2  
mov dl,0 
mov dh,24 
int 10h 
    
mov ah, 9h
mov dx, offset mes7
int 21h 
;;;;;;;;;;;;;;;;;;waits for user click;;;;;;;;;;;;;;;;;;;
select2: 
mov ah,0
int 16h 
cmp al,27d 
jz terminate 
cmp ah,3Bh
jz chat1
cmp ah,3Ch
jz game1
cmp ah,3Dh              ;f3
jz continuegame
jmp select2

terminate: ;label for termination
mov ah,4Ch ;terminates the program
int 21h  ;executes the interrupt

game1:

pop bp
pop di
pop si
pop dx
pop cx
pop bx
pop ax

continuegame:

call initializeTheGame
call move
ret
mainscreen endp
chat1:  jmp chat 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                             SERIAL                                                      ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


ChatModule proc
push ax
push bx
push cx
push dx
push si
push di

CALL INITIALIZATION
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

 CALL CLEAR

 setCursor 0,0Ch
            
 mov ah, 9
 mov dx, offset LINE
 int 21h

setCursor   0,0
 ;call detect

detect:
  MOV REsCHAR, '$'
 mov  ah,1                 ;check if a key is pressed
  int   16h
 jz  temp
 jnz   send

 ;;;;;;;;;;;;;;;;;;
 send:       
 mov ah,0                 ;clear the keyboard buffer
int 16h

cmp ah,3Eh
jnz ppppp
jmp ExitChatModule
ppppp:

 mov CHAR,al
 CMP ah,1ch               ; check if the key is enter
jz  newline

CMP AL, 08 ;BACKSPACE
JZ temp2



MOV CHAR, AL
				setCursor xs, ys
				MOV SI, OFFSET CHAR
				CALL DISPLAYMESSAGE
				SENDING CHAR

    inc xs
				CMP xs, 80
				JE akhrsatr
				BACKSEND:
				JMP recieve
                temp:
                jmp recieve
akhrsatr:
        MOV xs, 0
				INC ys
				CMP ys, 12
				JE khlst
				BACKakhrsatr:
				JMP BACKSEND
			khlst:
				SCROLL 0, 0, 79, 11
				MOV ys, 11
				JMP BACKakhrsatr
temp2:
jmp BACKSPACE
 newline:    
 inc  ys
mov xs,0
CMP ys, 12
				JE linegded
				CONTSEN:
				setCursor xs, ys
				SENDING 0CH
				JMP endsend
linegded:
				SCROLL 0, 0, 79, 11
				MOV ys, 11
				JMP CONTSEN
temp3:
jmp detect
ExitChatModule:
call mainscreen
BACKSPACE:
setCursor xs, ys
				MOV SI, OFFSET SPACE
				CALL DISPLAYMESSAGE
				DEC xs
				setCursor xs, ys
				SENDING SPACE
				JMP endsend

endsend:


recieve:     
        RECEIVING REsCHAR
				CMP REsCHAR, '$'
				JE temp3
				
				CMP REsCHAR, 0CH
				JE enterr
				
				CMP REsCHAR, 32
				JE BACKSPACERER
				
				setCursor xr, yr
				MOV SI, OFFSET REsCHAR
				CALL DISPLAYMESSAGE
				INC xr
				CMP xr, 80
				JE akhrsatr2
				BACKSENDREC:
				JMP detect
				
			enterr:        
				MOV xr, 0
				inc yr
				CMP yr, 24
				JE linegded2
				CONT_RES:
				setCursor xr, yr
				JMP detect
				
			BACKSPACERER:
				setCursor xr, yr
				MOV SI, OFFSET SPACE
				CALL DISPLAYMESSAGE
				DEC xr
				setCursor xr, yr
				JMP detect
				
			linegded2:
				SCROLL 0, 0DH, 79, 24
				setCursor 0, 12
				;MOV SI, OFFSET SPLIT
				;CALL DISPLAYMESSAGE
				MOV yr, 23
				JMP CONT_RES
				
			akhrsatr2:
				MOV xr, 0
				INC yr
				CMP yr, 24
				JE khlst2
				akhrsatr2back:
				JMP BACKSENDREC
				
			khlst2:
				SCROLL 0, 0DH, 79, 24
				setCursor 0, 12
				;MOV SI, OFFSET SPLIT
				;CALL DISPLAYMESSAGE
				MOV yr, 23
				JMP akhrsatr2back
	
		JMP detect

pop di
pop si
pop dx
pop cx
pop bx
pop ax

ret
ChatModule endp


INITIALIZATION PROC 
		;SET DIVISOR LATCH ACCESS BIT
		MOV DX,3FBH 			; LINE CONTROL REGISTER
		MOV AL,10000000B		;SET DIVISOR LATCH ACCESS BIT
		OUT DX,AL				;OUT IT

		;SET LSB BYTE OF THE BAUD RATE DIVISOR LATCH REGISTER.
		MOV DX,3F8H			
		MOV AL,0CH			
		OUT DX,AL

		;SET MSB BYTE OF THE BAUD RATE DIVISOR LATCH REGISTER.
		MOV DX,3F9H
		MOV AL,00H
		OUT DX,AL

		;SET PORT CONFIGURATION
		MOV DX,3FBH
		MOV AL,00011011B
			;0:ACCESS TO RECEIVER BUFFER, TRANSMITTER BUFFER
			;0:SET BREAK DISABLED
			;011:EVEN PARITY
			;0:ONE STOP BIT
			;11:8BITS
		OUT DX,AL
		RET
	INITIALIZATION ENDP

   CLEAR PROC 
		MOV AX, 0600h    ; Scroll up function
		MOV CX,0     ; Upper left corner CH=row, CL=column
		MOV DX, 184FH  ; lower right corner DH=row, DL=column
		MOV BH, 07    
		INT 10H
		RET
	CLEAR ENDP
DISPLAYMESSAGE PROC
		MOV AH, 9		;Display string function
		MOV DX, SI		;offset of the string
		INT 21H			;execute
		RET
	DISPLAYMESSAGE ENDP
 
END MAIN