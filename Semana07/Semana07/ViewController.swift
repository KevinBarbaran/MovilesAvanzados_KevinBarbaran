//
//  ViewController.swift
//  Semana07
//
//  Created by Tecsup on 14/10/26.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var listaProfesores = [
        Profesor(nombre: "Jaime Gomez", cargo: "Coordinador de Software", foto: UIImage(named: "avatar1")),
        Profesor(nombre: "Jaime Farfan", cargo: "Docente de Software TC", foto: UIImage(named: "avatar2")),
        Profesor(nombre: "Juan León", cargo: "Docente de Software TC", foto: UIImage(named: "avatar4")),
        Profesor(nombre: "Silvia Montoya", cargo: "Docente de Software TC", foto: UIImage(named: "avatar3")),
        Profesor(nombre: "Theobaldo Diaz", cargo: "Docente de Software TC", foto: UIImage(named: "avatar5")),
        Profesor(nombre: "Elliot Garamendi", cargo: "Docente de Software TC", foto: UIImage(named: "avatar4")),
        Profesor(nombre: "Edwin Huerto", cargo: "Docente de Redes TC", foto: UIImage(named: "avatar2"))
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaProfesores.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath)
        let profesor = listaProfesores[indexPath.row]
        
        cell.textLabel?.text = profesor.nombre
        cell.detailTextLabel?.text = profesor.cargo
        cell.imageView?.image = profesor.foto
        
        return cell
    }
}
