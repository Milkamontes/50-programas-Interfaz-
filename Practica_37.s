// Autor: Milka Guadalupe Montes Domínguez
// Fecha: 10-11-24
// Descripción: Implementación de una pila básica utilizando un arreglo en ARM64. 
//              Incluye las operaciones push (apilar) y pop (desapilar) con verificación 
//              de desbordamiento y subdesbordamiento. 

.global _start         // Punto de entrada para el sistema operativo

// Definición de constantes
.equ STACK_SIZE, 10    // Tamaño máximo de la pila

// Definición de la pila y el puntero de la pila
.section .data
stack: 
    .space STACK_SIZE * 4  // Espacio para STACK_SIZE elementos (4 bytes por entero)

.section .bss
stack_pointer: 
    .word 0              // Puntero de la pila inicializado a 0

// Operación Push
// Argumentos:
//   x0 - Valor a insertar en la pila
push:
    ldr w1, =STACK_SIZE  // Cargamos el tamaño máximo de la pila en w1
    ldr w2, stack_pointer // Cargamos el puntero de la pila en w2
    cmp w2, w1           // Comparamos el puntero con el tamaño máximo
    bge stack_overflow   // Si puntero >= STACK_SIZE, hay desbordamiento

    // Guardar el valor en la pila
    ldr x3, =stack       // Cargamos la dirección base de la pila en x3
    str w0, [x3, w2, LSL #2]  // Guardamos el valor en stack[stack_pointer]

    // Incrementamos el puntero de la pila
    add w2, w2, #1       // stack_pointer++
    str w2, stack_pointer // Guardamos el nuevo puntero en memoria
    ret                  // Retorno de la función push

stack_overflow:
    // Manejo de desbordamiento (opcional: puedes agregar una salida de error)
    mov w0, #1           // Código de error para desbordamiento
    b end_program        // Termina el programa

// Operación Pop
// Retorno:
//   x0 - Valor eliminado de la pila
pop:
    ldr w2, stack_pointer // Cargamos el puntero de la pila en w2
    cmp w2, #0           // Comparamos el puntero con 0
    ble stack_underflow  // Si puntero <= 0, hay subdesbordamiento

    // Decrementamos el puntero de la pila antes de extraer el valor
    sub w2, w2, #1       // stack_pointer--
    str w2, stack_pointer // Guardamos el nuevo puntero en memoria

    // Extraemos el valor de la pila
    ldr x3, =stack       // Cargamos la dirección base de la pila en x3
    ldr w0, [x3, w2, LSL #2]  // Leemos el valor de stack[stack_pointer]
    ret                  // Retorno de la función pop

stack_underflow:
    // Manejo de subdesbordamiento (opcional: puedes agregar una salida de error)
    mov w0, #2           // Código de error para subdesbordamiento
    b end_program        // Termina el programa

// Programa principal
_start:
    // Ejemplo de uso de la pila
    // Push de algunos valores
    mov w0, #10          // Valor a insertar
    bl push              // Llamada a push(10)

    mov w0, #20          // Valor a insertar
    bl push              // Llamada a push(20)

    mov w0, #30          // Valor a insertar
    bl push              // Llamada a push(30)

    // Pop de algunos valores
    bl pop               // Llamada a pop (debería devolver 30 en w0)
    bl pop               // Llamada a pop (debería devolver 20 en w0)

end_program:
    mov w8, #93          // Código de salida del sistema para "exit" en Linux
    svc #0               // Llamada al sistema para finalizar el programa
