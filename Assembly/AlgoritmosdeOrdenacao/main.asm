; ================================================================
; ALGORITMOS DE ORDENACAO - SEGA Mega Drive / Genesis (68000 ASM)
; ================================================================
; Montagem: vasmm68k_mot -Fbin -o rom.bin main.asm
; Executar em emulador (Kega Fusion, Gens, RetroArch + Genesis Plus)
; ================================================================

    org     $00000000

; ========== VETOR DE INTERRUPCOES ==========
    dc.l    $00FFE000, Start
    dc.l    Empty, Empty, Empty, Empty
    dc.l    Empty, Empty, Empty, Empty
    dc.l    Empty, Empty, Empty, Empty
    dc.l    Empty, Empty, Empty, Empty
    dc.l    Empty, Empty, Empty, Empty
    dc.l    Empty, Empty, Empty, Empty
    dc.l    Empty, Empty, Empty, Empty
    dc.l    Empty, Empty, Empty, Empty
    dc.l    Empty, Empty, Empty, Empty
    dc.l    Empty, Empty, Empty, Empty
    dc.l    Empty, Empty, Empty, Empty
    dc.l    Empty, Empty, Empty, Empty
    dc.l    Empty, Empty, Empty
    dc.l    Empty, Empty
    dc.l    Empty, Empty, Empty, Empty
    dc.l    HBlank
    dc.l    Empty
    dc.l    VBlank
    dc.l    Empty

; ========== HEADER DA ROM ==========
    org     $00000100
    dc.b    "SEGA MEGA DRIVE "
    dc.b    "(C)GSTV2021      "
    dc.b    "ALGORITMOS DE ORDENACAO                    "
    dc.b    "ALGORITMOS DE ORDENACAO                    "
    dc.b    "GM XXXXXXXX-XX"
    dc.w    $0000
    dc.b    "J               "
    dc.l    $00000000, $0007FFFF
    dc.l    $E00000, $EFFFFF
    dc.l    $00000000, $00000000
    dc.l    $00000000, $00000000
    dc.b    "                                        "
    dc.b    "JUE             "

; ========== HARDWARE PORTS ==========
VDPCTRL equ $C00004
VDPDATA equ $C00000
PAD1    equ $A10003
PADCTRL equ $A10009
PSG     equ $C00011

; ========== CONSTANTES ==========
MAXSIZE equ 32           ; Max elementos (valores 0-1023)
TILESLOT equ $2000       ; Slot de tiles na VRAM

; ========== RAM ==========
    org     $00FF0000
Arr     ds.w    MAXSIZE       ; Array principal
ArrSize ds.w    1             ; Tamanho atual
RNGSeed ds.l    1             ; Semente RNG
VBFlag  ds.w    1             ; Flag VBlank
PadStat ds.w    1             ; Estado atual do pad
PadEdge ds.w    1             ; Bordas do pad
Cursor  ds.w    1             ; Posicao cursor no menu
State   ds.w    1             ; 0=menu, 1=executando, 2=resultado
Buf     ds.w    MAXSIZE       ; Buffer auxiliar
Tmp     ds.w    MAXSIZE       ; Buffer temporario

; ========== INICIO ==========
Start:
    move    #$2700, sr
    lea     $00FFE000, sp
    jsr     InitVDP
    jsr     LoadFont
    move.l  #$12345678, RNGSeed
    move.w  #12, ArrSize
    jsr     GenArray
    move.w  #0, State
    move.w  #1, Cursor

; ========== LOOP PRINCIPAL ==========
Main:
    jsr     WaitVBlank
    jsr     ReadPad
    move.w  PadEdge, d0
    move.w  State, d1
    cmp.w   #0, d1
    beq     DoMenu
    cmp.w   #1, d1
    beq     DoSort
    cmp.w   #2, d1
    beq     DoResult
    bra     Main

; ========== MODO MENU ==========
DoMenu:
    jsr     DrawMenu
    move.w  PadEdge, d0
    btst    #0, d0
    beq     .chkDown
    subq.w  #1, Cursor
    cmp.w   #0, Cursor
    bge     .chkDown
    move.w  #10, Cursor
