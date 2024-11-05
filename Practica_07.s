// Autor: Milka Guadalupe Montes Domínguez
// Fecha: 05-11-2024
// Descripción: Cálculo del factorial de un número en ARM64

    .section .data
result: .asciz "El factorial de %d es: %d\n"

    .section .text
    .global _start

_start:
    // Definimos el valor de N (el número al que queremos calcular el factorial)
    mov x0, #5              // N = 5 (por ejemplo, queremos calcular 5!)

    // Inicializamos los registros
    mov x1, x0              // Guardamos el valor de N en x1 para imprimirlo después
    mov x2, #1              // x2 será el acumulador para el factorial, iniciamos en 1
    mov x3, #1              // x3 será el contador, comenzando en 1

factorial_loop:
    // Verificamos si el contador ha llegado a N
    cmp x3, x0              // Comparamos x3 (contador) con x0 (N)
    bgt end_factorial       // Si x3 > N, salimos del bucle

    // Multiplicamos el acumulador por el contador
    mul x2, x2, x3          // x2 = x2 * x3, actualizamos el acumulador

    // Incrementamos el contador
    add x3, x3, #1          // x3 = x3 + 1

    // Repetimos el bucle
    b factorial_loop

end_factorial:
    // Preparación para imprimir el resultado
    mov x0, result          // Mensaje para imprimir (la cadena en .data)
    mov x1, x1              // Valor de N para mostrar en printf
    mov x2, x2              // Factorial calculado para mostrar en printf

    // Llamada a la función printf
    bl printf               // Llamamos a printf

    // Salir del programa
    mov x8, #93             // Código de salida para syscall exit en ARM64
    mov x0, #0              // Código de retorno 0
    svc #0                  // Llamada al sistema
