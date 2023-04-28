# Manuable
Para lograr usar esta gema (en su version beta) de manera correcta, habremos de instalar todas las gemas.

Para logarlo tendiramos que despues de clonar el repositorio:

gh repo clone dederico/Manuable


instalar todas las gemas:

bundle install

despues usar bundle para ejecutar el script de ruby.


bundle exec ruby fedex_rates.rb


Esto se conectara con el estado actual del script, con atributos 'hard-coded', pero por el momento la gema se esta conectando de manera correcta a la API destino, y esta obteniendo la respuesta en XML, por lo que dentro del nodo TotalNetCharge, el atributo Amount es el que buscamos.


