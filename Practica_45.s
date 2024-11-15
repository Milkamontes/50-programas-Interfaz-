// Autor: Milka Guadalupe Montes Domínguez
// Fecha: 10-11-24
// Descripción: Verificar si un número es Armstrong en ARM64

    .section .data
num: .word 153                        // Número a verificar
msg_true: .asciz "El número es Armstrong\n"
msg_false: .asciz "El número no es Armstrong\n"

    .section .text
    .global _start

_start:
    // Cargar el número a verificar
    ldr x0, =num                  // Dirección del número
    ldr w0, [x0]                  // Cargar el número en w0
    mov w1, w0                    // Copia del número original en w1

    // Calcular la cantidad de dígitos
    mov w2, #0                    // Contador de dígitos en w2
count_digits:
    udiv w3, w1, #10              // w3 = w1 / 10
    mov w1, w3                    // Actualizar w1 con el cociente
    add w2, w2, #1                // Incrementar el contador de dígitos
    cbnz w1, count_digits         // Repetir hasta que w1 sea 0

    // Inicializar variables para el cálculo
    ldr w1, [x0]                  // Restaurar el número original en w1
    mov w4, #0                    // Acumulador de la suma en w4

calculate_armstrong:
    udiv w3, w1, #10              // Dividir el número por 10 (obtener dígito menos significativo)
    msub w5, w3, #10, w1          // Resto: w5 = w1 - (w3 * 10) (dígito menos significativo)
    mov w6, #1                    // Inicializar potencia como 1
    mov w7, w2                    // Copiar la cantidad de dígitos en w7 (potencia)

power_loop:
    mul w6, w6, w5                // Multiplicar la potencia actual por el dígito
    subs w7, w7, #1               // Decrementar la potencia
    cbnz w7, power_loop           // Repetir hasta que w7 sea 0

    // Sumar el resultado al acumulador
    add w4, w4, w6                // Acumular el resultado de la potencia

    // Reducir el número original
    udiv w1, w1, #10              // w1 = w1 / 10 (descartar el dígito menos significativo)
    cbnz w1, calculate_armstrong  // Repetir mientras queden dígitos

    // Verificar si el número original es igual a la suma
    ldr w1, [x0]                  // Restaurar el número original
    cmp w1, w4                    // Comparar el número original con la suma
    bne not_armstrong             // Si no son iguales, no es Armstrong

is_armstrong:
    ldr x0, =msg_true             // Mensaje: "El número es Armstrong"
    bl printf                     // Imprimir mensaje
    b end_program                 // Terminar

not_armstrong:
    ldr x0, =msg_false            // Mensaje: "El número no es Armstrong"
    bl printf                     // Imprimir mensaje

end_program:
    // Salir del programa
    mov x8, #93                   // Código de salida para syscall exit en ARM64
    mov x0, #0                    // Código de retorno 0
    svc #0                        // Llamada al sistema
