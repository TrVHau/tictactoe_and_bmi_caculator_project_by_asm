include 'emu8086.inc'
name "TIC TAC TOE"
ORG 100h
.data
    ;chao mung den voi tic tac toe 
    cell db '0123456789','$'
    wc1 db 2,2,2,2,2,32,2,32,32,2,2,2,32,32,2,2,2,2,2,32,32,2,2,32,32,32,2,2,2,32,32,2,2,2,2,2,32,32,2,2,32,32,2,2,2,2,'$'
    wc2 db 32,32,2,32,32,32,32,32,2,32,32,32,32,32,32,32,2,32,32,32,2,32,32,2,32,2,32,32,32,32,32,32,32,2,32,32,32,2,32,32,2,32,2,'$'
    wc3 db 32,32,2,32,32,32,2,32,2,32,32,32,32,32,32,32,2,32,32,32,2,2,2,2,32,2,32,32,32,32,32,32,32,2,32,32,32,2,32,32,2,32,2,2,2,2,'$'
    wc4 db 32,32,2,32,32,32,2,32,2,32,32,32,32,32,32,32,2,32,32,32,2,32,32,2,32,2,32,32,32,32,32,32,32,2,32,32,32,2,32,32,2,32,2,'$'
    wc5 db 32,32,2,32,32,32,2,32,32,2,2,2,32,32,32,32,2,32,32,32,2,32,32,2,32,32,2,2,2,32,32,32,32,2,32,32,32,32,2,2,32,32,2,2,2,2,'$'
    wc6 db 'Nhom 4$'
    wc7 db 'Giang vien: Dang Hoang Long$'
    wc8 db 'Bam nut bat ki de tiep tuc...$'
    
    ;ki tu nguoi choi
    inforPlayer1 db 'Nguoi choi 1 : (X) $'
    inforPlayer2 db 'Nguoi choi 2 : (O) $'
    
    ;tao bang
    
    line1 db  '|-----------|$'
    line2 db  '|   |   |   |$'
    line3 db  '| 1 | 2 | 3 |$'
    line4 db  '|   |   |   |$'
    line5 db  '|-----------|$'
    line6 db  '|   |   |   |$'
    line7 db  '| 4 | 5 | 6 |$'
    line8 db  '|   |   |   |$'
    line9 db  '|-----------|$'
    line10 db '|   |   |   |$'
    line11 db '| 7 | 8 | 9 |$'
    line12 db '|   |   |   |$'
    line13 db '|-----------|$'
    
    player db '1$'      ;ki tu nguoi choi thu 1,2
    currentMark db 'X$' ;ki tu o danh dau cua nguoi choi
    moves db 0          ; so lan di chuyen
    doneStatus db 0     ;da hoan thanh tran dau
    drawStatus db 0     ;trang thai hoa  
    tryAgainStatus db 0 ;trang thai ban co muon choi lai khong
    
    ;hien ra ket qua tran dau
    win1 db 'Nguoi choi $'
    win2 db 'chien thang $'
    drw db 'Tran dau hoa!'  
    
    ;nhap o muon chon
    inp db 'nhap o muon chon.                                                                                                         $'
    wasTaken db 'O da duoc chon. Moi ban chon lai.                                                                                    $'
    
    ;nhap khi choi lai
    try db 'ban co muon choi lai khong?(y/n): $'
    wronginput db 'khong dung ki tu, moi ban nhap lai.                                                                                $'
    
.code
start:
    call WELCOME
    beginGame:
    call BOARD
    call INIT
    game:
    call INPUT
    call CHECK
    
    cmp doneStatus,1
    je callVictory
    
    cmp drawStatus,1
    je callDraw
    
    jmp Game
    
    callVictory:
    call VICTORY
    call TRYAGAIN
    cmp tryAgainStatus,1
    je callTryAgain
    
    jmp EXIT
    
    callDraw:
    call DRAW
    call TRYAGAIN
    cmp tryAgainStatus,1
    je callTryAgain
    
    jmp EXIT
    
    callTryAgain:
    jmp beginGame:
    
    
;hien ra phan chao
WELCOME proc
    call CLEAR_SCREEN
    GOTOXY 35,3
    PRINT 'WELCOME TO' 
    GOTOXY 15,5
    mov ah,9
    lea dx, wc1
    int 21h
    GOTOXY 15,6
    lea dx, wc2
    int 21h
    GOTOXY 15,7
    lea dx, wc3
    int 21h
    GOTOXY 15,8
    lea dx, wc4
    int 21h
    GOTOXY 15,9
    lea dx, wc5
    int 21h
    GOTOXY 35,12
    lea dx,wc6
    int 21h
    GOTOXY 28,13
    lea dx,wc7
    int 21h
    GOTOXY 23,14
    lea dx,wc8
    int 21h
    mov ah,7
    int 21h
