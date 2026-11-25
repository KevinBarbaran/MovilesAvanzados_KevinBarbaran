//
//  MessagesView.swift
//  Lab14IntroFirebase
//
//  Actividad 02: pantalla de mensajería en tiempo real.
//

import SwiftUI
import FirebaseAuth

struct MessagesView: View {

    // @StateObject: la vista es dueña del servicio y lo conserva entre redibujados
    @StateObject private var databaseService = DatabaseService()
    @State private var newMessage = ""

    /// Mensaje sin espacios sobrantes; sirve para validar y enviar.
    private var trimmedMessage: String {
        newMessage.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var body: some View {
        VStack {
            // MARK: Cabecera
            HStack {
                Text("Messages")
                    .font(.title)
                    .fontWeight(.bold)

                Spacer()

                Button("Sign Out") {
                    // El listener de AuthView detecta el cambio y vuelve al login
                    try? Auth.auth().signOut()
                }
                .foregroundColor(.red)
            }
            .padding()

            // MARK: Lista de mensajes
            List(databaseService.messages) { message in
                VStack(alignment: .leading, spacing: 5) {
                    Text(message.text)
                        .font(.body)

                    HStack {
                        Text(message.userEmail)
                            .font(.caption)
                            .foregroundColor(.secondary)

                        Spacer()

                        Text(message.timestamp, style: .time)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.vertical, 2)
            }

            // MARK: Entrada de nuevo mensaje
            HStack {
                TextField("Type a message...", text: $newMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button("Send") {
                    sendMessage()
                }
                .disabled(trimmedMessage.isEmpty)
            }
            .padding()
        }
        .onAppear {
            databaseService.startListening()
        }
        .onDisappear {
            // Importante: tras cerrar sesión las reglas ya no permiten leer
            databaseService.stopListening()
        }
    }

    // MARK: - Acciones
    private func sendMessage() {
        guard !trimmedMessage.isEmpty else { return }
        databaseService.addMessage(text: trimmedMessage)
        newMessage = ""
    }
}

#Preview {
    MessagesView()
}
