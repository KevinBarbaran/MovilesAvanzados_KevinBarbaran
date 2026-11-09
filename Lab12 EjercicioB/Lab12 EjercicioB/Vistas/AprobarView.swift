//
//  AprobarView.swift
//  Lab12 EjercicioB
//
//  Created by Tecsup on 9/11/26.
//

import SwiftUI
import SwiftData

struct AprobarView: View {
    @Environment(\.modelContext) private var contexto
    @Environment(Sesion.self) private var sesion
    @Query(filter: #Predicate<Compra> { $0.estado == "Pendiente" }, sort: \Compra.fecha)
    private var pendientes: [Compra]

    @State private var compraARechazar: Compra?
    @State private var compraAAprobar: Compra?
    @State private var aviso: Aviso?

    var body: some View {
        NavigationStack {
            Group {
                if pendientes.isEmpty {
                    ContentUnavailableView("Sin compras por aprobar", systemImage: "checkmark.seal",
                                           description: Text("Las compras desde \(Configuracion.umbralAprobacion.enSoles) aparecerán aquí."))
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(pendientes) { compra in
                                TarjetaAprobacion(
                                    compra: compra,
                                    alRechazar: { compraARechazar = compra },
                                    alAprobar: { compraAAprobar = compra }
                                )
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Por aprobar")
            .conMenuCuenta()                                                             // ① avatar
            .sheet(item: $compraARechazar) { MotivoRechazoView(compra: $0) }
            .confirmationDialog(
                "¿Aprobar esta compra?",
                isPresented: Binding(get: { compraAAprobar != nil }, set: { if !$0 { compraAAprobar = nil } }),
                titleVisibility: .visible,
                presenting: compraAAprobar
            ) { compra in
                Button("Aprobar \(compra.total.enSoles)") { aprobar(compra) }
                Button("Cancelar", role: .cancel) {}
            } message: { _ in
                Text("Se actualizarán el stock y el costo promedio. Si es a crédito, pasará a cuentas por pagar.")
            }
            .alertaAviso($aviso)
        }
    }

    private func aprobar(_ compra: Compra) {
        guard let supervisor = sesion.usuarioActual else { return }
        do {
            try ServicioCompras.aprobar(compra, supervisor: supervisor, contexto: contexto)
        } catch {
            aviso = Aviso(titulo: "No se pudo aprobar", mensaje: error.localizedDescription)
        }
    }
}

private struct TarjetaAprobacion: View {
    let compra: Compra
    let alRechazar: () -> Void
    let alAprobar: () -> Void

    private var stockAntes: Int { compra.producto?.stock ?? 0 }
    private var stockDespues: Int { stockAntes + compra.cantidad }
    private var costoAntes: Double { compra.producto?.costoPromedio ?? 0 }
    private var costoDespues: Double {
        ReglasNegocio.costoPromedioPonderado(stockActual: stockAntes, costoPromedioActual: costoAntes,
                                             cantidad: compra.cantidad, costoUnitario: compra.costoUnitario)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(compra.producto?.nombre ?? "Producto").font(.headline)
                    Text(compra.proveedor?.nombre ?? "Proveedor").font(.subheadline).foregroundStyle(.secondary)
                }
                Spacer()
                Text(compra.total.enSoles).font(.title3.bold())
            }
            Text("\(compra.cantidad) uds × \(compra.costoUnitario.enSoles) + IGV \(compra.igv.enSoles) · \(compra.alCredito ? "Crédito 30 días" : "Contado")")
                .font(.footnote).foregroundStyle(.secondary)
            Label("Solicitó \(compra.comprador?.nombre ?? "—") el \(compra.fecha.corta)", systemImage: "person")
                .font(.footnote)

            Divider()
            VStack(alignment: .leading, spacing: 6) {
                Text("Efecto al aprobar").font(.caption.bold()).foregroundStyle(.secondary)
                HStack {
                    Text("Stock")
                    Spacer()
                    Text("\(stockAntes) → \(stockDespues) uds").bold()
                }
                HStack {
                    Text("Costo promedio")
                    Spacer()
                    Text("\(costoAntes.enSoles) → \(costoDespues.enSoles)").bold()
                }
            }
            .font(.subheadline)

            HStack(spacing: 12) {                                                        // ④
                Button(role: .destructive, action: alRechazar) {
                    Label("Rechazar", systemImage: "xmark").frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                Button(action: alAprobar) {
                    Label("Aprobar", systemImage: "checkmark").frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            }
            .controlSize(.large)
        }
        .padding()
        .background(.background.secondary, in: RoundedRectangle(cornerRadius: 14))
    }
}

/// Rechazar pide un motivo obligatorio
struct MotivoRechazoView: View {
    let compra: Compra
    @Environment(\.modelContext) private var contexto
    @Environment(\.dismiss) private var cerrar
    @Environment(Sesion.self) private var sesion
    @State private var motivo = ""
    @State private var aviso: Aviso?

    private var motivoVacio: Bool { motivo.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }

    var body: some View {
        NavigationStack {
            Form {
                Section("Compra") {
                    Text("\(compra.cantidad) × \(compra.producto?.nombre ?? "Producto") · \(compra.total.enSoles)")
                    Text("Solicitó \(compra.comprador?.nombre ?? "—")").foregroundStyle(.secondary)
                }
                Section {
                    TextField("Motivo del rechazo (obligatorio)", text: $motivo, axis: .vertical)
                        .lineLimit(3...6)
                } footer: {
                    Text("El comprador verá este motivo. Rechazar no cambia el stock, el costo promedio ni las cuentas por pagar.")
                }
                Section {
                    Button("Rechazar compra", role: .destructive, action: rechazar)
                        .frame(maxWidth: .infinity)
                        .disabled(motivoVacio)
                }
            }
            .navigationTitle("Rechazar compra")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancelar") { cerrar() } }
            }
            .alertaAviso($aviso)
        }
        .presentationDetents([.medium, .large])
    }

    private func rechazar() {
        guard let supervisor = sesion.usuarioActual else { return }
        do {
            try ServicioCompras.rechazar(compra, motivo: motivo, supervisor: supervisor, contexto: contexto)
            cerrar()
        } catch {
            aviso = Aviso(titulo: "No se pudo rechazar", mensaje: error.localizedDescription)
        }
    }
}
