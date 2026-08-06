extends Control


func _on_bonton_salir_pressed() -> void:
	get_tree().quit()


func _on_boton_siguiente_nivel_pressed() -> void:
	get_tree().change_scene_to_file("res://Juego.tscn")
