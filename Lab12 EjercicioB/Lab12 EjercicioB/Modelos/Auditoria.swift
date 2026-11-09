//
//  Auditoria.swift
//  Lab12 EjercicioB
//
//  Created by Tecsup on 9/11/26.
//

import Foundation
import SwiftData

@Model
class Auditoria {
    var fecha: Date
    var usuario: String
    var rol: String
    var accion: String
    var detalle: String

    init(usuario: String, rol: String, accion: String, detalle: String, fecha: Date = Date.now) {
        self.fecha = fecha
        self.usuario = usuario
        self.rol = rol
        self.accion = accion
        self.detalle = detalle
    }
}
