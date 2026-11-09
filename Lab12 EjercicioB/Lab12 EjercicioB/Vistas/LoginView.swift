//
//  LoginView.swift
//  Lab12 EjercicioB
//
//  Created by Tecsup on 9/11/26.
//

import SwiftUI
import SwiftData

struct LoginView: View {
    @Environment(\.modelContext) private var contexto
    @Environment(Sesion.self) private var sesion

    @State private var usuario = ""
    @State private var clave = ""
    @State private var mensajeError: String?

    private var puedeIngresar: Bool {
        !usuario.trimmingCharacters(in: .whitespaces).isEmpty && !clave.isEmpty
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    VStack(spacing: 8) {
                        Image(systemName: "shippingbox.fill")
                            .font(.system(size: 56))
                            .foregroundStyle(.white)
                            .frame(width: 100, height: 100)
                            .background(Color.accentColor.gradient, in: RoundedRectangle(cornerRadius: 24))
                        Text("Compras")
                            .font(.largeTitle.bold())
                        Text("Gestión de compras, proveedores y cuentas por pagar")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 40)

                    VStack(spacing: 12) {
                        TextField("Usuario", text: $usuario)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .textContentType(.username)
                            .padding(12)
                            .background(.quaternary, in: RoundedRectangle(cornerRadius: 10))
                        SecureField("Clave", text: $clave)
                            .textContentType(.password)
                            .padding(12)
                            .background(.quaternary, in: RoundedRectangle(cornerRadius: 10))

                        if let mensajeError {
                            Label(mensajeError, systemImage: "exclamationmark.triangle.fill")
                                .font(.footnote)
                                .foregroundStyle(.red)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }

                        Button(action: ingresar) {
                            Text("Ingresar").frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                        .disabled(!puedeIngresar)

                        NavigationLink("¿No tienes cuenta? Crear cuenta") {
                            RegistroView()
                        }
                        .font(.subheadline)
                        .padding(.top, 4)
                    }
                    .padding(.horizontal)
                }
            }
            .scrollDismissesKeyboard(.interactively)
        }
    }

    private func ingresar() {
        let usuarioNormalizado = usuario.trimmingCharacters(in: .whitespaces).lowercased()
        let claveIngresada = clave

        let descriptor = FetchDescriptor<Usuario>(
            predicate: #Predicate { $0.usuario == usuarioNormalizado && $0.clave == claveIngresada }
        )
        if let encontrado = try? contexto.fetch(descriptor).first {
            mensajeError = nil
            ServicioAuditoria.registrar("Inicio de sesión", detalle: "Ingreso a la app",
                                        usuario: encontrado, contexto: contexto)
            try? contexto.save()
            sesion.iniciar(encontrado)
        } else {
            mensajeError = "Usuario o clave incorrectos"
            clave = ""
        }
    }
}
