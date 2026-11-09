//
//  ProductosView.swift
//  Lab12 EjercicioB
//
//  Created by Tecsup on 9/11/26.
//

import SwiftUI
import SwiftData

struct ProductosView: View {
    @Environment(\.modelContext) private var contexto
    @Environment(Sesion.self) private var sesion
    @Query(sort: \Producto.nombre) private var productos: [Producto]

    @State private var busqueda = ""
    @State private var mostrarFormulario = false
    @State private var productoAEditar: Producto?
    @State private var aviso: Aviso?

    private var esSupervisor: Bool { sesion.usuarioActual?.esSupervisor ?? false }

    private var productosFiltrados: [Producto] {
        let texto = busqueda.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !texto.isEmpty else { return productos }
        return productos.filter {
            $0.nombre.localizedCaseInsensitiveContains(texto) || $0.categoria.localizedCaseInsensitiveContains(texto)
        }
    }

    private var valorInventario: Double { productos.reduce(0) { $0 + $1.valorInventario } }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        Label("Valor del inventario", systemImage: "banknote")
                        Spacer()
                        Text(valorInventario.enSoles).bold()
                    }
                } footer: {
                    Text("Suma de stock × costo promedio de todos los productos.")
                }

                Section("\(productosFiltrados.count) producto(s)") {
                    ForEach(productosFiltrados) { producto in
                        Button {
                            if esSupervisor { productoAEditar = producto }
                        } label: {
                            FilaProducto(producto: producto)
                        }
                        .buttonStyle(.plain)
                        .deleteDisabled(!esSupervisor)
                    }
                    .onDelete(perform: eliminar)
                }
            }
            .overlay {
                if productos.isEmpty {
                    ContentUnavailableView(
                        "Sin productos",
                        systemImage: "shippingbox",
                        description: Text(esSupervisor ? "Pulsa + para registrar el primer producto."
                                                       : "El supervisor aún no registra productos.")
                    )
                } else if productosFiltrados.isEmpty {
                    ContentUnavailableView.search(text: busqueda)
                }
            }
            .searchable(text: $busqueda, prompt: "Buscar producto o categoría")
            .navigationTitle("Productos")
            .toolbar {
                if esSupervisor {
                    ToolbarItem(placement: .topBarLeading) {
                        Button { mostrarFormulario = true } label: {
                            Label("Nuevo producto", systemImage: "plus")
                        }
                    }
                }
            }
            .conMenuCuenta()
            .sheet(isPresented: $mostrarFormulario) { ProductoFormView() }
            .sheet(item: $productoAEditar) { ProductoFormView(producto: $0) }
            .alertaAviso($aviso)
        }
    }

    private func eliminar(en posiciones: IndexSet) {
        guard esSupervisor else { return }
        for posicion in posiciones {
            let producto = productosFiltrados[posicion]
            if !producto.compras.isEmpty {
                aviso = Aviso(titulo: "No se puede eliminar",
                              mensaje: "«\(producto.nombre)» tiene \(producto.compras.count) compra(s) registrada(s). Los productos con compras no se pueden borrar.")
                continue
            }
            ServicioAuditoria.registrar("Producto eliminado", detalle: producto.nombre,
                                        usuario: sesion.usuarioActual, contexto: contexto)
            contexto.delete(producto)
        }
        try? contexto.save()
    }
}

struct FilaProducto: View {
    let producto: Producto

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(producto.nombre).font(.headline)
                Text(producto.categoria).font(.subheadline).foregroundStyle(.secondary)
                Text("Costo promedio: \(producto.costoPromedio.enSoles)")
                    .font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
            Etiqueta(texto: "\(producto.stock) uds", color: producto.colorStock)
        }
        .contentShape(Rectangle())
    }
}

struct ProductoFormView: View {
    @Environment(\.modelContext) private var contexto
    @Environment(\.dismiss) private var cerrar
    @Environment(Sesion.self) private var sesion
    @Query private var productos: [Producto]

    let producto: Producto?
    @State private var nombre: String
    @State private var categoria: String
    @State private var stock: Int
    @State private var costoPromedio: Double
    @State private var aviso: Aviso?

    init(producto: Producto? = nil) {
        self.producto = producto
        _nombre = State(initialValue: producto?.nombre ?? "")
        _categoria = State(initialValue: producto?.categoria ?? "")
        _stock = State(initialValue: producto?.stock ?? 0)
        _costoPromedio = State(initialValue: producto?.costoPromedio ?? 0)
    }

    private var nombreLimpio: String { nombre.trimmingCharacters(in: .whitespacesAndNewlines) }
    private var categoriaLimpia: String { categoria.trimmingCharacters(in: .whitespacesAndNewlines) }

    private var nombreDuplicado: Bool {
        productos.contains { $0 !== producto && $0.nombre.lowercased() == nombreLimpio.lowercased() }
    }

    private var esValido: Bool {
        !nombreLimpio.isEmpty && !categoriaLimpia.isEmpty && !nombreDuplicado && stock >= 0 && costoPromedio >= 0
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Datos del producto") {
                    TextField("Nombre", text: $nombre)
                    if nombreDuplicado {
                        Label("Ya existe un producto con ese nombre", systemImage: "xmark.circle.fill")
                            .font(.caption).foregroundStyle(.red)
                    }
                    TextField("Categoría", text: $categoria)
                }
                Section {
                    HStack {
                        Text("Stock")
                        Spacer()
                        TextField("0", value: $stock, format: .number)
                            .keyboardType(.numberPad).multilineTextAlignment(.trailing)
                    }
                    HStack {
                        Text("Costo promedio (S/)")
                        Spacer()
                        TextField("0.00", value: $costoPromedio, format: .number)
                            .keyboardType(.decimalPad).multilineTextAlignment(.trailing)
                    }
                } header: {
                    Text("Inventario")
                } footer: {
                    Text(producto == nil
                         ? "Stock y costo iniciales. Luego cambian solo con las compras aprobadas."
                         : "Cualquier ajuste manual queda registrado en la bitácora.")
                }
            }
            .navigationTitle(producto == nil ? "Nuevo producto" : "Editar producto")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancelar") { cerrar() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar", action: guardar).disabled(!esValido)
                }
            }
            .conBotonListoEnTeclado()
            .alertaAviso($aviso)
        }
    }

    private func guardar() {
        guard esValido else { return }
        if let producto {
            let cambios = "«\(producto.nombre)»: stock \(producto.stock)→\(stock), costo promedio \(producto.costoPromedio.enSoles)→\(costoPromedio.enSoles)"
            producto.nombre = nombreLimpio
            producto.categoria = categoriaLimpia
            producto.stock = stock
            producto.costoPromedio = costoPromedio
            ServicioAuditoria.registrar("Producto editado", detalle: cambios,
                                        usuario: sesion.usuarioActual, contexto: contexto)
        } else {
            let nuevo = Producto(nombre: nombreLimpio, categoria: categoriaLimpia, stock: stock, costoPromedio: costoPromedio)
            contexto.insert(nuevo)
            ServicioAuditoria.registrar("Producto creado",
                                        detalle: "«\(nuevo.nombre)» · stock \(stock) · costo \(costoPromedio.enSoles)",
                                        usuario: sesion.usuarioActual, contexto: contexto)
        }
        do {
            try contexto.save()
            cerrar()
        } catch {
            aviso = Aviso(titulo: "No se pudo guardar", mensaje: error.localizedDescription)
        }
    }
}
