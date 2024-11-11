// Autor: Milka Guadalupe Montes Domínguez
// Fecha: 10-11-24
// Descripción: Contar vocales y consonantes en una cadena en ARM64

    .section .data
cadena: .asciz "hola mundo"           // Cadena en la que contaremos vocales y consonantes
msg_resultado: .asciz "Vocales: %d, Consonantes: %d\n"

    .section .text
    .global _start

_start:
    // Cargar la dirección de la cadena en x0
    ldr x0, =cadena                  // x0 apunta al inicio de la cadena

    // Inicializar los contadores
    mov w1, #0                       // w1 será el contador de vocales
    mov w2, #0                       // w2 será el contador de consonantes

contar_loop:
    // Cargar el siguiente carácter
    ldrb w3, [x0], #1                // Cargar el byte actual en w3 y avanzar puntero x0
    cbz w3, imprimir_resultado       // Si encontramos el fin de cadena (byte 0), salimos del bucle

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

    // Si no es vocal, comprobar si es una consonante
    cmp w3, #'a'                     // Verificar que esté entre 'a' y 'z'
    blt contar_loop                  // Si es menor que 'a', no es letra, saltar al siguiente
    cmp w3, #'z'
    bgt contar_loop                  // Si es mayor que 'z', no es letra, saltar al siguiente

    // Incrementar el contador de consonantes
    add w2, w2, #1
    b contar_loop                    // Repetir el bucle

es_vocal:
    // Incrementar el contador de vocales
    add w1, w1, #1
    b contar_loop                    // Repetir el bucle

imprimir_resultado:
    // Preparación para imprimir los resultados
    ldr x0, =msg_resultado           // Mensaje para imprimir
    mov x1, w1                       // Mover el contador de vocales a x1
    mov x2, w2                       // Mover el contador de consonantes a x2

    // Llamada a printf para mostrar el resultado
    bl printf                        // Llamada a printf para mostrar vocales y consonantes

    // Salir del programa
    mov x8, #93                      // Código de salida para syscall exit en ARM64
    mov x0, #0                       // Código de retorno 0
    svc #0                           // Llamada al sistema
