// Desarrollado por: Kevin Barbaran
import Foundation // Importa el framework base de Swift con tipos de datos estándar

// Se definen datos de prueba para ejecución automática fluida en Playgrounds
let alumnosDemo = ["Carlos", "Ana", "Beto"] // Nombres simulados de alumnos
let notasDemo: [[Double]] = [[18.0, 19.0, 17.5], [14.0, 15.0, 13.5], [10.0, 11.0, 09.0]] // Notas simuladas por alumno

// TODO 8: Registro de alumnos con sus 3 notas en un diccionario
var registroAlumnos: [String: [Double]] = [:] // Clave String (nombre) y valor Array de Double (sus 3 notas)

print("¿Cuántos alumnos registrará?") // Muestra mensaje en pantalla
let entradaN = readLine() ?? "" // Lee entrada por consola
let totalAlumnos = Int(entradaN) ?? 3 // Convierte a entero o asigna 3 por defecto

for i in 1...totalAlumnos { // Bucle para registrar cada alumno
    print("\nAlumno \(i) - Nombre:") // Pide el nombre
    let entradaNombre = readLine() ?? "" // Captura el texto ingresado
    let nombre = entradaNombre.isEmpty ? alumnosDemo[i - 1] : entradaNombre // Asigna valor tecleado o de demostración
    
    var notasAlumno: [Double] = [] // Lista temporal para guardar las 3 notas del alumno actual
    for j in 1...3 { // Bucle secundario para pedir las 3 notas individualmente
        print("Nota \(j):") // Solicita la nota correspondiente
        let entradaNota = readLine() ?? "" // Lee la entrada
        let nota = Double(entradaNota) ?? notasDemo[i - 1][j - 1] // Convierte a Double o toma la nota predeterminada
        notasAlumno.append(nota) // Agrega la nota al arreglo temporal
    }
    registroAlumnos[nombre] = notasAlumno // Almacena el arreglo de notas bajo el nombre del alumno en el diccionario
}

// TODO 9 y 11: Procesamiento de notas, promedios, clasificaciones y ordenamiento
struct RegistroReporte { // Estructura para organizar la información calculada de cada estudiante
    let nombre: String // Guardará el nombre del alumno
    let promedio: Double // Guardará el promedio final obtenido
    let clasificacion: String // Guardará el estado cualitativo según la nota
}

var listaReporte: [RegistroReporte] = [] // Arreglo que contendrá los reportes individuales
var sumaGeneral = 0.0 // Acumulador numérico para calcular el promedio de la clase
var notaMasAlta = 0.0 // Variable de control para identificar la nota máxima general
var notaMasBaja = 20.0 // Variable de control para identificar la nota mínima general
var aprobados = 0 // Contador de estudiantes aprobados

for (alumno, notas) in registroAlumnos { // Iteración sobre cada pareja (clave, valor) del diccionario
    let sumaNotas = notas.reduce(0, +) // Suma todos los elementos numéricos del arreglo de notas
    let promedio = sumaNotas / Double(notas.count) // Divide la suma acumulada entre la cantidad de notas
    sumaGeneral += promedio // Acumula el promedio al total general del grupo
    
    let notaMaxAlumno = notas.max() ?? 0.0 // Busca la nota más alta del estudiante
    let notaMinAlumno = notas.min() ?? 20.0 // Busca la nota más baja del estudiante
    if notaMaxAlumno > notaMasAlta { notaMasAlta = notaMaxAlumno } // Actualiza la máxima general si corresponde
    if notaMinAlumno < notaMasBaja { notaMasBaja = notaMinAlumno } // Actualiza la mínima general si corresponde
    
    // Clasificación cualitativa mediante estructura switch
    var escala = "" // Variable contenedora para el texto del estado
    switch Int(promedio) { // Evalúa la parte entera del promedio obtenido
    case 18...20: escala = "Excelente" // Asigna 'Excelente' para notas de 18 a 20
    case 14...17: escala = "Bueno" // Asigna 'Bueno' para notas de 14 a 17
    case 13: escala = "Aprobado" // Asigna 'Aprobado' para nota justa de 13
    default: escala = "Desaprobado" // Asigna 'Desaprobado' para notas menores a 13
    }
    
    if promedio >= 13.0 { aprobados += 1 } // Incrementa el contador de aprobados si la nota es mayor o igual a 13
    
    let elementoReporte = RegistroReporte(nombre: alumno, promedio: promedio, clasificacion: escala) // Instancia el reporte
    listaReporte.append(elementoReporte) // Agrega el registro procesado a la lista de reportes
}

// TODO 11: Ordenar alumnos según su promedio de mayor a menor
let reporteOrdenado = listaReporte.sorted { $0.promedio > $1.promedio } // Ordena descendente comparando los promedios

print("\n===== REPORTE DE ALUMNOS (ORDENADO POR PROMEDIO) =====") // Encabezado en consola
for rep in reporteOrdenado { // Recorre la lista de alumnos ya ordenada
    print("Alumno: \(rep.nombre) | Promedio: \(rep.promedio) | Estado: \(rep.clasificacion)") // Muestra la información formateada
}

// TODO 10: Mostrar Estadísticas Generales
let promedioGeneral = sumaGeneral / Double(registroAlumnos.count) // Calcula la media general del curso
let porcentajeAprobados = (Double(aprobados) / Double(registroAlumnos.count)) * 100.0 // Calcula el % de aprobados

print("\n===== ESTADÍSTICAS GENERALES DE LA CLASE =====") // Imprime separador de métricas
print("Promedio General: \(promedioGeneral)") // Despliega el promedio de todo el grupo
print("Nota Más Alta Registrada: \(notaMasAlta)") // Imprime la nota máxima general
print("Nota Más Baja Registrada: \(notaMasBaja)") // Imprime la nota mínima general
print("Porcentaje de Aprobados: \(porcentajeAprobados)%") // Imprime el porcentaje de aprobados
