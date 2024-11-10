// Autor: Milka Guadalupe Montes Domínguez
// Fecha: 10-11-24
// Descripción: Multiplicación de dos matrices 3x3 en ARM64

    .section .data
matrizA: .word 1, 2, 3, 4, 5, 6, 7, 8, 9   // Matriz A de 3x3
matrizB: .word 9, 8, 7, 6, 5, 4, 3, 2, 1   // Matriz B de 3x3
resultado: .space 36                       // Matriz de resultados (3x3)

msg_resultado: .asciz "Resultado de la multiplicacion de matrices:\n%d %d %d\n%d %d %d\n%d %d %d\n"

    .section .text
    .global _start

_start:
    // Cargar las direcciones de las matrices
    ldr x0, =matrizA           // x0 apunta al inicio de matrizA
    ldr x1, =matrizB           // x1 apunta al inicio de matrizB
    ldr x2, =resultado         // x2 apunta al inicio de la matriz resultado

    // Definir el tamaño de la matriz
    mov w8, #3                 // Tamaño de la matriz (3x3)

    // Bucle para recorrer filas de matrizA
    mov w3, #0                 // Índice de fila de la matriz resultado
fila_loop:
    cmp w3, w8                 // Comparar con el tamaño de la matriz
    bge print_resultado        // Si hemos procesado todas las filas, salimos

    // Bucle para recorrer columnas de matrizB
    mov w4, #0                 // Índice de columna de la matriz resultado
columna_loop:
    cmp w4, w8                 // Comparar con el tamaño de la matriz
    bge next_fila              // Si hemos procesado todas las columnas, pasar a la siguiente fila

    // Inicializar el acumulador de la suma para el elemento de la matriz resultado
    mov w5, #0                 // Acumulador para la suma

    // Bucle interno para realizar el producto y suma de la fila de A y columna de B
    mov w6, #0                 // Índice k para el producto fila x columna
producto_suma:
    cmp w6, w8                 // Comparar k con el tamaño de la matriz
    bge almacenar_resultado    // Si k == tamaño, hemos terminado la suma para este elemento

    // Cargar el elemento de matrizA en la posición [fila][k]
    mul w7, w3, w8             // w7 = fila * tamaño (desplazamiento de la fila)
    add w7, w7, w6             // w7 = fila * tamaño + k (índice para matrizA)
    ldr w9, [x0, w7, LSL #2]   // Cargar matrizA[fila][k] en w9

    // Cargar el elemento de matrizB en la posición [k][columna]
    mul w10, w6, w8            // w10 = k * tamaño (desplazamiento de la fila en matrizB)
    add w10, w10, w4           // w10 = k * tamaño + columna (índice para matrizB)
    ldr w11, [x1, w10, LSL #2] // Cargar matrizB[k][columna] en w11

    // Multiplicar y acumular el resultado
    mul w12, w9, w11           // w12 = matrizA[fila][k] * matrizB[k][columna]
    add w5, w5, w12            // Acumular en w5

    // Incrementar k para el siguiente elemento de la fila y columna
    add w6, w6, #1
    b producto_suma            // Repetir el bucle de producto y suma

almacenar_resultado:
    // Almacenar el resultado en la matriz resultado en la posición [fila][columna]
    mul w7, w3, w8             // w7 = fila * tamaño (desplazamiento de la fila en resultado)
    add w7, w7, w4             // w7 = fila * tamaño + columna (índice para resultado)
    str w5, [x2, w7, LSL #2]   // Guardar el acumulador w5 en resultado[fila][columna]

    // Incrementar columna
    add w4, w4, #1
    b columna_loop             // Repetir el bucle para la siguiente columna

next_fila:
    // Incrementar fila
    add w3, w3, #1
    b fila_loop                // Repetir el bucle para la siguiente fila

print_resultado:
    // Preparación para imprimir la matriz resultado
    ldr x0, =msg_resultado     // Cargar el mensaje de resultado
    ldr w1, [x2]               // Cargar resultado[0][0] en w1
    ldr w2, [x2, #4]           // Cargar resultado[0][1] en w2
    ldr w3, [x2, #8]           // Cargar resultado[0][2] en w3
    ldr w4, [x2, #12]          // Cargar resultado[1][0] en w4
    ldr w5, [x2, #16]          // Cargar resultado[1][1] en w5
    ldr w6, [x2, #20]          // Cargar resultado[1][2] en w6
    ldr w7, [x2, #24]          // Cargar resultado[2][0] en w7
    ldr w8, [x2, #28]          // Cargar resultado[2][1] en w8
    ldr w9, [x2, #32]          // Cargar resultado[2][2] en w9

    // Llamada a printf para mostrar la matriz resultado
    bl printf                  // Llamada a printf para mostrar la matriz

    // Salir del programa
    mov x8, #93                // Código de salida para syscall exit en ARM64
    mov x0, #0                 // Código de retorno 0
    svc #0                     // Llamada al sistema
