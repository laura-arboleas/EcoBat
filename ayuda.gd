extends Control
@onready var seleccionar = $Select

func _on_volver_pressed() -> void:
	seleccionar.play()
	await seleccionar.finished
	get_tree().change_scene_to_file("res://Menu_Principal.tscn")
