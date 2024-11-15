// Autor: Milka Guadalupe Montes Domínguez
// Fecha: 10-11-24
// Descripción: Medir el tiempo de ejecución de una función en ARM64

    .section .data
msg_tiempo: .asciz "Tiempo de ejecución: %f segundos\n"

    .section .text
    .global _start

_start:
    // Leer el valor inicial del contador del sistema
    mrs x0, CNTVCT_EL0              // Leer el contador virtual en x0 (valor inicial)
    mov x1, x0                      // Guardar el valor inicial en x1 (para cálculo posterior)

    // Llamar a la función que vamos a medir
    bl funcion_a_medida

    // Leer el valor final del contador del sistema
    mrs x2, CNTVCT_EL0              // Leer el contador virtual en x2 (valor final)

    // Calcular la diferencia del contador
    sub x3, x2, x1                  // x3 = x2 - x1 (diferencia en ciclos)

    // Leer la frecuencia del contador
    mrs x4, CNTFRQ_EL0              // Leer la frecuencia del contador en x4 (ciclos por segundo)

    // Convertir la diferencia a tiempo en segundos
    udiv x5, x3, x4                 // x5 = x3 / x4 (resultado entero en segundos)

    // Preparar el valor como flotante para printf
    scvtf d0, x5                    // Convertir el tiempo a punto flotante (double)

    // Preparación para imprimir el resultado
    ldr x0, =msg_tiempo             // Cargar el mensaje
    fmov d1, d0                     // Mover el valor en d0 a d1 para printf
    bl printf                       // Imprimir el tiempo de ejecución

    // Salir del programa
    mov x8, #93                     // Código de salida para syscall exit en ARM64
    mov x0, #0                      // Código de retorno 0
    svc #0                          // Llamada al sistema

funcion_a_medida:
    // Una función simple que realiza un bucle
    mov w0, #0                      // Inicializar contador en w0
    mov w1, #1000000                // Número de iteraciones (1 millón)
bucle:
    add w0, w0, #1                  // Incrementar contador
    subs w1, w1, #1                 // Decrementar iteraciones
    bne bucle                       // Repetir mientras w1 != 0
    ret                             // Regresar de la función
