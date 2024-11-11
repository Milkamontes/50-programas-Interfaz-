// Autor: Milka Guadalupe Montes Domínguez
// Fecha: 10-11-24
// Descripción: Este programa calcula el Mínimo Común Múltiplo (MCM) de dos números
//              utilizando la relación MCM(a, b) = (a * b) / MCD(a, b). Los números de entrada 
//              deben estar en los registros x0 y x1, y el resultado se almacenará en x0.

.global _start       // Punto de entrada para el sistema operativo

_start:
    mov x0, #15      // Primer número (por ejemplo, 15)
    mov x1, #20      // Segundo número (por ejemplo, 20)

    // Guardamos los valores originales de x0 y x1 para el cálculo final del MCM
    mov x2, x0       // Guardamos el valor original de x0 en x2
    mov x3, x1       // Guardamos el valor original de x1 en x3

    // Llamamos a la función para calcular el MCD
    bl mcd           // MCD(x0, x1) -> Resultado en x0

    // Calculamos MCM = (x2 * x3) / MCD(x2, x3)
    mul x1, x2, x3   // Multiplicamos los valores originales: x1 = x2 * x3
    udiv x0, x1, x0  // Dividimos el producto entre el MCD, MCM en x0

    // Fin del programa
    mov w8, #93      // Código de salida del sistema para "exit" en Linux
    svc #0           // Llamada al sistema para finalizar el programa

// Función para calcular el MCD utilizando el Algoritmo de Euclides
mcd:
    cmp x1, #0         // Comparamos x1 con 0
    beq end_mcd        // Si x1 es 0, terminamos (MCD en x0)
    
    // Calculamos x0 = x0 % x1 usando división entera
    udiv x2, x0, x1    // x2 = x0 / x1
    msub x2, x2, x1, x0 // x2 = x0 - (x2 * x1), residuo

    mov x0, x1         // Intercambiamos x0 con x1
    mov x1, x2         // y x1 con el residuo
    b mcd              // Repetimos el proceso

end_mcd:
    ret                // Retornamos con el MCD en x0
