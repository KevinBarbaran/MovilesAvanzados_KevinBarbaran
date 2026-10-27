//
//  InstructorModelo.swift
//  CTSApp
//
//  Created by Tecsup on 27/10/26.
//

import Foundation

enum ErrorInstructor: LocalizedError {
    case horasInvalidas, porcentajeInvalido

    var errorDescription: String? {
        switch self {
        case .horasInvalidas: return "Las horas semanales deben estar entre 1 y 23."
        case .porcentajeInvalido: return "Selecciona una tasa de AFP/ONP válida."
        }
    }
}

struct ResultadoInstructor {
    let sueldoBruto: Double
    let descuentoPension: Double
    let descuentoIR: Double
    let aporteEssalud: Double
    let totalDescuentos: Double
    let sueldoNeto: Double
}

struct CalculadoraInstructor {
    static let pagoPorHora: Double = 50.0
    static let maxHorasSemanales: Int = 23
    
    static func calcular(horasSemanales: Int, tasaPension: Double, tasaIR: Double = 0.0) throws -> ResultadoInstructor {
        guard (1...maxHorasSemanales).contains(horasSemanales) else { throw ErrorInstructor.horasInvalidas }
        guard (0.10...0.13).contains(tasaPension) else { throw ErrorInstructor.porcentajeInvalido }
        
        let bruto = Double(horasSemanales) * pagoPorHora * 4.0
        let pension = bruto * tasaPension
        let ir = bruto * tasaIR
        let totalDesc = pension + ir
        let neto = bruto - totalDesc
        let essalud = bruto * 0.09
        
        return ResultadoInstructor(
            sueldoBruto: bruto,
            descuentoPension: pension,
            descuentoIR: ir,
            aporteEssalud: essalud,
            totalDescuentos: totalDesc,
            sueldoNeto: neto
        )
    }
}
