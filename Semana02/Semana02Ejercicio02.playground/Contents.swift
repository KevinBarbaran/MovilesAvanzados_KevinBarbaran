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

// 3. Cálculos de Financiamiento
let interes = calcularInteres(meses: meses, montoCompra: montoCompra)
let montoFinanciado = montoCompra + interes
let cuotaMensual = montoFinanciado / Double(meses)

print("\n===== PLAN DE PAGO =====")
print("Producto: \(producto)")
print("Monto Compra: S/ \(montoCompra) | Interés: S/ \(interes)")
print("Monto Financiado: S/ \(montoFinanciado) | Cuota Mensual: S/ \(cuotaMensual.formatted(.number.precision(.fractionLength(2))))\n")

// 4. Generación de la Tabla
var saldoPendiente = montoFinanciado
var mesesPagados = 0
let calendario = Calendar.current
let fechaActual = Date()

// Formateador para la columna de Fecha (dd/MM/yyyy)
let dateFormatter = DateFormatter()
dateFormatter.dateFormat = "dd/MM/yyyy"

print("Mes\t|\tFecha\t\t|\tMonto Inicial\t|\tPago\t\t|\tResta por Pagar")
print("----------------------------------------------------------------------------------------------------")

for mes in 1...meses {
    if saldoPendiente <= 0 {
        break
    }
    
    mesesPagados += 1
    let montoInicial = saldoPendiente
    
    // Calcular la fecha para el mes correspondiente
    let fechaMes = calendario.date(byAdding: .month, value: mes - 1, to: fechaActual) ?? fechaActual
    let fechaStr = dateFormatter.string(from: fechaMes)
    
    // Determinar el pago de este mes (Cuota normal + Monto adicional si aplica)
    var pagoMes = cuotaMensual
    if mes == mesAdelantado {
        pagoMes += montoAdicional
    }
    

