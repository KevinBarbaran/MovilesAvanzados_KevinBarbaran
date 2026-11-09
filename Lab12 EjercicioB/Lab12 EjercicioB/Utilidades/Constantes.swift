//
//  Constantes.swift
//  Lab12 EjercicioB
//
//  Created by Tecsup on 9/11/26.
//

import Foundation

enum RolUsuario: String, CaseIterable, Identifiable {
    case comprador = "Comprador"
    case supervisor = "Supervisor"
    var id: String { rawValue }
}

enum EstadoCompra: String {
    case pendiente = "Pendiente"
    case aprobada = "Aprobada"
    case rechazada = "Rechazada"
}

enum Configuracion {
    static let tasaIGV = 0.18              
    static let umbralAprobacion = 5_000.0
    static let diasDeCredito = 30
    static let largoMinimoClave = 6
    static let largoRUC = 11
}
