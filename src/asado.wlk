// objetos candidatos 
// Persona 
// Elementos
// Posicion
class Posicion {

	const property x
	const property y

}

class Persona {

	var property posicion = new Posicion(x = 0, y = 0)
	const property elementos = []
	var property criterioDeCambio
	var property criterioDeComida
	const comidas = []

	method agregarElementos(otrosElementos) {
		elementos.addAll(otrosElementos)
	}

	method quitarElementos(otrosElementos) {
		elementos.removeAll(otrosElementos)
	}

	method pasame(elemento, quienLoPide) {
		self.validarElemento(elemento)
		criterioDeCambio.aplicar(elemento, quienLoPide, self)
	}

	method validarElemento(elemento) {
		if (!self.tengoElemento(elemento)) throw new DomainException(message = "no tengo el elemento")
	}

	method tengoElemento(elemento) = elementos.contains(elemento)

	method primerElemento() = elementos.first()

	method cambiarPosicion(otraPersona) {
		const aDondeVoy = otraPersona.posicion()
		otraPersona.posicion(self.posicion())
		posicion = aDondeVoy
	}

	method comer(comida) {
		if (criterioDeComida.quiereComer(comida)) comidas.add(comida)
	}

}

class CriterioDeCambio {

	method aplicar(elemento, quienLoPide, quienLoDa) {
		const elementosADevolver = self.queElementosLePaso(elemento, quienLoDa)
		quienLoPide.agregarElementos(elementosADevolver)
		quienLoDa.quitarElementos(elementosADevolver)
	}

	method queElementosLePaso(elemento, quienLoDa)

}

//algunos son sordos, le pasan el primer elemento que tienen a mano
object sordo inherits CriterioDeCambio {

	override method queElementosLePaso(elemento, quienLoDa) = [ quienLoDa.primerElemento() ]

}

//otros le pasan todos los elementos, “así me dejás comer tranquilo”
object dejameTranquilo inherits CriterioDeCambio {

	override method queElementosLePaso(elemento, quienLoDa) = quienLoDa.elementos()

}

//otros le piden que cambien la posición en la mesa, “así de paso charlo con otras personas” (ambos intercambian posiciones, A debe ir a la posición de B y viceversa)
object cambioDePosicion {

	method aplicar(elemento, quienLoPide, quienLoDa) {
		quienLoPide.cambiarPosicion(quienLoDa)
	}

}

//finalmente están las personas que le pasan el bendito elemento al otro comensal
object normal inherits CriterioDeCambio {

	override method queElementosLePaso(elemento, quienLoDa) = [ elemento ]

}

class Comida {

	const property esCarne
	const property calorias

	method tieneMenosCaloriasQue(tope) = calorias < tope

}

// criterio para comer 
//vegetariano: solo come lo que no sea carne
object vegetariano {

	method quiereComer(comida) = !comida.esCarne()

}

//dietético: come lo que insuma menos de 500 calorías, queremos poder configurarlo para todos los que elijan esta estrategia en base a lo que recomiende la OMS (Organización Mundial de la Salud)
object dietetico {

	var property topeDeCalorias = 500

	method quiereComer(comida) = comida.tieneMenosCaloriasQue(topeDeCalorias)

}

//alternado: acepta y rechaza alternativamente cada comida
class Alternado {
	var estaDeHumor = false 
	
	method quiereComer(comida) {
		estaDeHumor = ! estaDeHumor
		return estaDeHumor
	}
	
}

//una combinación de condiciones, donde todas deben cumplirse para aceptar la comida
class Combinacion {
	const criterio = []
	
	method agregarCriterio(unCriterio) {
		criterio.add(unCriterio)
	}
	
	method quiereComer(comida) = criterio.all { condicion => condicion.quiereComer(comida)}
	
}