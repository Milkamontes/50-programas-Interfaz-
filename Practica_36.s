// Autor: Milka Guadalupe Montes Domínguez
// Fecha: 10-11-24
// Descripción: Este programa encuentra el segundo elemento más grande en un arreglo de enteros.
//              La dirección base del arreglo debe estar en x0 y el número de elementos en x1.
//              El segundo elemento más grande se almacenará en x2.

.global _start          // Punto de entrada para el sistema operativo

_start:
    // Inicialización del arreglo y número de elementos (solo para este ejemplo)
    ldr x0, =arreglo    // Dirección base del arreglo en x0
    mov x1, #5          // Número de elementos en el arreglo (ejemplo: 5)

    // Verificación de la cantidad de elementos
    cmp x1, #2          // Comprobamos si hay al menos 2 elementos
    blt end_program     // Si hay menos de 2 elementos, terminamos (no se puede encontrar el segundo más grande)

    // Inicializar los valores más grande y segundo más grande
    ldr w2, [x0]        // x2 tendrá el elemento más grande (inicialmente arreglo[0])
    mov x3, #0x80000000 // Inicializamos x3 (segundo más grande) con un valor muy bajo

    // Comenzamos desde el segundo elemento
    mov x4, #1          // Índice de inicio en el bucle

find_second_largest:
    cmp x4, x1          // Comparamos el índice actual con el número de elementos
    bge end_result      // Si el índice alcanza el tamaño del arreglo, terminamos el bucle

    ldr w5, [x0, x4, LSL #2] // Cargamos arreglo[x4] en w5

    // Comprobamos si el elemento actual es mayor que el mayor encontrado hasta ahora
    cmp x5, x2
    bge update_largest  // Si arreglo[x4] > mayor, actualizamos ambos valores

    // Si el elemento actual no es el mayor, comprobamos si es el segundo más grande
    cmp x5, x3
    ble next_element    // Si arreglo[x4] <= segundo mayor, seguimos al siguiente elemento
    mov x3, x5          // Si arreglo[x4] > segundo mayor, actualizamos el segundo mayor

next_element:
    add x4, x4, #1      // Avanzamos al siguiente elemento
    b find_second_largest // Repetimos el bucle

update_largest:
    mov x3, x2          // El mayor actual pasa a ser el segundo mayor
    mov x2, x5          // Actualizamos el mayor con arreglo[x4]
    b next_element      // Avanzamos al siguiente elemento

end_result:
    // El segundo mayor valor ahora está en x3

end_program:
    mov x2, x3          // Copiamos el segundo mayor a x2 para el resultado final
    mov w8, #93         // Código de salida del sistema para "exit" en Linux
    svc #0              // Llamada al sistema para finalizar el programa

// Datos del arreglo (ejemplo)
.section .data
arreglo:
    .word 3, 8, 5, 2, 7   // Ejemplo de arreglo con 5 elementos
