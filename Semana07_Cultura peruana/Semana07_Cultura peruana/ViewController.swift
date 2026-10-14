//
//  ViewController.swift
//  Semana07_Cultura peruana
//
//  Created by Tecsup on 14/10/26.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    let listaCulturas: [Cultura] = [
        Cultura(nombre: "Chavín", region: "Áncash", descripcion: "Destacó por su arquitectura monumental, las cabezas clavas y el Lanzón Monolítico de piedra en el templo Chavín de Huántar.", imagenNombre: "chavin"),
        Cultura(nombre: "Paracas", region: "Ica", descripcion: "Famosa por sus textiles finamente bordados, trepanaciones craneanas complejas y rituales de deformación craneal.", imagenNombre: "paracas"),
        Cultura(nombre: "Moche", region: "La Libertad", descripcion: "Conocidos por sus huacos retratos hiperrealistas, avanzada orfebrería y la tumba del Señor de Sipán.", imagenNombre: "moche"),
        Cultura(nombre: "Nazca", region: "Ica", descripcion: "Reconocidos mundialmente por sus enigmáticos geoglifos trazados sobre el desierto y sus acueductos subterráneos.", imagenNombre: "nazca"),
        Cultura(nombre: "Inca", region: "Cusco", descripcion: "El imperio más vasto de América del Sur, destacan por su arquitectura monumental en piedra como Machu Picchu y Sacsayhuamán.", imagenNombre: "inca")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let tv = tableView {
            tv.delegate = self
            tv.dataSource = self
        }
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaCulturas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celdaCultura", for: indexPath)
        let cultura = listaCulturas[indexPath.row]
        
        cell.textLabel?.text = cultura.nombre
        cell.detailTextLabel?.text = cultura.region
        cell.imageView?.image = UIImage(named: cultura.imagenNombre)
        
        return cell
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cultura = listaCulturas[indexPath.row]
        performSegue(withIdentifier: "sgDetalle", sender: cultura)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sgDetalle" {
            if let pantallaDetalle = segue.destination as? DetalleViewController,
               let cultura = sender as? Cultura {
                pantallaDetalle.culturaSeleccionada = cultura
            }
        }
    }
}
