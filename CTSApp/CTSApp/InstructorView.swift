//
//  InstructorView.swift
//  CTSApp
//
//  Created by Tecsup on 27/10/26.
//

import SwiftUI

struct InstructorView: View {
    @State private var horasSemanales = 20
    @State private var tasaPension = 0.13
    @State private var incluirIR = false
    @State private var tasaIRTexto = "8"
    
    @State private var resultado: ResultadoInstructor?
    @State private var mensajeError: String?

    let opcionesPension = [
        ("AFP Habitat / Profuturo (10%)", 0.10),
        ("AFP Integra / Prima (~11.8%)", 0.118),
        ("ONP (13%)", 0.13)
    ]

    var body: some View {
        Form {
            Section("Datos del Instructor") {
                HStack {
                    Text("Pago por hora:")
                    Spacer()
                    Text("S/ 50.00").bold()
                }
                Stepper("Horas semanales: \(horasSemanales)", value: $horasSemanales, in: 1...23)
                
                Picker("Pensiones", selection: $tasaPension) {
                    ForEach(opcionesPension, id: \.1) { item in
                        Text(item.0).tag(item.1)
                    }
                }
            }
            
            Section("Descuentos de Ley") {
                Toggle("Aplica Retención IR (5ta Cat.)", isOn: $incluirIR)
                if incluirIR {
                    HStack {
                        Text("Tasa IR estimada (%):")
                        Spacer()
                        TextField("8", text: $tasaIRTexto)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 60)
                    }
                }
            }

            Section {
                Button("Calcular Pago", action: calcular)
                Button("Limpiar", role: .destructive, action: limpiar)
            }

            if let mensajeError {
                Section { Text(mensajeError).foregroundStyle(.red) }
            }

            if let r = resultado {
                Section("Resultado del Pago") {
                    fila("Sueldo Bruto Mensual", r.sueldoBruto)
                    fila("Descuento Pensiones", -r.descuentoPension)
                    if r.descuentoIR > 0 { fila("Retención IR", -r.descuentoIR) }
                    fila("Total Descuentos", -r.totalDescuentos, destacado: true)
                    fila("Sueldo Neto a Cobrar", r.sueldoNeto, destacado: true, color: .green)
                }
                Section("Aportes del Empleador") {
                    fila("ESSALUD (9%)", r.aporteEssalud)
                }
            }
        }
        .navigationTitle("Pago Instructores")
    }

    private func fila(_ titulo: String, _ valor: Double, destacado: Bool = false, color: Color = .primary) -> some View {
        HStack {
            Text(titulo)
            Spacer()
            Text(String(format: "S/ %.2f", valor))
                .fontWeight(destacado ? .bold : .regular)
                .foregroundColor(color)
        }
    }

    private func calcular() {
        mensajeError = nil; resultado = nil
        var tasaIRFinal = 0.0
        if incluirIR {
            guard let irNum = Double(tasaIRTexto.replacingOccurrences(of: ",", with: ".")) else {
                mensajeError = "Tasa de IR inválida."
                return
            }
            tasaIRFinal = irNum / 100.0
        }
        do {
            resultado = try CalculadoraInstructor.calcular(horasSemanales: horasSemanales, tasaPension: tasaPension, tasaIR: tasaIRFinal)
        } catch {
            mensajeError = error.localizedDescription
        }
    }

    private func limpiar() {
        horasSemanales = 20; tasaPension = 0.13; incluirIR = false; tasaIRTexto = "8"
        resultado = nil; mensajeError = nil
    }
}
