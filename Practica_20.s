// Autor: Milka Guadalupe Montes Domínguez
// Fecha: 10-11-24
// Descripción: Multiplicación de dos matrices utilizando instrucciones NEON en ARM64
// Asciinema: https://asciinema.org/a/690604

.section .data
    // Declarar matrices de ejemplo (puedes cambiar los valores)
    matrix_a: .float 1.0, 2.0, 3.0, 4.0    // Matriz A (2x2)
    matrix_b: .float 5.0, 6.0, 7.0, 8.0    // Matriz B (2x2)
    matrix_c: .space 16                     // Espacio para Matriz C (2x2)

.section .text
.global _start

_start:
    // Inicializar argumentos
    ldr     X0, =matrix_a         // Dirección de la matriz A
    ldr     X1, =matrix_b         // Dirección de la matriz B
    ldr     X2, =matrix_c         // Dirección de la matriz C
    mov     W3, #2                // Número de filas de A
    mov     W4, #2                // Número de columnas de A / filas de B
    mov     W5, #2                // Número de columnas de B

    // Llamar a la función de multiplicación
    bl      matrix_multiply

    // Salir del programa
    mov     X8, #93               // syscall: exit
    mov     X0, #0                // Código de salida 0
    svc     #0                    // Llamada al sistema

matrix_multiply:
    // Verificar si las dimensiones son válidas
    cbz     W3, end             // Si m (filas de A) es 0, salir
    cbz     W4, end             // Si n (columnas de A) es 0, salir
    cbz     W5, end             // Si p (columnas de B) es 0, salir

    mov     X6, X0              // Dirección base de A
    mov     X7, X2              // Dirección base de C

loop_rows:                       // Bucle sobre las filas de A
    mov     X8, X1              // Reiniciar la dirección base de B
    mov     W9, W5              // Reiniciar contador de columnas de B

loop_columns:                    // Bucle sobre las columnas de B
    dup     V0.4S, WZR          // Inicializar acumulador a 0 (vector de 4 floats)
    mov     W10, W4             // Reiniciar contador de elementos de la fila/columna
    mov     X11, X6             // Dirección base de la fila actual de A
    mov     X12, X8             // Dirección base de la columna actual de B

loop_elements:                   // Bucle sobre los elementos de la fila de A y columna de B
    ld1     {V1.4S}, [X11], #16 // Cargar 4 floats de A
    ld1     {V2.4S}, [X12], #16 // Cargar 4 floats de B
    fmla    V0.4S, V1.4S, V2.4S // Acumular el producto de A y B
    sub     W10, W10, #4        // Decrementar el contador
    cbnz    W10, loop_elements  // Continuar hasta completar la fila/columna

    st1     {V0.4S}, [X7], #16  // Almacenar el resultado en C
    add     X8, X8, #16         // Mover a la siguiente columna de B
    sub     W9, W9, #1          // Decrementar el contador de columnas de B
    cbnz    W9, loop_columns    // Continuar hasta completar las columnas

    add     X6, X6, #16         // Mover a la siguiente fila de A
    sub     W3, W3, #1          // Decrementar el contador de filas de A
    cbnz    W3, loop_rows       // Continuar hasta completar las filas

end:
    ret                         // Finalizar
