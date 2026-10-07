//
//  BoletaViewController.swift
//  integrador
//
//  Created by Tecsup on 7/10/26.
//

import UIKit

class BoletaViewController: UIViewController {

    @IBOutlet weak var clienteLabel: UILabel!
    @IBOutlet weak var itemsLabel: UILabel!
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var descuentoLabel: UILabel!
    @IBOutlet weak var igvLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    var carrito: CarritoModel!
    var cliente: ClienteModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        clienteLabel.text = "\(cliente.nombres) \(cliente.apellidos) (\(carrito.categoriaCliente())) - DNI \(cliente.dni)"
        
        let lineas = carrito.items.map { "\($0.producto.nombre) x\($0.cantidad)\nS/ \(String(format: "%.2f", $0.subtotal()))" }
        itemsLabel.text = lineas.joined(separator: "\n\n")
        
        subtotalLabel.text = String(format: "S/ %.2f", carrito.subtotal())
        descuentoLabel.text = String(format: "-S/ %.2f (\(Int(carrito.porcentajeDescuento() * 100))%)", carrito.montoDescuento())
        igvLabel.text = String(format: "S/ %.2f", carrito.igv())
        totalLabel.text = String(format: "S/ %.2f", carrito.total())
    }

    @IBAction func cerrarTapped(_ sender: UIButton) {
        for item in carrito.items {
            item.producto.stock -= item.cantidad
        }
        carrito.vaciar()
        
        dismiss(animated: true) {
            if let nav = self.presentingViewController as? UINavigationController {
                nav.popToRootViewController(animated: true)
            }
        }
    }
}
