//
//  ExportadorCSV.swift
//  Lab12 EjercicioB
//
//  Created by Tecsup on 9/11/26.
//

import SwiftUI
import UniformTypeIdentifiers

struct ArchivoCSV: Transferable {
    let nombre: String
    let contenido: String

    static var transferRepresentation: some TransferRepresentation {
        FileRepresentation(exportedContentType: .commaSeparatedText) { archivo in
            let url = FileManager.default.temporaryDirectory.appendingPathComponent(archivo.nombre)
            try archivo.contenido.write(to: url, atomically: true, encoding: .utf8)
            return SentTransferredFile(url)
        }
    }
}

enum ExportadorCSV {
    static func comprasEnCSV(_ compras: [Compra]) -> String {
        var lineas = ["Fecha,Comprador,Proveedor,RUC,Producto,Cantidad,Costo unitario,Subtotal,IGV,Total,Condicion,Vence,Estado,Pagada,Motivo de rechazo"]
        for compra in compras {
            let campos: [String] = [
                compra.fecha.formatted(.iso8601.year().month().day()),
                compra.comprador?.nombre ?? "",
                compra.proveedor?.nombre ?? "",
                compra.proveedor?.ruc ?? "",
                compra.producto?.nombre ?? "",
                String(compra.cantidad),
                dos(compra.costoUnitario),
                dos(compra.subtotal),
                dos(compra.igv),
                dos(compra.total),
                compra.alCredito ? "Credito 30 dias" : "Contado",
                compra.vence.formatted(.iso8601.year().month().day()),
                compra.estado,
                compra.pagada ? "Si" : "No",
                compra.motivoRechazo ?? ""
            ]
            lineas.append(campos.map(escapar).joined(separator: ","))
        }
        return "\u{FEFF}" + lineas.joined(separator: "\n")
    }

    private static func dos(_ valor: Double) -> String { String(format: "%.2f", valor) }

    private static func escapar(_ campo: String) -> String {
        "\"" + campo.replacingOccurrences(of: "\"", with: "\"\"") + "\""
    }
}
