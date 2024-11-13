// Autor: Milka Guadalupe Montes Domínguez
// Fecha: 05-11-2024
// Descripción: Convertir temperatura de Celsius a Fahrenheit
// Fórmula: Fahrenheit = (Celsius * 9 / 5) + 32
// Asciinema: https://asciinema.org/a/687672

    .section .data
result: .asciz "Temperatura en Fahrenheit: %d\n"

    .section .text
    .global _start

_start:
    // Supongamos que el valor de la temperatura en Celsius está en el registro x0.
    // Ejemplo: mov x0, #25 ; 25 grados Celsius
    mov x0, #25             // Temperatura en Celsius (ejemplo 25 °C)
    
    // Convertimos Celsius a Fahrenheit usando la fórmula: (Celsius * 9 / 5) + 32

    // Paso 1: Celsius * 9
    mov x1, #9              // Cargamos el valor 9 en x1
    mul x0, x0, x1          // Multiplicamos Celsius por 9 -> x0 = Celsius * 9

    // Paso 2: (Celsius * 9) / 5
    mov x1, #5              // Cargamos el valor 5 en x1
    udiv x0, x0, x1         // Dividimos (Celsius * 9) entre 5 -> x0 = (Celsius * 9) / 5

    // Paso 3: ((Celsius * 9) / 5) + 32
    add x0, x0, #32         // Sumamos 32 al resultado -> x0 = Fahrenheit

    // Imprimir el resultado
    mov x1, x0              // Guardamos el resultado en x1 para la llamada al sistema
    ldr x0, =result         // Mensaje para imprimir
    mov x2, x1              // Pasamos el valor en Fahrenheit como argumento

    // Llamada a la función printf
    bl printf               // Llamamos a printf

    // Salir del programa
    mov x8, #93             // Código de salida para syscall exit en ARM64
    mov x0, #0              // Código de retorno 0
    svc #0                  // Llamada al sistema
