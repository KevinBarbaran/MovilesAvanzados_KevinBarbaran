//
//  Producto.swift
//  Lab12 EjercicioB
//
//  Created by Tecsup on 9/11/26.
//

import Foundation
import SwiftData

@Model
class Producto {
    var nombre: String
    var categoria: String
    var stock: Int
    var costoPromedio: Double

    @Relationship(deleteRule: .deny, inverse: \Compra.producto)
    var compras: [Compra] = []

    init(nombre: String, categoria: String, stock: Int, costoPromedio: Double) {
        self.nombre = nombre
        self.categoria = categoria
        self.stock = stock
        self.costoPromedio = costoPromedio
    }

    var valorInventario: Double { Double(stock) * costoPromedio }
}
