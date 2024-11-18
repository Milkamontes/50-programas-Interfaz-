// Autor: Milka Guadalupe Montes Domínguez
// Fecha: 10-11-24
// Descripción: Ordenamiento burbuja de un arreglo de enteros en ARM64

 .section .data
arreglo: .word 25, 10, 48, 3, 5, 30      // Arreglo desordenado
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
    sub w3, w1, #1             // w3 = tamano - 1

outer_loop:
    cbz w3, print_resultado    // Si w3 == 0, terminamos el ordenamiento

    mov w4, #0                 // Índice del primer elemento en la pasada

inner_loop:
    cmp w4, w3                 // Comparar índice con el tamaño restante
    bge decrement_passes       // Si w4 >= w3, terminar pasada

    // Cargar los dos elementos a comparar
    ldr w5, [x2, x4, LSL #2]   // arreglo[w4] en w5
    lsl x7, x4, #2             // Desplazar w4 << 2
    add x7, x2, x7             // Calcular la dirección de arreglo[w4 + 1]
    ldr w6, [x7]               // arreglo[w4 + 1] en w6

    // Comparar e intercambiar si están en orden incorrecto
    cmp w5, w6                 // Comparar arreglo[w4] con arreglo[w4 + 1]
    ble skip_swap              // Si arreglo[w4] <= arreglo[w4 + 1], saltar

    // Intercambiar elementos
    str w6, [x2, x4, LSL #2]   // Guardar arreglo[w4 + 1] en arreglo[w4]
    str w5, [x7]               // Guardar arreglo[w4] en arreglo[w4 + 1]

skip_swap:
    add w4, w4, #1             // Incrementar el índice
    b inner_loop               // Repetir el bucle interno

decrement_passes:
    sub w3, w3, #1             // Decrementar el número de pasadas
    b outer_loop               // Repetir el bucle externo

print_resultado:
    // Preparación para imprimir el arreglo ordenado
    ldr x0, =msg_resultado     // Cargar el mensaje
    mov x1, #0                 // Inicializar índice del bucle
print_loop:
    cmp w1, x1                 // Comparar índice con tamaño
    bge end_program            // Si índice >= tamaño, terminar

    ldr w2, [x2, x1, LSL #2]   // Cargar elemento en w2
    bl printf                  // Llamar a printf para imprimir el elemento
    add x1, x1, #1             // Incrementar índice
    b print_loop               // Repetir bucle de impresión

end_program:
    mov x8, #93                // syscall exit
    mov x0, #0                 // Código de retorno
    svc #0                     // Llamada al sistema

