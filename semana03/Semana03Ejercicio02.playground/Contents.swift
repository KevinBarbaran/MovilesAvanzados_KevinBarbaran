// Desarrollado por: Kevin Barbaran

import Foundation

// ===== TODO 4: Catálogo de productos =====
var productos: [String: Double] = [:]

// Añadire datos de simulación para entornos estáticos como playgrounds
let productosDemo = ["laptop", "mouse", "teclado", "monitor"]
let preciosDemo = [2500.0, 45.0, 120.0, 650.0]

for i in 1...4 {
    let entradaNombre = readLine() ?? ""
    let nombre = entradaNombre.isEmpty ? productosDemo[i - 1] : entradaNombre
    print("Producto \(i) - Nombre:\n\(nombre)")
    
    let entradaPrecio = readLine() ?? ""
    let precio = Double(entradaPrecio) ?? preciosDemo[i - 1]
    print("Precio:\n\(precio)")
    
    productos[nombre] = precio
}

// ===== TODO 5: Mostrar catálogo =====
print("\n===== CATÁLOGO =====")
for (nombre, precio) in productos {
    print("\(nombre): S/. \(precio)")
}

// ===== TODO 6: Valor total =====
var valorTotal = 0.0
for (_, precio) in productos {
    valorTotal += precio
}
print("\nValor total del catálogo: S/. \(valorTotal)")

// ===== TODO 7: Buscar producto =====
print("\nBuscar producto:")
let entradaBuscar = readLine() ?? ""
let buscarProd = entradaBuscar.isEmpty ? "Mouse" : entradaBuscar
print(buscarProd)

if let precioEncontrado = productos[buscarProd] {
    print("\(buscarProd) cuesta S/. \(precioEncontrado)")
} else {
    print("Producto no encontrado")
}
