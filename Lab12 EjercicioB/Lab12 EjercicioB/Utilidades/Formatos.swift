//
//  Formatos.swift
//  Lab12 EjercicioB
//
//  Created by Tecsup on 9/11/26.
//

import SwiftUI

private let localePeru = Locale(identifier: "es_PE")

extension Double {
    var enSoles: String {
        formatted(.currency(code: "PEN").locale(localePeru))
    }
}

extension Date {
    var corta: String {
        formatted(.dateTime.day().month(.abbreviated).year().locale(localePeru))
    }
    var conHora: String {
        formatted(.dateTime.day().month(.abbreviated).year().hour().minute().locale(localePeru))
    }
}

struct Aviso: Identifiable {
    let id = UUID()
    let titulo: String
    let mensaje: String
}

extension View {
    func alertaAviso(_ aviso: Binding<Aviso?>) -> some View {
        alert(
            aviso.wrappedValue?.titulo ?? "Aviso",
            isPresented: Binding(
                get: { aviso.wrappedValue != nil },
                set: { if !$0 { aviso.wrappedValue = nil } }
            ),
            presenting: aviso.wrappedValue
        ) { _ in
            Button("Aceptar", role: .cancel) {}
        } message: { dato in
            Text(dato.mensaje)
        }
    }

    func conBotonListoEnTeclado() -> some View {
        toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Listo") {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                                    to: nil, from: nil, for: nil)
                }
            }
        }
    }
}

struct Etiqueta: View {
    let texto: String
    let color: Color

    var body: some View {
        Text(texto)
            .font(.caption2.bold())
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(color.opacity(0.15), in: Capsule())
            .foregroundStyle(color)
    }
}

extension Producto {
    var colorStock: Color {
        if stock > 10 { return .green }
        if stock >= 6 { return .orange }
        return .red
    }
}

extension Compra {
    var colorEstado: Color {
        switch estado {
        case EstadoCompra.aprobada.rawValue: return .green
        case EstadoCompra.pendiente.rawValue: return .orange
        default: return .red
        }
    }
}
