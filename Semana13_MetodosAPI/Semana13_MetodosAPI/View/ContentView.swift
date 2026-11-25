//
//  ContentView.swift
//  Semana13_MetodosAPI
//
//  Created by Tecsup on 25/11/26.
//

import SwiftUI

struct ContentView: View {


    @StateObject private var viewModel = UserViewModel()


    @State private var showingForm = false

    @State private var editingUser: User? = nil

    var body: some View {

        NavigationStack {

            VStack(spacing: 0) {


                HStack {

                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)

                    TextField(
                        "Buscar usuario por nombre",
                        text: $viewModel.searchText
                    )
                    .textFieldStyle(.plain)
                }
                .padding(12)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)
                .padding(.top, 12)


                if let error = viewModel.errorMessage {

                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                        .padding(.top, 8)
                }


                if viewModel.isLoading && viewModel.users.isEmpty {

                    Spacer()

                    ProgressView("Cargando usuarios...")
                        .padding()

                    Spacer()

                } else if viewModel.filteredUsers.isEmpty {

                    Spacer()

                    VStack(spacing: 10) {

                        Image(systemName: "person.crop.circle.badge.questionmark")
                            .font(.system(size: 45))
                            .foregroundColor(.gray)

                        Text("No se encontraron usuarios")
                            .font(.headline)

                        Text("Intenta con otro nombre.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding()

                    Spacer()

                } else {

                    List {

                        ForEach(viewModel.filteredUsers) { user in


                            VStack(alignment: .leading, spacing: 5) {

                                Text(user.name)
                                    .font(.headline)
                                    .foregroundColor(.primary)

                                Text(user.email)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 5)


                            .swipeActions(edge: .trailing) {

                                // Acción para eliminar.
                                Button(role: .destructive) {

                                    Task {
                                        await viewModel.deleteUser(id: user.id)
                                    }

                                } label: {

                                    Label(
                                        "Eliminar",
                                        systemImage: "trash"
                                    )
                                }

                                // Acción para editar.
                                Button {

                                    editingUser = user
                                    showingForm = true

                                } label: {

                                    Label(
                                        "Editar",
                                        systemImage: "pencil"
                                    )
                                }
                                .tint(.blue)
                            }
                        }
                    }
                    .listStyle(.plain)
                }


                Button {

                    editingUser = nil
                    showingForm = true

                } label: {

                    Label(
                        "Agregar usuario",
                        systemImage: "plus.circle.fill"
                    )
                    .font(.headline)
                    .foregroundColor(.blue)
                    .padding()
                }
            }


            .navigationTitle("Usuarios")


            .task {
                await viewModel.fetchUsers()
            }


            .sheet(isPresented: $showingForm) {

                if let user = editingUser {

                    // Formulario para editar un usuario.
                    UserFormView(
                        name: user.name,
                        email: user.email,
                        isEditing: true
                    ) { name, email in

                        let updatedUser = User(
                            id: user.id,
                            name: name,
                            email: email
                        )

                        Task {
                            await viewModel.updateUser(updatedUser)
                        }
                    }

                } else {

                    // Formulario para crear un usuario.
                    UserFormView(
                        isEditing: false
                    ) { name, email in

                        Task {
                            await viewModel.createUser(
                                name: name,
                                email: email
                            )
                        }
                    }
                }
            }
        }
    }
}


#Preview {
    ContentView()
}
