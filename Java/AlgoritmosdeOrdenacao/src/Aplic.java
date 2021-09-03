import java.util.Scanner;
import java.util.Random;
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
            
        
        
        
    }
    

    public static void BubbleSort(int[] vetor, int size)
    {
    
    
    }
    
    /*  

void BubbleSort(long vet[], long size) {
    long indx;
    BOOL found = TRUE; // unsigned int found;

    showLine(vet,size);

    while (found) {
        found = FALSE;
        for (indx = 0; indx < size - 1; indx++) {
            if (vet[indx] > vet[indx + 1]) {
                swap(vet, indx, indx + 1);
                showLine(vet,size);
                found = TRUE;
            }
        }
    }
}

*/
    
    
    
}


