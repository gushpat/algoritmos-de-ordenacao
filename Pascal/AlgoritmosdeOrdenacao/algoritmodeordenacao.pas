{
   AUTOR: GUSTAVO PATRICIO 2021
}

program algoritmo_de_ordenacao;


uses crt;

type vArray = array[1..100] of integer;


//procedure BubbleSort( var vetBubble: vArray);

var
  opcao: Byte;
  vet: vArray;
  CONT: Integer;
  size: Integer;
  tam: Integer;

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

procedure SelectionSort( var vetSelection: vArray);
var
  i, j, min, aux: Integer;
begin
  for i := 1 to tam - 1 do
  begin
    min := i;
    for j := i + 1 to tam do
    begin
      if vetSelection[j] < vetSelection[min] then
        min := j;
    end;
    aux := vetSelection[i];
    vetSelection[i] := vetSelection[min];
    vetSelection[min] := aux;
  end;
end;


procedure BubbleSort( var vetBubble: vArray);
var
  i, j, aux: Integer;
begin
  for i := 1 to tam - 1 do
  begin
    for j := 1 to tam - i do
    begin
      if vetBubble[j] > vetBubble[j + 1] then
      begin
        aux := vetBubble[j];
        vetBubble[j] := vetBubble[j + 1];
        vetBubble[j + 1] := aux;
      end;
    end;
  end;
end;

procedure InsertionSort( var vetInsertion: vArray);
var
  i, j, aux: Integer;
begin
  for i := 2 to tam do
  begin
    aux := vetInsertion[i];
    j := i - 1;
    while (j > 0) and (vetInsertion[j] > aux) do
    begin
      vetInsertion[j + 1] := vetInsertion[j];
      j := j - 1;
    end;
    vetInsertion[j + 1] := aux;
  end;
end;

procedure MergeSort( var vetMerge: vArray);
var
  i, j, k, m, n, q, r: Integer;
  vetAux: vArray;
begin
  m := 0;
  n := 0;
  q := 0;
  r := 0;
  for i := 1 to tam do
  begin
    if (vetMerge[i] < vetMerge[i + 1]) then
    begin
      m := m + 1;
      vetAux[m] := vetMerge[i];
    end
    else
    begin
      n := n + 1;
      vetAux[n] := vetMerge[i];
    end;
  end;
  for i := 1 to m do
  begin
    vetMerge[i] := vetAux[i];
  end;
  for i := m + 1 to m + n do
  begin
    vetMerge[i] := vetAux[i];
  end;
  for i := 1 to m do
  begin
    for j := 1 to n do
    begin
      if (vetMerge[i] < vetMerge[i + j]) then
      begin
        q := q + 1;
        vetAux[q] := vetMerge[i];
      end
      else
      begin
        r := r + 1;
        vetAux[r] := vetMerge[i + j];
      end;
    end;
  end;
  for i := 1 to q do
  begin
    vetMerge[i] := vetAux[i];
  end;
  for i := q + 1 to q + r do
  begin
    vetMerge[i] := vetAux[i];
  end;
end;

procedure QuickSort( var vetQuick: vArray);
var
  i, j, k, m, n, q, r: Integer;
  vetAux: vArray;
begin
  m := 0;
  n := 0;
  q := 0;
  r := 0;
  for i := 1 to tam do
  begin
    if (vetQuick[i] < vetQuick[i + 1]) then
    begin
      m := m + 1;
      vetAux[m] := vetQuick[i];
    end
    else
    begin
      n := n + 1;
      vetAux[n] := vetQuick[i];
    end;
  end;
  for i := 1 to m do
  begin
    vetQuick[i] := vetAux[i];
  end;
  for i := m + 1 to m + n do
  begin
    vetQuick[i] := vetAux[i];
  end;
  for i := 1 to m do
  begin
    for j := 1 to n do
    begin
      if (vetQuick[i] < vetQuick[i + j]) then
      begin
        q := q + 1;
        vetAux[q] := vetQuick[i];
      end
      else
      begin
        r := r + 1;
        vetAux[r] := vetQuick[i + j];
      end;
    end;
  end;
  for i := 1 to q do
  begin
    vetQuick[i] := vetAux[i];
  end;
  for i := q + 1 to q + r do
  begin
    vetQuick[i] := vetAux[i];
  end;
end;

procedure ShellSort( var vetShell: vArray);
var
  i, j, k, m, n, q, r: Integer;
  vetAux: vArray;
begin
  m := 0;
  n := 0;
  q := 0;
  r := 0;
  for i := 1 to tam do
  begin
    if (vetShell[i] < vetShell[i + 1]) then
    begin
      m := m + 1;
      vetAux[m] := vetShell[i];
    end
    else
    begin
      n := n + 1;
      vetAux[n] := vetShell[i];
    end;
  end;
  for i := 1 to m do
  begin
    vetShell[i] := vetAux[i];
  end;
  for i := m + 1 to m + n do
  begin
    vetShell[i] := vetAux[i];
  end;
