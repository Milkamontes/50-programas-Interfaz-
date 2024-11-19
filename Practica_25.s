// Autor: Milka Guadalupe Montes Domínguez
// Fecha: 10-11-24
// Descripción: Contar vocales y consonantes en una cadena en ARM64
// Asciinema: https://asciinema.org/a/690616

.section .data
cadena: .asciz "hola mundo"           // Cadena en la que contaremos vocales y consonantes
msg_resultado: .asciz "Vocales: %d, Consonantes: %d\n"

.section .text
.global _start

_start:
    ldr x0, =cadena                  // x0 apunta al inicio de la cadena
    mov w1, #0                       // Inicializar el contador de vocales
    mov w2, #0                       // Inicializar el contador de consonantes

contar_loop:
    ldrb w3, [x0], #1                // Cargar el carácter actual y avanzar puntero x0
    cbz w3, imprimir_resultado       // Si el carácter es 0 (fin de cadena), salir del bucle

    // Comprobar si es una vocal
    cmp w3, #'a'
    b.eq es_vocal
    cmp w3, #'e'
    b.eq es_vocal
    cmp w3, #'i'
    b.eq es_vocal
    cmp w3, #'o'
    b.eq es_vocal
    cmp w3, #'u'
    b.eq es_vocal

    // Comprobar si es consonante
    cmp w3, #'a'
    blt contar_loop
    cmp w3, #'z'
    bgt contar_loop

    add w2, w2, #1                   // Incrementar el contador de consonantes
    b contar_loop

es_vocal:
    add w1, w1, #1                   // Incrementar el contador de vocales
    b contar_loop

imprimir_resultado:
    ldr x0, =msg_resultado           // Mensaje para imprimir
    uxtw x1, w1                      // Extender w1 a x1 (64 bits)
    uxtw x2, w2                      // Extender w2 a x2 (64 bits)
    bl printf                        // Llamada a printf

    mov x8, #93                      // Salir del programa
    mov x0, #0
    svc #0
