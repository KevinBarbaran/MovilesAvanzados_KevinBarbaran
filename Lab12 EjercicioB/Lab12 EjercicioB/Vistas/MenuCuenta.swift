//
//  MenuCuenta.swift
//  Lab12 EjercicioB
//
//  Created by Tecsup on 9/11/26.
//

import SwiftUI
import SwiftData

struct MenuCuenta: ViewModifier {
    @Environment(Sesion.self) private var sesion
    @Environment(\.modelContext) private var contexto
    @State private var confirmarSalida = false

    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        if let usuario = sesion.usuarioActual {
                            Section(usuario.nombre) {
                                Text("Usuario: \(usuario.usuario)")
                                Text("Rol: \(usuario.rol)")
                            }
                        }
                        Button(role: .destructive) {
                            confirmarSalida = true
                        } label: {
                            Label("Cerrar sesión", systemImage: "rectangle.portrait.and.arrow.right")
                        }
                    } label: {
                        Text(sesion.usuarioActual?.iniciales ?? "?")
                            .font(.caption.bold())
                            .frame(width: 30, height: 30)
                            .background(Color.accentColor, in: Circle())
                            .foregroundStyle(.white)
                    }
                    .accessibilityLabel("Cuenta")
                }
            }
            .confirmationDialog("¿Cerrar sesión?", isPresented: $confirmarSalida, titleVisibility: .visible) {
                Button("Cerrar sesión", role: .destructive) { cerrarSesion() }
                Button("Cancelar", role: .cancel) {}
            }
    }

    private func cerrarSesion() {
        ServicioAuditoria.registrar("Cierre de sesión", detalle: "Sesión cerrada",
                                    usuario: sesion.usuarioActual, contexto: contexto)
        try? contexto.save()
        sesion.cerrar()   
    }
}

extension View {
    func conMenuCuenta() -> some View { modifier(MenuCuenta()) }
}
