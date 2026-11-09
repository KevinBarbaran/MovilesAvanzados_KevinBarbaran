//
//  MisComprasView.swift
//  Lab12 EjercicioB
//
//  Created by Tecsup on 9/11/26.
//

import SwiftUI
import SwiftData

enum FiltroMisCompras: String, CaseIterable, Identifiable {
    case todas = "Todas"
    case pendientes = "Pendientes"
    case rechazadas = "Rechazadas"
    var id: String { rawValue }
}

struct MisComprasView: View {
    @Environment(Sesion.self) private var sesion
    @Query(sort: \Compra.fecha, order: .reverse) private var todasLasCompras: [Compra]
    @State private var filtro: FiltroMisCompras = .todas

    private var misCompras: [Compra] {
        guard let usuarioActual = sesion.usuarioActual?.usuario else { return [] }
        return todasLasCompras.filter { $0.comprador?.usuario == usuarioActual }
    }

    private var comprasFiltradas: [Compra] {
        switch filtro {
        case .todas: return misCompras
        case .pendientes: return misCompras.filter { $0.estado == EstadoCompra.pendiente.rawValue }
        case .rechazadas: return misCompras.filter { $0.estado == EstadoCompra.rechazada.rawValue }
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("Filtro", selection: $filtro) {
                    ForEach(FiltroMisCompras.allCases) { Text($0.rawValue).tag($0) }
                }
                .pickerStyle(.segmented)
                .padding()

                List(comprasFiltradas) { compra in
                    FilaCompra(compra: compra)
                }
                .listStyle(.plain)
                .overlay {
                    if comprasFiltradas.isEmpty {
                        ContentUnavailableView("Sin compras", systemImage: "tray",
                                               description: Text("No hay compras en esta vista."))
                    }
                }
            }
            .navigationTitle("Mis compras")
            .conMenuCuenta()
        }
    }
}

struct FilaCompra: View {
    let compra: Compra
    var mostrarComprador = false

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(compra.producto?.nombre ?? "Producto").font(.headline)
                Spacer()
                Text(compra.total.enSoles).font(.headline)
            }
            Text("\(compra.cantidad) uds × \(compra.costoUnitario.enSoles) · \(compra.proveedor?.nombre ?? "Proveedor")")
                .font(.subheadline).foregroundStyle(.secondary)
            HStack(spacing: 6) {
                Etiqueta(texto: compra.estado, color: compra.colorEstado)
                Etiqueta(texto: compra.alCredito ? "Crédito" : "Contado", color: .blue)
                Text(compra.fecha.corta).font(.caption).foregroundStyle(.secondary)
            }
            if mostrarComprador, let comprador = compra.comprador {
                Text("Solicitó: \(comprador.nombre)").font(.caption).foregroundStyle(.secondary)
            }
            if compra.estado == EstadoCompra.pendiente.rawValue {
                Text("En espera de aprobación del supervisor")
                    .font(.caption).foregroundStyle(.orange)
            }
            if compra.estado == EstadoCompra.rechazada.rawValue, let motivo = compra.motivoRechazo {
                Label("Motivo: \(motivo)", systemImage: "text.bubble")
                    .font(.caption).foregroundStyle(.red)
            }
        }
        .padding(.vertical, 2)
    }
}
