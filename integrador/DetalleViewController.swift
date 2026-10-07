//
//  DetalleViewController.swift
//  integrador
//
//  Created by Tecsup on 7/10/26.
//

import UIKit

class DetalleViewController: UIViewController {

    @IBOutlet weak var productoLabel: UILabel!
    @IBOutlet weak var precioLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    @IBOutlet weak var cantidadLabel: UILabel!
    
    var producto: Producto!
    var carrito: CarritoModel!
    var cantidadSeleccionada: Int = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        actualizarUI()
    }
    
    func actualizarUI() {
        productoLabel.text = producto.nombre
        precioLabel.text = String(format: "S/ %.2f", producto.precio)
        stockLabel.text = "\(producto.stock)"
        cantidadLabel.text = "\(cantidadSeleccionada)"
    }

    @IBAction func restarTapped(_ sender: UIButton) {
        if cantidadSeleccionada > 1 {
            cantidadSeleccionada -= 1
            cantidadLabel.text = "\(cantidadSeleccionada)"
        }
    }

    @IBAction func sumarTapped(_ sender: UIButton) {
        cantidadSeleccionada += 1
        cantidadLabel.text = "\(cantidadSeleccionada)"
    }

    @IBAction func agregarAlCarritoTapped(_ sender: UIButton) {
        let exito = carrito.agregar(producto: producto, cantidad: cantidadSeleccionada)
        if exito {
            navigationController?.popViewController(animated: true)
        } else {
            let alerta = UIAlertController(title: "Stock Insuficiente", message: "La cantidad supera el stock disponible.", preferredStyle: .alert)
            alerta.addAction(UIAlertAction(title: "OK", style: .default))
            present(alerta, animated: true)
        }
    }
}
