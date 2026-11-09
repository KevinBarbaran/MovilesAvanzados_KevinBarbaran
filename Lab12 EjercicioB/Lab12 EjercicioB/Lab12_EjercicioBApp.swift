//
//  Lab12_EjercicioBApp.swift
//  Lab12 EjercicioB
//
//  Created by Tecsup on 9/11/26.
//

import SwiftUI
import SwiftData

@main
struct Lab12_EjercicioBApp: App {
    @State private var sesion = Sesion()

    var body: some Scene {
        WindowGroup {
            RaizView()
                .environment(sesion)
                .environment(\.locale, Locale(identifier: "es_PE"))
                // Contenedor persistente para toda la app (igual que en la Actividad 02)
                .modelContainer(ModelContainerProvider.shared.container)
        }
    }
}
