// Autor: Milka Guadalupe Montes Domínguez
// Fecha: 10-11-24
// Descripción: Este programa calcula la potencia x^n 
// Asciinema: https://asciinema.org/a/691047

.data
    msg_base: .asciz "Ingrese la base (x): "
    msg_exp: .asciz "Ingrese el exponente (n): "
    formato_in: .asciz "%ld"
    msg_resultado: .asciz "%ld elevado a la %ld es: %ld\n"

.text
.global main
.align 2

main:
    stp x29, x30, [sp, -16]!
    mov x29, sp

    // Pedir la base al usuario
    adrp x0, msg_base
    add x0, x0, :lo12:msg_base
    bl printf

    // Leer la base
    sub sp, sp, #16
    mov x2, sp
    adrp x0, formato_in
    add x0, x0, :lo12:formato_in
    mov x1, x2
    bl scanf

    // Guardar la base
    ldr x19, [sp]
    add sp, sp, #16

    // Pedir el exponente al usuario
    adrp x0, msg_exp
    add x0, x0, :lo12:msg_exp
    bl printf

    // Leer el exponente
    sub sp, sp, #16
    mov x2, sp
    adrp x0, formato_in
    add x0, x0, :lo12:formato_in
    mov x1, x2
    bl scanf

    // Guardar el exponente
    ldr x20, [sp]
    add sp, sp, #16

    // Calcular la potencia
    mov x0, x19  // base
    mov x1, x20  // exponente
    bl potencia

    // Guardar resultado
    mov x21, x0

    // Imprimir resultado
    adrp x0, msg_resultado
    add x0, x0, :lo12:msg_resultado
    mov x1, x19  // base
    mov x2, x20  // exponente
    mov x3, x21  // resultado
    bl printf

    // Salir del programa
    mov x0, #0
    ldp x29, x30, [sp], #16
    ret

// Función para calcular la potencia usando exponenciación rápida
potencia:
    // x0: base (x)
    // x1: exponente (n)
    mov x2, #1    // resultado = 1

loop_potencia:
    cbz x1, end_potencia   // Si n == 0, terminar
    tbnz x1, #0, mult_base // Si el bit menos significativo de n es 1, multiplicar por la base
    mul x0, x0, x0         // x = x * x
    lsr x1, x1, #1         // n = n / 2
    b loop_potencia

mult_base:
    mul x2, x2, x0         // resultado *= x
    mul x0, x0, x0         // x = x * x
    lsr x1, x1, #1         // n = n / 2
    b loop_potencia

end_potencia:
    mov x0, x2    // Mover el resultado a x0
    ret
