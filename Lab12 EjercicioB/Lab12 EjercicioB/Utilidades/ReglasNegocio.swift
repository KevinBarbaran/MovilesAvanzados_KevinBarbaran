//
//  ReglasNegocio.swift
//  Lab12 EjercicioB
//
//  Created by Tecsup on 9/11/26.
//

import Foundation

enum ReglasNegocio {

    static func redondear(_ valor: Double) -> Double {
        (valor * 100).rounded() / 100
    }

    static func subtotal(cantidad: Int, costoUnitario: Double) -> Double {
        redondear(Double(cantidad) * costoUnitario)
    }

    static func igv(subtotal: Double) -> Double {
        redondear(subtotal * Configuracion.tasaIGV)
    }

    static func total(subtotal: Double, igv: Double) -> Double {
        redondear(subtotal + igv)
    }

    static func requiereAprobacion(total: Double) -> Bool {
        total >= Configuracion.umbralAprobacion
    }

    static func costoPromedioPonderado(stockActual: Int, costoPromedioActual: Double,
                                       cantidad: Int, costoUnitario: Double) -> Double {
        let unidades = stockActual + cantidad
        guard unidades > 0 else { return costoUnitario }
        let valor = Double(stockActual) * costoPromedioActual + Double(cantidad) * costoUnitario
        return valor / Double(unidades)
    }

    static func fechaVencimiento(desde fecha: Date, alCredito: Bool) -> Date {
        guard alCredito else { return fecha }
        return Calendar.current.date(byAdding: .day, value: Configuracion.diasDeCredito, to: fecha) ?? fecha
    }
}
