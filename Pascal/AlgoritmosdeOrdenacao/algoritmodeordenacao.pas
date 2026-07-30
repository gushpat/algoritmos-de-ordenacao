{
   AUTOR: GUSTAVO PATRICIO 2021
}

program algoritmo_de_ordenacao;

uses crt;

const MAX = 100;

type vArray = array[1..MAX] of integer;

var
  opcao: Byte;
  vet: vArray;
  tam, i: Integer;

procedure swap(var a, b: Integer);
var temp: Integer;
begin
  temp := a;
  a := b;
  b := temp;
end;

procedure BubbleSort(var v: vArray; n: Integer);
var i, j: Integer;
begin
  for i := 1 to n - 1 do
    for j := 1 to n - i do
      if v[j] > v[j + 1] then
        swap(v[j], v[j + 1]);
end;

procedure SelectionSort(var v: vArray; n: Integer);
var i, j, min: Integer;
begin
  for i := 1 to n - 1 do
  begin
    min := i;
    for j := i + 1 to n do
      if v[j] < v[min] then
        min := j;
    swap(v[i], v[min]);
  end;
end;

procedure InsertionSort(var v: vArray; n: Integer);
var i, j, key: Integer;
begin
  for i := 2 to n do
  begin
    key := v[i];
    j := i - 1;
    while (j > 0) and (v[j] > key) do
    begin
      v[j + 1] := v[j];
      j := j - 1;
    end;
    v[j + 1] := key;
  end;
end;

procedure Merge(var v: vArray; left, mid, right: Integer);
var i, j, k: Integer;
    temp: vArray;
begin
  i := left;
  j := mid + 1;
  k := left;
  while (i <= mid) and (j <= right) do
  begin
    if v[i] <= v[j] then
    begin
      temp[k] := v[i];
      i := i + 1;
    end
    else
    begin
      temp[k] := v[j];
      j := j + 1;
    end;
    k := k + 1;
  end;
  while i <= mid do
  begin
    temp[k] := v[i];
    i := i + 1;
    k := k + 1;
  end;
  while j <= right do
  begin
    temp[k] := v[j];
    j := j + 1;
    k := k + 1;
  end;
  for i := left to right do
    v[i] := temp[i];
end;

procedure MergeSort(var v: vArray; left, right: Integer);
var mid: Integer;
begin
  if left < right then
  begin
    mid := (left + right) div 2;
    MergeSort(v, left, mid);
    MergeSort(v, mid + 1, right);
    Merge(v, left, mid, right);
  end;
end;

function Partition(var v: vArray; low, high: Integer): Integer;
var pivot, i, j: Integer;
begin
  pivot := v[high];
  i := low - 1;
  for j := low to high - 1 do
  begin
    if v[j] < pivot then
    begin
      i := i + 1;
      swap(v[i], v[j]);
    end;
  end;
  swap(v[i + 1], v[high]);
  Partition := i + 1;
end;

procedure QuickSort(var v: vArray; low, high: Integer);
var pi: Integer;
begin
  if low < high then
  begin
    pi := Partition(v, low, high);
    QuickSort(v, low, pi - 1);
    QuickSort(v, pi + 1, high);
  end;
end;

procedure Heapify(var v: vArray; n, i: Integer);
var largest, left, right: Integer;
begin
  largest := i;
  left := 2 * i + 1;
  right := 2 * i + 2;

  if (left < n) and (v[left + 1] > v[largest + 1]) then
    largest := left;
  if (right < n) and (v[right + 1] > v[largest + 1]) then
    largest := right;

  if largest <> i then
  begin
    swap(v[i + 1], v[largest + 1]);
    Heapify(v, n, largest);
  end;
end;

procedure HeapSort(var v: vArray; n: Integer);
var i: Integer;
begin
  for i := (n div 2) - 1 downto 0 do
    Heapify(v, n, i);

  for i := n - 1 downto 1 do
  begin
    swap(v[1], v[i + 1]);
    Heapify(v, i, 0);
  end;
end;

procedure ShellSort(var v: vArray; n: Integer);
var gap, i, j, temp: Integer;
begin
  gap := n div 2;
  while gap > 0 do
  begin
    for i := gap + 1 to n do
    begin
      temp := v[i];
      j := i;
      while (j >= gap + 1) and (v[j - gap] > temp) do
      begin
        v[j] := v[j - gap];
        j := j - gap;
      end;
      v[j] := temp;
    end;
    gap := gap div 2;
  end;
end;

procedure CountingSort(var v: vArray; n: Integer);
var
  i, j, max: Integer;
  count: array[0..999] of Integer;
begin
  max := 0;
  for i := 1 to n do
    if v[i] > max then max := v[i];

  for i := 0 to max do
    count[i] := 0;

  for i := 1 to n do
    count[v[i]] := count[v[i]] + 1;

  j := 1;
  for i := 0 to max do
  begin
    while count[i] > 0 do
    begin
      v[j] := i;
      j := j + 1;
      count[i] := count[i] - 1;
    end;
  end;
