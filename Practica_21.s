// Autor: Milka Guadalupe Montes Domínguez
// Fecha: 10-11-24
// Descripción: Transposición de una matriz 3x3 en ARM64
// Asciinema: https://asciinema.org/a/689385

    .section .data
matrizA: .word 1, 2, 3, 4, 5, 6, 7, 8, 9   // Matriz original de 3x3
transpuesta: .space 36                     // Espacio para la matriz transpuesta (3x3)

msg_resultado: .asciz "Matriz transpuesta:\n%d %d %d\n%d %d %d\n%d %d %d\n"

    .section .text
    .global _start

_start:
    // Cargar las direcciones de las matrices
    ldr x0, =matrizA           // x0 apunta al inicio de matrizA
    ldr x1, =transpuesta       // x1 apunta al inicio de la matriz transpuesta

    // Definir el tamaño de la matriz (3x3)
    mov w2, #3                 // Tamaño de la matriz (3)

    // Bucle para recorrer filas de matrizA
    mov w3, #0                 // Índice de fila de la matriz original
fila_loop:
    cmp w3, w2                 // Comparar con el tamaño de la matriz
    bge print_resultado        // Si hemos procesado todas las filas, salimos

    // Bucle para recorrer columnas de matrizA
    mov w4, #0                 // Índice de columna de la matriz original
columna_loop:
    cmp w4, w2                 // Comparar con el tamaño de la matriz
    bge next_fila              // Si hemos procesado todas las columnas, pasar a la siguiente fila

    // Calcular el índice de matrizA en la posición (fila, columna)
    mul x5, x3, x2             // x5 = fila * tamaño (desplazamiento de la fila)
    add x5, x5, x4             // x5 = fila * tamaño + columna (índice de matrizA)

    // Calcular el índice de la posición transpuesta (columna, fila)
    mul x6, x4, x2             // x6 = columna * tamaño (desplazamiento de la columna en transpuesta)
    add x6, x6, x3             // x6 = columna * tamaño + fila (índice de transpuesta)

    // Cargar el valor de matrizA y almacenar en la posición transpuesta
    ldr w7, [x0, x5, LSL #2]   // Cargar matrizA[fila][columna] en w7
    str w7, [x1, x6, LSL #2]   // Guardar en transpuesta[columna][fila]

    // Incrementar columna
    add w4, w4, #1
    b columna_loop             // Repetir el bucle para la siguiente columna

next_fila:
    // Incrementar fila
    add w3, w3, #1
    b fila_loop                // Repetir el bucle para la siguiente fila

print_resultado:
    // Preparación para imprimir la matriz transpuesta
    ldr x0, =msg_resultado     // Cargar el mensaje de la matriz transpuesta
    ldr w1, [x1]               // Cargar transpuesta[0][0] en w1
    ldr w2, [x1, #4]           // Cargar transpuesta[0][1] en w2
    ldr w3, [x1, #8]           // Cargar transpuesta[0][2] en w3
    ldr w4, [x1, #12]          // Cargar transpuesta[1][0] en w4
    ldr w5, [x1, #16]          // Cargar transpuesta[1][1] en w5
    ldr w6, [x1, #20]          // Cargar transpuesta[1][2] en w6
    ldr w7, [x1, #24]          // Cargar transpuesta[2][0] en w7
    ldr w8, [x1, #28]          // Cargar transpuesta[2][1] en w8
    ldr w9, [x1, #32]          // Cargar transpuesta[2][2] en w9

    // Llamada a printf para mostrar la matriz transpuesta
    bl printf                  // Llamada a printf para mostrar la matriz

    // Salir del programa
    mov x8, #93                // Código de salida para syscall exit en ARM64
    mov x0, #0                 // Código de retorno 0
    svc #0                     // Llamada al sistema
