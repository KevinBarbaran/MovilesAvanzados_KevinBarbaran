//
//  Sesion.swift
//  Lab12 EjercicioB
//
//  Created by Tecsup on 9/11/26.
//

import Foundation
import Observation

@Observable
class Sesion {
    var usuarioActual: Usuario?

    func iniciar(_ usuario: Usuario) { usuarioActual = usuario }
    func cerrar() { usuarioActual = nil }
}
