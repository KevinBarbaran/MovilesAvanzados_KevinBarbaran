//
//  CTSModelo.swift
//  CTSApp
//

import Foundation

enum ErrorCTS: LocalizedError {
    case sueldoInvalido
    case fechaIngresoFutura
    case sinDerechoMinimoCTS

    var errorDescription: String? {
        switch self {
        case .sueldoInvalido:
            return "El sueldo mensual debe ser mayor a 0."
        case .fechaIngresoFutura:
            return "La fecha de ingreso no puede ser posterior a la fecha de corte del semestre."
        case .sinDerechoMinimoCTS:
            return "El trabajador debe acumular al menos 1 mes completo (30 días) de servicios para percibir CTS."
        }
    }
}

enum PeriodoCTS: String, CaseIterable, Identifiable {
    case mayo = "Mayo (Noviembre - Abril)"
    case noviembre = "Noviembre (Mayo - Octubre)"
    
    var id: String { self.rawValue }
}

struct ResultadoCTS {
    let asignacionFamiliaMonto: Double
    let sueldoTotalBase: Double
    let mesesCompletosGrati: Int
    let gratificacionCalculada: Double
    let sextoGratificacion: Double
    let remuneracionComputable: Double
    let mesesSemestreEfectivos: Int
    let diasSemestreEfectivos: Int
    let ctsMeses: Double
    let ctsDias: Double
    let ctsTotal: Double
}

struct CalculadoraCTS {
    static let rmvVigente: Double = 1230.0
    static let tasaAsignacionFamiliar: Double = 0.10
    
    static func calcular(
        sueldo: Double,
        tieneAsignacionFamiliar: Bool,
        periodo: PeriodoCTS,
        anio: Int,
        fechaIngreso: Date,
        inasistenciasDias: Int
    ) throws -> ResultadoCTS {
        
        guard sueldo > 0 else { throw ErrorCTS.sueldoInvalido }
        
        let calendar = Calendar.current
        
        let inicioSemestre: Date
        let finSemestre: Date
        let inicioSemestreGrati: Date
        
        if periodo == .mayo {
            inicioSemestre = calendar.date(from: DateComponents(year: anio - 1, month: 11, day: 1))!
            finSemestre = calendar.date(from: DateComponents(year: anio, month: 4, day: 30))!
            inicioSemestreGrati = calendar.date(from: DateComponents(year: anio - 1, month: 7, day: 1))!
        } else {
            inicioSemestre = calendar.date(from: DateComponents(year: anio, month: 5, day: 1))!
            finSemestre = calendar.date(from: DateComponents(year: anio, month: 10, day: 31))!
            inicioSemestreGrati = calendar.date(from: DateComponents(year: anio, month: 1, day: 1))!
        }
        
        guard fechaIngreso <= finSemestre else { throw ErrorCTS.fechaIngresoFutura }
        
        //Asignación Familiar
        let asigFam = tieneAsignacionFamiliar ? (rmvVigente * tasaAsignacionFamiliar) : 0.0
        let sueldoTotalBase = sueldo + asigFam
        
        //Gratificación según meses calendarios completos (Ley 27735)
        let fechaInicioGrati = max(fechaIngreso, inicioSemestreGrati)
        var mesesGrati = 0
        if fechaInicioGrati < finSemestre {
            let compGrati = calendar.dateComponents([.month], from: fechaInicioGrati, to: finSemestre)
            mesesGrati = min(max(compGrati.month ?? 0, 0), 6)
        }
        
        let gratificacionCalculada = sueldoTotalBase * (Double(mesesGrati) / 6.0)
        let sextoGrati = gratificacionCalculada / 6.0
        let remComputable = sueldoTotalBase + sextoGrati
        
        // La fecha de inicio del cómputo es el mayor entre la Fecha de Ingreso y el Inicio del Semestre
        let fechaInicioCTS = max(fechaIngreso, inicioSemestre)
        
        let compCTS = calendar.dateComponents([.month, .day], from: fechaInicioCTS, to: finSemestre)
        
        let mesesCalendario = compCTS.month ?? 0
        let diasCalendario = compCTS.day ?? 0
        
        let diasTotalesEnSemestre = (mesesCalendario * 30) + diasCalendario - inasistenciasDias
        
        guard diasTotalesEnSemestre >= 30 else { throw ErrorCTS.sinDerechoMinimoCTS }
        
        let mesesEfectivos = min(diasTotalesEnSemestre / 30, 6)
        let diasEfectivos = mesesEfectivos == 6 ? 0 : (diasTotalesEnSemestre % 30)
        
        let ctsMeses = (remComputable / 12.0) * Double(mesesEfectivos)
        let ctsDias = (remComputable / 360.0) * Double(diasEfectivos)
        let ctsTotal = ctsMeses + ctsDias
        
        return ResultadoCTS(
            asignacionFamiliaMonto: asigFam,
            sueldoTotalBase: sueldoTotalBase,
            mesesCompletosGrati: mesesGrati,
            gratificacionCalculada: gratificacionCalculada,
            sextoGratificacion: sextoGrati,
            remuneracionComputable: remComputable,
            mesesSemestreEfectivos: mesesEfectivos,
            diasSemestreEfectivos: diasEfectivos,
            ctsMeses: ctsMeses,
            ctsDias: ctsDias,
            ctsTotal: ctsTotal
        )
    }
}