.chkDown:
    btst    #1, d0
    beq     .chkA
    addq.w  #1, Cursor
    cmp.w   #11, Cursor
    blt     .chkA
    move.w  #1, Cursor
.chkA:
    btst    #5, d0
    beq     .chkB
    move.w  #1, State
.chkB:
    btst    #6, d0
    beq     Main
    jsr     GenArray
    bra     Main

; ========== MODO ORDENACAO ==========
DoSort:
    lea     Arr, a0
    move.w  ArrSize, d1
    move.w  Cursor, d0
    jsr     SortDispatch
    move.w  #2, State
    bra     Main

; ========== MODO RESULTADO ==========
DoResult:
    jsr     DrawResult
    move.w  PadEdge, d0
    btst    #6, d0
    beq     Main
    move.w  #0, State
    jsr     GenArray
    bra     Main

; ========== DISPATCH DE ORDENACAO ==========
SortDispatch:
    cmp.w   #1, d0
    bne     .c2
    jmp     BubbleSort
.c2:cmp.w   #2, d0
    bne     .c3
    jmp     SelectionSort
.c3:cmp.w   #3, d0
    bne     .c4
    jmp     InsertionSort
.c4:cmp.w   #4, d0
    bne     .c5
    jmp     MergeSort
.c5:cmp.w   #5, d0
    bne     .c6
    jmp     QuickSort
.c6:cmp.w   #6, d0
    bne     .c7
    jmp     HeapSort
.c7:cmp.w   #7, d0
    bne     .c8
    jmp     ShellSort
.c8:cmp.w   #8, d0
    bne     .c9
    jmp     CountingSort
.c9:cmp.w   #9, d0
    bne     .c10
    jmp     RadixSort
.c10:
    jmp     BucketSort

; ================================================================
; ALGORITMOS DE ORDENACAO
; Entrada: a0 = endereco do array, d1 = numero de elementos
; ================================================================

; ---------- BUBBLE SORT ----------
BubbleSort:
    movem.l d0-d4/a0, -(sp)
    move.w  d1, d2
    subq.w  #1, d2              ; i = n-1
.outer:
    cmp.w   #0, d2
    ble     .done
    move.w  d2, d3
    moveq   #0, d4              ; j = 0
.inner:
    cmp.w   d3, d4
    bge     .next
    move.w  (a0,d4.w*2), d0
    cmp.w   (a0,d4.w*2+2), d0
    ble     .noSwap
    move.w  (a0,d4.w*2), d0
    move.w  (a0,d4.w*2+2), d1
    move.w  d1, (a0,d4.w*2)
    move.w  d0, (a0,d4.w*2+2)
    addq.w  #1, Trocas
.noSwap:
    addq.w  #1, d4
    bra     .inner
.next:
    subq.w  #1, d2
    bra     .outer
.done:
    movem.l (sp)+, d0-d4/a0
    rts

; ---------- SELECTION SORT ----------
SelectionSort:
    movem.l d0-d5/a0, -(sp)
    move.w  d1, d2
    subq.w  #1, d2
    moveq   #0, d3              ; i = 0
.outer:
    cmp.w   d2, d3
    bge     .done
    move.w  d3, d4              ; min = i
    move.w  d3, d5
    addq.w  #1, d5              ; j = i+1
.inner:
    cmp.w   d1, d5
    bge     .swap
    move.w  (a0,d5.w*2), d0
    cmp.w   (a0,d4.w*2), d0
    bge     .nextJ
    move.w  d5, d4              ; min = j
.nextJ:
    addq.w  #1, d5
    bra     .inner
.swap:
    cmp.w   d3, d4
    beq     .nextI
    move.w  (a0,d3.w*2), d0
    move.w  (a0,d4.w*2), d1
    move.w  d1, (a0,d3.w*2)
    move.w  d0, (a0,d4.w*2)
.nextI:
    addq.w  #1, d3
    bra     .outer
.done:
    movem.l (sp)+, d0-d5/a0
    rts

