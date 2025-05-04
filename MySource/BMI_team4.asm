.model small           ; Su dung mo hinh bo nho nho
.stack 100h            ; Khoi tao ngan xep voi kich thuoc 256 byte

.data                  ; Bat dau doan du lieu
   1e1 dw 10           ; Hang so 10
   1e4 dw 10000        ; Hang so 10000
   chuso db ?          ; Bien tam luu tung chu so vua nhap
   weight dw ?         ; Can nang nguoi dung nhap (don vi: kg)
   height dw ?         ; Chieu cao nguoi dung nhap (don vi: cm)
   xinchao dw '=== CHUONG TRINH TINH BMI ===$'         ; Chuoi loi chao
   xuong_dong dw 10, 13, '$'                           ; Ky tu xuong dong
   yeu_cau_nhap_can_nang dw 'Xin hay nhap can nang cua ban(kg): $' ; Cau nhap can nang
   yeu_cau_nhap_chieu_cao dw 'Xin hay nhap chieu cao cua ban(cm): $' ; Cau nhap chieu cao
   ketqua dw 'Day la ket qua BMI cua ban: $'           ; Chuoi hien thi ket qua BMI
   tieptuc dw 'Ban co muon tiep tuc chuong trinh ?', 10, 13, 'Neu ban muon tiep tuc hay bam so 1, neu khong hay bam so 0.', 10, 13, 'Moi ban nhap: $' ; Cau hoi tiep tuc
   Error dw 'Ban da nhap sai!!!!$'                     ; Thong bao loi khi nhap sai
   Hi dw 0                                              ; Phan cao cua tich 32 bit
   Lo dw 0                                              ; Phan thap cua tich 32 bit
   cham_phay db '.$'                                   ; Ky tu dau cham
   ans_nguyen dw 0                                      ; Phan nguyen cua BMI
   ans_du dw 0                                          ; Phan du sau khi chia
   ans_champhay dw 0                                    ; Phan thap phan cua BMI

   ; Muc danh gia chi so BMI theo tung nguong
   muc1 dw 160
   tb1 dw 'Co the ban dang trong tinh trang Gay do 3 (rat nang)$'
   muc2 dw 170
   tb2 dw 'Co the ban dang trong tinh trang Gay do 2 <vua>$'
   muc3 dw 185
   tb3 dw 'Co the ban dang trong tinh trang Gay do 1 <nhe>$'
   muc4 dw 250
   tb4 dw 'Co the ban hoan toan Binh thuong <khoe manh>$'
   muc5 dw 300
   tb5 dw 'Co the ban co dau hieu Thua can <tien beo phi> $'
   muc6 dw 350
   tb6 dw 'Co the ban dang Beo phi do 1$'
   muc7 dw 400
   tb7 dw 'Co the ban dang Beo phi do 2$'
   tb8 dw 'Co the ban dang Beo phi do 3 <rat nang>$'

.code                   ; Bat dau doan ma chuong trinh
main proc
    mov ax, @data
    mov ds, ax          ; Khoi tao thanh ghi DS de truy xuat bien

Start:
    ; In ra loi chao
    lea dx, xinchao
    mov ah, 9
    int 21h

    ; Xuong dong
    lea dx, xuong_dong
    mov ah, 9
    int 21h

Nhap_weight:
    ; Hien thi thong bao nhap can nang
    lea dx, yeu_cau_nhap_can_nang
    mov ah, 9
    int 21h

    ; Goi ham nhap so nguyen
    call read_num
    mov weight, ax      ; Luu gia tri nhap vao bien weight

    ; Xuong dong
    lea dx, xuong_dong
    mov ah, 9
    int 21h

    ; Neu weight = 0 thi nhap lai
    cmp weight, 0
    je Nhap_weight

    ; Tinh tu so BMI = can nang * 10000
    mov ax, weight
    mul 1e4             ; AX * 10000 => ket qua 32 bit: DX:AX
    mov Hi, dx
    mov Lo, ax

