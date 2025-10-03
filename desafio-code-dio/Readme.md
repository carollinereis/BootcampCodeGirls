## Aula Desafios de Código: A Linguagem é só um detalhe... Como Resolver Desafios de Código

Na aula sobre desafios de código, o professor nos mostrou algumas linguages de programação. Coloquei abaixo os cógigos usados como exemplo pelo professor Venilton.

### Praticando Lógica com Desafios de Código

**Primeiros passos com Java**

// Para ler e escrever dados em Java, aqui na DIO padronizamos da seguinte forma:
// - new scanner(System.in): cria um leitor de Entradas, com métodos úteis com prefixo "next";
// - System.out.println: .imprime um texto de Saída (Output) e pulando uma linha.

import java.util.Scanner;

public class Desafio {
    public static void main(String[] args) {
      //Lê os valores de Entrada
      Scanner leitorDeEntradas = new Scanner(System.in);
      float valorSalario = leitorDeEntradas.nextFloat();
      float valorBeneficios = leitorDeEntradas.nextFloat();

      float valorimposto = 0;
      if (valorSalario >= 0 && valorSalario <= 1100) {
         //Atribiu a aliquota de 5% mediante o salário
         valorImposto = 0.05F * valorSalario;
      } else if (valorSalario >= 1100.01 && valorSalario <= 2500) {
         valorImposto = 0.10F * valorSalario;
      } else (valorSalario > 2500) {
         valorImposto = 0.15F * valorSalario;
      }
      //to do Criar as demais condições para as aliquotas de 10.00% e 15.00%.

      //Calcula e imprime a Saída (com 2 casas decimais):
      float saida = valorSalario - valorImposto + valorBeneficios;
      System.out.println(String.format("%.2f", saida));
    }
}

**Primeiros passos com C#**
// Para ler e escrever dados em C#, utilizamos os seguintes métodos da classe Console:
// - Console.ReadLine: lê UMA linha com dado(s) de Entrada (Inputs) do usuário;
// - Console.WriteLine: imprime um texto de Saída (Output) e pulando uma linha.

using System;

    public class Desafio
    {
      public static void Main()
      {
        // Lê os valores de Entrada
       float valorSalario = float.Parse(Console.ReadLine());
       float valorBeneficios = float.Parse(Console.ReadLine());

       float valorImposto = O;
       if (valorSalario >= O && valorSalario <= 1100) 
       {
          //Atribiu a aliquota de 5% mediante o salário
          valorImposto = 0.05F * valorSalario;
       }
        else if (valorSalario >= 1100.01 && valorSalario <= 2500) 
        {
         valorImposto = 0.10F * valorSalario;
        } 
      else (valorSalario > 2500) 
        {
         valorImposto = 0.15F * valorSalario;
        }
       //Calcula e imprime a Saída (com 2 casas decimais)
      float saida = valorSalario - valorImposto + valorBeneficios;
      Console.WriteLine(saida.ToString("0.00"));
      }
    }

**Primeiros passos com Javascript**
//Desafios JavaScript na DIO têm funções "gets" e "print" acessíveis globalmente:
//- "gets" : 1é UMA linha com dado(s) de entrada (inputs) do usuário;
//- "print": imprime um texto de saída (output), pulando linha.

//Lê os valores de Entrada
const valorSalario = parseFloat(gets());
const valorBeneficios = parsefloat(gets());

//calcula o impdsto através da função "calcularImposto”
const valorImposto = calcularImposto(valorSalario);

//Calcula e imprime a Saída (com 2 casas decimais)
const saida = valorSalario - valorImposto + valorBeneficios;
print(saida.toFixed(2));

//Função útil para o calculo do imposto (baseado nas aliquotas)
function calcularImposto(salario) {
   Let aliquota;
   if (salario >= 0 && salario <= 1100) {
   aliquota = 0.05;
   } else if(salario >= 1100.01 && salarioa <= 2500.00){
   aliquota = 0.10;
   } else {
    aliquota = 0.15;
   }
   return aliquota * salario;
}

**Primeiros passos com Python**
'''
Para ler e escrever dados em Python, utilizamos as seguintes funções:
- input: lê UMA linha com dado(s) de Entrada do usuário;
- print: imprime um texto de Saída (Output), pulando linha.
'''
#Função útil para o calculo do imposto (baseado nas aliquotas)
 def calcular imposto(salario):
 aliquota = 0.00
 if (salario >= 0 and salario <= 1100):
    aliquota = 0.05
 elif (salario >= 1100.01 and salario <= 2500.00):
    aliquota = 0.10
 else:
    aliquota = 0.15
 return aliquota * salario

#Lê os valores de Entrada:
valor salario = float(input())
valor beneficios = float(input())

#Calcula o imposto através da função "calcular imposto”:
valor_imposto = calcular imposto(valor salario)

#Calcula e imprime a Saída (com 2 casas decimais)
saida = valor_salario - valor_imposto + valor_beneficios
print(f'{saida:.2f)')

**Primeiros passos com Kotlin**
SImplificando a Orientação a Objetos com Kotlin

object ReceitaFederal {
    fun calcularImposto(salario: Double): Double {
    val aliquota = when {
        (salario >= O && salario <= 1100) -> 0.05
        (salario >= 1100.01 && salario <= 2500) -> 0.10
        else -> 0.15
     } 
    return aliquota * salario
    }
}
fun main() {
    val valorSalario = readLine()!!.toDouble();
    val valorBeneficios = readLine()!!.toDouble();

    val valorImposto = ReceitaFederal.calcularImposto(valorSalario);
    val saida = valorSalario - valorImposto + valorBeneficios;

    println(string.format("%.2f", saida)); 
}