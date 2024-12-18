// Autor: Milka Guadalupe Montes Domínguez
// Fecha: 05-11-2024
// Descripción: Multiplicación de dos números en ARM64
// Asciinema: https://asciinema.org/a/687759

    .section .data
result: .asciz "El producto es: %d\n"

    .section .text
    .global _start

_start:
    // Asignamos los valores para la multiplicación
    mov x0, #6              // Primer factor (ejemplo: 6)
    mov x1, #7              // Segundo factor (ejemplo: 7)

    // Realizamos la multiplicación
    mul x2, x0, x1          // x2 = x0 * x1, almacena el resultado en x2

    // Preparación para imprimir el resultado
    mov x1, x2              // Guardamos el resultado en x1 para la llamada a printf
    ldr x0, =result         // Mensaje para imprimir (la cadena en .data)

    // Llamada a la función printf
    bl printf               // Llamamos a printf

    // Salir del programa
    mov x8, #93             // Código de salida para syscall exit en ARM64
    mov x0, #0              // Código de retorno 0
    svc #0                  // Llamada al sistema
