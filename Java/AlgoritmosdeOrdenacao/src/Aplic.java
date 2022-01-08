
import java.util.Scanner;
import java.util.Random;
import java.util.Arrays;

/**
 *
 * @author Gustavo Patricio
 */
public class Aplic {

    public static void main(String[] args) {

        int size = 0;
        int[] vet;

        Scanner entrada = new Scanner(System.in);
        Random gerador = new Random();

        do {
            System.out.println("Digite o tamanho do vetor");
            size = entrada.nextInt();

        } while (size <= 0);

        //definindo o tamanho do vetor
        vet = new int[size];

        //Gerando numeros aleatórios para popular o vetor
        for (int i = 0; i < size; i++) {

            vet[i] = gerador.nextInt(1000);

        }

        System.out.println("\nOs números gerados foram:");
        //Exibição do vetor vet sem ordenação nenhuma
        System.out.println(Arrays.toString(vet));
        System.out.println("");

        int opcao;

        System.out.println("************************");
        System.out.println("ALGORITMOS DE ORDENAÇÃO");
        System.out.println("************************");
        System.out.println("");
        //exibindo opções para usuario
        System.out.println("1 - Bubble Sort");
        System.out.println("2 - Selection Sort");
        System.out.println("3 - Insertion Sort");
        System.out.println("4 - Quick Sort");
        System.out.println("5 - Sair");
        System.out.print("\n\n\t Digite a opcao: ");
        opcao = entrada.nextInt();
        System.out.println("\n");

        switch (opcao) {
            case 1:
                /*Bubble*/
                BubbleSort(vet, size);
                break;

            case 2:/*Selection*/
                SelectionSort(vet, size);

                break;

            case 3:
                /*Insertion*/
                InsertionSort(vet, size);
                break;

            case 4:
                /*Quick*/
                QuickSort(vet, 0, size);
                break;
        }

        System.out.println("\n\n");

    }
    
    public static void QuickSort(int[] vet, int inicio, int fim) {
        int pivo;
        int i, j;
        int aux;

        i = inicio;
        j = fim - 1;
        pivo = vet[(inicio + fim) / 2];

        while (i <= j) {
            while (vet[i] < pivo) {
                i++;
            }
            while (vet[j] > pivo) {
                j--;
            }
            if (i <= j) {
                aux = vet[i];
                vet[i] = vet[j];
                vet[j] = aux;
                i++;
                j--;
            }
        }

        if (inicio < j) {
            QuickSort(vet, inicio, j + 1);
        }
        if (i < fim) {
            QuickSort(vet, i, fim);
        }
    }



    public static void MergeSort(int[] vet, int inicio, int fim) {
        int meio;

        if (inicio < fim) {
            meio = (inicio + fim) / 2;
            MergeSort(vet, inicio, meio);
            MergeSort(vet, meio + 1, fim);
            Merge(vet, inicio, meio, fim);
        }
    }

    public static void Merge(int[] vet, int inicio, int meio, int fim) {
        int[] aux = new int[vet.length];
        int i, j, k;

        i = inicio;
        j = meio + 1;
        k = inicio;

        while ((i <= meio) && (j <= fim)) {
            if (vet[i] < vet[j]) {
                aux[k] = vet[i];
                i++;
            } else {
                aux[k] = vet[j];
                j++;
            }
            k++;
        }

        while (i <= meio) {
            aux[k] = vet[i];
            i++;
            k++;
        }

        while (j <= fim) {
            aux[k] = vet[j];
            j++;
            k++;
        }

        for (i = inicio; i <= fim; i++) {
            vet[i] = aux[i];
        }
    }

    public static void HeapSort(int[] vet, int size) {
        int i;

        for (i = size / 2 - 1; i >= 0; i--) {
            Heapify(vet, size, i);
        }

        for (i = size - 1; i >= 0; i--) {
            Swap(vet, 0, i);
            Heapify(vet, i, 0);
        }
    }

    public static void Heapify(int[] vet, int size, int i) {
        int maior;
        int esq = 2 * i + 1;
        int dir = 2 * i + 2;

        if (esq < size && vet[esq] > vet[i]) {
            maior = esq;
        } else {
            maior = i;
        }

        if (dir < size && vet[dir] > vet[maior]) {
            maior = dir;
        }

        if (maior != i) {
            Swap(vet, i, maior);
            Heapify(vet, size, maior);
        }
    }

    public static void Swap(int[] vet, int i, int j) {
        int aux;

        aux = vet[i];
        vet[i] = vet[j];
        vet[j] = aux;
    }
    

    public static void InsertionSort(int[] vet, int size) {
        int i, key, j;

        System.out.println(Arrays.toString(vet));

        for (i = 1; i < size; i++) {
            key = vet[i];
            j = i - 1;
            while (j >= 0 && vet[j] > key) {
                vet[j + 1] = vet[j];
                System.out.println(Arrays.toString(vet));
                j = j - 1;
            }
            vet[j + 1] = key;
            System.out.println(Arrays.toString(vet));
        }
    }

    public static void SelectionSort(int[] vet, int size) {
        int indx, indy;

        System.out.println(Arrays.toString(vet));

        for (indx = 0; indx < size - 1; indx++) {
            for (indy = indx + 1; indy < size; indy++) {
                if (vet[indx] > vet[indy]) {

                    int aux = vet[indx];
                    vet[indx] = vet[indy];
                    vet[indy] = aux;

                    System.out.println(Arrays.toString(vet));
                }
            }
        }
    }

    public static void BubbleSort(int[] vet, int size) {

        int indx;
        boolean found = true;

        System.out.println(Arrays.toString(vet));

        while (found) {
            found = false;
            for (indx = 0; indx < size - 1; indx++) {
                if (vet[indx] > vet[indx + 1]) {

                    int aux = vet[indx];
                    vet[indx] = vet[indx + 1];
                    vet[indx + 1] = aux;

                    System.out.println(Arrays.toString(vet));
                    found = true;
                }
            }
        }

    }

    

}


/*

 */
