import Foundation

//calendario de pagos/
//ingresar el nombre del producto, precio y cantidad.

let igv = 0.18

func    CalcularDesc(cantidad: Int, subtotal: Double)->Double{
    if cantidad >   10 {
        return subtotal * 0.15
    } else if cantidad > 5 {
        return subtotal * 0.10
    }else {
        return 0.0
    }
}

print("ingrese el nombre del producto")
let producto = readLine() ?? "Leche"
print("ingrese el precio del producto")
let precio = Double(readLine() ?? "12.0") ?? 12.0
print("ingrese la cantidad del producto")
let cantidad = Int(readLine() ?? "5") ?? 5

let subtotal = precio * Double(cantidad)
let descuento = CalcularDesc(cantidad: cantidad, subtotal: subtotal)

//halalr el monto base : subtotal - descuento
let montoBase = subtotal - descuento

//hallar el igv : monto base * igv
let totalIGV = montoBase * igv

//hallar el total : monto base + igv
let totalPagar = montoBase + totalIGV

//primer commit

//mostrar los datos.
print("Producto: \(producto)")
print("Precio unitario: S/ \(precio)")
print("Cantidad: \(cantidad)")
print("Subtotal: S/ \(subtotal)")
print("Descuento: S/ \(descuento)")
print("Monto base: S/ \(montoBase)")
print("IGV (18%): S/ \(totalIGV)")
print("Total a pagar: S/ \(totalPagar)")
