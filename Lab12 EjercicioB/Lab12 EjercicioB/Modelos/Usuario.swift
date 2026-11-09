//
//  Usuario.swift
//  Lab12 EjercicioB
//
//  Created by Tecsup on 9/11/26.
//

import Foundation
import SwiftData

@Model
class Usuario {
    var nombre: String
    var usuario: String
    var clave: String
    var rol: String

    @Relationship(deleteRule: .deny, inverse: \Compra.comprador)
    var compras: [Compra] = []

    init(nombre: String, usuario: String, clave: String, rol: String) {
        self.nombre = nombre
        self.usuario = usuario
        self.clave = clave
        self.rol = rol
    }

    var esSupervisor: Bool { rol == RolUsuario.supervisor.rawValue }

    var iniciales: String {
        let letras = nombre.split(separator: " ").prefix(2).compactMap { $0.first }
        return String(letras).uppercased()
    }
}
