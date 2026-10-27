//
//  CTSModelo.swift
//  CTSApp
//
//  Created by Tecsup on 27/10/26.
//

import Foundation

enum ErrorCTS: LocalizedError {
    case sueldoInvalido, gratificacionInvalida, mesesInvalidos

    var errorDescription: String? {
        switch self {
        case .sueldoInvalido: return "Ingresa un sueldo mayor a 0."
        case .gratificacionInvalida: return "La gratificación no puede ser negativa."
        case .mesesInvalidos: return "Los meses trabajados deben estar entre 1 y 6."
        }
    }
}

struct ResultadoCTS {
    let sextoGratificacion: Double
    let remuneracionComputable: Double
    let cts: Double
}

struct CalculadoraCTS {
    // CTS = (Sueldo + 1/6 Gratificación) × (Meses / 12)
    static func calcular(sueldo: Double, gratificacion: Double, meses: Int) throws -> ResultadoCTS {
        guard sueldo > 0 else { throw ErrorCTS.sueldoInvalido }
        guard gratificacion >= 0 else { throw ErrorCTS.gratificacionInvalida }
        guard (1...6).contains(meses) else { throw ErrorCTS.mesesInvalidos }

        let sexto = gratificacion / 6
        let computable = sueldo + sexto
        let cts = computable * (Double(meses) / 12)
        return ResultadoCTS(sextoGratificacion: sexto, remuneracionComputable: computable, cts: cts)
    }
}
