//
//  DetalleViewController.swift
//  Semana07_Cultura peruana
//
//  Created by Tecsup on 14/10/26.
//

import UIKit

class DetalleViewController: UIViewController {

    @IBOutlet weak var imgCultura: UIImageView!
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var lblRegion: UILabel!
    @IBOutlet weak var lblDescripcion: UILabel!

    var culturaSeleccionada: Cultura?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let cultura = culturaSeleccionada {
            title = cultura.nombre
            lblNombre.text = cultura.nombre
            lblRegion.text = "Región: \(cultura.region)"
            lblDescripcion.text = cultura.descripcion
            imgCultura.image = UIImage(named: cultura.imagenNombre)
        }
    }
}
