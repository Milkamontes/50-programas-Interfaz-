// Autor: Milka Guadalupe Montes Domínguez
// Fecha: 10-11-24
// Descripción: Detección de desbordamiento en suma en ARM64

    .section .data
num1: .word 2147483647              // Primer número (máximo entero positivo de 32 bits)
num2: .word 1                        // Segundo número (este causará desbordamiento)
msg_resultado: .asciz "Resultado de la suma: %d\n"
msg_overflow: .asciz "Advertencia: Desbordamiento en la suma\n"

    .section .text
    .global _start

_start:
    // Cargar los números en registros
    ldr x0, =num1                   // Dirección de num1
    ldr w0, [x0]                    // Cargar num1 en w0

    ldr x1, =num2                   // Dirección de num2
    ldr w1, [x1]                    // Cargar num2 en w1

    // Realizar la suma con verificación de desbordamiento
    adds w2, w0, w1                 // Sumar w0 y w1, resultado en w2 y actualizar flags

    // Verificar si ocurrió desbordamiento
    bvs overflow_detected           // Si el flag V (overflow) está activo, saltar a overflow_detected

    // Si no hubo desbordamiento, imprimir el resultado de la suma
    ldr x0, =msg_resultado          // Cargar el mensaje de resultado
    mov x1, w2                      // Mover el resultado de la suma a x1
    bl printf                       // Llamada a printf para mostrar el resultado
    b end_program                   // Terminar el programa

overflow_detected:
    // Imprimir mensaje de desbordamiento
    ldr x0, =msg_overflow           // Cargar el mensaje de advertencia
    bl printf                       // Llamada a printf para mostrar el mensaje de desbordamiento

end_program:
    // Salir del programa
    mov x8, #93                     // Código de salida para syscall exit en ARM64
    mov x0, #0                      // Código de retorno 0
    svc #0                          // Llamada al sistema
