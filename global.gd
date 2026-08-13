extends Node

var ruta_nivel_actual: String = ""

# Estadísticas del jugador
var vida_maxima: float = 100.0
var vida_actual: float = 100.0
var energia_maxima: float = 100.0
var energia_actual: float = 100.0
var tiene_escudo: bool = false


func reiniciar_estadisticas(mantener_escudo: bool = false):
	vida_actual = vida_maxima
	energia_actual = energia_maxima

	if not mantener_escudo:
		tiene_escudo = false
