//
//  PorPagarView.swift
//  Lab12 EjercicioB
//
//  Created by Tecsup on 9/11/26.
//

import SwiftUI
import SwiftData

enum FiltroCuentas: String, CaseIterable, Identifiable {
    case pendientes = "Pendientes"
    case vencidas = "Vencidas"
    case pagadas = "Pagadas"
    var id: String { rawValue }
}

struct PorPagarView: View {
    @Query(filter: #Predicate<Compra> { $0.alCredito && !$0.pagada && $0.estado == "Aprobada" })
    private var cuentasPendientes: [Compra]

    @State private var filtro: FiltroCuentas = .pendientes
    @State private var busqueda = ""

    private var totalPorPagar: Double { cuentasPendientes.reduce(0) { $0 + $1.total } }
    private var cuentasVencidas: [Compra] { cuentasPendientes.filter { $0.estaVencida } }
    private var totalVencido: Double { cuentasVencidas.reduce(0) { $0 + $1.total } }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                VStack(spacing: 12) {
                    Picker("Filtro", selection: $filtro) {
                        ForEach(FiltroCuentas.allCases) { Text($0.rawValue).tag($0) }
                    }
                    .pickerStyle(.segmented)

                    HStack(spacing: 12) {
                        indicador("Total por pagar", totalPorPagar.enSoles, .orange)
                        indicador("Vencido (\(cuentasVencidas.count))", totalVencido.enSoles, .red)
                    }
                }
                .padding()

                ListaCuentasPorPagar(filtro: filtro, busqueda: busqueda)
                    .id(filtro)
            }
            .navigationTitle("Por pagar")
            .searchable(text: $busqueda, prompt: "Buscar por proveedor")
            .conMenuCuenta()
        }
    }

    private func indicador(_ titulo: String, _ valor: String, _ color: Color) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(titulo).font(.caption).foregroundStyle(.secondary)
            Text(valor).font(.headline).foregroundStyle(color)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(.background.secondary, in: RoundedRectangle(cornerRadius: 12))
    }
}

private struct ListaCuentasPorPagar: View {
    @Environment(\.modelContext) private var contexto
    @Environment(Sesion.self) private var sesion
    @Query private var compras: [Compra]

    let filtro: FiltroCuentas
    let busqueda: String
    @State private var compraAPagar: Compra?
    @State private var aviso: Aviso?

    init(filtro: FiltroCuentas, busqueda: String) {
        self.filtro = filtro
        self.busqueda = busqueda

        let ahora = Date.now
        let aprobada = EstadoCompra.aprobada.rawValue
        let predicado: Predicate<Compra>
        switch filtro {
        case .pendientes:
            predicado = #Predicate<Compra> { $0.alCredito && !$0.pagada && $0.estado == aprobada }
        case .vencidas:
            predicado = #Predicate<Compra> { $0.alCredito && !$0.pagada && $0.estado == aprobada && $0.vence < ahora }
        case .pagadas:
            predicado = #Predicate<Compra> { $0.alCredito && $0.pagada && $0.estado == aprobada }
        }
        _compras = Query(filter: predicado, sort: \Compra.vence)
    }

    private var comprasVisibles: [Compra] {
        let texto = busqueda.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !texto.isEmpty else { return compras }
        return compras.filter { ($0.proveedor?.nombre ?? "").localizedCaseInsensitiveContains(texto) }
    }

    var body: some View {
        List(comprasVisibles) { compra in
            FilaCuenta(compra: compra)
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    if filtro != .pagadas {
                        Button { compraAPagar = compra } label: {
                            Label("Pagar", systemImage: "checkmark.circle")
                        }
                        .tint(.green)
                    }
                }
        }
        .listStyle(.plain)
        .overlay {
            if comprasVisibles.isEmpty {
                ContentUnavailableView("Sin cuentas", systemImage: "creditcard",
                                       description: Text("No hay compras en esta vista."))
            }
        }
        .confirmationDialog(
            "¿Marcar como pagada?",
            isPresented: Binding(get: { compraAPagar != nil }, set: { if !$0 { compraAPagar = nil } }),
            titleVisibility: .visible,
            presenting: compraAPagar
        ) { compra in
            Button("Pagar \(compra.total.enSoles)") { pagar(compra) }
            Button("Cancelar", role: .cancel) {}
        } message: { compra in
            Text("\(compra.proveedor?.nombre ?? "Proveedor") · \(compra.producto?.nombre ?? "Producto")")
        }
        .alertaAviso($aviso)
    }

    private func pagar(_ compra: Compra) {
        guard let supervisor = sesion.usuarioActual, supervisor.esSupervisor else { return }
        do {
            try ServicioCompras.pagar(compra, supervisor: supervisor, contexto: contexto)
        } catch {
            aviso = Aviso(titulo: "No se pudo pagar", mensaje: error.localizedDescription)
        }
    }
}

private struct FilaCuenta: View {
    let compra: Compra

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(compra.proveedor?.nombre ?? "Proveedor").font(.headline)
                Spacer()
                Text(compra.total.enSoles).font(.headline)
            }
            Text("\(compra.cantidad) × \(compra.producto?.nombre ?? "Producto")")
                .font(.subheadline).foregroundStyle(.secondary)
            HStack(spacing: 6) {
                if compra.pagada {
                    Etiqueta(texto: "PAGADA", color: .green)
                } else if compra.estaVencida {
                    Etiqueta(texto: "VENCIDA", color: .red)                              // ③
                    Text("Venció hace \(compra.diasDeVencida) día(s)").font(.caption).foregroundStyle(.red)
                } else {
                    Etiqueta(texto: "PENDIENTE", color: .orange)
                    Text("Vence el \(compra.vence.corta)").font(.caption).foregroundStyle(.secondary)
                }
            }
        }
        .padding(.vertical, 2)
    }
}
