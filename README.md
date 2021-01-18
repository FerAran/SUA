# SUA

Repositorio que actuelamente cuenta con las siguientes funciones para facilitar la importación de movientos al SUA:

Data.Siroc: crea un archivo en formato txt con el formato requerido para los movimientos en el SIROC a partir de un archivo pdf con los recibos de nómina.

Bajas:

Ordenar:


Data.SUA: 

La función consta de los siguientes argumentos:

files : aquí debe indicarse el nombre del archivo pdf del que se extraeran los datos con el formato: "nombre_archivo.pdf" per_sem: aquí debe indicarse el periodo al que pertenecen los recibos semanales, esto en formato de numero: ## *esto sirve para diferenciar entre aquellos recibos que son semanles y los que son quincenales

inicio_sem: aquí debe establecerse la fecha de incio de la semana correspondiente en formato: "dd/mm/aaaa"

inicio_quin: aquí debe establecerse la fecha de incio de la quincena correspondiente en formato: "dd/mm/aaaa"

patron = "Y123456790", es el número de registro patronal, tiene el valor "Y123456790" como default (es necesario moficarlo al de la empresa correspondiente)

mov = 30 , es el número de movimiento que se realiza dentro del SUA,tiene el valor 30 como default
