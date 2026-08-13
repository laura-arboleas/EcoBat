extends Node2D

@onready var arana = $"araña"

@onready var posicion_inicial_arana = arana.position

var ya_se_activo = false

var distancia_de_caida = 250 

func _on_zona_deteccion_body_entered(body: Node2D) -> void:
	if body.name == "Jugador" and not ya_se_activo:
		ya_se_activo = true
		bajar_arana()
		
func bajar_arana():
	var animacion = create_tween()
	var posicion_final = arana.position + Vector2(0, distancia_de_caida)
	animacion.tween_property(arana, "position", posicion_final, 0.5).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	arana.prender_luz()
	arana.bajar()
