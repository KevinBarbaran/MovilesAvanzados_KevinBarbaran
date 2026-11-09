//
//  NuevaCompraView.swift
//  Lab12 EjercicioB
//
//  Created by Tecsup on 9/11/26.
//

import SwiftUI
import SwiftData

struct NuevaCompraView: View {
    @Environment(\.modelContext) private var contexto
    @Environment(Sesion.self) private var sesion
    @Query(sort: \Proveedor.nombre) private var proveedores: [Proveedor]
    @Query(sort: \Producto.nombre) private var productos: [Producto]

    @State private var proveedorSeleccionado: Proveedor?
    @State private var productoSeleccionado: Producto?
    @State private var cantidad = 1
    @State private var costoUnitario = 0.0
    @State private var alCredito = false
    @State private var fechaCompra = Date.now
    @State private var aviso: Aviso?

    private var subtotal: Double { ReglasNegocio.subtotal(cantidad: cantidad, costoUnitario: costoUnitario) }
    private var igv: Double { ReglasNegocio.igv(subtotal: subtotal) }
    private var total: Double { ReglasNegocio.total(subtotal: subtotal, igv: igv) }
    private var requiereAprobacion: Bool { ReglasNegocio.requiereAprobacion(total: total) }
    private var vencimiento: Date { ReglasNegocio.fechaVencimiento(desde: fechaCompra, alCredito: alCredito) }

    private var formularioCompleto: Bool {
        proveedorSeleccionado != nil && productoSeleccionado != nil
            && cantidad > 0 && cantidad <= 1_000_000 && costoUnitario > 0
    }

    var body: some View {
        NavigationStack {
            Form {
                if proveedores.isEmpty || productos.isEmpty {
                    Section {
                        Label("Para comprar deben existir proveedores y productos. Pide al supervisor que los registre.",
                              systemImage: "info.circle")
                            .font(.footnote).foregroundStyle(.secondary)
                    }
                }

                Section("Proveedor y producto") {
                    Picker("Proveedor", selection: $proveedorSeleccionado) {           // ②
                        Text("Seleccione…").tag(Proveedor?.none)
                        ForEach(proveedores) { Text($0.nombre).tag(Proveedor?.some($0)) }
                    }
                    Picker("Producto", selection: $productoSeleccionado) {              // ③
                        Text("Seleccione…").tag(Producto?.none)
                        ForEach(productos) { Text($0.nombre).tag(Producto?.some($0)) }
                    }
                    if let producto = productoSeleccionado {
                        LabeledContent("Stock actual", value: "\(producto.stock) uds")
                        LabeledContent("Costo promedio actual", value: producto.costoPromedio.enSoles)
                    }
                }

                Section("Detalle") {
                    HStack {                                                            // ④
                        Text("Cantidad")
                        Spacer()
                        TextField("0", value: $cantidad, format: .number)
                            .keyboardType(.numberPad).multilineTextAlignment(.trailing)
                    }
                    HStack {
                        Text("Costo unitario (S/)")
                        Spacer()
                        TextField("0.00", value: $costoUnitario, format: .number)
                            .keyboardType(.decimalPad).multilineTextAlignment(.trailing)
                    }
                    DatePicker("Fecha de la compra", selection: $fechaCompra,
                               in: ...Date.now, displayedComponents: .date)
                }

                Section {
                    Picker("Pago", selection: $alCredito) {                             // ⑤
                        Text("Contado").tag(false)
                        Text("Crédito \(Configuracion.diasDeCredito) días").tag(true)
                    }
                    .pickerStyle(.segmented)
                    if alCredito {
                        LabeledContent("Vence el", value: vencimiento.corta)
                    }
                } header: {
                    Text("Condición de pago")
                } footer: {
                    Text(alCredito ? "Quedará pendiente de pago hasta que el supervisor la pague."
                                   : "Al contado la compra queda pagada.")
                }

                Section("Resumen") {
                    LabeledContent("Subtotal", value: subtotal.enSoles)
                    LabeledContent("IGV (18 %)", value: igv.enSoles)
                    LabeledContent("Total") { Text(total.enSoles).bold() }
                }

                if requiereAprobacion {                                                  // ⑥
                    Section {
                        Label("El total llega a \(Configuracion.umbralAprobacion.enSoles) o más: requiere aprobación del supervisor. El stock y el costo promedio no cambian hasta que la apruebe.",
                              systemImage: "exclamationmark.triangle.fill")
                            .font(.footnote).foregroundStyle(.orange)
                    }
                }

                Section {
                    Button(action: registrar) {                                          // ⑦
                        Text(requiereAprobacion ? "Enviar a aprobación" : "Registrar compra")
                            .frame(maxWidth: .infinity)
                    }
                    .disabled(!formularioCompleto)
                }
            }
            .navigationTitle("Nueva compra")
            .conMenuCuenta()
            .conBotonListoEnTeclado()
            .onChange(of: productoSeleccionado) { _, nuevo in
                if let nuevo { costoUnitario = ReglasNegocio.redondear(nuevo.costoPromedio) }
            }
            .alertaAviso($aviso)
        }
    }

    private func registrar() {
        guard let comprador = sesion.usuarioActual,
              let proveedor = proveedorSeleccionado,
              let producto = productoSeleccionado else { return }
        do {
            let compra = try ServicioCompras.registrar(
                comprador: comprador, proveedor: proveedor, producto: producto,
                cantidad: cantidad, costoUnitario: costoUnitario,
                alCredito: alCredito, fecha: fechaCompra, contexto: contexto
            )
            if compra.estado == EstadoCompra.pendiente.rawValue {
                aviso = Aviso(titulo: "Enviada a aprobación",
                              mensaje: "Total \(compra.total.enSoles). El supervisor debe aprobarla; puedes seguirla en «Mis compras».")
            } else {
                aviso = Aviso(titulo: "Compra registrada",
                              mensaje: "Total \(compra.total.enSoles) (IGV \(compra.igv.enSoles)). Stock de «\(producto.nombre)»: \(producto.stock) uds.")
            }
            limpiarFormulario()
        } catch {
            aviso = Aviso(titulo: "No se pudo registrar", mensaje: error.localizedDescription)
        }
    }

    private func limpiarFormulario() {
        proveedorSeleccionado = nil
        productoSeleccionado = nil
        cantidad = 1
        costoUnitario = 0
        alCredito = false
        fechaCompra = Date.now
    }
}
