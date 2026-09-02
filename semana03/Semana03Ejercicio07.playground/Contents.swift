// Desarrollado por: Kevin Barbaran
import Foundation // Carga los componentes esenciales de Swift

// TODO 12: Pedir N productos con nombre, precio y stock
var nombresInv: [String] = [] // Lista dinámica para almacenar los nombres de productos
var preciosInv: [Double] = [] // Lista dinámica para almacenar los precios unitarios
var stocksInv: [Int] = [] // Lista dinámica para almacenar las cantidades de stock

let productosDemo = ["Laptop", "Teclado", "Mouse"] // Nombres por defecto para Playgrounds
let preciosDemo = [3500.0, 120.0, 45.0] // Precios por defecto
let stocksDemo = [10, 3, 2] // Cantidades de stock por defecto

print("¿Cuántos productos registrará en el inventario?") // Imprime la consulta inicial
let entradaTotal = readLine() ?? "" // Toma la lectura enviada
let totalProductos = Int(entradaTotal) ?? 3 // Convierte el texto ingresado o asigna 3 por defecto

for i in 1...totalProductos { // Bucle encargado de la carga de ítems
    print("\nProducto \(i) - Nombre:") // Solicita la denominación del ítem
    let entradaNombre = readLine() ?? "" // Lee el texto ingresado
    let nombre = entradaNombre.isEmpty ? productosDemo[i - 1] : entradaNombre // Asigna valor tecleado o simulado
    
    print("Precio:") // Solicita el costo unitario
    let entradaPrecio = readLine() ?? "" // Captura la lectura
    let precio = Double(entradaPrecio) ?? preciosDemo[i - 1] // Asigna valor parseado o simulado
    
    print("Stock:") // Solicita las unidades disponibles
    let entradaStock = readLine() ?? "" // Captura la lectura
    let stock = Int(entradaStock) ?? stocksDemo[i - 1] // Asigna valor parseado o simulado
    
    nombresInv.append(nombre) // Guarda el nombre en el arreglo
    preciosInv.append(precio) // Guarda el precio en el arreglo
    stocksInv.append(stock) // Guarda el stock en el arreglo
}

// TODO 13 y 14: Menú interactivo estructurado con bucle while y reportes formateados
var opcionMenu = 0 // Variable de control para navegar las opciones del menú
let secuenciaOpciones = [1, 2, 3, 4, 5] // Simulación de opciones consecutivas para ejecución en Playgrounds
var pasoSimulacion = 0 // Contador de pasos para consumir el flujo de simulación

while opcionMenu != 5 { // El bucle se repetirá hasta que el usuario decida ingresar la opción 5 (Salir)
    print("\n================ MENÚ DE INVENTARIO ================") // Imprime encabezado visual
    print("1) Ver inventario") // Opción para consultar listado general
    print("2) Buscar producto") // Opción para localizar producto por nombre
    print("3) Ver stock bajo (< 5 unidades)") // Opción para filtrar alertas
    print("4) Ver valor total del inventario") // Opción para consultar balance financiero
    print("5) Salir") // Opción para finalizar el programa
    print("Seleccione una opción (1-5):") // Pide seleccionar una opción
    
    let entradaOpcion = readLine() ?? "" // Captura la lectura del menú
    if !entradaOpcion.isEmpty, let numOption = Int(entradaOpcion) { // Valida si el usuario tecleó un número real
        opcionMenu = numOption // Asigna la opción ingresada por el usuario
    } else { // Si la consola está vacía (como ocurre en Playgrounds)
        opcionMenu = secuenciaOpciones[pasoSimulacion] // Toma la opción de prueba correspondiente
        pasoSimulacion += 1 // Avanza al siguiente paso simulado
        print("-> [Simulación seleccionó opción: \(opcionMenu)]") // Muestra en consola la opción ejecutada
    }
    
    switch opcionMenu { // Evalúa la opción seleccionada y ejecuta el bloque correspondiente
    case 1: // CASO 1: Reporte completo del inventario
        print("\n--- INVENTARIO REGISTRADO ---") // Título del reporte
        for i in 0..<nombresInv.count { // Iteración mediante índice
            print("Ítem: \(nombresInv[i]) | Precio: S/. \(preciosInv[i]) | Stock: \(stocksInv[i]) unids.") // Formato de fila
        }
        
    case 2: // CASO 2: Búsqueda individual de productos
        print("\nIngrese el nombre del producto a buscar:") // Muestra solicitud de búsqueda
        let entradaBuscar = readLine() ?? "" // Lee la consulta ingresada
        let buscar = entradaBuscar.isEmpty ? "Teclado" : entradaBuscar // Asigna producto a buscar
        
        var encontrado = false // Variable bandera para verificar existencia
        for i in 0..<nombresInv.count { // Recorre la lista de productos
            if nombresInv[i].lowercased() == buscar.lowercased() { // Compara ignorando mayúsculas y minúsculas
                print("Resultados: \(nombresInv[i]) cuesta S/. \(preciosInv[i]) con stock de \(stocksInv[i]) unids.") // Imprime detalle
                encontrado = true // Marca que se encontró el ítem
                break // Sale del bucle de búsqueda
            }
        }
        if !encontrado { // Si la bandera permanece en falso
            print("El producto '\(buscar)' no existe en el catálogo.") // Informa ausencia del ítem
        }
        
    case 3: // CASO 3: Filtro de productos con bajo inventario
        print("\n--- REPORTE DE ALERTAS: STOCK BAJO (< 5) ---") // Título del reporte de alerta
        var hayAlertas = false // Bandera de control
        for i in 0..<nombresInv.count { // Recorre los arreglos paralelamente
            if stocksInv[i] < 5 { // Evalúa si la cantidad almacenada es menor a 5
                print("⚠️ Alerta: \(nombresInv[i]) cuenta con solo \(stocksInv[i]) unidades disponibles.") // Imprime alerta
                hayAlertas = true // Confirma existencia de productos en nivel crítico
            }
        }
        if !hayAlertas { // Si ningún producto cumple la condición
            print("Todos los ítems cuentan con suficiente disponibilidad de stock.") // Muestra mensaje de conformidad
        }
        
    case 4: // CASO 4: Balance del valor financiero almacenado
        print("\n--- VALORIZACIÓN DEL INVENTARIO ---") // Título del cálculo monetario
        var valorTotalAcumulado = 0.0 // Acumulador decimal para la suma de capital
        for i in 0..<nombresInv.count { // Iteración sobre colecciones
            let valorSubtotal = preciosInv[i] * Double(stocksInv[i]) // Multiplica costo unitario por unidades
            valorTotalAcumulado += valorSubtotal // Acumula el resultado en la variable total
        }
        print("Valor total acumulado del inventario: S/. \(valorTotalAcumulado)") // Imprime balance global
        
    case 5: // CASO 5: Salida del programa
        print("\nSaliendo del sistema de inventarios. ¡Hasta luego!") // Imprime confirmación de cierre
        
    default: // Manejo de respuestas no válidas
        print("Opción no válida. Ingrese un valor entero del 1 al 5.") // Notifica error de elección
    }
}
