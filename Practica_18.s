// Autor: Milka Guadalupe Montes Domínguez
// Fecha: 10-11-24
// Descripción: Ordenamiento por mezcla (Merge Sort) de un arreglo de enteros en ARM64

    .data
array: .word 12, 45, 7, 23, 67, 89, 34, 56, 90, 14    // Arreglo a ordenar
arr_len: .word 10                                      // Longitud del arreglo
temp_array: .zero 40                                   // Arreglo temporal (10 elementos * 4 bytes)
msg_before: .asciz "Arreglo antes de ordenar:\n"
msg_after: .asciz "Arreglo después de ordenar:\n"
msg_elem: .asciz "%d "                                 // Para imprimir cada elemento
msg_nl: .asciz "\n"                                    // Nueva línea

.text
.global main

// Función principal
main:
    stp x29, x30, [sp, -16]!    // Guardar registros
    mov x29, sp

    // Imprimir mensaje inicial
    adrp x0, msg_before
    add x0, x0, :lo12:msg_before
    bl printf

    // Imprimir arreglo original
    bl print_array

    // Preparar parámetros para merge_sort
    adrp x0, array
    add x0, x0, :lo12:array     // x0 = dirección del arreglo
    mov x1, #0                  // x1 = inicio (0)
    adrp x2, arr_len
    add x2, x2, :lo12:arr_len
    ldr w2, [x2]               
    sub x2, x2, #1              // x2 = fin (n-1)

    // Llamar a merge_sort
    bl merge_sort

    // Imprimir mensaje final
    adrp x0, msg_after
    add x0, x0, :lo12:msg_after
    bl printf

    // Imprimir arreglo ordenado
    bl print_array

    // Restaurar y retornar
    ldp x29, x30, [sp], 16
    ret

// Función merge_sort(arr, inicio, fin)
merge_sort:
    stp x29, x30, [sp, -48]!    // Guardar registros y espacio para variables locales
    mov x29, sp
    
    // Guardar parámetros
    str x0, [x29, 16]           // Guardar dirección del arreglo
    str x1, [x29, 24]           // Guardar inicio
    str x2, [x29, 32]           // Guardar fin

    // Verificar caso base
    cmp x1, x2                  // Si inicio >= fin, retornar
    bge merge_sort_end

    // Calcular punto medio
    add x3, x1, x2              // x3 = inicio + fin
    lsr x3, x3, #1              // x3 = (inicio + fin) / 2

    // Guardar punto medio
    str x3, [x29, 40]

    // Llamada recursiva para primera mitad
    ldr x0, [x29, 16]           // Recuperar dirección del arreglo
    ldr x1, [x29, 24]           // Recuperar inicio
    mov x2, x3                  // fin = medio
    bl merge_sort

    // Llamada recursiva para segunda mitad
    ldr x0, [x29, 16]           // Recuperar dirección del arreglo
    ldr x1, [x29, 40]           // inicio = medio
    add x1, x1, #1              // inicio = medio + 1
    ldr x2, [x29, 32]           // Recuperar fin
    bl merge_sort

    // Mezclar las dos mitades
    ldr x0, [x29, 16]           // Recuperar dirección del arreglo
    ldr x1, [x29, 24]           // Recuperar inicio
    ldr x2, [x29, 40]           // Recuperar medio
    ldr x3, [x29, 32]           // Recuperar fin
    bl merge

merge_sort_end:
    ldp x29, x30, [sp], 48
    ret

// Función merge(arr, inicio, medio, fin)
