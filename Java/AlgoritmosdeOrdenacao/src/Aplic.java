import java.util.Scanner;
import java.util.Random;
import java.util.Arrays;

public class Aplic {

    public static void main(String[] args) {
        Scanner entrada = new Scanner(System.in);
        Random gerador = new Random();

        int size;
        do {
            System.out.print("Digite o tamanho do vetor: ");
            size = entrada.nextInt();
        } while (size <= 0);

        int[] vet = new int[size];
        for (int i = 0; i < size; i++) {
            vet[i] = gerador.nextInt(1000);
        }

        System.out.println("\nVetor original:");
        System.out.println(Arrays.toString(vet));

        System.out.println("\n--- ALGORITMOS DE ORDENACAO ---");
        System.out.println("1  - Bubble Sort");
        System.out.println("2  - Selection Sort");
        System.out.println("3  - Insertion Sort");
        System.out.println("4  - Merge Sort");
        System.out.println("5  - Quick Sort");
        System.out.println("6  - Heap Sort");
        System.out.println("7  - Shell Sort");
        System.out.println("8  - Counting Sort");
        System.out.println("9  - Radix Sort");
        System.out.println("10 - Bucket Sort");
        System.out.println("0  - Sair");
        System.out.print("\nOpcao: ");

        int opcao = entrada.nextInt();

        if (opcao == 0) {
            System.out.println("Saindo...");
            return;
        }

        int[] copy = Arrays.copyOf(vet, vet.length);

        switch (opcao) {
            case 1:  BubbleSort(copy); break;
            case 2:  SelectionSort(copy); break;
            case 3:  InsertionSort(copy); break;
            case 4:  MergeSort(copy, 0, copy.length - 1); break;
            case 5:  QuickSort(copy, 0, copy.length - 1); break;
            case 6:  HeapSort(copy); break;
            case 7:  ShellSort(copy); break;
            case 8:  CountingSort(copy); break;
            case 9:  RadixSort(copy); break;
            case 10: BucketSort(copy); break;
            default:
                System.out.println("Opcao invalida");
                return;
        }

        System.out.println("\nVetor ordenado:");
        System.out.println(Arrays.toString(copy));
    }

    public static void BubbleSort(int[] v) {
        int n = v.length;
        for (int i = 0; i < n - 1; i++) {
            for (int j = 0; j < n - i - 1; j++) {
                if (v[j] > v[j + 1]) {
                    int temp = v[j];
                    v[j] = v[j + 1];
                    v[j + 1] = temp;
                }
            }
        }
    }

    public static void SelectionSort(int[] v) {
        int n = v.length;
        for (int i = 0; i < n - 1; i++) {
            int min = i;
            for (int j = i + 1; j < n; j++) {
                if (v[j] < v[min]) {
                    min = j;
                }
            }
            int temp = v[i];
            v[i] = v[min];
            v[min] = temp;
        }
    }