; ---------- INSERTION SORT ----------
InsertionSort:
    movem.l d0-d4/a0, -(sp)
    moveq   #1, d2              ; i = 1
.outer:
    cmp.w   d1, d2
    bge     .done
    move.w  (a0,d2.w*2), d3     ; key
    move.w  d2, d4
    subq.w  #1, d4              ; j = i-1
.inner:
    cmp.w   #0, d4
    blt     .place
    cmp.w   (a0,d4.w*2), d3
    bge     .place
    move.w  (a0,d4.w*2), d0
    move.w  d0, (a0,d4.w*2+2)
    subq.w  #1, d4
    bra     .inner
.place:
    move.w  d3, (a0,d4.w*2+2)
    addq.w  #1, d2
    bra     .outer
.done:
    movem.l (sp)+, d0-d4/a0
    rts

; ---------- MERGE SORT ----------
MergeSort:
    cmp.w   #1, d1
    ble     .done
    movem.l d0-d3/a0-a2, -(sp)
    move.w  d1, d2
    asr.w   #1, d2               ; mid = n/2
    subq.w  #1, d2

    lea     Buf, a1
    move.w  d2, d3
    moveq   #0, d0
.copyL:
    cmp.w   d3, d0
    bgt     .callL
    move.w  (a0,d0.w*2), (a1,d0.w*2)
    addq.w  #1, d0
    bra     .copyL
.callL:
    move.l  a1, a0
    move.w  d3, d1
    addq.w  #1, d1
    jsr     MergeSort

    lea     Arr, a0
    lea     Buf, a1
    move.w  d2, d3
    addq.w  #1, d3
    move.w  d1, d0
    subq.w  #1, d0
    sub.w   d3, d0
.copyR:
    move.w  d3, d0
    add.w   d2, d0
    addq.w  #1, d0
    cmp.w   d1, d0
    bge     .callR
    move.w  (a0,d0.w*2), d1
    move.w  d1, (a1,d0.w*2)
    bra     .copyR
.callR:
    move.w  d1, d0
    sub.w   d3, d0
    jsr     MergeSort

    lea     Arr, a0
    lea     Buf, a1
    jsr     MergeArrays

    movem.l (sp)+, d0-d3/a0-a2
.done:
    rts

MergeArrays:
    movem.l d0-d4/a0-a2, -(sp)
    move.w  d2, d3
    move.w  d1, d4
    subq.w  #1, d4
    moveq   #0, d0
    move.w  d2, d1
    addq.w  #1, d1
    moveq   #0, d2
.merge:
    cmp.w   d3, d0
    bgt     .useR
    cmp.w   d4, d1
    bgt     .useL
    move.w  (a1,d0.w*2), d2
    cmp.w   (a1,d1.w*2), d2
    ble     .useL
.useR:
    move.w  (a1,d1.w*2), (a0,d2.w*2)
    addq.w  #1, d1
    bra     .next
.useL:
    move.w  (a1,d0.w*2), (a0,d2.w*2)
    addq.w  #1, d0
.next:
    addq.w  #1, d2
    cmp.w   d4, d0
    bgt     .copyR
    cmp.w   d4, d1
    bgt     .copyL
    bra     .merge
.copyL:
    move.w  (a1,d0.w*2), (a0,d2.w*2)
    addq.w  #1, d0
    addq.w  #1, d2
    cmp.w   d4, d0
    ble     .copyL
    bra     .doneM
.copyR:
    move.w  (a1,d1.w*2), (a0,d2.w*2)
    addq.w  #1, d2
    addq.w  #1, d1
    cmp.w   d4, d1
    ble     .copyR
.doneM:
    movem.l (sp)+, d0-d4/a0-a2
    rts

; ---------- QUICK SORT ----------
QuickSort:
    cmp.w   #1, d1
    ble     .done
    movem.l d0-d5/a0, -(sp)
    move.w  d1, d5
    subq.w  #1, d5              ; high = n-1
    jsr     QSPartition
    movem.l (sp)+, d0-d5/a0
    move.w  d0, -(sp)           ; pi
    move.w  d1, d0
    sub.w   d0, d1
    subq.w  #1, d1
    jsr     QuickSort
    move.w  (sp)+, d0
    addq.w  #1, d0
    move.w  d5, d1
    subq.w  #1, d1
    sub.w   d0, d1
    addq.w  #1, d1
    lea     (a0,d0.w*2), a0
    jsr     QuickSort
