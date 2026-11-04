//
//  ViewController.swift
//  Lab11
//
//  Created by Tecsup on 4/11/26.
//

import UIKit
import CoreData


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    @IBOutlet weak var TablaContacto: UITableView!
    
    // Arreglo local para almacenar los contactos de Core Data
        var contactos = [Contacto]()

        override func viewDidLoad() {
            super.viewDidLoad()
            
            // Título de la pantalla
            self.navigationItem.title = "Lista de Contactos - Tecsup"
            
            // Configuración de la tabla
            TablaContacto.dataSource = self
            TablaContacto.delegate = self
            
            // Imprimir la ruta del archivo SQLite y cargar datos guardados
            mostrarRutaBaseDeDatos()
            cargarInfoCoreData()
        }

        // MARK: - Conexión con Core Data
        func conexion() -> NSManagedObjectContext {
            let delegate = UIApplication.shared.delegate as! AppDelegate
            return delegate.persistentContainer.viewContext
        }

        func mostrarRutaBaseDeDatos() {
            let delegate = UIApplication.shared.delegate as! AppDelegate
            let ruta = delegate.persistentContainer.persistentStoreDescriptions.first?.url?.path ?? "sin ruta"
            print("Base de datos SQLite en: \(ruta)")
        }

        // MARK: - READ: Leer los datos desde Core Data
        func cargarInfoCoreData() {
            let contexto = conexion()
            let fetchRequest: NSFetchRequest<Contacto> = Contacto.fetchRequest()
            
            // Ordenar alfabéticamente por nombre
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "nombre", ascending: true)]
            
            do {
                contactos = try contexto.fetch(fetchRequest)
            } catch {
                print("Error al cargar la BD: \(error)")
            }
        }

        // MARK: - UITableViewDataSource (Mostrar datos en la tabla)
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return contactos.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let celda = TablaContacto.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            let contacto = contactos[indexPath.row]
            
            celda.textLabel?.text = contacto.nombre
            celda.detailTextLabel?.text = "\(contacto.telefono ?? "") | \(contacto.direccion ?? "")"
            
            return celda
        }
    
    
    
    @IBAction func agregarContacto(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Agregar Contacto", message: "Nuevo Contacto", preferredStyle: .alert)
        alert.addTextField { $0.placeholder = "Nombre" }
        alert.addTextField { $0.placeholder = "Telefono" }
        alert.addTextField { $0.placeholder = "Direccion" }

        let actionAceptar = UIAlertAction(title: "Aceptar", style: .default) { _ in
            guard let nombre = alert.textFields?[0].text, !nombre.isEmpty else { return }
            let telefono = alert.textFields?[1].text ?? ""
            let direccion = alert.textFields?[2].text ?? ""

            let contexto = self.conexion()
            let entidad = NSEntityDescription.insertNewObject(forEntityName: "Contacto", into: contexto) as! Contacto
            entidad.nombre = nombre
            entidad.telefono = telefono
            entidad.direccion = direccion

            do {
                try contexto.save()
                self.cargarInfoCoreData()
                self.TablaContacto.reloadData()
            } catch {
                print("Error al guardar el dato: \(error)")
            }
        }

        alert.addAction(actionAceptar)
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        present(alert, animated: true)
    }

    // MARK: - UPDATE: Editar un contacto al tocar la fila
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let contacto = contactos[indexPath.row]
        
        let alert = UIAlertController(title: "Editar Contacto", message: "Modifica los datos", preferredStyle: .alert)
        alert.addTextField { $0.text = contacto.nombre }
        alert.addTextField { $0.text = contacto.telefono }
        alert.addTextField { $0.text = contacto.direccion }

        let actionGuardar = UIAlertAction(title: "Guardar", style: .default) { _ in
            guard let nombre = alert.textFields?[0].text, !nombre.isEmpty else { return }
            
            contacto.nombre = nombre
            contacto.telefono = alert.textFields?[1].text
            contacto.direccion = alert.textFields?[2].text

            do {
                try self.conexion().save()
                self.cargarInfoCoreData()
                self.TablaContacto.reloadData()
            } catch {
                print("Error al actualizar: \(error)")
            }
        }

        alert.addAction(actionGuardar)
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        present(alert, animated: true)
    }

    // MARK: - DELETE: Eliminar deslizando hacia la izquierda
    func eliminarContacto(at indexPath: IndexPath) {
        let contexto = conexion()
        let contactoEliminar = contactos[indexPath.row]
        contexto.delete(contactoEliminar)

        do {
            contactos.remove(at: indexPath.row)
            TablaContacto.deleteRows(at: [indexPath], with: .automatic)
            try contexto.save()
        } catch {
            print("Error al eliminar: \(error)")
        }
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            eliminarContacto(at: indexPath)
        }
    }
}


