using System;

class Program {
    static void Main() {
        Random rand = new Random();
        Console.Write("Digite o tamanho do vetor: ");
        int size = int.Parse(Console.ReadLine());
        if (size <= 0) size = 10;

        int[] vet = new int[size];
        for (int i = 0; i < size; i++)
            vet[i] = rand.Next(1000);

        Console.WriteLine("\nVetor original:");
        PrintArray(vet);

        Console.WriteLine("\n--- ALGORITMOS DE ORDENACAO (C#) ---");
        Console.WriteLine("1  - Bubble Sort");
        Console.WriteLine("2  - Selection Sort");
        Console.WriteLine("3  - Insertion Sort");
        Console.WriteLine("4  - Merge Sort");
        Console.WriteLine("5  - Quick Sort");
        Console.WriteLine("6  - Heap Sort");
        Console.WriteLine("7  - Shell Sort");
        Console.WriteLine("8  - Counting Sort");
        Console.WriteLine("9  - Radix Sort");
        Console.WriteLine("10 - Bucket Sort");
        Console.WriteLine("0  - Sair");
        Console.Write("Opcao: ");
        int opcao = int.Parse(Console.ReadLine());

        if (opcao == 0) {
            Console.WriteLine("Saindo...");
            return;
        }

        int[] copy = new int[size];
        Array.Copy(vet, copy, size);

        switch (opcao) {
            case 1:  BubbleSort(copy); break;
            case 2:  SelectionSort(copy); break;
            case 3:  InsertionSort(copy); break;
            case 4:  MergeSort(copy, 0, size - 1); break;
            case 5:  QuickSort(copy, 0, size - 1); break;
            case 6:  HeapSort(copy); break;
            case 7:  ShellSort(copy); break;
            case 8:  CountingSort(copy); break;
            case 9:  RadixSort(copy); break;
            case 10: BucketSort(copy); break;
            default:
                Console.WriteLine("Opcao invalida");
                return;
        }

        Console.WriteLine("\nVetor ordenado:");
        PrintArray(copy);
    }

    static void PrintArray(int[] v) {
        Console.WriteLine(string.Join(" ", v));
    }

    static void Swap(int[] v, int i, int j) {
        int t = v[i]; v[i] = v[j]; v[j] = t;
    }

    static void BubbleSort(int[] v) {
        int n = v.Length;
        for (int i = 0; i < n - 1; i++)
            for (int j = 0; j < n - i - 1; j++)
                if (v[j] > v[j + 1])
                    Swap(v, j, j + 1);
    }

    static void SelectionSort(int[] v) {
        int n = v.Length;
        for (int i = 0; i < n - 1; i++) {
            int min = i;
            for (int j = i + 1; j < n; j++)
                if (v[j] < v[min]) min = j;
            Swap(v, i, min);
        }
    }

    static void InsertionSort(int[] v) {
        int n = v.Length;
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

    static void MergeSort(int[] v, int left, int right) {
        if (left < right) {
            int mid = left + (right - left) / 2;
            MergeSort(v, left, mid);
            MergeSort(v, mid + 1, right);
            Merge(v, left, mid, right);
        }
    }

    static void Merge(int[] v, int left, int mid, int right) {
        int n1 = mid - left + 1, n2 = right - mid;
        int[] L = new int[n1], R = new int[n2];
        Array.Copy(v, left, L, 0, n1);
        Array.Copy(v, mid + 1, R, 0, n2);
        int i = 0, j = 0, k = left;
        while (i < n1 && j < n2)
            v[k++] = L[i] <= R[j] ? L[i++] : R[j++];
        while (i < n1) v[k++] = L[i++];
        while (j < n2) v[k++] = R[j++];
    }

    static void QuickSort(int[] v, int low, int high) {
        if (low < high) {
            int pi = Partition(v, low, high);
            QuickSort(v, low, pi - 1);
            QuickSort(v, pi + 1, high);
        }
    }

    static int Partition(int[] v, int low, int high) {
        int pivot = v[high];
        int i = low - 1;
        for (int j = low; j < high; j++)
            if (v[j] < pivot)
                Swap(v, ++i, j);
        Swap(v, i + 1, high);
        return i + 1;
    }

    static void HeapSort(int[] v) {
        int n = v.Length;
        for (int i = n / 2 - 1; i >= 0; i--)
            Heapify(v, n, i);
        for (int i = n - 1; i > 0; i--) {
            Swap(v, 0, i);
            Heapify(v, i, 0);
        }
    }

    static void Heapify(int[] v, int n, int i) {
        int largest = i, l = 2 * i + 1, r = 2 * i + 2;
        if (l < n && v[l] > v[largest]) largest = l;
        if (r < n && v[r] > v[largest]) largest = r;
        if (largest != i) {
            Swap(v, i, largest);
            Heapify(v, n, largest);
        }
    }

    static void ShellSort(int[] v) {
        int n = v.Length;
        for (int gap = n / 2; gap > 0; gap /= 2)
            for (int i = gap; i < n; i++) {
                int temp = v[i], j;
                for (j = i; j >= gap && v[j - gap] > temp; j -= gap)
                    v[j] = v[j - gap];
                v[j] = temp;
            }
    }

    static void CountingSort(int[] v) {
        int max = 0;
        foreach (int num in v)
            if (num > max) max = num;
        int[] count = new int[max + 1];
        foreach (int num in v) count[num]++;
        int idx = 0;
        for (int i = 0; i <= max; i++)
            while (count[i]-- > 0)
                v[idx++] = i;
    }

    static void RadixSort(int[] v) {
        int max = 0;
        foreach (int num in v)
            if (num > max) max = num;
        for (int exp = 1; max / exp > 0; exp *= 10) {
            int[] output = new int[v.Length];
            int[] count = new int[10];
            foreach (int num in v) count[(num / exp) % 10]++;
            for (int i = 1; i < 10; i++) count[i] += count[i - 1];
            for (int i = v.Length - 1; i >= 0; i--) {
                int d = (v[i] / exp) % 10;
                output[count[d] - 1] = v[i];
                count[d]--;
            }
            Array.Copy(output, v, v.Length);
        }
    }

    static void BucketSort(int[] v) {
        int n = v.Length;
        if (n <= 0) return;
        int max = v[0], min = v[0];
        foreach (int num in v) {
            if (num > max) max = num;
            if (num < min) min = num;
        }
        int bc = (int)Math.Sqrt(n) + 1;
        int range = (max - min) / bc + 1;
        int[][] buckets = new int[bc][];
        int[] sizes = new int[bc];
        for (int i = 0; i < bc; i++) buckets[i] = new int[n];
        foreach (int num in v) {
            int idx = (num - min) / range;
            if (idx >= bc) idx = bc - 1;
            buckets[idx][sizes[idx]++] = num;
        }
        int pos = 0;
        for (int i = 0; i < bc; i++) {
            if (sizes[i] == 0) continue;
            Array.Sort(buckets[i], 0, sizes[i]);
            for (int j = 0; j < sizes[i]; j++)
                v[pos++] = buckets[i][j];
        }
    }
}
