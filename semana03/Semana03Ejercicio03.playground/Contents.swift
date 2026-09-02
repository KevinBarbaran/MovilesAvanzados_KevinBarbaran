// Desarrollado por: Kevin Barbaran
import Foundation

// ===== TODO 8: Eliminar duplicados =====
var numeros: [Int] = []
let numerosDemo = [5, 2, 8, 2, 5, 10, 1, 8]

for i in 1...8 {
    let entrada = readLine() ?? ""
    let n = Int(entrada) ?? numerosDemo[i - 1]
    print("Número \(i):\n\(n)")
    numeros.append(n)
}

print("Con duplicados: \(numeros)")
let sinDuplicados = Array(Set(numeros)).sorted()
print("Sin duplicados: \(sinDuplicados)\n")

// ===== TODO 9: Comparar asistencia =====
var lunes: Set<String> = []
var martes: Set<String> = []

let lunesDemo = ["Juan", "Ana", "Carlos", "Maria"]
let martesDemo = ["Ana", "Pedro", "Maria", "Luis"]

print("===== ASISTENCIA LUNES =====")
for i in 1...4 {
    let entrada = readLine() ?? ""
    let nombre = entrada.isEmpty ? lunesDemo[i - 1] : entrada
    print("Alumno \(i):\n\(nombre)")
    lunes.insert(nombre)
}

print("\n===== ASISTENCIA MARTES =====")
for i in 1...4 {
    let entrada = readLine() ?? ""
    let nombre = entrada.isEmpty ? martesDemo[i - 1] : entrada
    print("Alumno \(i):\n\(nombre)")
    martes.insert(nombre)
}

let asistieronAmbos = lunes.intersection(martes)
let soloLunes = lunes.subtracting(martes)
let soloMartes = martes.subtracting(lunes)

print("\n===== RESULTADOS =====")
print("Asistieron ambos días: \(asistieronAmbos)")
print("Solo el lunes: \(soloLunes)")
print("Solo el martes: \(soloMartes)")


print("\n===== Respuestas esperadas. =====")

let a: Set = [1, 2, 3, 4, 5]
let b: Set = [4, 5, 6, 7, 8]

print(a.intersection(b))
// PREDICT 5: [4, 5] (o [5, 4] ya que el Set no tiene orden)
print(a.union(b).count)
// PREDICT 6: 8 | Los elementos del 1 al 8 sin repetir
print(a.subtracting(b))
// PREDICT 7: [1, 2, 3] Los elementos de 'a' quitando el 4 y 5

var repetidos: Set = ["A", "B", "A", "C", "B"]
print(repetidos.count)   // PREDICT 8: 3 (Set descarta automáticamente duplicados: quedan "A", "B", "C")
