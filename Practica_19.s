// Autor: Milka Guadalupe Montes Domínguez
// Fecha: 10-11-24
// Descripción: Suma de dos matrices 3x3 en ARM64
// Asciinema: https://asciinema.org/a/688623

    .section .data
matrizA: .word 1, 2, 3, 4, 5, 6, 7, 8, 9      // Matriz A de 3x3
matrizB: .word 9, 8, 7, 6, 5, 4, 3, 2, 1      // Matriz B de 3x3
resultado: .space 36                          // Matriz de resultados (3x3)

msg_resultado: .asciz "Resultado de la suma de matrices:\n%d %d %d\n%d %d %d\n%d %d %d\n"

    .section .text
    .global _start

_start:
    // Cargar las direcciones de las matrices
    ldr x0, =matrizA           // x0 apunta al inicio de matrizA
    ldr x1, =matrizB           // x1 apunta al inicio de matrizB
    ldr x2, =resultado         // x2 apunta al inicio de la matriz resultado

    // Definir el tamaño de la matriz
    mov w3, #9                 // Número de elementos (3x3 = 9)

suma_loop:
    // Verificar si hemos procesado todos los elementos
    cbz w3, print_resultado    // Si w3 es 0, terminamos el bucle

    // Cargar el elemento de matrizA y matrizB
    ldr w4, [x0], #4           // Cargar siguiente elemento de matrizA en w4 y avanzar puntero
    ldr w5, [x1], #4           // Cargar siguiente elemento de matrizB en w5 y avanzar puntero

    // Realizar la suma y almacenar en la matriz resultado
    add w6, w4, w5             // w6 = w4 + w5
    str w6, [x2], #4           // Almacenar el resultado en la matriz resultado y avanzar puntero

    // Decrementar el contador de elementos y repetir el bucle
    sub w3, w3, #1
    b suma_loop

print_resultado:
    // Preparación para imprimir la matriz resultado
    ldr x0, =msg_resultado     // Cargar el mensaje de resultado
    ldr w1, [x2, #-36]         // Cargar resultado[0][0] en w1
    ldr w2, [x2, #-32]         // Cargar resultado[0][1] en w2
    ldr w3, [x2, #-28]         // Cargar resultado[0][2] en w3
    ldr w4, [x2, #-24]         // Cargar resultado[1][0] en w4
    ldr w5, [x2, #-20]         // Cargar resultado[1][1] en w5
    ldr w6, [x2, #-16]         // Cargar resultado[1][2] en w6
    ldr w7, [x2, #-12]         // Cargar resultado[2][0] en w7
    ldr w8, [x2, #-8]          // Cargar resultado[2][1] en w8
    ldr w9, [x2, #-4]          // Cargar resultado[2][2] en w9

    // Llamada a printf para mostrar la matriz resultado
    bl printf                  // Llamada a printf para mostrar la matriz

    // Salir del programa
    mov x8, #93                // Código de salida para syscall exit en ARM64
    mov x0, #0                 // Código de retorno 0
    svc #0                     // Llamada al sistema
