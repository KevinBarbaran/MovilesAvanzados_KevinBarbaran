//
//  ResumenView.swift
//  Lab12 EjercicioB
//
//  Created by Tecsup on 9/11/26.
//

import SwiftUI
import SwiftData
import Charts

private struct TotalPorProveedor: Identifiable {
    let id: String
    let nombre: String
    let total: Double
}

struct ResumenView: View {
    @Environment(Sesion.self) private var sesion
    @Query(sort: \Compra.fecha, order: .reverse) private var compras: [Compra]
    @Query private var productos: [Producto]

    private var aprobadas: [Compra] { compras.filter { $0.estado == EstadoCompra.aprobada.rawValue } }
    private var porAprobar: [Compra] { compras.filter { $0.estado == EstadoCompra.pendiente.rawValue } }
    private var cuentasPorPagar: [Compra] { aprobadas.filter { $0.alCredito && !$0.pagada } }

    private var valorInventario: Double { productos.reduce(0) { $0 + $1.valorInventario } }
    private var creditoFiscal: Double { aprobadas.reduce(0) { $0 + $1.igv } }
    private var importePorAprobar: Double { porAprobar.reduce(0) { $0 + $1.total } }
    private var totalPorPagar: Double { cuentasPorPagar.reduce(0) { $0 + $1.total } }
    private var cantidadVencidas: Int { cuentasPorPagar.filter { $0.estaVencida }.count }

    private var totalesPorProveedor: [TotalPorProveedor] {
        var acumulado: [String: (nombre: String, total: Double)] = [:]
        for compra in aprobadas {
            guard let proveedor = compra.proveedor else { continue }
            acumulado[proveedor.ruc, default: (nombre: proveedor.nombre, total: 0)].total += compra.total
        }
        return acumulado
            .map { TotalPorProveedor(id: $0.key, nombre: $0.value.nombre, total: $0.value.total) }
            .sorted { $0.total > $1.total }
    }

    private var archivoCSV: ArchivoCSV {
        ArchivoCSV(nombre: "compras.csv", contenido: ExportadorCSV.comprasEnCSV(compras))
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    
                    if let usuario = sesion.usuarioActual {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Hola, \(usuario.nombre)").font(.title2.bold())
                            Text("\(usuario.rol) · \(Date.now.corta)").font(.subheadline).foregroundStyle(.secondary)
                        }
                    }

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        TarjetaIndicador(titulo: "Valor del inventario", valor: valorInventario.enSoles,
                                         detalle: "\(productos.count) producto(s)", icono: "shippingbox", color: .blue)
                        TarjetaIndicador(titulo: "Crédito fiscal (IGV)", valor: creditoFiscal.enSoles,
                                         detalle: "Compras aprobadas", icono: "percent", color: .purple)
                        TarjetaIndicador(titulo: "Por pagar", valor: totalPorPagar.enSoles,
                                         detalle: "\(cuentasPorPagar.count) cuenta(s) · \(cantidadVencidas) vencida(s)",
                                         icono: "creditcard", color: .orange)
                        TarjetaIndicador(titulo: "Por aprobar", valor: importePorAprobar.enSoles,
                                         detalle: "\(porAprobar.count) compra(s)", icono: "checkmark.seal", color: .red)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Total comprado por proveedor").font(.headline)
                        if totalesPorProveedor.isEmpty {
                            Text("Aún no hay compras aprobadas.").font(.footnote).foregroundStyle(.secondary)
                        } else {
                            Chart(totalesPorProveedor) { dato in
                                BarMark(x: .value("Total", dato.total), y: .value("Proveedor", dato.nombre))
                                    .annotation(position: .trailing) {
                                        Text(dato.total.enSoles).font(.caption2)
                                    }
                            }
                            .chartXAxis(.hidden)
                            .frame(height: max(120, CGFloat(totalesPorProveedor.count) * 48))
                        }
                    }
                    .padding()
                    .background(.background.secondary, in: RoundedRectangle(cornerRadius: 14))
                }
                .padding()
            }
            .navigationTitle("Resumen")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink {
                        BitacoraView()
                    } label: {
                        Label("Bitácora", systemImage: "list.clipboard")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    ShareLink(item: archivoCSV, preview: SharePreview("compras.csv")) {
                        Label("Exportar", systemImage: "square.and.arrow.up")
                    }
                }
            }
            .conMenuCuenta()
        }
    }
}

private struct TarjetaIndicador: View {
    let titulo: String
    let valor: String
    let detalle: String
    let icono: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Image(systemName: icono).foregroundStyle(color)
            Text(titulo).font(.caption).foregroundStyle(.secondary)
            Text(valor).font(.headline).minimumScaleFactor(0.7).lineLimit(1)
            Text(detalle).font(.caption2).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(.background.secondary, in: RoundedRectangle(cornerRadius: 14))
    }
}
