// Desarrollado por: Kevin Barbaran
import Foundation

var precios: [String: Double] = [:]
var stocks: [String: Int] = [:]

print("¿Cuántos productos?")
// Si readLine() viene vacío por Playgrounds, toma 3 por defecto
let n = Int(readLine() ?? "") ?? 3

// Listas de prueba simples para que Playgrounds imprima directo
let nombresDemo = ["Teclado", "Mouse", "Monitor"]
let preciosDemo = [120.0, 45.0, 650.0]
let stocksDemo = [10, 3, 2]

for i in 1...n {
    print("Producto \(i) - Nombre:")
    let entradaNombre = readLine() ?? ""
    let nombre = entradaNombre.isEmpty ? nombresDemo[i - 1] : entradaNombre
    
    print("Precio:")
    let entradaPrecio = readLine() ?? ""
    let precio = Double(entradaPrecio) ?? preciosDemo[i - 1]
    
    print("Stock:")
    let entradaStock = readLine() ?? ""
    let stock = Int(entradaStock) ?? stocksDemo[i - 1]
    
    precios[nombre] = precio
    stocks[nombre] = stock
}

print("\n===== REPORTE DE INVENTARIO =====")
var valorTotal = 0.0

for (producto, precio) in precios {
    if let stock = stocks[producto] {
        let subtotal = precio * Double(stock)
        valorTotal += subtotal
        print("\(producto): S/. \(precio) x \(stock) unidades = S/. \(subtotal)")
    }
}

print("\nValor total del inventario: S/. \(valorTotal)")

print("\n===== PRODUCTOS CON STOCK BAJO (< 5) =====")
for (producto, stock) in stocks {
    if stock < 5 {
        print("\(producto) (Stock: \(stock))")
    }
}
