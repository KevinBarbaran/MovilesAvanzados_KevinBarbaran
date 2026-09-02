import Foundation

// 1. Funciones auxiliares
func calcularInteres(meses: Int, montoCompra: Double) -> Double {
    switch meses {
    case 6:  return montoCompra * 0.20
    case 12: return montoCompra * 0.40
    case 24: return montoCompra * 0.60
    default: return 0.0
    }
}

// 2. Ingreso de datos
print("Nombre Producto:")
let productoRead = readLine() ?? ""
let producto = productoRead.isEmpty ? "Laptop" : productoRead

print("Precio Unitario:")
let precioRead = Double(readLine() ?? "0") ?? 0.0
let precioUnit = precioRead == 0 ? 2500.0 : precioRead

print("Cantidad:")
let cantidadRead = Int(readLine() ?? "0") ?? 0
let cantidad = cantidadRead == 0 ? 1 : cantidadRead

let montoCompra = precioUnit * Double(cantidad)
print("MONTO TOTAL COMPRA: S/ \(montoCompra)")

// Validar el Plan de Pago (6, 12, 24)
print("Plan de Pago (6, 12, 24):")
let mesesIngresados = Int(readLine() ?? "0") ?? 12
let meses = [6, 12, 24].contains(mesesIngresados) ? mesesIngresados : 12

// Preguntas sobre el Pago Adelantado
print("¿En qué mes hará un Pago Adelantado? (0 = Ninguno):")
let mesAdelantado = Int(readLine() ?? "0") ?? 3

print("Monto Adicional a Pagar ese Mes (S/.):")
let montoAdicional = Double(readLine() ?? "0") ?? 1000.0

