//
//  CTSView.swift
//  CTSApp
//

import SwiftUI

struct CTSView: View {
    @State private var sueldoTexto = ""
    @State private var tieneAsignacionFamiliar = false
    @State private var periodoSeleccionado: PeriodoCTS = .noviembre
    @State private var fechaIngreso = Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 1))!
    @State private var inasistencias = 0
    
    // El año se toma automáticamente del calendario actual
    private var anioActual: Int {
        Calendar.current.component(.year, from: Date())
    }

    @State private var resultado: ResultadoCTS?
    @State private var mensajeError: String?

    var body: some View {
        NavigationStack {
            Form {
                Section("Periodo a Liquidar (Corte Legal)") {
                    Picker("Periodo CTS", selection: $periodoSeleccionado) {
                        ForEach(PeriodoCTS.allCases) { p in
                            Text(p.rawValue).tag(p)
                        }
                    }
                    
                    // Muestra el año del calendario de forma informativa, sin permitir manipularlo
                    HStack {
                        Text("Año Fiscal")
                        Spacer()
                        Text("\(String(anioActual))")
                            .foregroundStyle(.secondary)
                    }
                }
                
                Section("Datos del Trabajador") {
                    HStack {
                        Text("Sueldo Mensual (S/)")
                        Spacer()
                        TextField("0.00", text: $sueldoTexto)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    Toggle("¿Asignación Familiar (Hijos)?", isOn: $tieneAsignacionFamiliar)
                    
                    DatePicker("Fecha de Ingreso", selection: $fechaIngreso, displayedComponents: .date)
                }
                
                Section("Control de Inasistencias") {
                    Stepper("Días de faltas injustificadas: \(inasistencias)", value: $inasistencias, in: 0...30)
                }

                Section {
                    Button("Calcular CTS Oficial", action: calcular)
                        .frame(maxWidth: .infinity)
                        .fontWeight(.bold)
                }

                if let mensajeError {
                    Section("Aviso del Sistema") {
                        Label(mensajeError, systemImage: "exclamationmark.octagon.fill")
                            .foregroundStyle(.red)
                    }
                }

                if let r = resultado {
                    Section("Antigüedad y Gratificación Calculada") {
                        fila("Meses completados para Grati", Double(r.mesesCompletosGrati), esMonto: false)
                        fila("Gratificación Legal", r.gratificacionCalculada)
                        fila("1/6 de Gratificación a CTS", r.sextoGratificacion)
                        fila("Remuneración Computable", r.remuneracionComputable, destacado: true)
                    }
                    
                    Section("Resultado Final de CTS") {
                        HStack {
                            Text("Tiempo Neto Computable")
                            Spacer()
                            Text("\(r.mesesSemestreEfectivos) mes(es), \(r.diasSemestreEfectivos) día(s)").bold()
                        }
                        fila("Monto por Meses (\(r.mesesSemestreEfectivos)/12)", r.ctsMeses)
                        fila("Monto por Días (\(r.diasSemestreEfectivos)/360)", r.ctsDias)
                        fila("CTS Total a Depositar", r.ctsTotal, destacado: true, color: .blue)
                    }
                }
            }
            .navigationTitle("Calculadora CTS Oficial")
        }
    }

    private func fila(_ titulo: String, _ valor: Double, destacado: Bool = false, color: Color = .primary, esMonto: Bool = true) -> some View {
        HStack {
            Text(titulo)
            Spacer()
            Text(esMonto ? String(format: "S/ %.2f", valor) : "\(Int(valor)) meses")
                .fontWeight(destacado ? .bold : .regular)
                .foregroundStyle(color)
        }
    }

    private func calcular() {
        mensajeError = nil
        resultado = nil
        
        guard let s = Double(sueldoTexto.replacingOccurrences(of: ",", with: ".")) else {
            mensajeError = "Ingresa un sueldo válido."
            return
        }
        
        do {
            resultado = try CalculadoraCTS.calcular(
                sueldo: s,
                tieneAsignacionFamiliar: tieneAsignacionFamiliar,
                periodo: periodoSeleccionado,
                anio: anioActual, // Pasa el año automático del calendario
                fechaIngreso: fechaIngreso,
                inasistenciasDias: inasistencias
            )
        } catch {
            mensajeError = error.localizedDescription
        }
    }
}
