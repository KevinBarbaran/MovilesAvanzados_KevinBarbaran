//
//  UserViewModel.swift
//  Semana13_MetodosAPI
//
//  Created by Tecsup on 25/11/26.
//

import Foundation
import Combine


@MainActor
final class UserViewModel: ObservableObject {


    // Lista original de usuarios.
    @Published var users: [User] = []

    // Texto ingresado en el buscador.
    @Published var searchText: String = ""

    // Estado de carga.
    @Published var isLoading: Bool = false

    // Mensaje de error para mostrarlo en la interfaz.
    @Published var errorMessage: String?


    private let baseURL =
        "https://jsonplaceholder.typicode.com/users"


    // Devuelve los usuarios que coinciden con el texto ingresado.
    var filteredUsers: [User] {

        let search = searchText
            .trimmingCharacters(in: .whitespacesAndNewlines)

        // Si el buscador está vacío, devuelve todos los usuarios.
        guard !search.isEmpty else {
            return users
        }

        // Busca coincidencias en el nombre sin distinguir
        // entre mayúsculas y minúsculas.
        return users.filter { user in
            user.name.localizedCaseInsensitiveContains(search)
        }
    }

    // Obtener todos los usuarios de la API.

    func fetchUsers() async {

        guard let url = URL(string: baseURL) else {
            errorMessage = "La dirección de la API no es válida."
            return
        }

        isLoading = true
        errorMessage = nil

        defer {
            isLoading = false
        }

        do {

            // Realiza la solicitud GET y espera la respuesta.
            let (data, response) =
                try await URLSession.shared.data(from: url)

            // Comprueba el código de respuesta HTTP.
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {

                errorMessage = "No se pudieron obtener los usuarios."
                return
            }

            // Convierte el JSON recibido en una lista de usuarios.
            let decodedUsers = try JSONDecoder().decode(
                [User].self,
                from: data
            )

            // Actualiza la lista que utiliza la interfaz.
            users = decodedUsers

        } catch {

            errorMessage =
                "Error al obtener los usuarios: \(error.localizedDescription)"
        }
    }

    // Crear un nuevo usuario.

    func createUser(name: String, email: String) async {

        guard let url = URL(string: baseURL) else {
            errorMessage = "La dirección de la API no es válida."
            return
        }

        errorMessage = nil

        // JSONPlaceholder asigna el ID al usuario creado.
        // El valor 0 se utiliza únicamente antes de recibir la respuesta.
        let newUser = User(
            id: 0,
            name: name,
            email: email
        )

        var request = URLRequest(url: url)

        request.httpMethod = "POST"

        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )

        do {

            // Convierte el usuario en JSON.
            request.httpBody = try JSONEncoder().encode(newUser)

            // Envía la solicitud POST.
            let (data, response) =
                try await URLSession.shared.data(for: request)

            // Verifica que la respuesta HTTP sea exitosa.
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {

                errorMessage = "No se pudo crear el usuario."
                return
            }

            // Decodifica el usuario creado que devuelve la API.
            let createdUser = try JSONDecoder().decode(
                User.self,
                from: data
            )

            // Agrega el usuario a la lista local.
            users.append(createdUser)

        } catch {

            errorMessage =
                "Error al crear el usuario: \(error.localizedDescription)"
        }
    }

    // Actualizar un usuario existente.

    func updateUser(_ user: User) async {

        let urlString = "\(baseURL)/\(user.id)"

        guard let url = URL(string: urlString) else {
            errorMessage = "La dirección de la API no es válida."
            return
        }

        errorMessage = nil

        var request = URLRequest(url: url)

        request.httpMethod = "PUT"

        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )

        do {

            // Convierte el usuario actualizado en JSON.
            request.httpBody = try JSONEncoder().encode(user)

            // Envía la solicitud PUT.
            let (data, response) =
                try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {

                errorMessage = "No se pudo actualizar el usuario."
                return
            }

            // Decodifica la respuesta de la API.
            let updatedUser = try JSONDecoder().decode(
                User.self,
                from: data
            )

            // Busca el usuario original en la lista.
            if let index = users.firstIndex(where: {
                $0.id == updatedUser.id
            }) {

                // Reemplaza el usuario con sus datos actualizados.
                users[index] = updatedUser

            } else {

                errorMessage = "No se encontró el usuario actualizado."
            }

        } catch {

            errorMessage =
                "Error al actualizar el usuario: \(error.localizedDescription)"
        }
    }

    // Eliminar un usuario por su identificador.

    func deleteUser(id: Int) async {

        let urlString = "\(baseURL)/\(id)"

        guard let url = URL(string: urlString) else {
            errorMessage = "La dirección de la API no es válida."
            return
        }

        errorMessage = nil

        var request = URLRequest(url: url)

        request.httpMethod = "DELETE"

        do {

            // Envía la solicitud DELETE.
            let (_, response) =
                try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {

                errorMessage = "No se pudo eliminar el usuario."
                return
            }

            // Elimina el usuario de la lista local.
            users.removeAll { $0.id == id }

        } catch {

            errorMessage =
                "Error al eliminar el usuario: \(error.localizedDescription)"
        }
    }
}
