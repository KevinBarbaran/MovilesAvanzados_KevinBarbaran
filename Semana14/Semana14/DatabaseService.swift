//
//  DatabaseService.swift
//  Lab14IntroFirebase
//
//  Actividad 02: capa de acceso a datos (Cloud Firestore).
//  Aísla la lógica de base de datos para que las vistas no hablen directo con Firebase.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import Combine


// MARK: - Modelo
/// Documento de la colección "messages".
/// Codable  → Firestore lo convierte automáticamente a/desde documento.
/// Identifiable → SwiftUI puede usarlo directamente en List.
struct Message: Identifiable, Codable {
    let id: String
    let text: String
    let userEmail: String
    let timestamp: Date
}

// MARK: - Servicio
final class DatabaseService: ObservableObject {

    private let db = Firestore.firestore()

    /// Lista de mensajes. Al ser @Published, la vista se redibuja sola cuando cambia.
    @Published var messages: [Message] = []

    /// Registro del listener, necesario para poder cancelarlo.
    private var listener: ListenerRegistration?

    // MARK: Escritura

    /// Guarda un mensaje nuevo en la colección "messages".
    func addMessage(text: String) {
        // Solo un usuario autenticado puede escribir
        guard let user = Auth.auth().currentUser else { return }

        let message = Message(
            id: UUID().uuidString,
            text: text,
            userEmail: user.email ?? "Unknown",
            timestamp: Date()
        )

        do {
            print("message \(message.userEmail)")
            // El id del documento coincide con el id del mensaje
            try db.collection("messages").document(message.id).setData(from: message)
        } catch {
            print("Error adding message: \(error)")
        }
    }

    // MARK: Lectura en tiempo real

    /// Se suscribe a la colección. El closure se ejecuta una vez con los datos
    /// actuales y luego CADA VEZ que alguien agrega, edita o borra un mensaje.
    func startListening() {
        // Evita duplicar listeners si la vista aparece varias veces
        stopListening()

        listener = db.collection("messages")
            .order(by: "timestamp", descending: false)   // más antiguos primero
            .addSnapshotListener { [weak self] querySnapshot, error in
                if let error = error {
                    print("Error getting messages: \(error)")
                    return
                }

                // compactMap descarta documentos que no se puedan decodificar a Message
                self?.messages = querySnapshot?.documents.compactMap { document in
                    try? document.data(as: Message.self)
                } ?? []
            }
    }

    /// Cancela la suscripción (al salir de la pantalla o cerrar sesión).
    func stopListening() {
        listener?.remove()
        listener = nil
    }

    deinit {
        stopListening()
    }
}
