//
//  Lab14IntroFirebaseApp.swift
//  Lab14IntroFirebase
//
//  Punto de entrada de la aplicación.
//  Aquí se inicializa Firebase UNA sola vez, antes de que se cree cualquier vista.
//

import SwiftUI
import FirebaseCore            // Necesario para usar FirebaseApp

@main
struct Semana14: App {

    // El inicializador de la App se ejecuta antes de construir la primera escena.
    // Por eso es el lugar correcto para configurar Firebase: así AuthView y
    // DatabaseService ya encuentran Firebase listo cuando lo necesitan.
    init() {
        // Lee GoogleService-Info.plist (API_KEY, GOOGLE_APP_ID, PROJECT_ID, BUNDLE_ID...)
        // y crea la instancia por defecto de Firebase.
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
