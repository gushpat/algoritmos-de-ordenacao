#include <iostream>
#include <vector>
#include <algorithm>
#include <random>
#include <cmath>

using namespace std;

void bubble_sort(vector<int> &v) {
    int n = v.size();
    for (int i = 0; i < n - 1; i++)
        for (int j = 0; j < n - i - 1; j++)
            if (v[j] > v[j + 1])
                swap(v[j], v[j + 1]);
}

void selection_sort(vector<int> &v) {
    int n = v.size();
    for (int i = 0; i < n - 1; i++) {
        int min = i;
        for (int j = i + 1; j < n; j++)
            if (v[j] < v[min]) min = j;
        swap(v[i], v[min]);
    }
}

void insertion_sort(vector<int> &v) {
    int n = v.size();
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

void merge(vector<int> &v, int left, int mid, int right) {
    vector<int> L(v.begin() + left, v.begin() + mid + 1);
    vector<int> R(v.begin() + mid + 1, v.begin() + right + 1);
    int i = 0, j = 0, k = left;
    while (i < L.size() && j < R.size()) {
        if (L[i] <= R[j]) v[k++] = L[i++];
        else v[k++] = R[j++];
    }
    while (i < L.size()) v[k++] = L[i++];
    while (j < R.size()) v[k++] = R[j++];
}

void merge_sort(vector<int> &v, int left, int right) {
    if (left < right) {
        int mid = left + (right - left) / 2;
        merge_sort(v, left, mid);
        merge_sort(v, mid + 1, right);
        merge(v, left, mid, right);
    }
}

int partition(vector<int> &v, int low, int high) {
    int pivot = v[high];
    int i = low - 1;
    for (int j = low; j < high; j++)
        if (v[j] < pivot)
            swap(v[++i], v[j]);
    swap(v[i + 1], v[high]);
    return i + 1;
}

void quick_sort(vector<int> &v, int low, int high) {
    if (low < high) {
        int pi = partition(v, low, high);
        quick_sort(v, low, pi - 1);
        quick_sort(v, pi + 1, high);
    }
}

void heapify(vector<int> &v, int n, int i) {
    int largest = i;
    int left = 2 * i + 1;
    int right = 2 * i + 2;
    if (left < n && v[left] > v[largest]) largest = left;
    if (right < n && v[right] > v[largest]) largest = right;
    if (largest != i) {
        swap(v[i], v[largest]);
        heapify(v, n, largest);
    }
}

void heap_sort(vector<int> &v) {
    int n = v.size();
    for (int i = n / 2 - 1; i >= 0; i--)
        heapify(v, n, i);
    for (int i = n - 1; i > 0; i--) {
        swap(v[0], v[i]);
        heapify(v, i, 0);
    }
}

void shell_sort(vector<int> &v) {
    int n = v.size();
    for (int gap = n / 2; gap > 0; gap /= 2)
        for (int i = gap; i < n; i++) {
            int temp = v[i];
            int j;
            for (j = i; j >= gap && v[j - gap] > temp; j -= gap)
                v[j] = v[j - gap];
            v[j] = temp;
        }
}

void counting_sort(vector<int> &v) {
    int max = *max_element(v.begin(), v.end());
    vector<int> count(max + 1, 0);
    for (int num : v) count[num]++;
    int idx = 0;
    for (int i = 0; i <= max; i++)
        while (count[i]-- > 0)
            v[idx++] = i;
}

void radix_sort(vector<int> &v) {
    int max = *max_element(v.begin(), v.end());
    for (int exp = 1; max / exp > 0; exp *= 10) {
        vector<int> output(v.size());
        int count[10] = {0};
        for (int num : v) count[(num / exp) % 10]++;
        for (int i = 1; i < 10; i++) count[i] += count[i - 1];
        for (int i = v.size() - 1; i >= 0; i--) {
            int digit = (v[i] / exp) % 10;
            output[count[digit] - 1] = v[i];
            count[digit]--;
        }
        v = output;
    }
}

void bucket_sort(vector<int> &v) {
    int n = v.size();
    if (n <= 0) return;
    int max = v[0], min = v[0];
    for (int num : v) {
        if (num > max) max = num;
        if (num < min) min = num;
    }
    int bucket_count = (int)sqrt(n) + 1;
    int range = (max - min) / bucket_count + 1;
    vector<int> buckets[bucket_count];
    for (int num : v)
        buckets[(num - min) / range].push_back(num);
    int idx = 0;
    for (int i = 0; i < bucket_count; i++) {
        sort(buckets[i].begin(), buckets[i].end());
        for (int num : buckets[i])
            v[idx++] = num;
    }
}

void print_array(const vector<int> &v) {
    for (int num : v) cout << num << " ";
    cout << endl;
}

int main() {
    int size, opcao;
    cout << "--- ALGORITMOS DE ORDENACAO (C++) ---" << endl;
    cout << "Digite o tamanho do vetor: ";
    cin >> size;
    if (size <= 0) size = 10;

    random_device rd;
    mt19937 gen(rd());
    uniform_int_distribution<> dis(0, 999);

    vector<int> vet(size);
    for (int i = 0; i < size; i++) vet[i] = dis(gen);

    cout << "\nVetor original:" << endl;
    print_array(vet);

    cout << "\n1  - Bubble Sort" << endl;
    cout << "2  - Selection Sort" << endl;
    cout << "3  - Insertion Sort" << endl;
    cout << "4  - Merge Sort" << endl;
    cout << "5  - Quick Sort" << endl;
    cout << "6  - Heap Sort" << endl;
    cout << "7  - Shell Sort" << endl;
    cout << "8  - Counting Sort" << endl;
    cout << "9  - Radix Sort" << endl;
    cout << "10 - Bucket Sort" << endl;
    cout << "0  - Sair" << endl;
    cout << "Opcao: ";
    cin >> opcao;

    if (opcao == 0) {
        cout << "Saindo..." << endl;
        return 0;
    }

    vector<int> copy = vet;

    switch (opcao) {
        case 1:  bubble_sort(copy); break;
        case 2:  selection_sort(copy); break;
        case 3:  insertion_sort(copy); break;
        case 4:  merge_sort(copy, 0, size - 1); break;
        case 5:  quick_sort(copy, 0, size - 1); break;
        case 6:  heap_sort(copy); break;
        case 7:  shell_sort(copy); break;
        case 8:  counting_sort(copy); break;
        case 9:  radix_sort(copy); break;
        case 10: bucket_sort(copy); break;
        default:
            cout << "Opcao invalida" << endl;
            return 1;
    }

    cout << "\nVetor ordenado:" << endl;
    print_array(copy);
    return 0;
}
