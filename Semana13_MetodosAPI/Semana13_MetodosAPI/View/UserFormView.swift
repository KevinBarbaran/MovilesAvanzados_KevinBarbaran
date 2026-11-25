//
//  UserFormView.swift
//  Semana13_MetodosAPI
//
//  Created by Tecsup on 25/11/26.
//

import SwiftUI

struct UserFormView: View {

    // Permite cerrar el formulario.
    @Environment(\.dismiss) private var dismiss

    // Datos del formulario.
    @State private var name: String
    @State private var email: String

    // Indica si se está editando un usuario existente.
    let isEditing: Bool

    // Acción que ejecutará ContentView al guardar.
    let onSubmit: (String, String) -> Void

    // Inicializador del formulario.
    init(
        name: String = "",
        email: String = "",
        isEditing: Bool = false,
        onSubmit: @escaping (String, String) -> Void
    ) {

        _name = State(initialValue: name)
        _email = State(initialValue: email)

        self.isEditing = isEditing
        self.onSubmit = onSubmit
    }

    var body: some View {

        NavigationStack {

            Form {

                Section("Información del usuario") {

                    TextField("Nombre completo", text: $name)
                        .textInputAutocapitalization(.words)
                        .autocorrectionDisabled()

                    TextField("Correo electrónico", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                }

                Section {

                    Button {

                        let cleanName = name.trimmingCharacters(
                            in: .whitespacesAndNewlines
                        )

                        let cleanEmail = email.trimmingCharacters(
                            in: .whitespacesAndNewlines
                        )

                        // Evita enviar campos vacíos.
                        guard !cleanName.isEmpty,
                              !cleanEmail.isEmpty else {
                            return
                        }

                        // Ejecuta la acción recibida desde ContentView.
                        onSubmit(cleanName, cleanEmail)

                        dismiss()

                    } label: {

                        HStack {

                            Spacer()

                            Text(isEditing ? "Actualizar usuario" : "Guardar usuario")
                                .fontWeight(.semibold)

                            Spacer()
                        }
                    }
                    .disabled(
                        name.trimmingCharacters(
                            in: .whitespacesAndNewlines
                        ).isEmpty ||
                        email.trimmingCharacters(
                            in: .whitespacesAndNewlines
                        ).isEmpty
                    )
                }
            }
            .navigationTitle(
                isEditing ? "Editar usuario" : "Nuevo usuario"
            )
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {

                ToolbarItem(placement: .cancellationAction) {

                    Button("Cancelar") {
                        dismiss()
                    }
                }
            }
        }
    }
}
