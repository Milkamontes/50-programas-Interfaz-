// Autor: Milka Guadalupe Montes Domínguez
// Fecha: 10-11-24
// Descripción: Ordenamiento por selección de un arreglo de enteros en ARM64
// Asciinema: https://asciinema.org/a/690543

.global _start
.global selection_sort

.section .data
arr:    .word 5, 3, 8, 6, 2       // Un ejemplo de arreglo para ordenar
size:   .word 5                   // Tamaño del arreglo
msg:    .asciz "Arreglo ordenado: " // Mensaje inicial
sep:    .asciz ", "               // Separador para los números

.section .text
_start:
    // Inicialización de los parámetros
    ldr x0, =arr                // Poner la dirección de arr en x0 (puntero a la lista)
    ldr x1, =size               // Poner la dirección de size en x1
    ldr w1, [x1]                // Cargar el tamaño del arreglo en w1
    bl selection_sort           // Llamar a la función de ordenamiento

    // Imprimir el mensaje inicial
    ldr x0, =msg                // Dirección del mensaje en x0
    bl print_string             // Imprimir el mensaje

    // Imprimir los números del arreglo
    ldr x0, =arr                // Puntero al arreglo
    ldr w1, [x1]                // Tamaño del arreglo
    bl print_array              // Imprimir el arreglo

    // Salir del programa
    mov x8, #93                 // Número de syscall para _exit
    mov x0, #0                  // Código de salida
    svc #0                      // Hacer la llamada al sistema

// Función: selection_sort
selection_sort:
    // x0: puntero a la lista de números
    // x1: tamaño de la lista

    mov x2, #0                  // x2 es el índice i
loop_i:
    cmp x2, x1                  // Compara i con el tamaño de la lista
    bge end_loop_i              // Si i >= tamaño, termina el ciclo

    // Encuentra el índice mínimo
    add x3, x2, #1              // x3 es el índice j (comienza en i+1)
    mov x4, x2                  // x4 es el índice mínimo (inicia en i)

loop_j:
    cmp x3, x1                  // Compara j con el tamaño de la lista
    bge swap_check              // Si j >= tamaño, salta a la comprobación de intercambio

    // Cargar valores para comparar
    ldr w5, [x0, x4, lsl #2]    // Cargar valor en la posición min (índice x4)
    ldr w6, [x0, x3, lsl #2]    // Cargar valor en la posición j (índice x3)
    cmp w6, w5                  // Compara arr[j] con arr[min]
    bge next_j                  // Si arr[j] >= arr[min], sigue al siguiente j

    // Actualizar el índice mínimo
    mov x4, x3                  // Actualiza min a j

next_j:
    add x3, x3, #1              // Incrementa j
    b loop_j                    // Repite el ciclo de j

swap_check:
    cmp x2, x4                  // Si i != min, realiza un intercambio
    beq next_i                  // Si son iguales, no es necesario intercambiar

    // Intercambiar arr[i] y arr[min]
    ldr w5, [x0, x2, lsl #2]    // Cargar arr[i]
    ldr w6, [x0, x4, lsl #2]    // Cargar arr[min]
    str w6, [x0, x2, lsl #2]    // Guardar arr[min] en arr[i]
    str w5, [x0, x4, lsl #2]    // Guardar arr[i] en arr[min]

next_i:
    add x2, x2, #1              // Incrementa i
    b loop_i                    // Repite el ciclo de i

end_loop_i:
    ret                          // Termina la función

// Función: print_string
// Imprime una cadena de texto terminada en '\0'
print_string:
    mov x8, #64                 // Número de syscall para write
    mov x1, x0                  // Dirección de la cadena
    mov x2, #20                 // Tamaño aproximado (ajustar según tu cadena)
    mov x0, #1                  // Salida estándar (stdout)
    svc #0                      // Hacer la llamada al sistema
    ret

// Función: print_array
// Imprime un arreglo de enteros
print_array:
    mov x3, #0                  // Índice actual
print_loop:
    cmp x3, x1                  // Compara índice con el tamaño del arreglo
    bge end_print_loop          // Si índice >= tamaño, termina

    // Cargar el valor actual
    ldr w4, [x0, x3, lsl #2]    // Cargar arr[i] en w4

    // Mostrar número (esto sería un stub si no tienes una función de conversión)
    bl print_number

    // Imprimir separador
    ldr x5, =sep                // Dirección del separador
    bl print_string             // Imprimir separador

    add x3, x3, #1              // Incrementar índice
    b print_loop

end_print_loop:
    ret

// Función: print_number
// Imprime un número en formato decimal
print_number:
    // (Aquí puedes implementar la conversión de número a cadena si es necesario)
    ret
