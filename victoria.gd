extends Control
@onready var seleccionar = $Select
#@onready var victoria = $AudioStreamPlayer
func _ready() -> void:
	#var inicio = $AudioStreamPlayer2D
	# Si el juego se está ejecutando en la web (itch.io), ocultamos el botón
	if OS.has_feature("web"):
		$"Boton Salir".visible = false
	#victoria.play()
	
func _on_boton_salir_pressed() -> void:
	get_tree().quit()


func _on_boton_siguiente_nivel_pressed() -> void:
	seleccionar.play()
	Global.reiniciar_estadisticas(true)
	await seleccionar.finished
	get_tree().change_scene_to_file("res://Nivel2.tscn")


func _on_menu_principal_pressed() -> void:
	seleccionar.play()
	await seleccionar.finished
	get_tree().change_scene_to_file("res://Menu_Principal.tscn")
