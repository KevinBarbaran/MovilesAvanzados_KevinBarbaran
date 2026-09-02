// Desarrollado por: Kevin Barbaran

import Foundation

// ===== TODO 1: Registro de 5 alumnos =====
var alumnos: [String] = []
let nombresDemo = ["Carlos", "Ana", "Beto", "Diana", "Elena"]

for i in 1...5 {
    let entrada = readLine() ?? ""
    let nombre = entrada.isEmpty ? nombresDemo[i - 1] : entrada
    print("Nombre del alumno \(i):\n\(nombre)")
    alumnos.append(nombre)
}
print("\nAlumnos registrados: \(alumnos)")

// ===== TODO 2: Buscar un alumno =====
print("\nIngresa el nombre del alumno a buscar:")
let entradaBuscar = readLine() ?? ""
let buscar = entradaBuscar.isEmpty ? "Ana" : entradaBuscar
print(buscar)

if alumnos.contains(buscar) {
    print("\(buscar) está en la lista")
} else {
    print("\(buscar) NO está en la lista")
}

// ===== TODO 3: Notas con clasificación =====
var notasClase: [Double] = []
let notasDemo = [15.5, 11.0, 18.0, 10.5, 14.0]

print("")
for i in 1...5 {
    let entrada = readLine() ?? ""
    let n = Double(entrada) ?? notasDemo[i - 1]
    print("Nota del alumno \(i):\n\(n)")
    notasClase.append(n)
}

var aprobados = 0
var desaprobados = 0
var sumaNotas = 0.0

for nota in notasClase {
    sumaNotas += nota
    if nota >= 13 {
        aprobados += 1
    } else {
        desaprobados += 1
    }
}

print("\n--- Resultados del Aula ---")
print("Promedio: \(sumaNotas / Double(notasClase.count))")
print("Aprobados: \(aprobados), Desaprobados: \(desaprobados)")

print("\n------- FIX: Corrección de los 3 errores. -------")


// FIX 1: Se encontro un error de tipo de dato (osea type mismatch). Esto nos indico que lo incorrec﻿to fue: frutas.append(7) | siendo que "frutas" es string, no acepta int.

var frutas = ["Manzana", "Plátano", "Naranja"]
frutas.append("Uva")

// Para solucionarlo se debe agregar un valor de tipo string.

// FIX 2: La empleación de let fue erronea, let colores = ... |Esto pues "let" define una constante inmutable.

var colores = ["Rojo", "Azul", "Verde"]
// Se cambió "let" por "var" para poder usar append().
colores.append("Amarillo")

// FIX 3: Se indico de forma erronea el rango del indice, puesto que el numeros[5] no existe como tal. Esto es así ya que nuestro índices va de 0 a 4 (10->0, 20->1, 30->2, 40->3, 50->4).

let numeros = [10, 20, 30, 40, 50]
print(numeros[4])
//El último elemento está en la posición 4.

print("\n------- Respuestas esperadas. -------")


var lista = [1, 2, 3, 4, 5]
lista.remove(at: 0)
// Eliminará el elemento en índice 0 (el 1).
lista.append(6)
// Agrega 6 al final.

print(lista)
// PREDICT 1: [2, 3, 4, 5, 6]
print(lista.count)
// PREDICT 2: 5

var nombres = ["Ana", "Carlos", "Beto"]
print(nombres.sorted())
// PREDICT 3: ["Ana", "Beto", "Carlos"]
print(nombres)
// PREDICT 4: ["Ana", "Carlos", "Beto"]
