//
//  RegistroView.swift
//  Lab12 EjercicioB
//
//  Created by Tecsup on 9/11/26.
//

import SwiftUI
import SwiftData

struct RegistroView: View {
    @Environment(\.modelContext) private var contexto
    @Environment(Sesion.self) private var sesion

    @State private var nombreCompleto = ""
    @State private var usuario = ""
    @State private var clave = ""
    @State private var confirmacion = ""
    @State private var rol = RolUsuario.comprador
    @State private var usuarioYaExiste = false
    @State private var aviso: Aviso?

    private var usuarioNormalizado: String {
        usuario.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }

    private var errorDeValidacion: String? {
        if nombreCompleto.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { return "Ingresa tu nombre completo." }
        if usuarioNormalizado.isEmpty { return "Ingresa un usuario." }
        if usuarioNormalizado.contains(" ") { return "El usuario no puede tener espacios." }
        if usuarioYaExiste { return "Ese usuario ya existe. Elige otro." }
        if clave.count < Configuracion.largoMinimoClave { return "La clave debe tener mínimo \(Configuracion.largoMinimoClave) caracteres." }
        if clave != confirmacion { return "La clave y su confirmación no coinciden." }
        return nil
    }

    private var hayAlgoEscrito: Bool {
        !nombreCompleto.isEmpty || !usuario.isEmpty || !clave.isEmpty || !confirmacion.isEmpty
    }

    var body: some View {
        Form {
            Section("Datos personales") {
                TextField("Nombre completo", text: $nombreCompleto)
                    .textContentType(.name)
                VStack(alignment: .leading, spacing: 4) {
                    TextField("Usuario", text: $usuario)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                    if usuarioYaExiste {
                        Label("Este usuario ya existe", systemImage: "xmark.circle.fill")
                            .font(.caption).foregroundStyle(.red)
                    } else if !usuarioNormalizado.isEmpty {
                        Label("Usuario disponible", systemImage: "checkmark.circle.fill")
                            .font(.caption).foregroundStyle(.green)
                    }
                }
            }

            Section {
                SecureField("Clave (mínimo \(Configuracion.largoMinimoClave))", text: $clave)
                SecureField("Confirmar clave", text: $confirmacion)
            } header: {
                Text("Seguridad")
            }

            Section("Rol") {
                Picker("Rol", selection: $rol) {
                    ForEach(RolUsuario.allCases) { Text($0.rawValue).tag($0) }
                }
                .pickerStyle(.segmented)
            }

            Section {
                if hayAlgoEscrito, let errorDeValidacion {
                    Label(errorDeValidacion, systemImage: "exclamationmark.triangle.fill")
                        .font(.footnote).foregroundStyle(.red)
                }
                Button("Registrarme", action: registrar)
                    .frame(maxWidth: .infinity)
                    .disabled(errorDeValidacion != nil)
            }
        }
        .navigationTitle("Crear cuenta")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: usuario) { _, _ in
            usuarioYaExiste = existeUsuario(usuarioNormalizado)
        }
        .alertaAviso($aviso)
    }

    private func existeUsuario(_ texto: String) -> Bool {
        guard !texto.isEmpty else { return false }
        let descriptor = FetchDescriptor<Usuario>(predicate: #Predicate { $0.usuario == texto })
        return ((try? contexto.fetchCount(descriptor)) ?? 0) > 0
    }

    private func registrar() {
        usuarioYaExiste = existeUsuario(usuarioNormalizado)
        guard errorDeValidacion == nil else { return }

        let nuevo = Usuario(
            nombre: nombreCompleto.trimmingCharacters(in: .whitespacesAndNewlines),
            usuario: usuarioNormalizado,
            clave: clave,
            rol: rol.rawValue
        )
        contexto.insert(nuevo)
        ServicioAuditoria.registrar("Usuario registrado", detalle: "Alta de \(nuevo.usuario) como \(nuevo.rol)",
                                    usuario: nuevo, contexto: contexto)
        do {
            try contexto.save()
            sesion.iniciar(nuevo)
        } catch {
            aviso = Aviso(titulo: "No se pudo registrar", mensaje: error.localizedDescription)
        }
    }
}
