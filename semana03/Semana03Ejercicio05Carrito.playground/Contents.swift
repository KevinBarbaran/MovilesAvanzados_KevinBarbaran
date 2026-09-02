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

// TODO 12: Calcular subtotales
var subtotales: [Double] = []
for i in 0..<nombres.count {
    let sub = precios[i] * Double(cantidades[i])
    subtotales.append(sub)
}

// TODO 13: Total del carrito
var totalCarrito = 0.0
for sub in subtotales {
    totalCarrito += sub
}

// TODO 14: Nombre del cliente
print("\nNombre del cliente:")
let entradaCliente = readLine() ?? ""
let cliente = entradaCliente.isEmpty ? "María García" : entradaCliente

// TODO 15: Descuento
var descPct = 0.0
if totalCarrito >= 5000 {
    descPct = 0.15
} else if totalCarrito >= 2000 {
    descPct = 0.10
} else if totalCarrito >= 500 {
    descPct = 0.05
}

let descuento = totalCarrito * descPct
let totalConDesc = totalCarrito - descuento

// TODO 16: IGV y total
let igv = totalConDesc * 0.18
let totalFinal = totalConDesc + igv

// TODO 17: Categoría
var categoria = ""
switch Int(totalCarrito) {
case 0..<500: categoria = "Regular"
case 500..<2000: categoria = "Frecuente"
case 2000..<5000: categoria = "VIP"
default: categoria = "Premium"
}

// TODO 18: Ticket
let sep = String(repeating: "=", count: 45)
print("\n" + sep)
print(" TICKET DE COMPRA 2.0")
print(" Cliente: \(cliente) (\(categoria))")
print(sep)
for i in 0..<nombres.count {
    print("\(nombres[i]) x\(cantidades[i]) S/. \(subtotales[i])")
}
print(sep)
print("Subtotal: S/. \(totalCarrito)")
if descPct > 0 {
    print("Descuento (\(descPct * 100)%): -S/. \(descuento)")
}
print("IGV (18%): S/. \(igv)")
print(sep)
print("TOTAL: S/. \(totalFinal)")
print(sep)
print("¡Gracias por su compra, \(cliente)!")
