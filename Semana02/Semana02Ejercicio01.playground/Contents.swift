import Foundation

//Calendario de pagos

//El interés según las cuotas (6 -> 20%, 12 -> 40%, 24 -> 60%)
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
