//
//  ContabilidadView.swift
//  CTSApp
//
//  Created by Tecsup on 27/10/26.
//

import SwiftUI

struct ContabilidadView: View {
    @State private var cuentasCobrar = ""
    @State private var ventasCredito = ""
    @State private var cuentasPagar = ""
    @State private var comprasCredito = ""

    @State private var edadCobrar: Double?
    @State private var edadPagar: Double?

    var body: some View {
        Form {
            Section("Cuentas por Cobrar") {
                TextField("Cuentas por Cobrar Promedio (S/)", text: $cuentasCobrar).keyboardType(.decimalPad)
                TextField("Ventas a Crédito (S/)", text: $ventasCredito).keyboardType(.decimalPad)
            }
            Section("Cuentas por Pagar") {
                TextField("Cuentas por Pagar Promedio (S/)", text: $cuentasPagar).keyboardType(.decimalPad)
                TextField("Compras a Crédito (S/)", text: $comprasCredito).keyboardType(.decimalPad)
            }
            Section {
                Button("Calcular Indicadores", action: calcular)
            }
            if let ec = edadCobrar, let ep = edadPagar {
                Section("Resultado Financiero") {
                    HStack { Text("Edad Prom. Cobro:"); Spacer(); Text("\(String(format: "%.1f", ec)) días").bold() }
                    HStack { Text("Edad Prom. Pago:"); Spacer(); Text("\(String(format: "%.1f", ep)) días").bold() }
                    HStack {
                        Text("Ciclo Financiero:")
                        Spacer()
                        Text("\(String(format: "%.1f", ec - ep)) días")
                            .bold()
                            .foregroundStyle((ec - ep) <= 0 ? .green : .red)
                    }
                }
            }
        }
        .navigationTitle("Cuentas / Contabilidad")
    }

    private func calcular() {
        guard let cc = Double(cuentasCobrar), let vc = Double(ventasCredito), vc > 0,
              let cp = Double(cuentasPagar), let cm = Double(comprasCredito), cm > 0 else { return }
        edadCobrar = (cc / vc) * 360.0
        edadPagar = (cp / cm) * 360.0
    }
}
