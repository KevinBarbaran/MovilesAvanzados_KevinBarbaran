import Foundation

//Calendario de pagos

//El interés según las cuotas (6 : 20%, 12 : 40%, 24 : 60%)
func calcularInteres(meses: Int, montoCompra: Double) -> Double {
    if meses == 6 {
        return montoCompra * 0.20
    } else if meses == 12 {
        return montoCompra * 0.40
    } else if meses == 24 {
        return montoCompra * 0.60
    } else {
        return 0.0
    }
}

//lectura de datos
print("Nombre del Producto:")
let producto = readLine() ?? ""
print("Precio:")
let precioUnit = Double(readLine() ?? "0") ?? 0.0
print("Cantidad:")
let cantidad = Int(readLine() ?? "0") ?? 0

//monto total de la compra
let montoCompra = precioUnit * Double(cantidad)
print("monto total de la compra : \(montoCompra)")

print("Elige el plan de pago (6, 12, 24):")
let meses = Int(readLine() ?? "0") ?? 6

//Plan de pago

let interes = calcularInteres(meses: meses, montoCompra: montoCompra)
let montoFinanciado = montoCompra + interes
let cuotaMensual = montoFinanciado / Double(meses)

//Encabezado

print("\n--- Plan de pago ---")
print("Producto:   \(producto) | Interés: S/ \(interes) | Cuota M: S/ \(cuotaMensual)")
print("Monto de compra: S/ \(montoCompra) | Monto Financiado: S/ \(montoFinanciado)\n")


