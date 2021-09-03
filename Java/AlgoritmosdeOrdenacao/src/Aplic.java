
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
                System.out.println("Esta função ainda não foi programada!");
                break;

            case 4:
                /*Quick*/
                System.out.println("Esta função ainda não foi programada!");
                break;
        }

        System.out.println("\n\n");

    }

    public static void SelectionSort(int[] vet, int size) {
        int indx, indy;

        System.out.println(Arrays.toString(vet));

        for (indx = 0; indx < size - 1; indx++) {
            for (indy = indx + 1; indy < size; indy++) {
                if (vet[indx] > vet[indy]) {
                    
                    //swap(vet, indx, indy);
                    
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
