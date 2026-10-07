//
//  DatosClienteViewController.swift
//  integrador
//
//  Created by Tecsup on 7/10/26.
//

import UIKit

class DatosClienteViewController: UIViewController {

    @IBOutlet weak var apellidosTextField: UITextField!
    @IBOutlet weak var nombresTextField: UITextField!
    @IBOutlet weak var dniTextField: UITextField!
    
    var carrito: CarritoModel!
    var cliente: ClienteModel?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func confirmarCompraTapped(_ sender: UIButton) {
        guard let apellidos = apellidosTextField.text, !apellidos.trimmingCharacters(in: .whitespaces).isEmpty,
              let nombres = nombresTextField.text, !nombres.trimmingCharacters(in: .whitespaces).isEmpty,
              let dni = dniTextField.text, !dni.trimmingCharacters(in: .whitespaces).isEmpty else {
            mostrarAlerta(mensaje: "Todos los campos son obligatorios.")
            return
        }
        
        if dni.count != 8 || Int(dni) == nil {
            mostrarAlerta(mensaje: "El DNI debe tener exactamente 8 dígitos.")
            return
        }
        
        cliente = ClienteModel(apellidos: apellidos, nombres: nombres, dni: dni)
        performSegue(withIdentifier: "verBoleta", sender: nil)
    }
    
    func mostrarAlerta(mensaje: String) {
        let alerta = UIAlertController(title: "Validación", message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "OK", style: .default))
        present(alerta, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "verBoleta" {
            let destino = segue.destination as! BoletaViewController
            destino.carrito = carrito
            destino.cliente = cliente
        }
    }
}
