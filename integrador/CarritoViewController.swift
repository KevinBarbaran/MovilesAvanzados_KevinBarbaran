//
//  CarritoViewController.swift
//  integrador
//
//  Created by Tecsup on 7/10/26.
//

import UIKit

class CarritoViewController: UIViewController {

    @IBOutlet weak var itemsLabel: UILabel!
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var descuentoLabel: UILabel!
    @IBOutlet weak var igvLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    var carrito: CarritoModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        actualizarUI()
    }
    
    func actualizarUI() {
        if carrito.items.isEmpty {
            itemsLabel.text = "El carrito está vacío"
        } else {
            let lineas = carrito.items.map { "\($0.producto.nombre) x\($0.cantidad)  S/ \(String(format: "%.2f", $0.subtotal()))" }
            itemsLabel.text = lineas.joined(separator: "\n")
        }
        
        subtotalLabel.text = String(format: "S/ %.2f", carrito.subtotal())
        descuentoLabel.text = String(format: "-S/ %.2f", carrito.montoDescuento())
        igvLabel.text = String(format: "S/ %.2f", carrito.igv())
        totalLabel.text = String(format: "S/ %.2f", carrito.total())
    }

    @IBAction func finalizarCompraTapped(_ sender: UIButton) {
        if carrito.items.isEmpty {
            let alerta = UIAlertController(title: "Carrito Vacío", message: "Agrega productos antes de continuar.", preferredStyle: .alert)
            alerta.addAction(UIAlertAction(title: "OK", style: .default))
            present(alerta, animated: true)
            return
        }
        performSegue(withIdentifier: "irDatosCliente", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "irDatosCliente" {
            let destino = segue.destination as! DatosClienteViewController
            destino.carrito = carrito
        }
    }
}
