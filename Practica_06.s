// Autor: Milka Guadalupe Montes Domínguez
// Fecha: 05-11-2024
// Descripción: Suma de los primeros N números naturales en ARM64

    .section .data
result: .asciz "La suma de los primeros %d números naturales es: %d\n"

    .section .text
    .global _start

_start:
    // Definimos el valor de N (número de términos)
    mov x0, #10             // N = 10 (calcularemos la suma de los primeros 10 números naturales)
    
    // Inicializamos los registros
    mov x1, #0              // x1 acumulará la suma, comenzamos en 0
    mov x2, #1              // x2 será el contador, comenzando en 1

loop:
    // Verificamos si el contador ha llegado a N
    cmp x2, x0              // Comparamos x2 (contador) con x0 (N)
    bgt end_loop            // Si x2 > N, salimos del bucle

    // Sumamos el valor del contador a la acumulación
    add x1, x1, x2          // x1 = x1 + x2, acumulamos el contador en x1

    // Incrementamos el contador
    add x2, x2, #1          // x2 = x2 + 1

    // Repetimos el bucle
    b loop

end_loop:
    // Preparación para imprimir el resultado
    mov x2, x1              // x2 contiene la suma final
    ldr x0, =result         // Mensaje para imprimir (la cadena en .data)
    mov x1, #10             // Valor de N para mostrar en printf

    // Llamada a la función printf
    bl printf               // Llamamos a printf

    // Salir del programa
    mov x8, #93             // Código de salida para syscall exit en ARM64
    mov x0, #0              // Código de retorno 0
    svc #0                  // Llamada al sistema
