// Autor: Milka Guadalupe Montes Domínguez
// Fecha: 05-11-2024
// Descripción: Verificación de si un número es primo en ARM64
// Asciinema: https://asciinema.org/a/688536

    .section .data
msg_prime: .asciz "El número %d es primo.\n"
msg_not_prime: .asciz "El número %d no es primo.\n"

    .section .text
    .global _start

_start:
    // Definimos el número que queremos verificar
    mov x0, #29             // Número a verificar (ejemplo: 29)
    mov x1, x0              // Guardamos el número original en x1 para imprimirlo después

    // Casos especiales para los números 0, 1 y 2
    cmp x0, #2
    blt not_prime           // Si x0 < 2, no es primo
    beq prime               // Si x0 == 2, es primo

    // Inicializamos el divisor en 2
    mov x2, #2

check_divisors:
    // Comprobamos si x2 * x2 > x0 para optimizar la verificación hasta sqrt(x0)
    mul x3, x2, x2          // x3 = x2 * x2
    cmp x3, x0              // Si x2 * x2 > x0, ya no necesitamos más divisores
    bgt prime               // Saltamos a "prime" si x2 * x2 > x0

    // Verificamos si el número es divisible por x2
    udiv x4, x0, x2         // x4 = x0 / x2
    msub x3, x4, x2, x0     // x3 = x0 - (x4 * x2), calcula el residuo de x0 / x2
    cbz x3, not_prime       // Si el residuo es 0, x0 es divisible por x2 (no es primo)

    // Incrementamos el divisor y continuamos el bucle
    add x2, x2, #1          // Incrementamos el divisor
    b check_divisors        // Repetimos el bucle

prime:
    // Preparación para imprimir que el número es primo
    ldr x0, =msg_prime      // Mensaje de número primo
    mov x2, x1              // Número a mostrar en printf
    bl printf               // Llamada a printf
    b end_program           // Saltamos al final del programa

not_prime:
    // Preparación para imprimir que el número no es primo
    ldr x0, =msg_not_prime  // Mensaje de número no primo
    mov x2, x1              // Número a mostrar en printf
    bl printf               // Llamada a printf

end_program:
    // Salir del programa
    mov x8, #93             // Código de salida para syscall exit en ARM64
    mov x0, #0              // Código de retorno 0
    svc #0                  // Llamada al sistema
