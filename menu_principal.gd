extends Control

@onready var seleccionar = $Select
@onready var inicio = $AudioStreamPlayer

func _ready() -> void:
	# Si el juego se está ejecutando en la web (itch.io), ocultamos el botón
	if OS.has_feature("web"):
		$"Boton Salir".visible = false
	inicio.play()
		
func _on_boton_inicio_pressed() -> void:
	seleccionar.play()
	await seleccionar.finished
	get_tree().change_scene_to_file("res://Juego.tscn")


func _on_boton_salir_pressed() -> void:
	seleccionar.play()
	await seleccionar.finished
	get_tree().quit()


func _on_boton_ayuda_pressed() -> void:
	seleccionar.play()
	await seleccionar.finished
	get_tree().change_scene_to_file("res://Ayuda.tscn")


func _on_boton_creditos_pressed() -> void:
	seleccionar.play()
	await seleccionar.finished
	get_tree().change_scene_to_file("res://Creditos.tscn")
