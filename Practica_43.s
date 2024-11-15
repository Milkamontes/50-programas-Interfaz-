// Autor: Milka Guadalupe Montes Domínguez
// Fecha: 10-11-24
// Descripción: Calculadora simple en ARM64 (Suma, Resta, Multiplicación, División)

    .section .data
num1: .word 12                       // Primer número
num2: .word 3                        // Segundo número
op_code: .word 1                     // Código de operación: 1 = suma, 2 = resta, 3 = multiplicación, 4 = división

msg_suma: .asciz "Resultado de la suma: %d\n"
msg_resta: .asciz "Resultado de la resta: %d\n"
msg_multiplicacion: .asciz "Resultado de la multiplicación: %d\n"
msg_division: .asciz "Resultado de la división: %d\n"
msg_error: .asciz "Error: División por cero\n"

    .section .text
    .global _start

_start:
    // Cargar los valores de los números y el código de operación
    ldr x0, =num1                  // Cargar la dirección de num1
    ldr w0, [x0]                   // Cargar el primer número en w0

    ldr x1, =num2                  // Cargar la dirección de num2
    ldr w1, [x1]                   // Cargar el segundo número en w1

    ldr x2, =op_code               // Cargar la dirección de op_code
    ldr w2, [x2]                   // Cargar el código de operación en w2

    // Verificar el código de operación y realizar la operación correspondiente
    cmp w2, #1
    beq operacion_suma             // Si op_code == 1, realizar suma

    cmp w2, #2
    beq operacion_resta            // Si op_code == 2, realizar resta

    cmp w2, #3
    beq operacion_multiplicacion   // Si op_code == 3, realizar multiplicación

    cmp w2, #4
    beq operacion_division         // Si op_code == 4, realizar división

    b fin                          // Si el código no coincide, terminar el programa

operacion_suma:
    add w3, w0, w1                 // Sumar w0 y w1, almacenar en w3
    ldr x0, =msg_suma              // Mensaje de suma
    mov x1, w3                     // Mover el resultado a x1 para printf
    bl printf                      // Imprimir el resultado
    b fin                          // Terminar

operacion_resta:
    sub w3, w0, w1                 // Restar w1 de w0, almacenar en w3
    ldr x0, =msg_resta             // Mensaje de resta
    mov x1, w3                     // Mover el resultado a x1 para printf
    bl printf                      // Imprimir el resultado
    b fin                          // Terminar

operacion_multiplicacion:
    mul w3, w0, w1                 // Multiplicar w0 por w1, almacenar en w3
    ldr x0, =msg_multiplicacion    // Mensaje de multiplicación
    mov x1, w3                     // Mover el resultado a x1 para printf
    bl printf                      // Imprimir el resultado
    b fin                          // Terminar

operacion_division:
    cbz w1, error_division         // Verificar división por cero
    udiv w3, w0, w1                // Dividir w0 entre w1, almacenar en w3
    ldr x0, =msg_division          // Mensaje de división
    mov x1, w3                     // Mover el resultado a x1 para printf
    bl printf                      // Imprimir el resultado
    b fin                          // Terminar

error_division:
    ldr x0, =msg_error             // Mensaje de error por división por cero
    bl printf                      // Imprimir mensaje de error
    b fin                          // Terminar

fin:
    // Salir del programa
    mov x8, #93                    // Código de salida para syscall exit en ARM64
    mov x0, #0                     // Código de retorno 0
    svc #0                         // Llamada al sistema
