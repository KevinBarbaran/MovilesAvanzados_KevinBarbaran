//
//  Compra.swift
//  Lab12 EjercicioB
//
//  Created by Tecsup on 9/11/26.
//

import Foundation
import SwiftData

@Model
class Compra {
    var fecha: Date
    var cantidad: Int
    var costoUnitario: Double
    var igv: Double
    var total: Double
    var alCredito: Bool
    var vence: Date
    var estado: String           // "Pendiente", "Aprobada" o "Rechazada"
    var pagada: Bool
    var motivoRechazo: String?

    // Lado "uno" de las relaciones (el inverso .deny está declarado en Usuario, Proveedor y Producto)
    var comprador: Usuario?
    var proveedor: Proveedor?
    var producto: Producto?

    init(fecha: Date, cantidad: Int, costoUnitario: Double, igv: Double, total: Double,
         alCredito: Bool, vence: Date, estado: String, pagada: Bool, motivoRechazo: String? = nil) {
        self.fecha = fecha
        self.cantidad = cantidad
        self.costoUnitario = costoUnitario
        self.igv = igv
        self.total = total
        self.alCredito = alCredito
        self.vence = vence
        self.estado = estado
        self.pagada = pagada
        self.motivoRechazo = motivoRechazo
    }

    var subtotal: Double { ReglasNegocio.subtotal(cantidad: cantidad, costoUnitario: costoUnitario) }

    /// Pendiente de pago con fecha vencida => se muestra como VENCIDA
    var estaVencida: Bool {
        alCredito && !pagada && estado == EstadoCompra.aprobada.rawValue && vence < Date.now
    }

    var diasDeVencida: Int {
        max(0, Calendar.current.dateComponents([.day], from: vence, to: Date.now).day ?? 0)
    }
}
