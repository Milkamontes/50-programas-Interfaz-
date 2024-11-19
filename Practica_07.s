// Autor: Milka Guadalupe Montes Domínguez
// Fecha: 05-11-2024
// Descripción: Cálculo del factorial de un número en ARM64. El programa calcula el factorial de un número entero positivo
// utilizando un bucle para realizar la multiplicación acumulativa. El resultado se imprime en pantalla.
// Asciinema: https://asciinema.org/a/690691

 .global _start          // Punto de entrada al programa
.section .text          // Sección de código

_start:
    // Inicialización de variables
    mov x0, 5           // Cargar el valor 5 (número para calcular el factorial)
    mov x1, 1           // Inicializar x1 con 1, que será el resultado del factorial

factorial_loop:
    cmp x0, 1           // Compara x0 (número) con 1
    ble done            // Si x0 <= 1, terminamos el bucle

    mul x1, x1, x0      // Multiplicamos el valor actual de x1 por x0 (resultado * número)
    sub x0, x0, 1       // Decrementamos x0 (número) en 1
    b factorial_loop    // Volver al inicio del bucle

done:
    // El resultado final del factorial está en x1
    mov x0, x1          // Mover el resultado a x0 para pasar a la llamada al sistema
    bl print_result     // Llamada a la función para imprimir el resultado

    mov x8, 93          // Código de sistema para 'exit'
    svc 0               // Llamada al sistema para terminar el programa

// Función para imprimir el resultado
print_result:
    // Convertir el número en x0 a una cadena de caracteres
    mov x2, 10          // Base decimal
    mov x3, sp          // Usamos el stack para almacenar la cadena
    add x3, x3, 10      // Reservamos espacio en el stack para la cadena

    mov x4, 0           // Índice para la cadena
reverse_loop:
    udiv x5, x0, x2     // Dividimos x0 entre 10
    msub x6, x5, x2, x0 // El residuo de la división es el dígito actual
    add x6, x6, '0'     // Convertimos el dígito a su valor ASCII
    strb w6, [x3, x4]   // Almacenamos el dígito en la cadena
    mov x0, x5          // Actualizamos x0 con el cociente
    add x4, x4, 1       // Incrementamos el índice
    cmp x0, 0           // Comprobamos si hemos procesado todo el número
    bne reverse_loop    // Si no, seguimos dividiendo

    // Imprimir la cadena de caracteres
    mov x0, 1           // File descriptor 1 (stdout)
    mov x1, x3          // Dirección de la cadena en el stack
    mov x2, x4          // Longitud de la cadena
    mov x8, 64          // Código de sistema para 'write'
    svc 0               // Llamada al sistema para escribir

    ret                 // Regresar de la función
