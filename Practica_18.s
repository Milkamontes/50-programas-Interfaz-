// Autor: Milka Guadalupe Montes Domínguez
// Fecha: 10-11-24
// Descripción: Ordenamiento por mezcla (Merge Sort) de un arreglo de enteros en ARM64

    .section .data
arreglo: .word 25, 10, 48, 3, 5, 30      // Arreglo desordenado de números enteros
tamano: .word 6                          // Tamaño del arreglo
temp: .space 24                          // Espacio temporal para mezclar elementos (6 elementos * 4 bytes)
msg_resultado: .asciz "Arreglo ordenado: %d %d %d %d %d %d\n"

    .section .text
    .global _start

_start:
    // Cargar el tamaño del arreglo
    ldr x1, =tamano            // Dirección del tamaño
    ldr w1, [x1]               // Cargar el tamaño en w1

    // Cargar la dirección del arreglo
    ldr x2, =arreglo           // x2 apunta al inicio del arreglo
    ldr x3, =temp              // x3 apunta al arreglo temporal

    // Llamar a merge_sort
    mov w4, #0                 // Índice inicial (0)
    sub w5, w1, #1             // Índice final (tamaño - 1)
    bl merge_sort              // Llamada a merge_sort(arreglo, temp, 0, tamaño - 1)

    // Preparación para imprimir el arreglo ordenado
    ldr x0, =msg_resultado     // Cargar el mensaje del arreglo ordenado
    ldr w1, [x2]               // Cargar arreglo[0] en w1
    ldr w2, [x2, #4]           // Cargar arreglo[1] en w2
    ldr w3, [x2, #8]           // Cargar arreglo[2] en w3
    ldr w4, [x2, #12]          // Cargar arreglo[3] en w4
    ldr w5, [x2, #16]          // Cargar arreglo[4] en w5
    ldr w6, [x2, #20]          // Cargar arreglo[5] en w6

    // Llamada a printf para mostrar el arreglo ordenado
    bl printf                  // Llamada a printf para mostrar el arreglo

    // Salir del programa
    mov x8, #93                // Código de salida para syscall exit en ARM64
    mov x0, #0                 // Código de retorno 0
    svc #0                     // Llamada al sistema

// Subrutina: merge_sort
// Parámetros:
//   x2: puntero al arreglo
//   x3: puntero al arreglo temporal
//   w4: índice inicial
//   w5: índice final
merge_sort:
    cmp w4, w5                 // Si inicio >= fin, retorno (caso base)
    bge end_merge_sort

    // Calcular el índice medio
    add w6, w4, w5             // w6 = inicio + fin
    lsr w6, w6, #1             // w6 = (inicio + fin) / 2

    // Ordenar la mitad izquierda
    mov w7, w4                 // w7 = inicio
    mov w8, w6                 // w8 = medio
    bl merge_sort              // Llamada recursiva a merge_sort(arreglo, temp, inicio, medio)

    // Ordenar la mitad derecha
    add w7, w6, #1             // w7 = medio + 1
    mov w8, w5                 // w8 = fin
    bl merge_sort              // Llamada recursiva a merge_sort(arreglo, temp, medio + 1, fin)

    // Fusionar ambas mitades
    mov w7, w4                 // w7 = inicio
    mov w8, w6                 // w8 = medio
    add w9, w6, #1             // w9 = medio + 1
    mov w10, w5                // w10 = fin
    bl merge                   // Llamada a merge(arreglo, temp, inicio, medio, fin)

end_merge_sort:
    ret

// Subrutina: merge
// Parámetros:
//   x2: puntero al arreglo
//   x3: puntero al arreglo temporal
//   w7: índice de inicio
//   w8: índice medio
//   w10: índice de fin
merge:
    mov w11, w7                // Índice para la mitad izquierda (inicio)
    mov w12, w9                // Índice para la mitad derecha (medio + 1)
    mov w13, #0                // Índice para el arreglo temporal

merge_loop:
    // Fusionar elementos de ambas mitades en el arreglo temporal
    cmp w11, w8                // Comparar índice izquierdo con el medio
    bgt right_remain           // Si el izquierdo ha terminado, fusionar solo la derecha

    cmp w12, w10               // Comparar índice derecho con el fin
    bgt left_remain            // Si el derecho ha terminado, fusionar solo la izquierda

    // Comparar elementos y fusionar
    ldr x14, [x2, x11, LSL #2] // Cargar arreglo[w11]
    ldr x15, [x2, x12, LSL #2] // Cargar arreglo[w12]

    cmp x14, x15               // Comparar arreglo[w11] y arreglo[w12]
    ble use_left               // Si arreglo[w11] <= arreglo[w12], usar el izquierdo

    // Usar el elemento derecho
    str x15, [x3, x13, LSL #2] // temp[w13] = arreglo[w12]
    add x12, x12, #1           // Incrementar índice derecho
    b next_index

use_left:
    // Usar el elemento izquierdo
    str x14, [x3, x13, LSL #2] // temp[w13] = arreglo[w11]
    add x11, x11, #1           // Incrementar índice izquierdo

next_index:
    add x13, x13, #1           // Incrementar índice temporal
    b merge_loop               // Repetir el bucle de fusión

right_remain:
    // Copiar el resto de la mitad derecha
    cmp x12, w10
    bgt copy_to_array

    ldr x15, [x2, x12, LSL #2] // Cargar arreglo[w12]
    str x15, [x3, x13, LSL #2] // temp[w13] = arreglo[w12]
    add x12, x12, #1           // Incrementar índice derecho
    add x13, x13, #1           // Incrementar índice temporal
    b right_remain

left_remain:
    // Copiar el resto de la mitad izquierda
    cmp x11, x8
    bgt copy_to_array

    ldr x14, [x2, x11, LSL #2] // Cargar arreglo[w11]
    str x14, [x3, x13, LSL #2] // temp[w13] = arreglo[w11]
    add x11, x11, #1           // Incrementar índice izquierdo
    add x13, x13, #1           // Incrementar índice temporal
    b left_remain

copy_to_array:
    // Copiar el contenido de temp al arreglo original
    mov x14, x7                // w14 = inicio
copy_loop:
    cmp x14, w10
    bgt end_merge
    ldr x15, [x3, x14, LSL #2] // Cargar temp[w14]
    str x15, [x2, x14, LSL #2] // arreglo[w14] = temp[w14]
    add x14, x14, #1
    b copy_loop

end_merge:
    ret
