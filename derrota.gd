extends Control


func _on_boton_salir_pressed() -> void:
	get_tree().quit()

func _on_boton_reintentar_pressed() -> void:
	Global.reiniciar_estadisticas(false)
	if Global.ruta_nivel_actual != "":
		get_tree().change_scene_to_file(Global.ruta_nivel_actual)
	else:
		get_tree().change_scene_to_file("res://Juego.tscn")


func _on_menu_principal_pressed() -> void:
	get_tree().change_scene_to_file("res://Menu_Principal.tscn")
