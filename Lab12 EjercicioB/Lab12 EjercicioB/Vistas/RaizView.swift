//
//  RaizView.swift
//  Lab12 EjercicioB
//
//  Created by Tecsup on 9/11/26.
//

import SwiftUI

struct RaizView: View {
    @Environment(Sesion.self) private var sesion

    var body: some View {
        Group {
            if let usuario = sesion.usuarioActual {
                PrincipalView(usuario: usuario)
                    .id(usuario.persistentModelID)
            } else {
                LoginView()
            }
        }
        .animation(.default, value: sesion.usuarioActual == nil)
    }
}

struct PrincipalView: View {
    let usuario: Usuario

    var body: some View {
        TabView {
            if usuario.esSupervisor {
                ResumenView()
                    .tabItem { Label("Resumen", systemImage: "chart.bar.xaxis") }
                AprobarView()
                    .tabItem { Label("Aprobar", systemImage: "checkmark.seal") }
                PorPagarView()
                    .tabItem { Label("Por pagar", systemImage: "creditcard") }
                ProductosView()
                    .tabItem { Label("Productos", systemImage: "shippingbox") }
                ProveedoresView()
                    .tabItem { Label("Proveedores", systemImage: "building.2") }
            } else {
                ProductosView()
                    .tabItem { Label("Productos", systemImage: "shippingbox") }
                ProveedoresView()
                    .tabItem { Label("Proveedores", systemImage: "building.2") }
                NuevaCompraView()
                    .tabItem { Label("Compra", systemImage: "cart.badge.plus") }
                MisComprasView()
                    .tabItem { Label("Mis compras", systemImage: "list.bullet.rectangle") }
            }
        }
    }
}
