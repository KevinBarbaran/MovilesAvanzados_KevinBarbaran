// Desarrollado por: Kevin Barbaran
import Foundation

// ===== CARRITO DE COMPRAS 2.0 =====
var nombres: [String] = []
var precios: [Double] = []
var cantidades: [Int] = []

// Datos de simulación para ejecución automática en Playgrounds
let nombresDemo = ["Laptop", "Mouse"]
let preciosDemo = [3500.0, 45.5]
let cantidadesDemo = [1, 2]

// TODO 11: Pedir productos
print("¿Cuántos productos va a comprar?")
let entradaTotal = readLine() ?? ""
let totalProductos = Int(entradaTotal) ?? 2

for i in 1...totalProductos {
    print("\nProducto \(i) - Nombre:")
    let entradaNombre = readLine() ?? ""
    let nombre = entradaNombre.isEmpty ? nombresDemo[i - 1] : entradaNombre
    nombres.append(nombre)
    
    print("Precio unitario:")
    let entradaPrecio = readLine() ?? ""
    let precio = Double(entradaPrecio) ?? preciosDemo[i - 1]
    precios.append(precio)
    
    print("Cantidad:")
    let entradaCantidad = readLine() ?? ""
    let cantidad = Int(entradaCantidad) ?? cantidadesDemo[i - 1]
    cantidades.append(cantidad)
}
