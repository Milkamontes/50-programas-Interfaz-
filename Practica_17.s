// Autor: Milka Guadalupe Montes Domínguez
// Fecha: 10-11-24
// Descripción: Ordenamiento por selección de un arreglo de enteros en ARM64

    .section .data
arreglo: .word 25, 10, 48, 3, 5, 30        // Arreglo desordenado de números enteros
tamano: .word 6                            // Tamaño del arreglo
msg_resultado: .asciz "Arreglo ordenado:\n" // Mensaje para resultado
msg_elemento: .asciz "%d "                 // Formato para imprimir cada elemento

    .section .text
    .global _start

_start:
    // Cargar el tamaño del arreglo
    ldr x1, =tamano            // Dirección del tamaño
    ldr w1, [x1]               // Tamaño del arreglo en w1

    // Validar que el tamaño del arreglo sea mayor a 0
    cmp w1, #0
    ble end_program            // Si tamaño <= 0, terminar el programa

    // Cargar la dirección del arreglo
    ldr x2, =arreglo           // x2 apunta al inicio del arreglo

selection_sort:
    mov w3, #0                 // Índice externo para el bucle

outer_loop:
    cmp w3, w1                 // Comparar índice externo con el tamaño
    bge print_resultado        // Si hemos recorrido todo el arreglo, pasamos a imprimir

    mov w4, w3                 // Inicializar índice mínimo (w4) con w3
    ldr w5, [x2, w3, LSL #2]   // Valor mínimo actual

    mov w6, w3                 // Inicializar índice interno
    add w6, w6, #1             // Comenzar en el siguiente elemento

inner_loop:
    cmp w6, w1                 // Verificar si índice interno está dentro del rango
    bge swap_min               // Si hemos terminado, pasar al intercambio

    ldr w7, [x2, w6, LSL #2]   // Cargar arreglo[w6] en w7
    cmp w7, w5                 // Comparar con el mínimo actual
    bge skip_update            // Si arreglo[w6] >= mínimo actual, no actualizar

    mov w4, w6                 // Actualizar índice mínimo
    mov w5, w7                 // Actualizar valor mínimo

skip_update:
    add w6, w6, #1             // Incrementar índice interno
    b inner_loop               // Repetir el bucle interno

swap_min:
    cmp w4, w3                 // Comprobar si el índice mínimo es el mismo
    beq skip_swap              // Si no hay cambio, saltar intercambio

    ldr w8, [x2, w3, LSL #2]   // Cargar arreglo[w3] en w8
    str w5, [x2, w3, LSL #2]   // Guardar el valor mínimo en arreglo[w3]
    str w8, [x2, w4, LSL #2]   // Guardar arreglo[w3] en arreglo[w4]

skip_swap:
    add w3, w3, #1             // Incrementar índice externo
    b outer_loop               // Repetir el bucle externo

print_resultado:
    ldr x0, =msg_resultado     // Mensaje inicial
    bl printf                  // Imprimir mensaje

    mov w3, #0                 // Inicializar índice para impresión

print_loop:
    cmp w3, w1                 // Verificar si índice está dentro del rango
    bge end_program            // Si hemos terminado, salir

    ldr w4, [x2, w3, LSL #2]   // Cargar elemento actual en w4
    ldr x0, =msg_elemento      // Formato para imprimir el número
    mov x1, w4                 // Pasar el número como argumento a printf
    bl printf                  // Imprimir el elemento

    add w3, w3, #1             // Incrementar índice
    b print_loop               // Repetir el bucle de impresión

end_program:
    mov x8, #93                // syscall: exit
    mov x0, #0                 // Código de salida
    svc #0                     // Llamada al sistema
