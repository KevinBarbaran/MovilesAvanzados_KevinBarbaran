//
//  AuthView.swift
//  Lab14IntroFirebase
//
//  Actividad 01 (autenticación) + Actividad 02 (muestra MessagesView al iniciar sesión).
//

import SwiftUI
import FirebaseAuth
import FirebaseCore

struct AuthView: View {

    // MARK: - Estado de la vista
    @State private var email = ""
    @State private var password = ""
    @State private var isSignedIn = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    /// Handle del listener de sesión. Se guarda para poder removerlo cuando la vista desaparece.
    @State private var authStateListener: AuthStateDidChangeListenerHandle?

    // MARK: - Cuerpo
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {

                Text("Lab 14: Firebase")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 50)

                Spacer()

                if isSignedIn {
                    // Actividad 02: con sesión iniciada se muestra la mensajería
                    // (en la Actividad 01 aquí iba el "Welcome! / You are signed in").
                    MessagesView()
                } else {
                    // Formulario de acceso
                    VStack(spacing: 15) {
                        TextField("Email", text: $email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                            .textContentType(.emailAddress)
                            .autocorrectionDisabled()

                        SecureField("Password", text: $password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .textContentType(.password)

                        HStack(spacing: 20) {
                            Button("Sign In") {
                                signIn()
                            }
                            .buttonStyle(PrimaryButtonStyle())

                            Button("Sign Up") {
                                signUp()
                            }
                            .buttonStyle(SecondaryButtonStyle())
                        }
                    }
                    .padding(.horizontal, 30)
                }

                Spacer()
            }
            .navigationBarHidden(true)
        }
        .alert("Message", isPresented: $showAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
        .onAppear {
            checkAuthState()
        }
        .onDisappear {
            removeAuthListener()
        }
        .onChange(of: isSignedIn) {
            // Limpia el formulario cuando se cierra sesión
            if !isSignedIn {
                email = ""
                password = ""
            }
        }
    }

    // MARK: - Authentication Functions

    /// Inicia sesión con un usuario ya registrado en Firebase Authentication.
    func signIn() {
        let cleanEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)

        // 1. Validación local: evita una llamada de red innecesaria
        guard !cleanEmail.isEmpty && !password.isEmpty else {
            alertMessage = "Please enter both email and password"
            showAlert = true
            return
        }

        // 2. Llamada asíncrona a Firebase. El closure se ejecuta cuando el servidor responde.
        Auth.auth().signIn(withEmail: cleanEmail, password: password) { result, error in
            if let error = error {
                alertMessage = "Sign in failed: \(friendlyMessage(for: error))"
                showAlert = true
                print("error.localizedDescription: '\(error.localizedDescription)'")
            } else {
                isSignedIn = true
                alertMessage = "Sign in successful!"
                showAlert = true
            }
        }
    }

    /// Registra un usuario nuevo (correo + contraseña) y, si tiene éxito, inicia sesión con él.
    func signUp() {
        let cleanEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !cleanEmail.isEmpty && !password.isEmpty else {
            alertMessage = "Please enter both email and password"
            showAlert = true
            return
        }

        // Firebase exige un mínimo de 6 caracteres; validarlo antes ahorra una petición.
        guard password.count >= 6 else {
            alertMessage = "Password must be at least 6 characters"
            showAlert = true
            return
        }

        Auth.auth().createUser(withEmail: cleanEmail, password: password) { result, error in
            if let error = error {
                alertMessage = "Sign up failed: \(friendlyMessage(for: error))"
                showAlert = true
            } else {
                // createUser deja al usuario autenticado automáticamente
                isSignedIn = true
                alertMessage = "Account created successfully!"
                showAlert = true
            }
        }
    }

    /// Cierra la sesión del usuario actual (operación local, puede lanzar error).
    func signOut() {
        do {
            try Auth.auth().signOut()
            isSignedIn = false
            alertMessage = "Signed out successfully"
            showAlert = true
        } catch {
            alertMessage = "Sign out failed: \(error.localizedDescription)"
            showAlert = true
        }
    }

    /// Escucha los cambios de sesión (login, logout, sesión restaurada al abrir la app).
    func checkAuthState() {
        // Evita registrar dos listeners si onAppear se dispara más de una vez
        removeAuthListener()

        authStateListener = Auth.auth().addStateDidChangeListener { auth, user in
            DispatchQueue.main.async {
                // user != nil  → hay sesión activa; user == nil → no hay sesión
                self.isSignedIn = user != nil
            }
        }
    }

    /// Libera el listener para no dejar observadores colgados.
    private func removeAuthListener() {
        if let handle = authStateListener {
            Auth.auth().removeStateDidChangeListener(handle)
            authStateListener = nil
        }
    }

    // MARK: - Helpers

    /// Traduce los códigos de error de Firebase a mensajes claros para el usuario.
    private func friendlyMessage(for error: Error) -> String {
        let nsError = error as NSError
        guard let code = AuthErrorCode.Code(rawValue: nsError.code) else {
            return error.localizedDescription
        }
        switch code {
        case .invalidEmail:
            return "The email address is badly formatted."
        case .emailAlreadyInUse:
            return "This email is already registered. Try signing in."
        case .weakPassword:
            return "The password is too weak (minimum 6 characters)."
        case .wrongPassword, .invalidCredential, .userNotFound:
            return "Incorrect email or password."
        case .userDisabled:
            return "This account has been disabled."
        case .networkError:
            return "Network error. Check your internet connection."
        case .tooManyRequests:
            return "Too many attempts. Please try again later."
        default:
            return error.localizedDescription
        }
    }
}

// MARK: - Button Styles

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding()
            .background(Color.blue)
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.blue)
            .padding()
            .background(Color.clear)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.blue, lineWidth: 2)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

struct SignOutButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding()
            .background(Color.red)
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

#Preview {
    AuthView()
}
