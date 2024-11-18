// Autor: Milka Guadalupe Montes Domínguez
// Fecha: 10-11-24
// Descripción: Ordenamiento burbuja de un arreglo de enteros en ARM64
// Asciinema: https://asciinema.org/a/690533

                .section .data
array:  .word 8, 5, 3, 1, 7, 6, 2, 4  // Arreglo a ordenar
n:      .word 8                       // Número de elementos

        .section .text
        .global _start

_start:
        // Inicializar registros
        ldr x0, =array                // Dirección base del arreglo
        ldr x1, =n                    // Dirección de n
        ldr w1, [x1]                  // Número de elementos en w1 (n)

bubble_sort:
        // Iteración externa
        sub w2, w1, #1                // w2 = n - 1 (límite del ciclo)
        mov w3, #0                    // Bandera de intercambio (swapped = 0)

outer_loop:
        mov w4, #0                    // Índice del ciclo interno (i = 0)

inner_loop:
        cmp w4, w2                    // Verificar que i < límite
        b.ge inner_done               // Si i >= límite, salir del ciclo interno

        lsl w5, w4, #2                // Calcular desplazamiento: i * 4 (en w5)
        add x6, x0, w5, sxtw          // Dirección de array[i]
        ldr w7, [x6]                  // Cargar array[i]
        ldr w8, [x6, #4]              // Cargar array[i+1]

        // Comparar array[i] y array[i+1]
        cmp w7, w8
        b.le no_swap                  // Si array[i] <= array[i+1], no intercambiar

        // Intercambiar array[i] y array[i+1]
        str w8, [x6]                  // array[i] = array[i+1]
        str w7, [x6, #4]              // array[i+1] = array[i]
        mov w3, #1                    // swapped = 1

no_swap:
        add w4, w4, #1                // i++
        b inner_loop                  // Repetir ciclo interno

inner_done:
        // Comprobar si hubo intercambio
        cmp w3, #0
        b.eq done                     // Si no hubo intercambio, salir
        sub w2, w2, #1                // Reducir límite del ciclo
        b outer_loop                  // Repetir ciclo externo

done:
        // Terminar el programa
        mov w8, #93                   // syscall: exit
        mov x0, #0                    // Código de salida
        svc #0
