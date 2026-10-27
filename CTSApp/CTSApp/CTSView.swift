//
//  CTSView.swift
//  CTSApp
//
//  Created by Tecsup on 27/10/26.
//

import SwiftUI

struct CTSView: View {
    @State private var sueldo = ""
    @State private var gratificacion = ""
    @State private var meses = 6
    @State private var resultado: ResultadoCTS?
    @State private var mensajeError: String?

    var body: some View {
        NavigationStack {
            Form {
                Section("Datos del trabajador") {
                    TextField("Sueldo mensual (S/)", text: $sueldo)
                        .keyboardType(.decimalPad)
                    TextField("Gratificación del semestre (S/)", text: $gratificacion)
                        .keyboardType(.decimalPad)
                    Stepper("Meses trabajados: \(meses)", value: $meses, in: 1...6)
                }

                Section {
                    Button("Calcular CTS", action: calcular)
                    Button("Limpiar", role: .destructive, action: limpiar)
                }

                if let mensajeError {
                    Section { Text(mensajeError).foregroundStyle(.red) }
                }

                if let r = resultado {
                    Section("Resultado") {
                        fila("1/6 de gratificación", r.sextoGratificacion)
                        fila("Remuneración computable", r.remuneracionComputable)
                        fila("CTS a depositar", r.cts, destacado: true)
                    }
                }
            }
            .navigationTitle("Calculadora CTS")
        }
    }

    private func fila(_ titulo: String, _ valor: Double, destacado: Bool = false) -> some View {
        HStack {
            Text(titulo)
            Spacer()
            Text(String(format: "S/ %.2f", valor))
                .fontWeight(destacado ? .bold : .regular)
        }
    }

    private func numero(_ texto: String) -> Double? {
        Double(texto.replacingOccurrences(of: ",", with: "."))
    }

    private func calcular() {
        mensajeError = nil
        resultado = nil
        guard let s = numero(sueldo) else {
            mensajeError = "Ingresa un sueldo válido (solo números)."
            return
        }
        let g = gratificacion.isEmpty ? 0 : numero(gratificacion)
        guard let g else {
            mensajeError = "La gratificación no es un número válido."
            return
        }
        do {
            resultado = try CalculadoraCTS.calcular(sueldo: s, gratificacion: g, meses: meses)
        } catch {
            mensajeError = error.localizedDescription
        }
    }

    private func limpiar() {
        sueldo = ""; gratificacion = ""; meses = 6
        resultado = nil; mensajeError = nil
    }
}

#Preview { CTSView() }