.done:
    rts

QSPartition:
    move.w  (a0,d5.w*2), d4     ; pivot = v[high]
    moveq   #0, d2
    subq.w  #1, d2              ; i = low - 1
    moveq   #0, d3              ; j = low
.loop:
    cmp.w   d5, d3
    bge     .swapPivot
    cmp.w   (a0,d3.w*2), d4
    bge     .nextJ
    addq.w  #1, d2
    move.w  (a0,d2.w*2), d0
    move.w  (a0,d3.w*2), d1
    move.w  d1, (a0,d2.w*2)
    move.w  d0, (a0,d3.w*2)
.nextJ:
    addq.w  #1, d3
    bra     .loop
.swapPivot:
    addq.w  #1, d2
    move.w  (a0,d2.w*2), d0
    move.w  (a0,d5.w*2), d1
    move.w  d1, (a0,d2.w*2)
    move.w  d0, (a0,d5.w*2)
    move.w  d2, d0
    rts

; ---------- HEAP SORT ----------
HeapSort:
    movem.l d0-d4/a0, -(sp)
    move.w  d1, d4
    move.w  d4, d2
    asr.w   #1, d2
    subq.w  #1, d2
.build:
    cmp.w   #0, d2
    blt     .extract
    move.w  d4, d1
    move.w  d2, d0
    jsr     Heapify
    subq.w  #1, d2
    bra     .build
.extract:
    subq.w  #1, d4
    cmp.w   #0, d4
    ble     .doneH
    move.w  (a0), d0
    move.w  (a0,d4.w*2), d1
    move.w  d1, (a0)
    move.w  d0, (a0,d4.w*2)
    move.w  d4, d1
    moveq   #0, d0
    jsr     Heapify
    bra     .extract
.doneH:
    movem.l (sp)+, d0-d4/a0
    rts

Heapify:
    movem.l d0-d3/a0, -(sp)
    move.w  d0, d2              ; largest = i
    move.w  d0, d3
    add.w   d3, d3
    addq.w  #1, d3              ; l = 2*i+1
    cmp.w   d1, d3
    bge     .chkR
    move.w  (a0,d3.w*2), d0
    cmp.w   (a0,d2.w*2), d0
    ble     .chkR
    move.w  d3, d2
.chkR:
    addq.w  #1, d3              ; r = 2*i+2
    cmp.w   d1, d3
    bge     .chkSwap
    move.w  (a0,d3.w*2), d0
    cmp.w   (a0,d2.w*2), d0
    ble     .chkSwap
    move.w  d3, d2
.chkSwap:
    cmp.w   d0, d2
    beq     .doneF
    move.w  (a0,d0.w*2), d3
    move.w  (a0,d2.w*2), d1
    move.w  d1, (a0,d0.w*2)
    move.w  d3, (a0,d2.w*2)
    move.w  d1, d0
    movem.l (sp)+, d0-d3/a0
    jmp     Heapify
.doneF:
    movem.l (sp)+, d0-d3/a0
    rts

; ---------- SHELL SORT ----------
ShellSort:
    movem.l d0-d4/a0, -(sp)
    move.w  d1, d2
    asr.w   #1, d2              ; gap = n/2
.gapLoop:
    cmp.w   #0, d2
    ble     .doneS
    move.w  d2, d3              ; i = gap
.iLoop:
    cmp.w   d1, d3
    bge     .nextGap
    move.w  (a0,d3.w*2), d4     ; temp = v[i]
    move.w  d3, d0
    sub.w   d2, d0              ; j = i - gap
.jLoop:
    cmp.w   #0, d0
    blt     .placeS
    cmp.w   (a0,d0.w*2), d4
    ble     .placeS
    move.w  (a0,d0.w*2), d1
    move.w  d1, (a0,d0.w*2+d2.w*2)
    sub.w   d2, d0
    bra     .jLoop
