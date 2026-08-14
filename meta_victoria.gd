extends Area2D

func _on_body_entered(body):
	# Verificamos si el que entró es el jugador
	if body.has_method("ganar_nivel"):
		body.ganar_nivel()
		var tween = create_tween()
		tween.tween_property(body, "global_position", global_position, 1.5)
		tween.parallel().tween_property(body, "scale", Vector2.ZERO, 1.5)
		tween.tween_callback(cambiar_pantalla)

func cambiar_pantalla():
	get_tree().change_scene_to_file("res://Victoria.tscn")
