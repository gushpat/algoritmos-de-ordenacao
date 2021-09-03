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
        //Exibição do vetor vet sem ordenação nennhuma
        System.out.println(Arrays.toString(vet));
        
        
        BubbleSort(vet,size);
        
        
        
    }
    

    public static void BubbleSort(int[] vet, int size)
    {
       
       
        int indx;
        boolean found = true; 

        

    while (found) {
        found = false;
        for (indx = 0; indx < size - 1; indx++) {
            if (vet[indx] > vet[indx + 1]) {
                
                //swap(vet, indx, indx + 1);
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


