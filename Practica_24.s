// Autor: Milka Guadalupe Montes Domínguez
// Fecha: 10-11-24
// Descripción: Calcular la longitud de una cadena en ARM64
// Asciinema:  https://asciinema.org/a/690611

.section .data
cadena: .asciz "Hola, mundo!"     // Cadena cuya longitud queremos calcular
msg_resultado: .asciz "La longitud de la cadena es: %d\n"

.section .text
.global _start

_start:
    ldr x0, =cadena           // x0 apunta al inicio de la cadena
    mov w1, #0                // Inicializar el contador de longitud en 0

calcular_longitud:
    uxtw x1, w1               // Extender w1 a x1 para usarlo como desplazamiento
    ldrb w2, [x0, x1]         // Cargar el byte en la posición actual
    cbz w2, imprimir_resultado // Si w2 es 0 (fin de cadena), salir del bucle
    add w1, w1, #1            // Incrementar el contador de longitud
    b calcular_longitud        // Repetir el bucle

imprimir_resultado:
    ldr x0, =msg_resultado    // Cargar el mensaje de resultado
    uxtw x1, w1               // Extender w1 a x1 para pasarlo a printf
    bl printf                 // Llamada a printf para mostrar el resultado

    // Salir del programa
    mov x8, #93               // Código de salida para syscall exit en ARM64
    mov x0, #0                // Código de retorno 0
    svc #0                    // Llamada al sistema