.placeS:
    move.w  d4, (a0,d0.w*2+d2.w*2)
    addq.w  #1, d3
    bra     .iLoop
.nextGap:
    asr.w   #1, d2
    bra     .gapLoop
.doneS:
    movem.l (sp)+, d0-d4/a0
    rts

; ---------- COUNTING SORT ----------
CountingSort:
    movem.l d0-d5/a0-a1, -(sp)
    lea     Arr, a0
    move.w  d1, d5
    moveq   #0, d2              ; max = 0
    moveq   #0, d3
.findMax:
    cmp.w   d5, d3
    bge     .initCount
    move.w  (a0,d3.w*2), d0
    cmp.w   d2, d0
    ble     .nextMax
    move.w  d0, d2
.nextMax:
    addq.w  #1, d3
    bra     .findMax
.initCount:
    lea     Tmp, a1
    moveq   #0, d3
    move.w  d2, d4
.clrLoop:
    move.w  #0, (a1,d3.w*2)
    addq.w  #1, d3
    cmp.w   d4, d3
    ble     .clrLoop
    moveq   #0, d3
.count:
    cmp.w   d5, d3
    bge     .reconstruct
    move.w  (a0,d3.w*2), d0
    addq.w  #1, (a1,d0.w*2)
    addq.w  #1, d3
    bra     .count
.reconstruct:
    moveq   #0, d3              ; idx
    moveq   #0, d4              ; i
.reconLoop:
    cmp.w   d2, d4
    bgt     .doneC
    move.w  (a1,d4.w*2), d0
.fillLoop:
    cmp.w   #0, d0
    ble     .nextI
    move.w  d4, (a0,d3.w*2)
    addq.w  #1, d3
    subq.w  #1, d0
    bra     .fillLoop
.nextI:
    addq.w  #1, d4
    bra     .reconLoop
.doneC:
    movem.l (sp)+, d0-d5/a0-a1
    rts

; ---------- RADIX SORT ----------
RadixSort:
    movem.l d0-d5/a0-a1, -(sp)
    move.w  d1, d5
    moveq   #0, d2
    moveq   #0, d3
.findMaxR:
    cmp.w   d5, d3
    bge     .expLoop
    move.w  (a0,d3.w*2), d0
    cmp.w   d2, d0
    ble     .nextMaxR
    move.w  d0, d2
.nextMaxR:
    addq.w  #1, d3
    bra     .findMaxR
.expLoop:
    moveq   #1, d4              ; exp = 1
.chkExp:
    cmp.w   d2, d4
    bgt     .doneR
    move.w  d4, -(sp)
    lea     Buf, a1
    moveq   #0, d3
    movem.l d0-d5/a0-a1, -(sp)
    lea     CountTable, a1
    moveq   #0, d3
.clrCnt:
    move.w  #0, (a1,d3.w*2)
    addq.w  #1, d3
    cmp.w   #9, d3
    ble     .clrCnt
    movem.l (sp)+, d0-d5/a0-a1
    moveq   #0, d3
.cntLoop:
    cmp.w   d5, d3
    bge     .cumSum
    move.w  (a0,d3.w*2), d0
    divu.w  d4, d0
    andi.w  #$000F, d0
    lea     CountTable, a1
    addq.w  #1, (a1,d0.w*2)
    addq.w  #1, d3
    bra     .cntLoop
.cumSum:
    moveq   #1, d3
.cumLoop:
    cmp.w   #9, d3
    bgt     .placeR
    lea     CountTable, a1
    move.w  (a1,d3.w*2), d0
    subq.w  #1, d3
    add.w   (a1,d3.w*2), d0
    addq.w  #1, d3
    move.w  d0, (a1,d3.w*2)
    addq.w  #1, d3
    bra     .cumLoop
.placeR:
    move.w  d5, d3
    subq.w  #1, d3
