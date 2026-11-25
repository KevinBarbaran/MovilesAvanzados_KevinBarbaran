//
//  ContentView.swift
//  Lab14IntroFirebase
//
//  Vista raíz. Solo delega en AuthView, que decide si muestra el
//  formulario de login o la pantalla de mensajes según el estado de sesión.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        AuthView()
    }
}

#Preview {
    ContentView()
}
