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