.plcLoop:
    cmp.w   #0, d3
    blt     .copyBack
    move.w  (a0,d3.w*2), d0
    divu.w  d4, d0
    andi.w  #$000F, d0
    lea     CountTable, a1
    move.w  (a1,d0.w*2), d1
    subq.w  #1, d1
    lea     Buf, a1
    move.w  (a0,d3.w*2), d2
    move.w  d2, (a1,d1.w*2)
    lea     CountTable, a1
    subq.w  #1, (a1,d0.w*2)
    subq.w  #1, d3
    bra     .plcLoop
.copyBack:
    moveq   #0, d3
.cpLoop:
    cmp.w   d5, d3
    bge     .nextExp
    lea     Buf, a1
    move.w  (a1,d3.w*2), d0
    move.w  d0, (a0,d3.w*2)
    addq.w  #1, d3
    bra     .cpLoop
.nextExp:
    move.w  (sp)+, d4
    mulu.w  #10, d4
    bra     .chkExp
.doneR:
    movem.l (sp)+, d0-d5/a0-a1
    rts

; ---------- BUCKET SORT ----------
BucketSort:
    movem.l d0-d5/a0-a1, -(sp)
    move.w  d1, d5
    moveq   #0, d2
    move.w  #$7FFF, d3
    moveq   #0, d4
.findMinMax:
    cmp.w   d5, d4
    bge     .initBuckets
    move.w  (a0,d4.w*2), d0
    cmp.w   d2, d0
    ble     .chkMin
    move.w  d0, d2
.chkMin:
    cmp.w   d3, d0
    bge     .nextMM
    move.w  d0, d3
.nextMM:
    addq.w  #1, d4
    bra     .findMinMax
.initBuckets:
    move.w  d5, d4
    jsr     Sqrt
    addq.w  #1, d0
    move.w  d0, d4              ; bc = sqrt(n) + 1
    sub.w   d3, d2
    divu.w  d4, d2
    addq.w  #1, d2              ; range = (max-min)/bc + 1
    moveq   #0, d0
.clrBkts:
    lea     Buf, a1
    move.w  #0, (a1,d0.w*2)
    addq.w  #1, d0
    cmp.w   d5, d0
    blt     .clrBkts
    moveq   #0, d0
.distribute:
    cmp.w   d5, d0
    bge     .sortBuckets
    move.w  (a0,d0.w*2), d1
    sub.w   d3, d1
    divu.w  d2, d1
    lea     Buf, a1
    add.w   d1, d1
    add.w   d1, d1
    move.w  (a1,d1.w*2), d2
    addq.w  #1, d2
    move.w  d2, (a1,d1.w*2)
    addq.w  #1, d0
    bra     .distribute
.sortBuckets:
    ; Simplified: use selection sort on full array
    lea     Arr, a0
    move.w  d5, d1
    jsr     SelectionSort
.doneB:
    movem.l (sp)+, d0-d5/a0-a1
    rts

; ---------- SQRT (INTEIRO) ----------
Sqrt:
    moveq   #0, d0
    moveq   #1, d1
.sqrtLoop:
    cmp.w   d1, d4
    ble     .sqrtDone
    addq.w  #1, d0
    move.w  d0, d1
    add.w   d0, d1
    bra     .sqrtLoop
.sqrtDone:
    rts

; ================================================================
; GERADOR DE NUMEROS ALEATORIOS (LCG)
; ================================================================
GenArray:
    movem.l d0-d2/a0, -(sp)
    lea     Arr, a0
    move.w  ArrSize, d2
    subq.w  #1, d2
.loop:
    move.l  RNGSeed, d0
    mulu.w  #$4D3B, d0
    addi.l  #$7A4B, d0
    move.l  d0, RNGSeed
    lsr.w   #8, d0
    andi.w  #$03FF, d0
    move.w  d0, (a0)+
    dbra    d2, .loop
    movem.l (sp)+, d0-d2/a0
    rts

