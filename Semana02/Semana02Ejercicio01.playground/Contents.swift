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
let producto = readLine() ?? "audifonos"
print("Precio:")
let precioUnit = Double(readLine() ?? "100.0") ?? 100.0
print("Cantidad:")
let cantidad = Int(readLine() ?? "5") ?? 5

//monto total de la compra
let montoCompra = precioUnit * Double(cantidad)
print("monto total de la compra : \(montoCompra)")

print("Elige el plan de pago (6, 12, 24):")
let meses = Int(readLine() ?? "6") ?? 6

//Plan de pago

let interes = calcularInteres(meses: meses, montoCompra: montoCompra)
let montoFinanciado = montoCompra + interes
let cuotaMensual = montoFinanciado / Double(meses)

//Encabezado

print("\n--- Plan de pago ---")
print("Producto:   \(producto) | Interés: S/ \(interes) | Cuota M: S/ \(cuotaMensual)")
print("Monto de compra: S/ \(montoCompra) | Monto Financiado: S/ \(montoFinanciado)\n")

var saldoPendiente = montoFinanciado

print("Mes\t|\tMonto Inicial\t|\tCuota Mensual\t|\tResta x Pago")
print("---------------------------------------------------------------------")

for mes in 1...meses {
    let montoInicial = saldoPendiente
    saldoPendiente -= cuotaMensual
    
    if saldoPendiente < 0.001 {
        saldoPendiente = 0.0
    }
    
    let mInicialStr = String(format: "%.2f", montoInicial)
    let cuotaStr = String(format: "%.2f", cuotaMensual)
    let restaStr = String(format: "%.2f", saldoPendiente)
    
    print("\(mes)\t|\tS/ \(mInicialStr)\t\t|\tS/ \(cuotaStr)\t\t|\tS/ \(restaStr)")
}
