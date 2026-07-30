<?php

function swap(&$v, $i, $j) {
    $t = $v[$i]; $v[$i] = $v[$j]; $v[$j] = $t;
}

function bubbleSort(&$v) {
    $n = count($v);
    for ($i = 0; $i < $n - 1; $i++)
        for ($j = 0; $j < $n - $i - 1; $j++)
            if ($v[$j] > $v[$j + 1])
                swap($v, $j, $j + 1);
}

function selectionSort(&$v) {
    $n = count($v);
    for ($i = 0; $i < $n - 1; $i++) {
        $min = $i;
        for ($j = $i + 1; $j < $n; $j++)
            if ($v[$j] < $v[$min]) $min = $j;
        swap($v, $i, $min);
    }
}

function insertionSort(&$v) {
    $n = count($v);
    for ($i = 1; $i < $n; $i++) {
        $key = $v[$i];
        $j = $i - 1;
        while ($j >= 0 && $v[$j] > $key) {
            $v[$j + 1] = $v[$j];
            $j--;
        }
        $v[$j + 1] = $key;
    }
}

function mergeSort(&$v, $left, $right) {
    if ($left < $right) {
        $mid = intdiv($left + $right, 2);
        mergeSort($v, $left, $mid);
        mergeSort($v, $mid + 1, $right);
        merge($v, $left, $mid, $right);
    }
}

function merge(&$v, $left, $mid, $right) {
    $L = array_slice($v, $left, $mid - $left + 1);
    $R = array_slice($v, $mid + 1, $right - $mid);
    $i = 0; $j = 0; $k = $left;
    while ($i < count($L) && $j < count($R)) {
        if ($L[$i] <= $R[$j]) $v[$k++] = $L[$i++];
        else $v[$k++] = $R[$j++];
    }
    while ($i < count($L)) $v[$k++] = $L[$i++];
    while ($j < count($R)) $v[$k++] = $R[$j++];
}

function quickSort(&$v, $low, $high) {
    if ($low < $high) {
        $pi = partition($v, $low, $high);
        quickSort($v, $low, $pi - 1);
        quickSort($v, $pi + 1, $high);
    }
}

function partition(&$v, $low, $high) {
    $pivot = $v[$high];
    $i = $low - 1;
    for ($j = $low; $j < $high; $j++) {
        if ($v[$j] < $pivot) {
            $i++;
            swap($v, $i, $j);
        }
    }
    swap($v, $i + 1, $high);
    return $i + 1;
}

function heapSort(&$v) {
    $n = count($v);
    for ($i = intdiv($n, 2) - 1; $i >= 0; $i--)
        heapify($v, $n, $i);
    for ($i = $n - 1; $i > 0; $i--) {
        swap($v, 0, $i);
        heapify($v, $i, 0);
    }
}

function heapify(&$v, $n, $i) {
    $largest = $i;
    $l = 2 * $i + 1;
    $r = 2 * $i + 2;
    if ($l < $n && $v[$l] > $v[$largest]) $largest = $l;
    if ($r < $n && $v[$r] > $v[$largest]) $largest = $r;
    if ($largest != $i) {
        swap($v, $i, $largest);
        heapify($v, $n, $largest);
    }
}

function shellSort(&$v) {
    $n = count($v);
    for ($gap = intdiv($n, 2); $gap > 0; $gap = intdiv($gap, 2))
        for ($i = $gap; $i < $n; $i++) {
            $temp = $v[$i];
            for ($j = $i; $j >= $gap && $v[$j - $gap] > $temp; $j -= $gap)
                $v[$j] = $v[$j - $gap];
            $v[$j] = $temp;
        }
}

function countingSort(&$v) {
    $max = max($v);
    $count = array_fill(0, $max + 1, 0);
    foreach ($v as $num) $count[$num]++;
    $idx = 0;
    for ($i = 0; $i <= $max; $i++)
        while ($count[$i]-- > 0)
            $v[$idx++] = $i;
}

function radixSort(&$v) {
    $max = max($v);
    for ($exp = 1; intdiv($max, $exp) > 0; $exp *= 10) {
        $output = array_fill(0, count($v), 0);
        $count = array_fill(0, 10, 0);
        foreach ($v as $num) $count[intdiv($num, $exp) % 10]++;
        for ($i = 1; $i < 10; $i++) $count[$i] += $count[$i - 1];
        for ($i = count($v) - 1; $i >= 0; $i--) {
            $d = intdiv($v[$i], $exp) % 10;
            $output[$count[$d] - 1] = $v[$i];
            $count[$d]--;
        }
        $v = $output;
    }
}

function bucketSort(&$v) {
    $n = count($v);
    if ($n <= 0) return;
    $max = max($v);
    $min = min($v);
    $bc = (int)sqrt($n) + 1;
    $range = intdiv($max - $min, $bc) + 1;
    $buckets = array_fill(0, $bc, []);
    foreach ($v as $num) {
        $idx = intdiv($num - $min, $range);
        if ($idx >= $bc) $idx = $bc - 1;
        $buckets[$idx][] = $num;
    }
    $pos = 0;
    for ($i = 0; $i < $bc; $i++) {
        if (empty($buckets[$i])) continue;
        sort($buckets[$i]);
        foreach ($buckets[$i] as $num)
            $v[$pos++] = $num;
    }
}

function intdiv($a, $b) {
    return ($a - $a % $b) / $b;
}

echo "--- ALGORITMOS DE ORDENACAO (PHP) ---\n";
$size = (int)readline("Digite o tamanho do vetor: ");
if ($size <= 0) $size = 10;

$vet = [];
for ($i = 0; $i < $size; $i++)
    $vet[] = rand(0, 999);

echo "\nVetor original:\n";
echo implode(" ", $vet) . "\n";

echo "\n1  - Bubble Sort\n";
echo "2  - Selection Sort\n";
echo "3  - Insertion Sort\n";
echo "4  - Merge Sort\n";
echo "5  - Quick Sort\n";
echo "6  - Heap Sort\n";
echo "7  - Shell Sort\n";
echo "8  - Counting Sort\n";
echo "9  - Radix Sort\n";
echo "10 - Bucket Sort\n";
echo "0  - Sair\n";
$opcao = (int)readline("Opcao: ");

if ($opcao === 0) {
    echo "Saindo...\n";
    exit;
}

$copy = $vet;

switch ($opcao) {
    case 1:  bubbleSort($copy); break;
    case 2:  selectionSort($copy); break;
    case 3:  insertionSort($copy); break;
    case 4:  mergeSort($copy, 0, $size - 1); break;
    case 5:  quickSort($copy, 0, $size - 1); break;
    case 6:  heapSort($copy); break;
    case 7:  shellSort($copy); break;
    case 8:  countingSort($copy); break;
    case 9:  radixSort($copy); break;
    case 10: bucketSort($copy); break;
    default:
        echo "Opcao invalida\n";
        exit(1);
}

echo "\nVetor ordenado:\n";
echo implode(" ", $copy) . "\n";