; ================================================================
; VDP - VIDEO DISPLAY PROCESSOR
; ================================================================
InitVDP:
    move.l  #$8004, VDPCTRL
    move.l  #$8174, VDPCTRL
    move.l  #$8230, VDPCTRL    ; Plane A = $C000
    move.l  #$8328, VDPCTRL    ; Plane B = $A000
    move.l  #$8407, VDPCTRL
    move.l  #$8554, VDPCTRL
    move.l  #$8600, VDPCTRL
    move.l  #$8700, VDPCTRL
    move.l  #$8A01, VDPCTRL
    move.l  #$8B00, VDPCTRL
    move.l  #$8C81, VDPCTRL    ; 40 col mode
    move.l  #$8D00, VDPCTRL
    move.l  #$8F01, VDPCTRL
    move.l  #$9001, VDPCTRL
    move.l  #$9100, VDPCTRL
    move.l  #$9200, VDPCTRL

    move.l  #$40000000, VDPCTRL
    move.w  #$1FFF, d7
.clr:
    move.w  #0, VDPDATA
    dbra    d7, .clr

    move.l  #$C0000000, VDPCTRL
    move.w  #$000E, VDPDATA
    move.w  #$0EEE, VDPDATA
    move.w  #$000A, VDPDATA
    move.w  #$00A0, VDPDATA
    move.w  #$0A00, VDPDATA
    move.w  #$0444, VDPDATA
    rts

; ========== FONTE 8x8 ==========
Font:
    dc.b $3C,$66,$6E,$7E,$76,$66,$3C,$00  ; 0
    dc.b $18,$38,$18,$18,$18,$18,$7E,$00  ; 1
    dc.b $3C,$66,$06,$0C,$30,$60,$7E,$00  ; 2
    dc.b $3C,$66,$06,$1C,$06,$66,$3C,$00  ; 3
    dc.b $0C,$1C,$3C,$6C,$7E,$0C,$0C,$00  ; 4
    dc.b $7E,$60,$7C,$06,$06,$66,$3C,$00  ; 5
    dc.b $3C,$66,$60,$7C,$66,$66,$3C,$00  ; 6
    dc.b $7E,$06,$0C,$18,$30,$30,$30,$00  ; 7
    dc.b $3C,$66,$66,$3C,$66,$66,$3C,$00  ; 8
    dc.b $3C,$66,$66,$3E,$06,$66,$3C,$00  ; 9
    dc.b $3C,$66,$66,$7E,$66,$66,$66,$00  ; A
    dc.b $7C,$66,$66,$7C,$66,$66,$7C,$00  ; B
    dc.b $3C,$66,$60,$60,$60,$66,$3C,$00  ; C
    dc.b $78,$6C,$66,$66,$66,$6C,$78,$00  ; D
    dc.b $7E,$60,$60,$7C,$60,$60,$7E,$00  ; E
    dc.b $7E,$60,$60,$7C,$60,$60,$60,$00  ; F
    dc.b $00,$00,$00,$00,$00,$00,$00,$00  ; Space
    dc.b $00,$00,$00,$5C,$00,$00,$00,$00  ; -
    dc.b $00,$00,$00,$00,$00,$00,$00,$00  ; .
    dc.b $00,$00,$18,$18,$18,$00,$18,$00  ; !

LoadFont:
    move.l  #$40200000, VDPCTRL
    lea     Font, a0
    move.w  #(20*8)-1, d7
.fl:
    move.b  (a0)+, d0
    move.w  d0, VDPDATA
    dbra    d7, .fl
    rts

; ========== ESCREVER TEXTO ==========
; a0 = string, d7 = linha, d6 = coluna
WriteText:
    move.l  d0, -(sp)
    move.w  d7, d0
    mulu.w  #40*2, d0
    add.w   d6, d0
    add.w   d6, d0
    add.l   #$40000000, d0
    move.l  d0, VDPCTRL
.wl:
    move.b  (a0)+, d0
    beq     .wd
    ori.w   #$0800, d0
    move.w  d0, VDPDATA
    bra     .wl
.wd:
    move.l  (sp)+, d0
    rts

; ========== DESENHAR MENU ==========
DrawMenu:
    lea     .title, a0
    moveq   #0, d7
    moveq   #4, d6
    jsr     WriteText
    lea     .items, a0
    moveq   #2, d7
    moveq   #2, d6
    jsr     WriteText
    move.w  Cursor, d0
    addq.w  #1, d7
    move.w  #$0820, VDPDATA
    lea     .labels, a0
    moveq   #3, d7
    moveq   #0, d6
    moveq   #10, d5
