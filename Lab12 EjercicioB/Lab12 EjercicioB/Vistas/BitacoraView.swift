//
//  BitacoraView.swift
//  Lab12 EjercicioB
//
//  Created by Tecsup on 9/11/26.
//

import SwiftUI
import SwiftData

struct BitacoraView: View {
    @Query(sort: \Auditoria.fecha, order: .reverse) private var registros: [Auditoria]
    @State private var busqueda = ""

    private var registrosFiltrados: [Auditoria] {
        let texto = busqueda.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !texto.isEmpty else { return registros }
        return registros.filter {
            $0.accion.localizedCaseInsensitiveContains(texto)
                || $0.usuario.localizedCaseInsensitiveContains(texto)
                || $0.detalle.localizedCaseInsensitiveContains(texto)
        }
    }

    var body: some View {
        List(registrosFiltrados) { registro in
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(registro.accion).font(.headline)
                    Spacer()
                    Text(registro.fecha.conHora).font(.caption).foregroundStyle(.secondary)
                }
                Text(registro.detalle).font(.subheadline)
                Text("\(registro.usuario) · \(registro.rol)").font(.caption).foregroundStyle(.secondary)
            }
            .padding(.vertical, 2)
        }
        .overlay {
            if registros.isEmpty {
                ContentUnavailableView("Sin movimientos", systemImage: "list.clipboard")
            } else if registrosFiltrados.isEmpty {
                ContentUnavailableView.search(text: busqueda)
            }
        }
        .searchable(text: $busqueda, prompt: "Buscar acción, usuario o detalle")
        .navigationTitle("Bitácora")
        .navigationBarTitleDisplayMode(.inline)
    }
}