ret    
WELCOME endp
;hien thi bang hien tai
BOARD proc
    call CLEAR_SCREEN
    
    GOTOXY 2,3
    mov ah,9
    lea dx,inforPlayer1
    int 21h
    
    GOTOXY 2,4
    mov ah,9
    lea dx,inforPlayer2
    int 21h

    GOTOXY 30,2     ;dua con tro den cot 30 dong 2
    mov ah,9
    lea dx,line1
    int 21h
    
    GOTOXY 30,3     ;dua con tro den cot 30 dong 3
    mov ah,9
    lea dx,line2
    int 21h
    
    GOTOXY 30,4     ;dua con tro den cot 30 dong 4
    mov ah,9
    lea dx,line3
    int 21h
    
    GOTOXY 30,5     ;dua con tro den cot 30 dong 5
    mov ah,9
    lea dx,line4
    int 21h
    
    GOTOXY 30,6     ;dua con tro den cot 30 dong 6
    mov ah,9
    lea dx,line5
    int 21h
    
    GOTOXY 30,7     ;dua con tro den cot 30 dong 7
    mov ah,9
    lea dx,line6
    int 21h
    
    GOTOXY 30,8     ;dua con tro den cot 30 dong 8
    mov ah,9
    lea dx,line7
    int 21h
    
    GOTOXY 30,9     ;dua con tro den cot 30 dong 9
    mov ah,9
    lea dx,line8
    int 21h
    
    GOTOXY 30,10     ;dua con tro den cot 30 dong 10
    mov ah,9
    lea dx,line9
    int 21h
    
    GOTOXY 30,11     ;dua con tro den cot 30 dong 11
    mov ah,9
    lea dx,line10
    int 21h
    
    GOTOXY 30,12     ;dua con tro den cot 30 dong 12
    mov ah,9
    lea dx,line11
    int 21h
    
    GOTOXY 30,13     ;dua con tro den cot 30 dong 13
    mov ah,9
    lea dx,line12
    int 21h
    
    GOTOXY 30,14     ;dua con tro den cot 30 dong 14
    mov ah,9
    lea dx,line13
    int 21h
    
    ret   
BOARD endp
;khoi tao tat ca cac bien ve ban dau
INIT proc
    mov cell[1],'1'
    mov cell[2],'2'
    mov cell[3],'3'
    mov cell[4],'4'
    mov cell[5],'5'
    mov cell[6],'6'
    mov cell[7],'7'
    mov cell[8],'8'
    mov cell[9],'9'
    
    mov player,'1'
    mov currentMark,'X'
    mov moves,0
    mov doneStatus,0
    mov drawStatus,0
    mov tryAgainStatus,0 
ret    
INIT endp

VICTORY proc
    GOTOXY 26,19    ;dua con tro den cot 26 dong 19
    mov ah,9
    lea dx,win1
    int 21h
    
    lea dx,player
    int 21h
    
    lea dx,win2
    int 21h
    
    GOTOXY 22,20    ;dua con tro den cot 22 dong 20
    mov ah,9
    lea dx,wc8
    int 21h
    
    mov ah,7        ;bam nut bat ki
    int 21h
ret       
VICTORY endp

DRAW proc
    GOTOXY 26,19    ;dua con tro den cot 26 dong 19
    mov ah,9
    lea dx,drw
    int 21h
    
    GOTOXY 22,20    ;dua con tro den cot 22 dong 20
    mov ah,9
    lea dx,wc8
    int 21h
    
    mov ah,7        ;bam nut bat ki
    int 21h
    
ret
DRAW endp

CHECK proc
   check1: ;check 1 2 3
   mov al,cell[1]
   cmp al,cell[2]
   jne check2   
   cmp al,cell[3]
   jne check2
   
   mov doneStatus,1
   ret
     
   check2:
   mov al,cell[4]   
   cmp al,cell[5]
   jne check3   
   cmp al,cell[6]
   jne check3
   
   mov doneStatus,1
   ret
     
   check3:
   mov al,cell[7]  
   cmp al,cell[8]
   jne check4  
   cmp al,cell[9]
   jne check4
   
   mov doneStatus,1
   ret 
   
   check4:
   mov al,cell[1]  
   cmp al,cell[4]
   jne check5   
   cmp al,cell[7]
   jne check5
   
   mov doneStatus,1
   ret
   
   check5:
   mov al,cell[2]
   cmp al,cell[5]
   jne check6  
   cmp al,cell[8]
   jne check6
   
   mov doneStatus,1
   ret
   
   check6:
   mov al,cell[3]
   cmp al,cell[6]
   jne check7
   cmp al,cell[9]
   jne check7
   
   mov doneStatus,1
   ret
   
   check7:
   mov al,cell[1]
   cmp al,cell[5]
   jne check8   
   cmp al,cell[9]
   jne check8
   
   mov doneStatus,1
   ret 
   
   check8:
   mov al,cell[3]
   cmp al,cell[5]
   jne checkdraw 
   cmp al,cell[7]
   jne checkdraw
   
   mov doneStatus,1
   ret 
   
   checkdraw:
   mov al,moves
   cmp al,9
   jl callPlayerChange
   
   mov drawStatus,1
   ret
   
   callPlayerChange:
   call PLAYERCHANGE
   ret
   
