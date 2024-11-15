// Autor: Milka Guadalupe Montes Domínguez
// Fecha: 10-11-24
// Descripción: Generación de números aleatorios en ARM64 usando LCG

    .section .data
semilla: .word 12345                  // Valor de la semilla inicial
a: .word 1103515245                    // Constante multiplicativa
c: .word 12345                         // Constante aditiva
m: .word 0x7FFFFFFF                    // Módulo (2^31 - 1 para limitar a 31 bits)
msg_resultado: .asciz "Número aleatorio: %d\n"

    .section .text
    .global _start

_start:
    // Cargar la semilla en un registro
    ldr x0, =semilla               // Dirección de la semilla
    ldr w0, [x0]                   // Cargar la semilla en w0 (X_n)

    // Cargar las constantes
    ldr x1, =a                     // Dirección de la constante a
    ldr w1, [x1]                   // Cargar a en w1

    ldr x2, =c                     // Dirección de la constante c
    ldr w2, [x2]                   // Cargar c en w2

    ldr x3, =m                     // Dirección de la constante m
    ldr w3, [x3]                   // Cargar m en w3

    // Generar el siguiente número pseudoaleatorio: X_{n+1} = (a * X_n + c) mod m
    mul w4, w1, w0                 // w4 = a * X_n
    add w4, w4, w2                 // w4 = a * X_n + c
    and w4, w4, w3                 // w4 = (a * X_n + c) mod m, limitar a 31 bits

    // Guardar el nuevo valor de la semilla para el próximo uso
    str w4, [x0]                   // Actualizar semilla en memoria

    // Preparación para imprimir el número aleatorio
    ldr x0, =msg_resultado         // Cargar el mensaje de resultado
    mov x1, w4                     // Mover el número aleatorio a x1

    // Llamada a printf para mostrar el número aleatorio
    bl printf                      // Imprimir el resultado

    // Salir del programa
    mov x8, #93                    // Código de salida para syscall exit en ARM64
    mov x0, #0                     // Código de retorno 0
    svc #0                         // Llamada al sistema
