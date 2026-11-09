//
//  ProveedoresView.swift
//  Lab12 EjercicioB
//
//  Created by Tecsup on 9/11/26.
//

import SwiftUI
import SwiftData

struct ProveedoresView: View {
    @Environment(\.modelContext) private var contexto
    @Environment(Sesion.self) private var sesion
    @Query(sort: \Proveedor.nombre) private var proveedores: [Proveedor]

    @State private var busqueda = ""
    @State private var mostrarFormulario = false
    @State private var proveedorAEditar: Proveedor?
    @State private var aviso: Aviso?

    private var esSupervisor: Bool { sesion.usuarioActual?.esSupervisor ?? false }

    private var proveedoresFiltrados: [Proveedor] {
        let texto = busqueda.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !texto.isEmpty else { return proveedores }
        return proveedores.filter {
            $0.nombre.localizedCaseInsensitiveContains(texto) || $0.ruc.contains(texto)
        }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(proveedoresFiltrados) { proveedor in
                    Button {
                        if esSupervisor { proveedorAEditar = proveedor }
                    } label: {
                        FilaProveedor(proveedor: proveedor)
                    }
                    .buttonStyle(.plain)
                    .deleteDisabled(!esSupervisor)
                }
                .onDelete(perform: eliminar)
            }
            .overlay {
                if proveedores.isEmpty {
                    ContentUnavailableView(
                        "Sin proveedores",
                        systemImage: "building.2",
                        description: Text(esSupervisor ? "Pulsa + para registrar el primer proveedor."
                                                       : "El supervisor aún no registra proveedores.")
                    )
                } else if proveedoresFiltrados.isEmpty {
                    ContentUnavailableView.search(text: busqueda)
                }
            }
            .searchable(text: $busqueda, prompt: "Buscar por nombre o RUC")
            .navigationTitle("Proveedores")
            .toolbar {
                if esSupervisor {
                    ToolbarItem(placement: .topBarLeading) {
                        Button { mostrarFormulario = true } label: {
                            Label("Nuevo proveedor", systemImage: "plus")
                        }
                    }
                }
            }
            .conMenuCuenta()
            .sheet(isPresented: $mostrarFormulario) { ProveedorFormView() }
            .sheet(item: $proveedorAEditar) { ProveedorFormView(proveedor: $0) }
            .alertaAviso($aviso)
        }
    }

    private func eliminar(en posiciones: IndexSet) {
        guard esSupervisor else { return }
        for posicion in posiciones {
            let proveedor = proveedoresFiltrados[posicion]
            if !proveedor.compras.isEmpty {
                aviso = Aviso(titulo: "No se puede eliminar",
                              mensaje: "«\(proveedor.nombre)» tiene \(proveedor.compras.count) compra(s) registrada(s). Los proveedores con compras no se pueden borrar.")
                continue
            }
            ServicioAuditoria.registrar("Proveedor eliminado", detalle: "\(proveedor.nombre) · RUC \(proveedor.ruc)",
                                        usuario: sesion.usuarioActual, contexto: contexto)
            contexto.delete(proveedor)
        }
        try? contexto.save()
    }
}

struct FilaProveedor: View {
    let proveedor: Proveedor

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text(proveedor.nombre).font(.headline)
                Text("RUC \(proveedor.ruc)").font(.subheadline).foregroundStyle(.secondary)
                Text("Total comprado: \(proveedor.totalComprado.enSoles)")
                    .font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
            if proveedor.montoPorPagar > 0 {
                VStack(alignment: .trailing, spacing: 4) {
                    Etiqueta(texto: "Por pagar", color: .orange)
                    Text(proveedor.montoPorPagar.enSoles).font(.caption.bold())
                }
            } else {
                Etiqueta(texto: "Al día", color: .green)
            }
        }
        .contentShape(Rectangle())
    }
}

struct ProveedorFormView: View {
    @Environment(\.modelContext) private var contexto
    @Environment(\.dismiss) private var cerrar
    @Environment(Sesion.self) private var sesion
    @Query private var proveedores: [Proveedor]

    let proveedor: Proveedor?
    @State private var nombre: String
    @State private var ruc: String
    @State private var aviso: Aviso?

    init(proveedor: Proveedor? = nil) {
        self.proveedor = proveedor
        _nombre = State(initialValue: proveedor?.nombre ?? "")
        _ruc = State(initialValue: proveedor?.ruc ?? "")
    }

    private var nombreLimpio: String { nombre.trimmingCharacters(in: .whitespacesAndNewlines) }
    private var rucValido: Bool { ruc.count == Configuracion.largoRUC && ruc.allSatisfy { $0.isNumber } }
    private var rucDuplicado: Bool { proveedores.contains { $0 !== proveedor && $0.ruc == ruc } }
    private var esValido: Bool { !nombreLimpio.isEmpty && rucValido && !rucDuplicado }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Razón social o nombre", text: $nombre)
                    TextField("RUC (11 dígitos)", text: $ruc)
                        .keyboardType(.numberPad)
                    if !ruc.isEmpty && !rucValido {
                        Label("El RUC debe tener \(Configuracion.largoRUC) dígitos", systemImage: "exclamationmark.triangle.fill")
                            .font(.caption).foregroundStyle(.orange)
                    }
                    if rucDuplicado {
                        Label("Ya existe un proveedor con ese RUC", systemImage: "xmark.circle.fill")
                            .font(.caption).foregroundStyle(.red)
                    }
                } header: {
                    Text("Datos del proveedor")
                }
            }
            .navigationTitle(proveedor == nil ? "Nuevo proveedor" : "Editar proveedor")
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: ruc) { _, nuevo in
                let soloDigitos = String(nuevo.filter { $0.isNumber }.prefix(Configuracion.largoRUC))
                if soloDigitos != nuevo { ruc = soloDigitos }
            }
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
        if let proveedor {
            ServicioAuditoria.registrar("Proveedor editado",
                                        detalle: "\(proveedor.nombre) (\(proveedor.ruc)) → \(nombreLimpio) (\(ruc))",
                                        usuario: sesion.usuarioActual, contexto: contexto)
            proveedor.nombre = nombreLimpio
            proveedor.ruc = ruc
        } else {
            let nuevo = Proveedor(nombre: nombreLimpio, ruc: ruc)
            contexto.insert(nuevo)
            ServicioAuditoria.registrar("Proveedor creado", detalle: "\(nuevo.nombre) · RUC \(nuevo.ruc)",
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
