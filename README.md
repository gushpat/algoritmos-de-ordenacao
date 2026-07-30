# Algoritmos de Ordenação

Uma coleção completa dos algoritmos de ordenação **Bubble Sort**, **Selection Sort**, **Insertion Sort**, **Merge Sort**, **Quick Sort**, **Heap Sort**, **Shell Sort**, **Counting Sort**, **Radix Sort** e **Bucket Sort** implementados em **13 linguagens de programação**.

Cada implementação gera um vetor de números aleatórios, permite escolher o algoritmo via menu interativo e exibe o resultado ordenado.

## Estrutura do Repositório

```
algoritmos-de-ordenacao/
├── Ada/          → main.adb
├── Assembly/     → main.asm (Sega Mega Drive / 68000)
├── C/            → main.c
├── C++/          → main.cpp
├── C#/           → Program.cs
├── CSS/          → index.html (visualização interativa)
├── Dart/         → main.dart
├── Java/         → src/Aplic.java
├── JavaScript/   → main.js
├── Lua/          → main.lua
├── Pascal/       → algoritmodeordenacao.pas
├── PHP/          → index.php
├── TypeScript/   → main.ts
└── README.md
```

## Como Compilar e Executar

### Java
```
javac Java/AlgoritmosdeOrdenacao/src/Aplic.java -d Java/AlgoritmosdeOrdenacao/build
java -cp Java/AlgoritmosdeOrdenacao/build Aplic
```
- **Compilador:** [JDK](https://www.oracle.com/java/technologies/downloads/)

### Pascal
```
fpc Pascal/AlgoritmosdeOrdenacao/algoritmodeordenacao.pas
./Pascal/AlgoritmosdeOrdenacao/algoritmodeordenacao
```
- **Compilador:** [Free Pascal](https://www.freepascal.org/)

### Ada
```
gnatmake Ada/AlgoritmosdeOrdenacao/main.adb -D Ada/AlgoritmosdeOrdenacao/
./Ada/AlgoritmosdeOrdenacao/main
```
- **Compilador:** [GNAT (AdaCore)](https://www.adacore.com/download/)

### C
```
gcc C/AlgoritmosdeOrdenacao/main.c -o C/AlgoritmosdeOrdenacao/main -lm
./C/AlgoritmosdeOrdenacao/main
```
- **Compilador:** [GCC](https://gcc.gnu.org/)

### C++
```
g++ C++/AlgoritmosdeOrdenacao/main.cpp -o C++/AlgoritmosdeOrdenacao/main
./C++/AlgoritmosdeOrdenacao/main
```
- **Compilador:** [G++](https://gcc.gnu.org/)

### C#
```
csc C#/AlgoritmosdeOrdenacao/Program.cs -out:C#/AlgoritmosdeOrdenacao/Program.exe
./C#/AlgoritmosdeOrdenacao/Program.exe
```
- **Compilador:** [.NET SDK](https://dotnet.microsoft.com/download) ou Mono C#


### Dart
```
dart run Dart/AlgoritmosdeOrdenacao/main.dart
```
- **SDK:** [Dart](https://dart.dev/get-dart)

### JavaScript (Node.js)
```
node JavaScript/AlgoritmosdeOrdenacao/main.js
```
- **Runtime:** [Node.js](https://nodejs.org/)

### Lua
```
lua Lua/AlgoritmosdeOrdenacao/main.lua
```
- **Runtime:** [Lua](https://www.lua.org/download.html)

### PHP (CLI)
```
php PHP/AlgoritmosdeOrdenacao/index.php
```
- **Runtime:** [PHP](https://www.php.net/downloads)

### TypeScript
```
# Compilar:
npx tsc TypeScript/AlgoritmosdeOrdenacao/main.ts --outDir TypeScript/AlgoritmosdeOrdenacao/build

# Executar:
node TypeScript/AlgoritmosdeOrdenacao/build/main.js
```
- **Compilador:** [TypeScript](https://www.typescriptlang.org/download)

### Assembly (Sega Mega Drive / Genesis - 68000)
```
# Montar com vasm:
vasmm68k_mot -Fbin -o rom.bin Assembly/AlgoritmosdeOrdenacao/main.asm

# Executar em emulador:
# - Kega Fusion: File → Load ROM → rom.bin
# - Gens: File → Open ROM → rom.bin
# - RetroArch: Load Content → rom.bin → Genesis Plus GX core
```
- **Montador:** [vasm](http://sun.hasenbraten.de/vasm/)
- **Emuladores:** Kega Fusion, Gens, RetroArch + Genesis Plus GX
- **Controles:** Setas (navegar menu), A (selecionar algoritmo), B (gerar novo vetor)

## Algoritmos Implementados

| # | Algoritmo    | Tipo          | Complexidade Média | Estável |
|---|-------------|---------------|-------------------|---------|
| 1 | Bubble Sort | Comparação    | O(n²)             | Sim     |
| 2 | Selection Sort | Comparação | O(n²)             | Não     |
| 3 | Insertion Sort | Comparação | O(n²)             | Sim     |
| 4 | Merge Sort  | Comparação    | O(n log n)        | Sim     |
| 5 | Quick Sort  | Comparação    | O(n log n)        | Não     |
| 6 | Heap Sort   | Comparação    | O(n log n)        | Não     |
| 7 | Shell Sort  | Comparação    | O(n log n)*       | Não     |
| 8 | Counting Sort | Não-comp.   | O(n + k)          | Sim     |
| 9 | Radix Sort  | Não-comp.     | O(d × n)          | Sim     |
| 10| Bucket Sort | Não-comp.     | O(n + k)*         | Sim     |

## Licença

Este projeto está licenciado sob a licença MIT - veja o arquivo [LICENSE](LICENSE) para detalhes.