CHECK endp

PLAYERCHANGE proc
    cmp player,'1'
    je changeToPlayer2
    jmp changeToPlayer1
    
    changeToPlayer1:
    mov player,'1'
    mov currentMark,'X'
    ret
    
    changeToPlayer2:
    mov player,'2'
    mov currentMark,'O'
    ret    
PLAYERCHANGE endp
;choi lai
TRYAGAIN proc   
    call CLEAR_SCREEN
    ag:
    GOTOXY 24,10
    mov ah,9
    lea dx,try
    int 21h
    
    mov ah,1
    int 21h
    
    cmp al,'y'
    je callYES  
    cmp al,'Y'
    je callYES
    
    cmp al,'n'
    je callNO 
    cmp al,'N'
    je callNO
    
    callYES:
    mov tryAgainStatus,1
    ret
    
    callNO:
    ret
    
    callWRONGINPUT:
    GOTOXY 24,9
    mov ah,9
    lea dx,wronginput
    int 21h
    jmp ag      
    
TRYAGAIN endp
;nhap vao
INPUT proc
    startInput:
    GOTOXY 20,16
    
    cmp player,'1'
    je take1:
    
    mov ah,9
    lea dx,inforPlayer2
    int 21h
    jmp takeinput
    
    take1:
    mov ah,9
    lea dx,inforPlayer1
    int 21h
    
    takeinput:
    mov ah,9
    lea dx,inp
    int 21h
    
    mov ah,1  ;nhap 1 ki tu
    int 21h
    
    inc moves ;tang so lan choi len 1
    mov bl,al
    sub bl,'0'
    
    mov cl,currentMark
    ;nhap dung ki tu
    cmp bl,1
    je checkCell1:
    cmp bl,2
    je checkCell2:
    cmp bl,3
    je checkCell3:
    cmp bl,4
    je checkCell4:
    cmp bl,5
    je checkCell5:
    cmp bl,6
    je checkCell6:
    cmp bl,7
    je checkCell7:
    cmp bl,8
    je checkCell8:
    cmp bl,9
    je checkCell9:
    
    ;nhap sai ki tu
    dec moves
    GOTOXY 20,16
    mov ah,9
    lea dx,wronginput
    int 21h
    
    mov ah,7
    int 21h
    jmp startInput:
    
    ;kiem tra o duoc chon
    checkcell1:
    cmp cell[1],'O'
    je taken
    cmp cell[1],'X'
    je taken
    mov cell[1],cl
    GOTOXY 32,4
    mov ah,9
    lea dx,currentMark
    int 21h
    ret
    
    checkcell2:
    cmp cell[2],'O'
    je taken
    cmp cell[2],'X'
    je taken
    mov cell[2],cl
    GOTOXY 36,4
    mov ah,9
    lea dx,currentMark
    int 21h
    ret
    
    checkcell3:
    cmp cell[3],'O'
    je taken
    cmp cell[3],'X'
    je taken
    mov cell[3],cl
    GOTOXY 40,4
    mov ah,9
    lea dx,currentMark
    int 21h
    ret
    
    checkcell4:
    cmp cell[4],'O'
    je taken
    cmp cell[4],'X'
    je taken
    mov cell[4],cl
    GOTOXY 32,8
    mov ah,9
    lea dx,currentMark
    int 21h
    ret
    
    checkcell5:
    cmp cell[5],'O'
    je taken
    cmp cell[5],'X'
    je taken
    mov cell[5],cl
    GOTOXY 36,8
    mov ah,9
    lea dx,currentMark
    int 21h
    ret
    
    checkcell6:
    cmp cell[6],'O'
    je taken
    cmp cell[6],'X'
    je taken
    mov cell[6],cl
    GOTOXY 40,8
    mov ah,9
    lea dx,currentMark
    int 21h
    ret
    
    checkcell7:
    cmp cell[7],'O'
    je taken
    cmp cell[7],'X'
    je taken
    mov cell[7],cl
    GOTOXY 32,12
    mov ah,9
    lea dx,currentMark
    int 21h
    ret
    
    checkcell8:
    cmp cell[8],'O'
    je taken
    cmp cell[8],'X'
    je taken
    mov cell[8],cl
    GOTOXY 36,12
    mov ah,9
    lea dx,currentMark
    int 21h
    ret
    
    checkcell9:
    cmp cell[9],'O'
    je taken
    cmp cell[9],'X'
    je taken
    mov cell[9],cl
    GOTOXY 40,12
    mov ah,9
    lea dx,currentMark
    int 21h
    ret
    
    ;o da duoc chon
    taken:
    dec moves
    GOTOXY 20,16
    mov ah,9
    lea dx,wasTaken
    int 21h
    
    mov ah,7
    int 21h
    jmp startInput:
    
INPUT endp


EXIT: ;ket thuc chuong trinh
mov ah,4ch
int 21h
DEFINE_CLEAR_SCREEN
END start
