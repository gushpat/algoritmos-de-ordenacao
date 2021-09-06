{
   AUTOR: GUSTAVO PATRICIO 2021
}

program algoritmo_de_ordenacao;


uses crt;

type vArray = array [1..11] of Integer;

//procedure BubbleSort( var vetBubble: vArray);

var
  opcao: Byte;
  vet: vArray;
  CONT: Integer;
  size: Integer;

  //variaveis do bubble sort;
  //indx: Integer;
 // found: boolean;
 // aux: Integer;


procedure swap( var a, b:Integer );
var
  temp : Integer;
begin
  temp := a;
  a := b;
  b := temp;
end;


procedure BubbleSort( var vetBubble: vArray );
var
  n, newn, i:integer;
begin
  n := high( vetBubble );
  repeat
    newn := 0;
    for i := 1 to n   do
      begin
        if vetBubble[ i - 1 ] > vetBubble[ i ] then
          begin
            swap( vetBubble[ i - 1 ], vetBubble[ i ]);
            newn := i ;
          end;
      end ;
    n := newn;
  until n = 0;
end;

BEGIN

clrscr;
WriteLn('************************************************************');
WriteLn('**************** ALGORITMOS DE ORDENACAO *******************');
WriteLn('******************** PASCAL EDITION ************************');
WriteLn('************************************************************');

WriteLn('');

WriteLn('1 - Bubble Sort');
WriteLn('2 - Selection Sort');
WriteLn('3 - Insertion Sort');
WriteLn('4 - Quick Sort');
WriteLn('5 - Sair');

WriteLn('');
WriteLn('Digite a opcao: ');


ReadLn(opcao);

FOR CONT:=1 to 10 do
begin
  WriteLn('Digite um Numero:');
  ReadLn(vet[CONT]);
end;

 //-----------------------------

FOR CONT:=1 to 10 do
begin
  WriteLn(vet[CONT]);
end;

BubbleSort(vet);

FOR CONT:=1 to 10 do
begin
  WriteLn(vet[CONT]);
end;

ReadLn();


END.
