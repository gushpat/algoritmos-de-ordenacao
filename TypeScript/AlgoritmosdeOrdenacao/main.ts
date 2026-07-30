import * as readline from 'readline';

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

function ask(question: string): Promise<string> {
  return new Promise(resolve => rl.question(question, resolve));
}

function swap(v: number[], i: number, j: number): void {
  [v[i], v[j]] = [v[j], v[i]];
}

function bubbleSort(v: number[]): void {
  const n = v.length;
  for (let i = 0; i < n - 1; i++)
    for (let j = 0; j < n - i - 1; j++)
      if (v[j] > v[j + 1]) swap(v, j, j + 1);
}

function selectionSort(v: number[]): void {
  const n = v.length;
  for (let i = 0; i < n - 1; i++) {
    let min = i;
    for (let j = i + 1; j < n; j++)
      if (v[j] < v[min]) min = j;
    swap(v, i, min);
  }
}

function insertionSort(v: number[]): void {
  const n = v.length;
  for (let i = 1; i < n; i++) {
    const key = v[i];
    let j = i - 1;
    while (j >= 0 && v[j] > key) {
      v[j + 1] = v[j];
      j--;
    }
    v[j + 1] = key;
  }
}

function mergeSort(v: number[], left: number, right: number): void {
  if (left < right) {
    const mid = Math.floor((left + right) / 2);
    mergeSort(v, left, mid);
    mergeSort(v, mid + 1, right);
    merge(v, left, mid, right);
  }
}

function merge(v: number[], left: number, mid: number, right: number): void {
  const L = v.slice(left, mid + 1);
  const R = v.slice(mid + 1, right + 1);
  let i = 0, j = 0, k = left;
  while (i < L.length && j < R.length) {
    if (L[i] <= R[j]) v[k++] = L[i++];
    else v[k++] = R[j++];
  }
  while (i < L.length) v[k++] = L[i++];
  while (j < R.length) v[k++] = R[j++];
}

function quickSort(v: number[], low: number, high: number): void {
  if (low < high) {
    const pi = partition(v, low, high);
    quickSort(v, low, pi - 1);
    quickSort(v, pi + 1, high);
  }
}

function partition(v: number[], low: number, high: number): number {
  const pivot = v[high];
  let i = low - 1;
  for (let j = low; j < high; j++) {
    if (v[j] < pivot) {
      i++;
      swap(v, i, j);
    }
  }
  swap(v, i + 1, high);
  return i + 1;
}

function heapSort(v: number[]): void {
  const n = v.length;
  for (let i = Math.floor(n / 2) - 1; i >= 0; i--)
    heapify(v, n, i);
  for (let i = n - 1; i > 0; i--) {
    swap(v, 0, i);
    heapify(v, i, 0);
  }
}

function heapify(v: number[], n: number, i: number): void {
  let largest = i;
  const l = 2 * i + 1, r = 2 * i + 2;
  if (l < n && v[l] > v[largest]) largest = l;
  if (r < n && v[r] > v[largest]) largest = r;
  if (largest !== i) {
    swap(v, i, largest);
    heapify(v, n, largest);
  }
}

function shellSort(v: number[]): void {
  const n = v.length;
  for (let gap = Math.floor(n / 2); gap > 0; gap = Math.floor(gap / 2))
    for (let i = gap; i < n; i++) {
      const temp = v[i];
      let j: number;
      for (j = i; j >= gap && v[j - gap] > temp; j -= gap)
        v[j] = v[j - gap];
      v[j] = temp;
    }
}

function countingSort(v: number[]): void {
  const max = Math.max(...v);
  const count = new Array(max + 1).fill(0);
  for (const num of v) count[num]++;
  let idx = 0;
  for (let i = 0; i <= max; i++)
    while (count[i]-- > 0)
      v[idx++] = i;
}

function radixSort(v: number[]): void {
  const max = Math.max(...v);
  for (let exp = 1; Math.floor(max / exp) > 0; exp *= 10) {
    const output = new Array(v.length);
    const count = new Array(10).fill(0);
    for (const num of v) count[Math.floor(num / exp) % 10]++;
    for (let i = 1; i < 10; i++) count[i] += count[i - 1];
    for (let i = v.length - 1; i >= 0; i--) {
      const d = Math.floor(v[i] / exp) % 10;
      output[count[d] - 1] = v[i];
      count[d]--;
    }
    for (let i = 0; i < v.length; i++) v[i] = output[i];
  }
}

function bucketSort(v: number[]): void {
  const n = v.length;
  if (n <= 0) return;
  const max = Math.max(...v);
  const min = Math.min(...v);
  const bc = Math.floor(Math.sqrt(n)) + 1;
  const range = Math.floor((max - min) / bc) + 1;
  const buckets: number[][] = Array.from({ length: bc }, () => []);
  for (const num of v) {
    let idx = Math.floor((num - min) / range);
    if (idx >= bc) idx = bc - 1;
    buckets[idx].push(num);
  }
  let pos = 0;
  for (let i = 0; i < bc; i++) {
    if (buckets[i].length === 0) continue;
    buckets[i].sort((a, b) => a - b);
    for (const num of buckets[i]) v[pos++] = num;
  }
}

async function main(): Promise<void> {
  const size = parseInt(await ask("Digite o tamanho do vetor: ")) || 10;
  const vet: number[] = Array.from({ length: size }, () => Math.floor(Math.random() * 1000));

  console.log("\nVetor original:");
  console.log(vet.join(" "));

  console.log("\n--- ALGORITMOS DE ORDENACAO (TYPESCRIPT) ---");
  console.log("1  - Bubble Sort");
  console.log("2  - Selection Sort");
  console.log("3  - Insertion Sort");
  console.log("4  - Merge Sort");
  console.log("5  - Quick Sort");
  console.log("6  - Heap Sort");
  console.log("7  - Shell Sort");
  console.log("8  - Counting Sort");
  console.log("9  - Radix Sort");
  console.log("10 - Bucket Sort");
  console.log("0  - Sair");
  const opcao = parseInt(await ask("Opcao: "));

  if (opcao === 0) {
    console.log("Saindo...");
    rl.close();
    return;
  }

  const copy = [...vet];

  switch (opcao) {
    case 1:  bubbleSort(copy); break;
    case 2:  selectionSort(copy); break;
    case 3:  insertionSort(copy); break;
    case 4:  mergeSort(copy, 0, size - 1); break;
    case 5:  quickSort(copy, 0, size - 1); break;
    case 6:  heapSort(copy); break;
    case 7:  shellSort(copy); break;
    case 8:  countingSort(copy); break;
    case 9:  radixSort(copy); break;
    case 10: bucketSort(copy); break;
    default:
      console.log("Opcao invalida");
      rl.close();
      return;
  }

  console.log("\nVetor ordenado:");
  console.log(copy.join(" "));
  rl.close();
}

main();
