;<<https://en.wikipedia.org/wiki/INT_10H>>
;<<https://stanislavs.org/helppc/int_10-0.html>>
;<<https://en.wikipedia.org/wiki/BIOS_color_attributes>>


.model small

.stack 64   


.data
PIXEL_X DW ? ;right
PIXEL_Y DW ? ;down
PIXEL_SIZE DW 04h
TAPE DB ':+?+D+S+X+0050:0?0D0I0S0X0+50555:5?5D5I5N5S5X5]5b5+:0:5:::?:D:I:N:S:X:]:b:g:+?0?5?:???D?I?N?S?X?]?b?g?0D5D:D?DDDIDNDSDXD]DbDgDlDqD&I+I0I5I:I?IDIIINISIXI]IbIgIlIqIvI{I!N&N+N0N5N:N?NDNINNNSNXN]NbNgNlNqNvN{N!S&S+S0S5S:S?SDSISNSSSXS]SbSgSlSqSvS{S!X&X+X0X5X:X?XDXIXNXSXXX]XbXgXlXqXvX!]&]+]0]5]:]?]D]I]N]S]X]]]b]g]l]!b&b+b0b5b:b?bDbIbNbSbXb]bbbgb&g+g0g:g?gDgIgNgSgXg]gbggg:l?lDlIlNlSlXl]lblglll?qDqIqNqSqXq]qbqgqlqXv]vbvgvlv]{b{g{l{'
COLOR DB '?555EE55LL55EE5LLLLL5EE5555LLLLLEE55LL555LLL5EE5LLL555L55E+55LL5zz5555555++5LL5zHHHH5LLLLL55+555555zzzH5LLL55555555LL55zHz5LLLLL5L5L5LLLL5zz5LLL55LL5L55LLL55LL555LLLL555555555LLLLL5zzz5LLLL55zzHz55555zzHzHzHHHHzzzz'


.code
MAIN: 
MOV AX,@data
MOV DS,AX

MOV AH,00h ;[10h function] set video mode 
MOV AL,13h ;choose the video mode 
INT 10h    ;execute

;MOV AH,0Bh ;[10h function] set background color
;MOV BH,00h ;[10h function] set background color
;MOV BL,03h ;choose the BG color 
;INT 10h    ;execute 


;------------------DRAW A PIXEL----------------------

MOV SI,OFFSET TAPE
MOV DI,OFFSET COLOR
MOV CX,00D5h ; 'XY XY XY' === 3 (pixel count)

L:
PUSH CX
MOV AX,[SI] ; AX = 'XY'


MOV CL,AL ;set the initial (x)
MOV DL,AH ;set the initial (y)
ADD SI,2h ;move the tape
ADD DI,1h ;move the color
MOV PIXEL_X,CX ;PIXEL_X = initial (x)
MOV PIXEL_Y,DX ;PIXEL_Y = initial (y)
 

DRAW_PIXEL:
MOV AH,0Ch ;[10h function] write graphics pixel
MOV AL,[DI] ;choose the pixel color  
INT 10h    ;execute

;********MKAE THE PIXEL BIG********
INC CX         ;CX+=1 or in other word X+1 (CL contain the X & DL containt the y)
MOV AX,CX      ;CX - PIXEL_X > PIXEL_SIZE (Y -> We go to the next line(y),N -> We continue to the next column(x))
SUB AX,PIXEL_X
CMP AX,PIXEL_SIZE
JNG DRAW_PIXEL ;Jump if not greater

MOV CX,PIXEL_X ;the CX register goes back to the initial column(x)

INC DX         ;DX+=1 or in other word Y+1 (CL contain the X & DL containt the y)
MOV AX,DX      ;DX - PIXEL_Y > PIXEL_SIZE (Y -> we exit this procedure,N -> we continue to the next line(y))
SUB AX,PIXEL_Y
CMP AX,PIXEL_SIZE
JNG DRAW_PIXEL ;Jump if not greater
;********MKAE THE PIXEL BIG********
 
 
POP CX
LOOP L

;pause the screen for dos compatibility:
;wait for keypress
MOV AH,00
INT 16h			
RET
END MAIN