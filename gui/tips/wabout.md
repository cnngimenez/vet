# ¡Encontré un error!
Los errores puede reportarlo en la sección "Issues" de la  página del proyecto: https://github.com/cnngimenez/vet

En la ventana "Ayuda y Soporte" encontrará todos los enlaces y botones para acceder directamente a ellos. Para acceder a dicha ventana, click en el menú *Ventana* y luego en *Información y Soporte*.

# Me gustaría compartir este programa con un amig@
Mientras que el nombre de los autores y colaboradores se preserven, usted puede compartir este programa con quién desee. La licencia GNU General Public License (GPLv3) es una licencia libre que respeta sus libertades de usuario.

También puede modificar el software a su gusto y compartir sus cambios. Esto es así siempre y cuando todos los autores y colaboradores se mencionen y se preserven como así las libertades de ejecutar, utilizar, estudiar, modificar y distribuir el software (modificado o no) como se estableció inicialmente. Esto se denomina en la jerga informática como "Copyleft".

Para más información, puede visitar la página de la Free Software Foundation donde explica estos conceptos de forma detallada: 

- "¿Qué es el software libre?": https://www.gnu.org/philosophy/free-sw.es.html
- "Copyleft: Idealismo pragmático": https://www.gnu.org/philosophy/pragmatic.es.html

# ¿Cómo hacer una copia de Respaldo de la Base de Datos?
La Base de Datos de la aplicación es el archivo donde se encuentra toda la información que usted ingresó. En otras palabras, es un archivo que tiene un formato especial (técnicamente SQLite) y que adentro de él se encuentra la información del stock y los turnos.

Realizar una copia de respaldo es copiar el archivo db.sqlite3 que se encuentra en el directorio de la aplicación (la carpeta donde instaló Vet). Si usted no sabe dónde se encuentra esta carpeta, en el menú *Ventanas* > *Información y Soporte* abrirá una ventana nueva. Al final, se muestra la ubicación y puede hacer clic en "Abrir Ubicación" para que el explorador de archivos de su sistema muestre ese directorio.

Al realizar una copia de respaldo, considere lo siguiente:

- Es recomendable copiar el archivo original a un pendrive o un disco portátil. Si usted supone que su sistema operativo puede fallar, esto le ayudará a recuperar los datos a pesar de que no pueda utilizar su computadora a futuro. 
- Puede hacer varias copias en varios lugares físicos. Por ejemplo, puede hacer una copia en un disco portátil y otra en su carpeta de documentos del sistema. Esto le permitirá recuperar los datos si Vet falla solamente o si el sistema operativo falla. 
- Para mantener el orden, intente ser consistente y constante al hacer las copias: si tomó la decisión de copiar su base de datos en dos lugares físicos cada día, evite saltearse días o realizar solo una de las copias.
- Puede utilizar la copia de respaldo para pasar sus datos de una máquina a otra.
- *Siempre escriba la fecha en el nombre del archivo.*
- Es una buena práctica dejar dos o más copias de respaldo anteriores.
- Siempre evite pisar las copias de respaldo viejas. Para ello, puede indicarle al sistema que esos archivos son de solo lectura. Las opciones de permisos se encuentra usualmente en las propiedades del archivo del explorador de archivos.

En resumen, los pasos habituales son los siguientes:

- Dirígase al menú *Ventanas* y luego *Información y Soporte*.
- Haga clic en *Abrir Ubicación*.
- Cierre la aplicación Vet completamente (Clic en el menú *Programa* y luego *Salir*).
- Copie el archivo *db.sqlite3* a otra ubicación. Puede ser sus documentos o el escritorio, pero recomendamos que lo copie a un pendrive o un disco portátil. 
- Cambie el nombre de la nueva copia a "db-FECHA_ACTUAL.sqlite3", donde "FECHA_ACTUAL" es la fecha del día de hoy.
