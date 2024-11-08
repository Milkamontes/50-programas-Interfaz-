// Autor: Milka Guadalupe Montes Domínguez
// Fecha: 05-11-2024
// Descripción: Cálculo de los primeros N términos de la serie de Fibonacci en ARM64

    .section .data
msg_fib: .asciz "Fibonacci(%d): %d\n"
newline: .asciz "\n"

    .section .text
    .global _start

_start:
    // Definimos el número de términos N de la serie de Fibonacci
    mov x0, #10             // N = 10, queremos los primeros 10 términos

    // Inicializamos los primeros términos de Fibonacci
    mov x1, #0              // F(0) = 0
    mov x2, #1              // F(1) = 1
    mov x3, #2              // Contador, comenzando en 2 (ya tenemos los primeros dos términos)

    // Imprimir F(0)
    mov x4, #1              // Descriptor de archivo (stdout)
    ldr x5, =msg_fib
    mov x6, #0              // Índice para F(0)
    mov x7, x1              // Valor F(0)
    bl print_fibonacci

    // Imprimir F(1)
    mov x6, #1              // Índice para F(1)
    mov x7, x2              // Valor F(1)
    bl print_fibonacci

fibonacci_loop:
    // Comprobar si el contador ha alcanzado N
    cmp x3, x0
    bge end_fibonacci       // Si x3 >= N, detenemos el bucle

    // Calcular el siguiente número de Fibonacci
    add x8, x1, x2          // x8 = x1 + x2, próximo término

    // Preparación para imprimir el término actual
    mov x6, x3              // Índice actual
    mov x7, x8              // Valor actual de Fibonacci
    bl print_fibonacci      // Llamada a función para imprimir

    // Actualizar valores para el siguiente ciclo
    mov x1, x2              // F(n-1) = F(n)
    mov x2, x8              // F(n) = nuevo término
    add x3, x3, #1          // Incrementar el contador

    // Repetir el bucle
    b fibonacci_loop

end_fibonacci:
    // Salir del programa
    mov x8, #93             // syscall exit
    mov x0, #0              // Código de retorno 0
    svc #0                  // Llamada al sistema

// Subrutina para imprimir el valor de Fibonacci actual
print_fibonacci:
    ldr x0, =msg_fib
    mov x1, x6              // Índice
    mov x2, x7              // Valor de Fibonacci
    mov x8, #64             // syscall write
    svc #0
    ret
