//
//  PersonasTableViewCell.swift
//  Semana07_Ejercicio02
//
//  Created by Tecsup on 14/10/26.
//

import UIKit

class PersonasTableViewCell: UITableViewCell {

    @IBOutlet weak var PersonaImagen: UIImageView!
    @IBOutlet weak var personaNombre: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
