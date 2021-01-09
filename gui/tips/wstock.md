# Carga masiva de productos
Si necesita cargar muchos productos, se puede hacer de la siguiente manera:

1. Situe el cursor en "Nombre"
2. Escriba el nombre y presione ENTER. El foco pasará a "Código"
3. Escriba el código y presione ENTER. El foco pasará a "Stock inicial" seleccionando el número "0".
4. Escriba el stock inicial. La selección será reemplazada por el número que ingrese. Presione ENTER y el foco pasará a "Precio".
5. Escriba el precio y presione ENTER. La selección será reemplazad por el número que ingrese. Presione ENTER y el foco pasará al botón "Nuevo producto"
6. Presione ENTER y se creará el nuevo producto. El foco volverá a "Nombre".
7. Repetir todo el proceso desde el paso 2 si desea agregar un nuevo producto.

En pocas palabras, la regla a recordar es: "Presionar ENTER para pasar al próximo campo".

# Editar un producto
Al hacer doble clic en la lista de stock se habilitará la edición de ese producto.

Podrá observar los siguientes cambios:

- El botón "Nuevo producto" se convertirá en "Guardar".
- En vez de "(Nuevo producto)" se mostrará el último precio de compra que usted realizó al proveedor.
- Si el precio de venta que usted escriba es mayor al precio de compra al provedor más un 50%, se mostrará una alerta. Ésto no prohibirá que pueda guardar el cambio ya que es meramente informativa.
  - El objetivo de esta notificación es para evitar errores al escribir el nuevo precio.
- Si el precio de venta que usted escriba es menor al precio de compra al proveedor, se mostrará un mensaje de alerta. Análoga al anterior, podrá guardar los cambios y es meramente informativa.
  - El objetivo de esta notificación es para que revea el precio evitando equivocaciones de escritura que puedan llevarle a pérdida.
- Se mostrarán las últimas 10 compras realizadas al proveedor.
- Se mostrarán las últimas 10 ventas realizadas a sus clientes.

