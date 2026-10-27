//
//  MenuView.swift
//  CTSApp
//
//  Created by Tecsup on 27/10/26.
//

import SwiftUI

struct MenuView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Módulos") {
                    NavigationLink {
                        CTSView()
                    } label: {
                        Label("Calculadora de CTS", systemImage: "dollarsign.circle.fill")
                    }
                    
                    NavigationLink {
                        InstructorView()
                    } label: {
                        Label("Pago de Instructores", systemImage: "person.badge.clock.fill")
                    }
                    
                    NavigationLink {
                        ContabilidadView()
                    } label: {
                        Label("Análisis de Cuentas (Cobrar/Pagar)", systemImage: "chart.bar.doc.horizontal.fill")
                    }
                }
                
                Section {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Programación en móviles avanzado")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text("Tecsup - 2026")
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Menú del laboratorio")
        }
    }
}

#Preview {
    MenuView()
}