end;

procedure CountingSortByDigit(var v: vArray; n, exp: Integer);
var
  i: Integer;
  output: vArray;
  count: array[0..9] of Integer;
begin
  for i := 0 to 9 do
    count[i] := 0;

  for i := 1 to n do
    count[(v[i] div exp) mod 10] := count[(v[i] div exp) mod 10] + 1;

  for i := 1 to 9 do
    count[i] := count[i] + count[i - 1];

  for i := n downto 1 do
  begin
    output[count[(v[i] div exp) mod 10]] := v[i];
    count[(v[i] div exp) mod 10] := count[(v[i] div exp) mod 10] - 1;
  end;

  for i := 1 to n do
    v[i] := output[i];
end;

procedure RadixSort(var v: vArray; n: Integer);
var max, exp, i: Integer;
begin
  if n <= 0 then Exit;
  max := v[1];
  for i := 2 to n do
    if v[i] > max then max := v[i];

  exp := 1;
  while max div exp > 0 do
  begin
    CountingSortByDigit(v, n, exp);
    exp := exp * 10;
  end;
end;

procedure BucketSort(var v: vArray; n: Integer);
var
  i, j, idx, bucketIdx, maxVal, minVal, bucketCount, range, temp: Integer;
  buckets: array[0..9, 1..MAX] of integer;
  bucketSizes: array[0..9] of integer;
begin
  if n <= 0 then Exit;

  maxVal := v[1];
  minVal := v[1];
  for i := 2 to n do
  begin
    if v[i] > maxVal then maxVal := v[i];
    if v[i] < minVal then minVal := v[i];
  end;

  bucketCount := 10;
  range := (maxVal - minVal) div bucketCount + 1;

  for i := 0 to bucketCount - 1 do
    bucketSizes[i] := 0;

  for i := 1 to n do
  begin
    bucketIdx := (v[i] - minVal) div range;
    if bucketIdx >= bucketCount then
      bucketIdx := bucketCount - 1;
    bucketSizes[bucketIdx] := bucketSizes[bucketIdx] + 1;
    buckets[bucketIdx][bucketSizes[bucketIdx]] := v[i];
  end;

  idx := 1;
  for i := 0 to bucketCount - 1 do
  begin
    if bucketSizes[i] > 0 then
    begin
      for j := 2 to bucketSizes[i] do
      begin
        temp := buckets[i][j];
        bucketIdx := j - 1;
        while (bucketIdx >= 1) and (buckets[i][bucketIdx] > temp) do
        begin
          buckets[i][bucketIdx + 1] := buckets[i][bucketIdx];
          bucketIdx := bucketIdx - 1;
        end;
        buckets[i][bucketIdx + 1] := temp;
      end;
      for j := 1 to bucketSizes[i] do
      begin
        v[idx] := buckets[i][j];
        idx := idx + 1;
      end;
    end;
  end;
end;

BEGIN
  Randomize;

  clrscr;
  WriteLn('************************************************************');
  WriteLn('**************** ALGORITMOS DE ORDENACAO *******************');
  WriteLn('******************** PASCAL EDITION ************************');
  WriteLn('************************************************************');
  WriteLn('');

  Write('Digite o tamanho do vetor (maximo 100): ');
  ReadLn(tam);
  if tam > MAX then tam := MAX;
  if tam <= 0 then tam := 10;

  for i := 1 to tam do
    vet[i] := Random(1000);

  WriteLn('');
  WriteLn('Vetor original:');
  for i := 1 to tam do
    Write(vet[i], ' ');
  WriteLn('');
  WriteLn('');

  WriteLn('1  - Bubble Sort');
  WriteLn('2  - Selection Sort');
  WriteLn('3  - Insertion Sort');
  WriteLn('4  - Merge Sort');
  WriteLn('5  - Quick Sort');
  WriteLn('6  - Heap Sort');
  WriteLn('7  - Shell Sort');
  WriteLn('8  - Counting Sort');
  WriteLn('9  - Radix Sort');
  WriteLn('10 - Bucket Sort');
  WriteLn('0  - Sair');
  WriteLn('');
  Write('Digite a opcao: ');
  ReadLn(opcao);

  if opcao = 0 then
  begin
    WriteLn('Saindo...');
    Exit;
  end;

  case opcao of
    1: BubbleSort(vet, tam);
    2: SelectionSort(vet, tam);
    3: InsertionSort(vet, tam);
    4: MergeSort(vet, 1, tam);
    5: QuickSort(vet, 1, tam);
    6: HeapSort(vet, tam);
    7: ShellSort(vet, tam);
    8: CountingSort(vet, tam);
    9: RadixSort(vet, tam);
    10: BucketSort(vet, tam);
  else
    begin
      WriteLn('Opcao invalida');
      Exit;
    end;
  end;

  WriteLn('');
  WriteLn('Vetor ordenado:');
  for i := 1 to tam do
    Write(vet[i], ' ');
  WriteLn('');

  ReadLn;
END.