end;

procedure HeapSort( var vetHeap: vArray);
var
  i, j, k, m, n, q, r: Integer;
  vetAux: vArray;
begin
  m := 0;
  n := 0;
  q := 0;
  r := 0;
  for i := 1 to tam do
  begin
    if (vetHeap[i] < vetHeap[i + 1]) then
    begin
      m := m + 1;
      vetAux[m] := vetHeap[i];
    end
    else
    begin
      n := n + 1;
      vetAux[n] := vetHeap[i];
    end;
  end;
  for i := 1 to m do
  begin
    vetHeap[i] := vetAux[i];
  end;
  for i := m + 1 to m + n do
  begin
    vetHeap[i] := vetAux[i];
  end;
end;

procedure CountingSort( var vetCounting: vArray);
var
  i, j, k, m, n, q, r: Integer;
  vetAux: vArray;
begin
  m := 0;
  n := 0;
  q := 0;
  r := 0;
  for i := 1 to tam do
  begin
    if (vetCounting[i] < vetCounting[i + 1]) then
    begin
      m := m + 1;
      vetAux[m] := vetCounting[i];
    end
    else
    begin
      n := n + 1;
      vetAux[n] := vetCounting[i];
    end;
  end;
  for i := 1 to m do
  begin
    vetCounting[i] := vetAux[i];
  end;
  for i := m + 1 to m + n do
  begin
    vetCounting[i] := vetAux[i];
  end;
end;

procedure RadixSort( var vetRadix: vArray);
var
  i, j, k, m, n, q, r: Integer;
  vetAux: vArray;
begin
  m := 0;
  n := 0;
  q := 0;
  r := 0;
  for i := 1 to tam do
  begin
    if (vetRadix[i] < vetRadix[i + 1]) then
    begin
      m := m + 1;
      vetAux[m] := vetRadix[i];
    end
    else
    begin
      n := n + 1;
      vetAux[n] := vetRadix[i];
    end;
  end;
  for i := 1 to m do
  begin
    vetRadix[i] := vetAux[i];
  end;
  for i := m + 1 to m + n do
  begin
    vetRadix[i] := vetAux[i];
  end;
end;

procedure RandomNumber ();
var
  i: Integer;
begin
  for i := 1 to tam do
  begin
    vet[i] := Random(100);
  end;
end;



BEGIN

tam := 100;

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
WriteLn('5 - Merge Sort');
WriteLn('6 - Shell Sort');
WriteLn('7 - Heap Sort');
WriteLn('8 - Counting Sort');
WriteLn('9 - Radix Sort');
WriteLn('10 - Exit');


WriteLn('');
WriteLn('Digite a opcao: ');


ReadLn(opcao);

RandomNumber ();
 //-----------------------------

FOR CONT:=1 to tam do
begin
  WriteLn(vet[CONT]);
end;

  END.



if opcao = 1 then
begin
  BubbleSort(vetBubble);
  FOR CONT:=1 to tam do
  begin
    WriteLn(vetBubble[CONT]);
  end;
end;

else if opcao = 2 then
begin
  SelectionSort(vetSelection);
  FOR CONT:=1 to tam do
  begin
    WriteLn(vetSelection[CONT]);
  end;
end;

else if opcao = 3 then
begin
  InsertionSort(vetInsertion);
  FOR CONT:=1 to tam do
  begin
    WriteLn(vetInsertion[CONT]);
  end;
end;

else if opcao = 4 then
begin
  QuickSort(vetQuick);
  FOR CONT:=1 to tam do
  begin
    WriteLn(vetQuick[CONT]);
  end;
end;

else if opcao = 5 then
begin
  MergeSort(vetMerge);
  FOR CONT:=1 to tam do
  begin
    WriteLn(vetMerge[CONT]);
  end;
end;

else if opcao = 6 then
begin
  ShellSort(vetShell);
  FOR CONT:=1 to tam do
  begin
    WriteLn(vetShell[CONT]);
  end;
end;

else if opcao = 7 then
begin
  HeapSort(vetHeap);
  FOR CONT:=1 to tam do
  begin
    WriteLn(vetHeap[CONT]);
  end;
end;

else if opcao = 8 then
begin
  CountingSort(vetCounting);
  FOR CONT:=1 to tam do
  begin
    WriteLn(vetCounting[CONT]);
  end;
end;

else if opcao = 9 then
begin
  RadixSort(vetRadix);
  FOR CONT:=1 to tam do
  begin
    WriteLn(vetRadix[CONT]);
  end;
end;








ReadLn();


END.
