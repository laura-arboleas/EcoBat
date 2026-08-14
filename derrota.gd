extends Control
@onready var seleccionar = $Select
@onready var derrota = $AudioStreamPlayer
func _ready() -> void:
	# Si el juego se está ejecutando en la web (itch.io), ocultamos el botón
	if OS.has_feature("web"):
		$"Boton Salir".visible = false
	derrota.play()
	
func _on_boton_salir_pressed() -> void:
	get_tree().quit()

func _on_boton_reintentar_pressed() -> void:
	seleccionar.play()
	Global.reiniciar_estadisticas(false)
	if Global.ruta_nivel_actual != "":
		get_tree().change_scene_to_file(Global.ruta_nivel_actual)
	else:
		await seleccionar.finished
		get_tree().change_scene_to_file("res://Nivel1.tscn")


func _on_menu_principal_pressed() -> void:
	seleccionar.play()
	await seleccionar.finished
	get_tree().change_scene_to_file("res://Menu_Principal.tscn")