Nhap_height:
    ; Hien thi thong bao nhap chieu cao
    lea dx, yeu_cau_nhap_chieu_cao
    mov ah, 9
    int 21h

    call read_num
    mov height, ax      ; Luu vao bien height

    ; Xuong dong
    lea dx, xuong_dong
    mov ah, 9
    int 21h

    cmp height, 0
    je Nhap_height

    ; Tinh height^2
    mov ax, height
    mul height
    mov cx, ax          ; cx = height^2

    mov height, cx      ; cap nhat height thanh height^2 de su dung sau

    ; BMI = (can nang * 10000) / (height^2)
    mov dx, Hi          ; phan cao cua so chia
    mov ax, Lo          ; phan thap
    div cx              ; ket qua chia 32-bit / 16-bit

    mov ans_nguyen, ax  ; phan nguyen cua BMI
    mov ans_du, dx      ; phan du

    ; In thong bao ket qua
    lea dx, ketqua
    mov ah, 9
    int 21h

    ; In phan nguyen cua BMI
    mov ax, ans_nguyen
    call print_num

    ; In dau cham
    lea dx, cham_phay
    mov ah, 9
    int 21h

    ; Tinh va in phan thap phan: (du * 10) / height^2
    mov ax, ans_du
    mul 1e1
    mov cx, height
    div cx
    mov ans_champhay, ax
    call print_num

    ; Xuong dong
    lea dx, xuong_dong
    mov ah, 9
    int 21h

    ; Goi ham phan loai BMI
    call phan_loai

    ; Xuong dong
    lea dx, xuong_dong
    mov ah, 9
    int 21h

    ; Hoi nguoi dung co muon tiep tuc khong
    lea dx, tieptuc
    mov ah, 9
    int 21h

    ; Nhan phim lua chon
    mov ah, 1
    int 21h

    ; Xuong dong
    lea dx, xuong_dong
    mov ah, 9
    int 21h

    cmp al, '0'
    jne Start           ; Neu khac '0' thi quay lai dau

    ; Ket thuc chuong trinh
    mov ah, 4Ch
    int 21h

main endp

; === Ham danh gia BMI dua tren ket qua tinh duoc ===
phan_loai proc
    ; Tinh BMI * 10 de so sanh so nguyen
    mov ax, ans_nguyen
    mul 1e1
    add ax, ans_champhay

    ; So sanh theo nguong BMI
    cmp ax, muc1
    jl Muc_1
    cmp ax, muc2
    jl Muc_2
    cmp ax, muc3
    jl Muc_3
    cmp ax, muc4
    jl Muc_4
    cmp ax, muc5
    jl Muc_5
    cmp ax, muc6
    jl Muc_6
    cmp ax, muc7
    jl Muc_7
    jmp Muc_8

Muc_1:
    lea dx, tb1
    mov ah, 9
    int 21h
    ret
Muc_2:
    lea dx, tb2
    mov ah, 9
    int 21h
    ret
Muc_3:
    lea dx, tb3
    mov ah, 9
    int 21h
    ret
Muc_4:
    lea dx, tb4
    mov ah, 9
    int 21h
    ret
Muc_5:
    lea dx, tb5
    mov ah, 9
    int 21h
    ret
Muc_6:
    lea dx, tb6
    mov ah, 9
    int 21h
    ret
Muc_7:
    lea dx, tb7
    mov ah, 9
    int 21h
    ret
Muc_8:
    lea dx, tb8
    mov ah, 9
    int 21h
    ret
phan_loai endp

; === Ham nhap so nguyen tu ban phim ===
read_num proc
    mov ax, 0
    mov bx, 0
read_loop:
    mov ah, 1
    int 21h            ; Nhan mot ky tu
    cmp al, 13
    je read_done       ; Neu enter thi ket thuc

    cmp al, '9'
    jg read_again      ; Neu khong phai chu so thi bao loi

    sub al, '0'        ; Chuyen ky tu ve dang so
    mov chuso, al
    mov ax, bx
    mul 1e1            ; Nhan 10 de dich trai so
    mov bx, ax
    add bl, chuso      ; Cong chu so moi
    mov ax, bx
    jmp read_loop

read_done:
    mov ax, bx
    mov weight, ax
    ret

read_again:
    lea dx, xuong_dong
    mov ah, 9
    int 21h
    lea dx, error
    mov ah, 9
    int 21h
    mov ax, 0
    ret
read_num endp

; === Ham in so nguyen ra man hinh ===
print_num proc
    mov cx, 0
Lappush:
    mov dx, 0
    div 1e1            ; Tach lay tung chu so
    add dx, '0'        ; Chuyen thanh ky tu
    push dx            ; Day vao ngan xep
    inc cx
    cmp ax, 0
    jne Lappush
Hienthi:
    pop dx             ; Lay chu so ra
    mov ah, 2
    int 21h
    loop Hienthi
    ret
print_num endp

end main
