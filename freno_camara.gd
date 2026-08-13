extends Area2D

func _on_freno_camara_body_entered(body: Node2D) -> void:
	if body.has_method("ganar_nivel"):
		var camara = body.get_node_or_null("Camera2D")
		if camara:
			# Desvinculamos la cámara para que se quede estática en ese punto
			camara.seguir_jugador = false
