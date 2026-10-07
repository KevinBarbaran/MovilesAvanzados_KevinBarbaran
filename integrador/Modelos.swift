//
//  Modelos.swift
//  integrador
//
//  Created by Tecsup on 7/10/26.
//

import UIKit

class Producto {
    let nombre: String
    let precio: Double
    var stock: Int
    
    init(nombre: String, precio: Double, stock: Int) {
        self.nombre = nombre
        self.precio = precio
        self.stock = stock
    }
}

class ItemCarrito {
    let producto: Producto
    var cantidad: Int
    
    init(producto: Producto, cantidad: Int) {
        self.producto = producto
        self.cantidad = cantidad
    }
    
    func subtotal() -> Double {
        return producto.precio * Double(cantidad)
    }
}

class CarritoModel {
    var items: [ItemCarrito] = []
    
    func agregar(producto: Producto, cantidad: Int) -> Bool {
        let cantidadEnCarrito = items.first(where: { $0.producto.nombre == producto.nombre })?.cantidad ?? 0
        if (cantidadEnCarrito + cantidad) > producto.stock {
            return false
        }
        
        if let item = items.first(where: { $0.producto.nombre == producto.nombre }) {
            item.cantidad += cantidad
        } else {
            items.append(ItemCarrito(producto: producto, cantidad: cantidad))
        }
        return true
    }
    
    func subtotal() -> Double {
        return items.reduce(0.0) { $0 + $1.subtotal() }
    }
    
    func porcentajeDescuento() -> Double {
        let sub = subtotal()
        if sub >= 5000 { return 0.15 }
        if sub >= 2000 { return 0.10 }
        if sub >= 500 { return 0.05 }
        return 0.0
    }
    
    func montoDescuento() -> Double {
        return subtotal() * porcentajeDescuento()
    }
    
    func igv() -> Double {
        let subDescontado = subtotal() - montoDescuento()
        return subDescontado * 0.18
    }
    
    func total() -> Double {
        let subDescontado = subtotal() - montoDescuento()
        return subDescontado + igv()
    }
    
    func cantidadTotal() -> Int {
        return items.reduce(0) { $0 + $1.cantidad }
    }
    
    func vaciar() {
        items.removeAll()
    }
    
    func categoriaCliente() -> String {
        let sub = subtotal()
        switch Int(sub) {
        case 0..<500: return "Regular"
        case 500..<2000: return "Frecuente"
        case 2000..<5000: return "VIP"
        default: return "Premium"
        }
    }
}

class ClienteModel {
    var apellidos: String
    var nombres: String
    var dni: String
    
    init(apellidos: String, nombres: String, dni: String) {
        self.apellidos = apellidos
        self.nombres = nombres
        self.dni = dni
    }
}
