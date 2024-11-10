// Autor: Milka Guadalupe Montes Domínguez
// Fecha: 10-11-24
// Descripción: Ordenamiento burbuja de un arreglo de enteros en ARM64

    .section .data
arreglo: .word 25, 10, 48, 3, 5, 30      // Arreglo desordenado de números enteros
tamano: .word 6                          // Tamaño del arreglo
msg_resultado: .asciz "Arreglo ordenado: %d %d %d %d %d %d\n"

    .section .text
    .global _start

_start:
    // Cargar el tamaño del arreglo
    ldr x1, =tamano            // Dirección del tamaño
    ldr w1, [x1]               // Cargar el tamaño en w1 (número de elementos)

    // Cargar la dirección del arreglo
    ldr x2, =arreglo           // x2 apunta al inicio del arreglo

bubble_sort:
    // Bucle externo: controla las pasadas
    sub w3, w1, #1             // Número de pasadas (tamaño - 1)
    mov w9, w3                 // Guardamos el valor original en w9 para reiniciar las pasadas

outer_loop:
    cbz w3, print_resultado    // Si w3 == 0, el arreglo está ordenado

    // Bucle interno: compara e intercambia elementos
    mov w4, #0                 // Índice del primer elemento en la pasada

inner_loop:
    // Verificar si llegamos al final de esta pasada
    cmp w4, w3
    bge decrement_passes       // Si w4 >= w3, terminamos esta pasada

    // Cargar los elementos actuales para comparar
    ldr w5, [x2, w4, LSL #2]   // Cargar arreglo[w4] en w5
    ldr w6, [x2, w4, LSL #2 + 4] // Cargar arreglo[w4 + 1] en w6

    // Comparar e intercambiar si están en el orden incorrecto
    cmp w5, w6                 // Comparar arreglo[w4] con arreglo[w4 + 1]
    ble skip_swap              // Si arreglo[w4] <= arreglo[w4 + 1], saltar el intercambio

    // Intercambiar arreglo[w4] y arreglo[w4 + 1]
    str w6, [x2, w4, LSL #2]   // Guardar arreglo[w4 + 1] en arreglo[w4]
    str w5, [x2, w4, LSL #2 + 4] // Guardar arreglo[w4] en arreglo[w4 + 1]

skip_swap:
    // Incrementar el índice para el siguiente par
    add w4, w4, #1
    b inner_loop               // Repetir el bucle interno

decrement_passes:
    // Decrementar el contador de pasadas y repetir el bucle externo
    sub w3, w3, #1
    b outer_loop               // Repetir el bucle externo

print_resultado:
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
