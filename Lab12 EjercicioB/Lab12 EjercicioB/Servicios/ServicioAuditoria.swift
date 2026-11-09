//
//  ServicioAuditoria.swift
//  Lab12 EjercicioB
//
//  Created by Tecsup on 9/11/26.
//

import Foundation
import SwiftData

enum ServicioAuditoria {
    static func registrar(_ accion: String, detalle: String, usuario: Usuario?, contexto: ModelContext) {
        let registro = Auditoria(
            usuario: usuario?.usuario ?? "sistema",
            rol: usuario?.rol ?? "-",
            accion: accion,
            detalle: detalle
        )
        contexto.insert(registro)
    }
}