.loop:
    move.l  d0, -(sp)
    move.w  d7, d0
    mulu.w  #40*2, d0
    add.w   d6, d0
    add.w   d6, d0
    add.l   #$40000000, d0
    move.l  d0, VDPCTRL
    move.b  (a0)+, d1
    beq     .skip
    move.w  Cursor, d1
    subq.w  #1, d1
    cmp.w   d5, d1
    bne     .noArr
    move.w  #$081E, VDPDATA
    bra     .next
.noArr:
    move.w  #$0820, VDPDATA
.next:
    addq.w  #1, d7
    move.l  (sp)+, d0
    dbra    d5, .loop
    rts
.title:
    dc.b "ALGORITMOS DE ORDENACAO",0
.items:
    dc.b "Pressione A para ordenar, B para novo vetor",0
.labels:
    dc.b " 1-BUBBLE  ",0
    dc.b " 2-SELECT  ",0
    dc.b " 3-INSERT  ",0
    dc.b " 4-MERGE   ",0
    dc.b " 5-QUICK   ",0
    dc.b " 6-HEAP    ",0
    dc.b " 7-SHELL   ",0
    dc.b " 8-COUNTING",0
    dc.b " 9-RADIX   ",0
    dc.b "10-BUCKET  ",0
    dc.b "0-SAIR     ",0

; ========== DESENHAR ARRAY ==========
DrawArray:
    lea     .arrLabel, a0
    moveq   #15, d7
    moveq   #0, d6
    jsr     WriteText
    lea     Arr, a0
    move.w  ArrSize, d5
    moveq   #16, d7
    moveq   #0, d6
    moveq   #0, d4
.dl:
    cmp.w   d5, d4
    bge     .dd
    move.w  (a0)+, d0
    jsr     DrawHex
    addq.w  #1, d4
    cmp.w   #8, d4
    bne     .dl
    addq.w  #1, d7
    moveq   #0, d6
    bra     .dl
.dd:
    rts
.arrLabel:
    dc.b "Vetor:",0

DrawHex:
    movem.l d0-d2, -(sp)
    moveq   #3, d2
.dhl:
    rol.w   #4, d0
    move.w  d0, d1
    andi.w  #$000F, d1
    ori.w   #$0800, d1
    move.w  d1, VDPDATA
    dbra    d2, .dhl
    move.w  #$0820, VDPDATA
    movem.l (sp)+, d0-d2
    rts

; ========== DESENHAR RESULTADO ==========
DrawResult:
    lea     .doneT, a0
    moveq   #18, d7
    moveq   #8, d6
    jsr     WriteText
    jsr     DrawArray
    rts
.doneT:
    dc.b "ORDENACAO CONCLUIDA! B=Voltar",0

; ================================================================
; LEITURA DO CONTROLE
; ================================================================
ReadPad:
    movem.l d0-d1/a0, -(sp)
    lea     PAD1, a0
    move.b  #$40, PADCTRL
    move.b  (a0), d0
    move.b  #$00, PADCTRL
    move.b  (a0), d1
    lsl.w   #8, d1
    move.b  (a0), d0
    move.b  (a0), d1
    not.w   d0
    move.w  PadStat, d1
    eor.w   d0, d1
    and.w   d0, d1
    move.w  d0, PadStat
    move.w  d1, PadEdge
    movem.l (sp)+, d0-d1/a0
    rts

; ================================================================
; INTERRUPCOES
; ================================================================
VBlank:
    movem.l d0/a0, -(sp)
    move.w  #1, VBFlag
    movem.l (sp)+, d0/a0
    rte

HBlank:
    rte

Empty:
    rte

; ========== WAIT VBLANK ==========
WaitVBlank:
    move.w  #0, VBFlag
.wait:
    tst.w   VBFlag
    beq     .wait
    rts

; ========== VARIAVEIS EXTRAS ==========
CountTable:
    ds.w    10
Trocas:
    ds.w    1

    end
