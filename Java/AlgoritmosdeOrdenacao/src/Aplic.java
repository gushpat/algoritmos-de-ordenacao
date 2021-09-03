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
        //boolean showLine = true;
        
        Scanner entrada = new Scanner(System.in);
        Random gerador = new Random();

        do {
            System.out.println("Digite o tamanho do vetor");
            size = entrada.nextInt();
               
        } while (size <= 0);
        
        /*
        System.out.println("Deseja que as linhas sejam mostradas no console? S/N");
        String resposta;
        resposta = entrada.nextLine();
        
        if (resposta == "S" || resposta == "s")
        {
        showLine = true;
        }
        else if (resposta == "N" || resposta == "n")
        {
        showLine = false;
        }
        else
        {
        System.out.println("Erro! Como não entendi sua resposta, as linhas serão mostradas por padrão!");
        }
        */
        
        //definindo o tamanho do vetor
            vet = new int[size];
        
        //Gerando numeros aleatórios para popular o vetor
        for (int i = 0; i < size; i++) { 
            
            vet[i] = gerador.nextInt(1000);
            
        }
        
        System.out.println("\nOs números gerados foram:");
        //Exibição do vetor vet sem ordenação nennhuma
        System.out.println(Arrays.toString(vet));
        System.out.println("\n");
        
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


