extends Control

func _on_boton_inicio_pressed() -> void:
	get_tree().change_scene_to_file("res://Juego.tscn")


func _on_boton_salir_pressed() -> void:
	get_tree().quit()


func _on_boton_ayuda_pressed() -> void:
	get_tree().change_scene_to_file("res://Ayuda.tscn")
