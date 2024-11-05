// Autor: Milka Guadalupe Montes Domínguez
// Fecha: 05-11-2024
// Descripción: Cálculo de la serie de Fibonacci hasta el N-ésimo término en ARM64

    .section .data
result: .asciz "Fibonacci(%d): %d\n"

    .section .text
    .global _start

_start:
    // Definimos el valor de N (número de términos de la serie)
    mov x0, #10             // N = 10 (calcularemos los primeros 10 términos de Fibonacci)

    // Inicializamos los primeros términos de Fibonacci
    mov x1, #0              // F(0) = 0
    mov x2, #1              // F(1) = 1
    mov x3, #2              // Contador, comenzando en 2 (ya tenemos los primeros dos términos)

print_fib_0_1:
    // Imprimir F(0) y F(1) antes del bucle, ya que están inicializados
    mov x8, #64             // Código de impresión para printf
    ldr x0, =result         // Mensaje para imprimir "Fibonacci(%d): %d"
    mov x1, #0              // Primer término (0)
    mov x2, #0              // F(0) = 0
    bl printf               // Llamamos a printf

    ldr x0, =result         // Mensaje para imprimir
    mov x1, #1              // Segundo término (1)
    mov x2, #1              // F(1) = 1
    bl printf               // Llamamos a printf

fibonacci_loop:
    // Verificamos si hemos alcanzado el N-ésimo término
    cmp x3, x0              // Comparamos el contador con N
    bge end_fibonacci       // Si el contador >= N, salimos del bucle

    // Calculamos el siguiente término de Fibonacci
    add x4, x1, x2          // x4 = x1 + x2, siguiente término en la serie

    // Preparación para imprimir el término actual
    ldr x0, =result         // Mensaje para imprimir "Fibonacci(%d): %d"
    mov x1, x3              // Índice actual en la serie
    mov x2, x4              // Valor actual de Fibonacci

    bl printf               // Llamamos a printf

    // Actualizamos los valores para el siguiente ciclo
    mov x1, x2              // x1 toma el valor anterior de x2 (F(n-1))
    mov x2, x4              // x2 toma el valor de x4 (F(n))
    add x3, x3, #1          // Incrementamos el contador

    // Repetimos el bucle
    b fibonacci_loop

end_fibonacci:
    // Salir del programa
    mov x8, #93             // Código de salida para syscall exit en ARM64
    mov x0, #0              // Código de retorno 0
    svc #0                  // Llamada al sistema
