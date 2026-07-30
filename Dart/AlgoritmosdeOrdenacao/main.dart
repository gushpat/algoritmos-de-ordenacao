import 'dart:io';
import 'dart:math';

void main() {
  final random = Random();
  stdout.write("Digite o tamanho do vetor: ");
  int size = int.parse(stdin.readLineSync() ?? "10");
  if (size <= 0) size = 10;

  List<int> vet = List.generate(size, (_) => random.nextInt(1000));

  print("\nVetor original:");
  printArray(vet);

  print("\n--- ALGORITMOS DE ORDENACAO (DART) ---");
  print("1  - Bubble Sort");
  print("2  - Selection Sort");
  print("3  - Insertion Sort");
  print("4  - Merge Sort");
  print("5  - Quick Sort");
  print("6  - Heap Sort");
  print("7  - Shell Sort");
  print("8  - Counting Sort");
  print("9  - Radix Sort");
  print("10 - Bucket Sort");
  print("0  - Sair");
  stdout.write("Opcao: ");
  int opcao = int.parse(stdin.readLineSync() ?? "0");

  if (opcao == 0) {
    print("Saindo...");
    return;
  }

  List<int> copy = List.from(vet);

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
      print("Opcao invalida");
      return;
  }

  print("\nVetor ordenado:");
  printArray(copy);
}

void printArray(List<int> v) {
  print(v.join(" "));
}

void bubbleSort(List<int> v) {
  int n = v.length;
  for (int i = 0; i < n - 1; i++)
    for (int j = 0; j < n - i - 1; j++)
      if (v[j] > v[j + 1]) {
        int t = v[j]; v[j] = v[j + 1]; v[j + 1] = t;
      }
}

void selectionSort(List<int> v) {
  int n = v.length;
  for (int i = 0; i < n - 1; i++) {
    int min = i;
    for (int j = i + 1; j < n; j++)
      if (v[j] < v[min]) min = j;
    int t = v[i]; v[i] = v[min]; v[min] = t;
  }
}

void insertionSort(List<int> v) {
  int n = v.length;
  for (int i = 1; i < n; i++) {
    int key = v[i];
    int j = i - 1;
    while (j >= 0 && v[j] > key) {
      v[j + 1] = v[j];
      j--;
    }
    v[j + 1] = key;
  }
}

void mergeSort(List<int> v, int left, int right) {
  if (left < right) {
    int mid = left + (right - left) ~/ 2;
    mergeSort(v, left, mid);
    mergeSort(v, mid + 1, right);
    merge(v, left, mid, right);
  }
}

void merge(List<int> v, int left, int mid, int right) {
  List<int> L = v.sublist(left, mid + 1);
  List<int> R = v.sublist(mid + 1, right + 1);
  int i = 0, j = 0, k = left;
  while (i < L.length && j < R.length) {
    if (L[i] <= R[j]) { v[k] = L[i]; i++; }
    else { v[k] = R[j]; j++; }
    k++;
  }
  while (i < L.length) { v[k] = L[i]; i++; k++; }
  while (j < R.length) { v[k] = R[j]; j++; k++; }
}

void quickSort(List<int> v, int low, int high) {
  if (low < high) {
    int pi = partition(v, low, high);
    quickSort(v, low, pi - 1);
    quickSort(v, pi + 1, high);
  }
}

int partition(List<int> v, int low, int high) {
  int pivot = v[high];
  int i = low - 1;
  for (int j = low; j < high; j++) {
    if (v[j] < pivot) {
      i++;
      int t = v[i]; v[i] = v[j]; v[j] = t;
    }
  }
  int t = v[i + 1]; v[i + 1] = v[high]; v[high] = t;
  return i + 1;
}

void heapSort(List<int> v) {
  int n = v.length;
  for (int i = n ~/ 2 - 1; i >= 0; i--)
    heapify(v, n, i);
  for (int i = n - 1; i > 0; i--) {
    int t = v[0]; v[0] = v[i]; v[i] = t;
    heapify(v, i, 0);
  }
}

void heapify(List<int> v, int n, int i) {
  int largest = i;
  int l = 2 * i + 1, r = 2 * i + 2;
  if (l < n && v[l] > v[largest]) largest = l;
  if (r < n && v[r] > v[largest]) largest = r;
  if (largest != i) {
    int t = v[i]; v[i] = v[largest]; v[largest] = t;
    heapify(v, n, largest);
  }
}

void shellSort(List<int> v) {
  int n = v.length;
  for (int gap = n ~/ 2; gap > 0; gap ~/= 2) {
    for (int i = gap; i < n; i++) {
      int temp = v[i];
      int j;
      for (j = i; j >= gap && v[j - gap] > temp; j -= gap)
        v[j] = v[j - gap];
      v[j] = temp;
    }
  }
}

void countingSort(List<int> v) {
  int max = v.reduce((a, b) => a > b ? a : b);
  List<int> count = List.filled(max + 1, 0);
  for (int num in v) count[num]++;
  int idx = 0;
  for (int i = 0; i <= max; i++)
    while (count[i]-- > 0)
      v[idx++] = i;
}

void radixSort(List<int> v) {
  int max = v.reduce((a, b) => a > b ? a : b);
  for (int exp = 1; max ~/ exp > 0; exp *= 10) {
    List<int> output = List.filled(v.length, 0);
    List<int> count = List.filled(10, 0);
    for (int num in v) count[(num ~/ exp) % 10]++;
    for (int i = 1; i < 10; i++) count[i] += count[i - 1];
    for (int i = v.length - 1; i >= 0; i--) {
      int d = (v[i] ~/ exp) % 10;
      output[count[d] - 1] = v[i];
      count[d]--;
    }
    for (int i = 0; i < v.length; i++) v[i] = output[i];
  }
}

void bucketSort(List<int> v) {
  int n = v.length;
  if (n <= 0) return;
  int max = v.reduce((a, b) => a > b ? a : b);
  int min = v.reduce((a, b) => a < b ? a : b);
  int bc = (sqrt(n).floor()) + 1;
  int range = ((max - min) / bc).floor() + 1;
  List<List<int>> buckets = List.generate(bc, (_) => []);
  for (int num in v) {
    int idx = ((num - min) / range).floor();
    if (idx >= bc) idx = bc - 1;
    buckets[idx].add(num);
  }
  int pos = 0;
  for (int i = 0; i < bc; i++) {
    if (buckets[i].isEmpty) continue;
    buckets[i].sort();
    for (int num in buckets[i]) v[pos++] = num;
  }
}
