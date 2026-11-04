//
//  EditarAlumnoView.swift
//  apple_lab11_02_SwiftUI_SwiftData
//
//  Created by Tecsup on 4/11/26.
//

import SwiftUI
import SwiftData

struct EditarAlumnoView: View {
    @Bindable var alumno: Alumno
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Datos del Alumno")) {
                    TextField("Apellido", text: $alumno.apellido)
                    TextField("Nombre", text: $alumno.nombre)
                    TextField("DNI", text: $alumno.dni)
                        .keyboardType(.numberPad)
                }
            }
            .navigationTitle("Editar Alumno")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Listo") { dismiss() }
                }
            }
        }
    }
}
