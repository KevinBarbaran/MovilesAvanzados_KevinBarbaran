//
//  ServicioCompras.swift
//  Lab12 EjercicioB
//
//  Created by Tecsup on 9/11/26.
//

import Foundation
import SwiftData

enum ErrorCompras: LocalizedError {
    case motivoVacio
    case estadoInvalido
    case datosIncompletos

    var errorDescription: String? {
        switch self {
        case .motivoVacio: return "Debe indicar el motivo del rechazo."
        case .estadoInvalido: return "La compra ya no está en un estado que permita esta operación."
        case .datosIncompletos: return "Faltan datos o hay valores no válidos en la compra."
        }
    }
}

enum ServicioCompras {

    static func registrar(comprador: Usuario, proveedor: Proveedor, producto: Producto,
                          cantidad: Int, costoUnitario: Double, alCredito: Bool,
                          fecha: Date, contexto: ModelContext) throws -> Compra {
        guard cantidad > 0, costoUnitario > 0 else { throw ErrorCompras.datosIncompletos }

        let subtotal = ReglasNegocio.subtotal(cantidad: cantidad, costoUnitario: costoUnitario)
        let igv = ReglasNegocio.igv(subtotal: subtotal)
        let total = ReglasNegocio.total(subtotal: subtotal, igv: igv)

        let compra = Compra(
            fecha: fecha,
            cantidad: cantidad,
            costoUnitario: costoUnitario,
            igv: igv,
            total: total,
            alCredito: alCredito,
            vence: ReglasNegocio.fechaVencimiento(desde: fecha, alCredito: alCredito),
            estado: EstadoCompra.pendiente.rawValue,
            pagada: !alCredito
        )
        contexto.insert(compra)
        compra.comprador = comprador
        compra.proveedor = proveedor
        compra.producto = producto

        let descripcion = "\(cantidad) × \(producto.nombre) a \(costoUnitario.enSoles) · \(proveedor.nombre) · total \(total.enSoles) · \(alCredito ? "crédito" : "contado")"

        if ReglasNegocio.requiereAprobacion(total: total) {
            ServicioAuditoria.registrar("Compra enviada a aprobación", detalle: descripcion,
                                        usuario: comprador, contexto: contexto)
        } else {
            aplicarEfectos(de: compra)
            compra.estado = EstadoCompra.aprobada.rawValue
            ServicioAuditoria.registrar("Compra registrada", detalle: descripcion,
                                        usuario: comprador, contexto: contexto)
        }
        try contexto.save()
        return compra
    }

    static func aprobar(_ compra: Compra, supervisor: Usuario, contexto: ModelContext) throws {
        guard compra.estado == EstadoCompra.pendiente.rawValue else { throw ErrorCompras.estadoInvalido }
        aplicarEfectos(de: compra)
        compra.estado = EstadoCompra.aprobada.rawValue
        ServicioAuditoria.registrar("Compra aprobada", detalle: resumen(compra),
                                    usuario: supervisor, contexto: contexto)
        try contexto.save()
    }

    static func rechazar(_ compra: Compra, motivo: String, supervisor: Usuario, contexto: ModelContext) throws {
        let motivoLimpio = motivo.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !motivoLimpio.isEmpty else { throw ErrorCompras.motivoVacio }
        guard compra.estado == EstadoCompra.pendiente.rawValue else { throw ErrorCompras.estadoInvalido }
        compra.estado = EstadoCompra.rechazada.rawValue
        compra.motivoRechazo = motivoLimpio
        ServicioAuditoria.registrar("Compra rechazada", detalle: "\(resumen(compra)) · motivo: \(motivoLimpio)",
                                    usuario: supervisor, contexto: contexto)
        try contexto.save()
    }

    static func pagar(_ compra: Compra, supervisor: Usuario, contexto: ModelContext) throws {
        guard compra.alCredito, !compra.pagada,
              compra.estado == EstadoCompra.aprobada.rawValue else { throw ErrorCompras.estadoInvalido }
        compra.pagada = true
        ServicioAuditoria.registrar("Compra pagada", detalle: resumen(compra),
                                    usuario: supervisor, contexto: contexto)
        try contexto.save()
    }

    // MARK: - Privado

    private static func aplicarEfectos(de compra: Compra) {
        guard let producto = compra.producto else { return }
        producto.costoPromedio = ReglasNegocio.costoPromedioPonderado(
            stockActual: producto.stock,
            costoPromedioActual: producto.costoPromedio,
            cantidad: compra.cantidad,
            costoUnitario: compra.costoUnitario
        )
        producto.stock += compra.cantidad
    }

    private static func resumen(_ compra: Compra) -> String {
        "\(compra.cantidad) × \(compra.producto?.nombre ?? "producto") · \(compra.proveedor?.nombre ?? "proveedor") · \(compra.total.enSoles)"
    }
}