    public static void InsertionSort(int[] v) {
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

    public static void MergeSort(int[] v, int left, int right) {
        if (left < right) {
            int mid = (left + right) / 2;
            MergeSort(v, left, mid);
            MergeSort(v, mid + 1, right);
            Merge(v, left, mid, right);
        }
    }

    private static void Merge(int[] v, int left, int mid, int right) {
        int n1 = mid - left + 1;
        int n2 = right - mid;

        int[] L = new int[n1];
        int[] R = new int[n2];

        for (int i = 0; i < n1; i++) L[i] = v[left + i];
        for (int j = 0; j < n2; j++) R[j] = v[mid + 1 + j];

        int i = 0, j = 0, k = left;
        while (i < n1 && j < n2) {
            if (L[i] <= R[j]) {
                v[k] = L[i];
                i++;
            } else {
                v[k] = R[j];
                j++;
            }
            k++;
        }

        while (i < n1) {
            v[k] = L[i];
            i++;
            k++;
        }

        while (j < n2) {
            v[k] = R[j];
            j++;
            k++;
        }
    }

    public static void QuickSort(int[] v, int low, int high) {
        if (low < high) {
            int pi = Partition(v, low, high);
            QuickSort(v, low, pi - 1);
            QuickSort(v, pi + 1, high);
        }
    }

    private static int Partition(int[] v, int low, int high) {
        int pivot = v[high];
        int i = low - 1;
        for (int j = low; j < high; j++) {
            if (v[j] < pivot) {
                i++;
                int temp = v[i];
                v[i] = v[j];
                v[j] = temp;
            }
        }
        int temp = v[i + 1];
        v[i + 1] = v[high];
        v[high] = temp;
        return i + 1;
    }

    public static void HeapSort(int[] v) {
        int n = v.length;
        for (int i = n / 2 - 1; i >= 0; i--) {
            Heapify(v, n, i);
        }
        for (int i = n - 1; i > 0; i--) {
            int temp = v[0];
            v[0] = v[i];
            v[i] = temp;
            Heapify(v, i, 0);
        }
    }

    private static void Heapify(int[] v, int n, int i) {
        int largest = i;
        int left = 2 * i + 1;
        int right = 2 * i + 2;

        if (left < n && v[left] > v[largest]) largest = left;
        if (right < n && v[right] > v[largest]) largest = right;

        if (largest != i) {
            int temp = v[i];
            v[i] = v[largest];
            v[largest] = temp;
            Heapify(v, n, largest);
        }
    }

    public static void ShellSort(int[] v) {
        int n = v.length;
        for (int gap = n / 2; gap > 0; gap /= 2) {
            for (int i = gap; i < n; i++) {
                int temp = v[i];
                int j;
                for (j = i; j >= gap && v[j - gap] > temp; j -= gap) {
                    v[j] = v[j - gap];
                }
                v[j] = temp;
            }
        }
    }

    public static void CountingSort(int[] v) {
        int max = 0;
        for (int num : v) {
            if (num > max) max = num;
        }

        int[] count = new int[max + 1];
        for (int num : v) {
            count[num]++;
        }

        int index = 0;
        for (int i = 0; i <= max; i++) {
            while (count[i] > 0) {
                v[index] = i;
                index++;
                count[i]--;
            }
        }
    }

    public static void RadixSort(int[] v) {
        int max = 0;
        for (int num : v) {
            if (num > max) max = num;
        }

        for (int exp = 1; max / exp > 0; exp *= 10) {
            CountingSortByDigit(v, exp);
        }
    }

    private static void CountingSortByDigit(int[] v, int exp) {
        int n = v.length;
        int[] output = new int[n];
        int[] count = new int[10];

        for (int i = 0; i < n; i++) {
            count[(v[i] / exp) % 10]++;
        }

        for (int i = 1; i < 10; i++) {
            count[i] += count[i - 1];
        }

        for (int i = n - 1; i >= 0; i--) {
            int digit = (v[i] / exp) % 10;
            output[count[digit] - 1] = v[i];
            count[digit]--;
        }

        System.arraycopy(output, 0, v, 0, n);
    }

    public static void BucketSort(int[] v) {
        int n = v.length;
        if (n <= 0) return;

        int max = v[0], min = v[0];
        for (int num : v) {
            if (num > max) max = num;
            if (num < min) min = num;
        }

        int bucketCount = (int) Math.sqrt(n) + 1;
        int range = (max - min) / bucketCount + 1;

        int[][] buckets = new int[bucketCount][n];
        int[] bucketSizes = new int[bucketCount];

        for (int num : v) {
            int bucketIndex = (num - min) / range;
            if (bucketIndex >= bucketCount) bucketIndex = bucketCount - 1;
            buckets[bucketIndex][bucketSizes[bucketIndex]++] = num;
        }

        int index = 0;
        for (int i = 0; i < bucketCount; i++) {
            if (bucketSizes[i] > 0) {
                InsertionSortBucket(buckets[i], bucketSizes[i]);
                for (int j = 0; j < bucketSizes[i]; j++) {
                    v[index++] = buckets[i][j];
                }
            }
        }
    }

    private static void InsertionSortBucket(int[] arr, int n) {
        for (int i = 1; i < n; i++) {
            int key = arr[i];
            int j = i - 1;
            while (j >= 0 && arr[j] > key) {
                arr[j + 1] = arr[j];
                j--;
            }
            arr[j + 1] = key;
        }
    }
}
