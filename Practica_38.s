// Autor: Milka Guadalupe Montes Domínguez
// Fecha: 10-11-24
// Descripción: Implementación de una cola básica utilizando un arreglo en ARM64.
//              Incluye las operaciones enqueue (insertar) y dequeue (retirar) con 
//              verificación de desbordamiento y subdesbordamiento utilizando un arreglo circular.

.global _start         // Punto de entrada para el sistema operativo

// Definición de constantes
.equ QUEUE_SIZE, 10    // Tamaño máximo de la cola

// Definición de la cola y sus punteros
.section .data
queue: 
    .space QUEUE_SIZE * 4  // Espacio para QUEUE_SIZE elementos (4 bytes por entero)

.section .bss
front: 
    .word 0              // Índice de inicio de la cola
rear: 
    .word 0              // Índice de fin de la cola
count:
    .word 0              // Número actual de elementos en la cola

// Operación Enqueue (insertar elemento)
// Argumentos:
//   x0 - Valor a insertar en la cola
enqueue:
    ldr w3, count        // Cargar el conteo actual de elementos en la cola
    cmp w3, QUEUE_SIZE   // Comparar con el tamaño máximo
    bge queue_full       // Si count >= QUEUE_SIZE, hay desbordamiento

    // Insertar el valor en la posición de 'rear'
    ldr x1, =queue       // Cargar la dirección base de la cola en x1
    ldr w2, rear         // Cargar el índice 'rear'
    str w0, [x1, w2, LSL #2]  // Guardar el valor en queue[rear]

    // Actualizar 'rear' usando aritmética modular para circularidad
    add w2, w2, #1
    udiv x4, xzr, QUEUE_SIZE
    str w2, rear         // Guardar el nuevo valor de 'rear'
    
