// Autor: Milka Guadalupe Montes Domínguez
// Fecha: 10-11-24
// Descripción: Este programa encuentra el segundo elemento más grande en un arreglo de enteros.
//              La dirección base del arreglo debe estar en x0 y el número de elementos en x1.
//              El segundo elemento más grande se almacenará en x2.

// Función para imprimir un número (en formato decimal)
print_number:
    mov x2, #10         // Divisor para convertir a decimal
    mov x3, x1          // Copiar el valor a imprimir

    // Convertir el número a cadena de caracteres
    mov x4, sp          // Usar el stack para almacenar los caracteres
    add x4, x4, #20     // Espacio suficiente para un número de hasta 10 dígitos
    mov x5, #0          // Limpiar el índice del número

convert_loop:
    udiv x6, x3, x2     // Dividir el número por 10
    msub x7, x6, x2, x3 // Obtener el residuo (último dígito)
    add x7, x7, #'0'    // Convertir a ASCII
    strb w7, [x4, x5]   // Almacenar el dígito en la cadena
    mov x3, x6          // Actualizar el número para la siguiente iteración
    add x5, x5, #1      // Avanzar el índice
    cmp x3, #0          // ¿Terminamos?
    bne convert_loop

    // Imprimir la cadena de caracteres
    mov x0, #1          // File descriptor 1 (stdout)
    mov x1, x4          // Dirección de la cadena de caracteres
    mov x2, x5          // Longitud de la cadena
    svc #0              // Llamada al sistema para escribir en stdout

    ret

