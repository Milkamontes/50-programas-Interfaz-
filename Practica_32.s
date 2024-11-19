// Autor: Milka Guadalupe Montes Domínguez
// Fecha: 10-11-24
// Descripción: Este programa calcula la potencia x^n 

.global _start       // Punto de entrada para el sistema operativo

_start:
    mov x0, #2       // Base (ejemplo: x = 2)
    mov x1, #5       // Exponente (ejemplo: n = 5)

    // Inicializamos el resultado a 1 (ya que cualquier número elevado a 0 es 1)
    mov x2, x0       // Guardamos la base en x2 para la multiplicación repetida
    mov x0, #1       // El resultado inicial es 1

power_loop:
    cmp x1, #0       // Comparamos el exponente con 0
    beq end_power    // Si el exponente es 0, terminamos el bucle

    // Multiplicamos el resultado por la base y reducimos el exponente
    mul x0, x0, x2   // x0 = x0 * base (resultado acumulado)
    sub x1, x1, #1   // Reducimos el exponente en 1
    b power_loop     // Repetimos el bucle

end_power:
    // El resultado final (x^n) está en x0
    mov w8, #93      // Código de salida del sistema para "exit" en Linux
    svc #0           // Llamada al sistema para finalizar el programa
