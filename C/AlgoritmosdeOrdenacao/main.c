#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

void swap(int *a, int *b) {
    int temp = *a;
    *a = *b;
    *b = temp;
}

void bubble_sort(int v[], int n) {
    for (int i = 0; i < n - 1; i++)
        for (int j = 0; j < n - i - 1; j++)
            if (v[j] > v[j + 1])
                swap(&v[j], &v[j + 1]);
}

void selection_sort(int v[], int n) {
    for (int i = 0; i < n - 1; i++) {
        int min = i;
        for (int j = i + 1; j < n; j++)
            if (v[j] < v[min]) min = j;
        swap(&v[i], &v[min]);
    }
}

void insertion_sort(int v[], int n) {
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

void merge(int v[], int left, int mid, int right) {
    int n1 = mid - left + 1;
    int n2 = right - mid;
    int L[n1], R[n2];
    for (int i = 0; i < n1; i++) L[i] = v[left + i];
    for (int j = 0; j < n2; j++) R[j] = v[mid + 1 + j];
    int i = 0, j = 0, k = left;
    while (i < n1 && j < n2) {
        if (L[i] <= R[j]) { v[k] = L[i]; i++; }
        else { v[k] = R[j]; j++; }
        k++;
    }
    while (i < n1) { v[k] = L[i]; i++; k++; }
    while (j < n2) { v[k] = R[j]; j++; k++; }
}

void merge_sort(int v[], int left, int right) {
    if (left < right) {
        int mid = left + (right - left) / 2;
        merge_sort(v, left, mid);
        merge_sort(v, mid + 1, right);
        merge(v, left, mid, right);
    }
}

int partition(int v[], int low, int high) {
    int pivot = v[high];
    int i = low - 1;
    for (int j = low; j < high; j++) {
        if (v[j] < pivot) {
            i++;
            swap(&v[i], &v[j]);
        }
    }
    swap(&v[i + 1], &v[high]);
    return i + 1;
}

void quick_sort(int v[], int low, int high) {
    if (low < high) {
        int pi = partition(v, low, high);
        quick_sort(v, low, pi - 1);
        quick_sort(v, pi + 1, high);
    }
}

void heapify(int v[], int n, int i) {
    int largest = i;
    int left = 2 * i + 1;
    int right = 2 * i + 2;
    if (left < n && v[left] > v[largest]) largest = left;
    if (right < n && v[right] > v[largest]) largest = right;
    if (largest != i) {
        swap(&v[i], &v[largest]);
        heapify(v, n, largest);
    }
}

void heap_sort(int v[], int n) {
    for (int i = n / 2 - 1; i >= 0; i--)
        heapify(v, n, i);
    for (int i = n - 1; i > 0; i--) {
        swap(&v[0], &v[i]);
        heapify(v, i, 0);
    }
}

void shell_sort(int v[], int n) {
    for (int gap = n / 2; gap > 0; gap /= 2) {
        for (int i = gap; i < n; i++) {
            int temp = v[i];
            int j;
            for (j = i; j >= gap && v[j - gap] > temp; j -= gap)
                v[j] = v[j - gap];
            v[j] = temp;
        }
    }
}

void counting_sort(int v[], int n) {
    int max = 0;
    for (int i = 0; i < n; i++)
        if (v[i] > max) max = v[i];
    int count[max + 1];
    memset(count, 0, sizeof(count));
    for (int i = 0; i < n; i++)
        count[v[i]]++;
    int idx = 0;
    for (int i = 0; i <= max; i++)
        while (count[i]-- > 0)
            v[idx++] = i;
}

void counting_sort_by_digit(int v[], int n, int exp) {
    int output[n];
    int count[10] = {0};
    for (int i = 0; i < n; i++)
        count[(v[i] / exp) % 10]++;
    for (int i = 1; i < 10; i++)
        count[i] += count[i - 1];
    for (int i = n - 1; i >= 0; i--) {
        int digit = (v[i] / exp) % 10;
        output[count[digit] - 1] = v[i];
        count[digit]--;
    }
    memcpy(v, output, sizeof(output));
}

void radix_sort(int v[], int n) {
    int max = 0;
    for (int i = 0; i < n; i++)
        if (v[i] > max) max = v[i];
    for (int exp = 1; max / exp > 0; exp *= 10)
        counting_sort_by_digit(v, n, exp);
}

void bucket_sort(int v[], int n) {
    if (n <= 0) return;
    int max = v[0], min = v[0];
    for (int i = 1; i < n; i++) {
        if (v[i] > max) max = v[i];
        if (v[i] < min) min = v[i];
    }
    int bucket_count = (int)sqrt(n) + 1;
    int range = (max - min) / bucket_count + 1;
    int buckets[bucket_count][n];
    int bucket_sizes[bucket_count];
    memset(bucket_sizes, 0, sizeof(bucket_sizes));
    for (int i = 0; i < n; i++) {
        int idx = (v[i] - min) / range;
        if (idx >= bucket_count) idx = bucket_count - 1;
        buckets[idx][bucket_sizes[idx]++] = v[i];
    }
    int pos = 0;
    for (int i = 0; i < bucket_count; i++) {
        if (bucket_sizes[i] == 0) continue;
        for (int j = 1; j < bucket_sizes[i]; j++) {
            int key = buckets[i][j];
            int k = j - 1;
            while (k >= 0 && buckets[i][k] > key) {
                buckets[i][k + 1] = buckets[i][k];
                k--;
            }
            buckets[i][k + 1] = key;
        }
        for (int j = 0; j < bucket_sizes[i]; j++)
            v[pos++] = buckets[i][j];
    }
}

void print_array(int v[], int n) {
    for (int i = 0; i < n; i++)
        printf("%d ", v[i]);
    printf("\n");
}

int main() {
    int size, opcao;
    printf("--- ALGORITMOS DE ORDENACAO (C) ---\n");
    printf("Digite o tamanho do vetor: ");
    scanf("%d", &size);
    if (size <= 0) size = 10;

    int vet[size];
    for (int i = 0; i < size; i++)
        vet[i] = rand() % 1000;

    printf("\nVetor original:\n");
    print_array(vet, size);

    printf("\n1  - Bubble Sort");
    printf("\n2  - Selection Sort");
    printf("\n3  - Insertion Sort");
    printf("\n4  - Merge Sort");
    printf("\n5  - Quick Sort");
    printf("\n6  - Heap Sort");
    printf("\n7  - Shell Sort");
    printf("\n8  - Counting Sort");
    printf("\n9  - Radix Sort");
    printf("\n10 - Bucket Sort");
    printf("\n0  - Sair");
    printf("\nOpcao: ");
    scanf("%d", &opcao);

    if (opcao == 0) {
        printf("Saindo...\n");
        return 0;
    }

    int copy[size];
    memcpy(copy, vet, sizeof(vet));

    switch (opcao) {
        case 1:  bubble_sort(copy, size); break;
        case 2:  selection_sort(copy, size); break;
        case 3:  insertion_sort(copy, size); break;
        case 4:  merge_sort(copy, 0, size - 1); break;
        case 5:  quick_sort(copy, 0, size - 1); break;
        case 6:  heap_sort(copy, size); break;
        case 7:  shell_sort(copy, size); break;
        case 8:  counting_sort(copy, size); break;
        case 9:  radix_sort(copy, size); break;
        case 10: bucket_sort(copy, size); break;
        default:
            printf("Opcao invalida\n");
            return 1;
    }

    printf("\nVetor ordenado:\n");
    print_array(copy, size);
    return 0;
}
