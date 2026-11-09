//
//  Proveedor.swift
//  Lab12 EjercicioB
//
//  Created by Tecsup on 9/11/26.
//

import Foundation
import SwiftData

@Model
class Proveedor {
    var nombre: String
    var ruc: String

    @Relationship(deleteRule: .deny, inverse: \Compra.proveedor)
    var compras: [Compra] = []

    init(nombre: String, ruc: String) {
        self.nombre = nombre
        self.ruc = ruc
    }

    // Valores calculados desde las compras del proveedor (no se guardan)
    var comprasAprobadas: [Compra] {
        compras.filter { $0.estado == EstadoCompra.aprobada.rawValue }
    }
    var totalComprado: Double {
        comprasAprobadas.reduce(0) { $0 + $1.total }
    }
    var montoPorPagar: Double {
        comprasAprobadas.filter { $0.alCredito && !$0.pagada }.reduce(0) { $0 + $1.total }
    }
}
