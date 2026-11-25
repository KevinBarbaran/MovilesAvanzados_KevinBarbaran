//
//  User.swift
//  Semana13_MetodosAPI
//
//  Created by Tecsup on 25/11/26.
//

import Foundation

struct User: Codable, Identifiable {

    // Identificador único del usuario.
    let id: Int

    // Nombre completo del usuario.
    var name: String

    // Correo electrónico del usuario.
    var email: String

}
