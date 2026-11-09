//
//  ModelContainerProvider.swift
//  Lab12 EjercicioB
//
//  Created by Tecsup on 9/11/26.
//

import Foundation
import SwiftData

@MainActor
class ModelContainerProvider {
    static let shared = ModelContainerProvider()

    let container: ModelContainer

    private init() {
        let esquema = Schema([Usuario.self, Proveedor.self, Producto.self, Compra.self, Auditoria.self])
        do {
            let carpeta = FileManager.default
                .urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
            try FileManager.default.createDirectory(at: carpeta, withIntermediateDirectories: true)

            let configuracion = ModelConfiguration(
                "ComprasData",
                schema: esquema,
                url: carpeta.appendingPathComponent("ComprasData.sqlite")
            )
            print("Base de datos SQLite en: \(configuracion.url.path)")
            container = try ModelContainer(for: esquema, configurations: [configuracion])
        } catch {
            fatalError("Error al inicializar ModelContainer: \(error)")
        }
    }
}
