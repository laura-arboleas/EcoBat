extends Node2D

@onready var jugador: CharacterBody2D = $Jugador
@onready var musica = $Musica_Fondo
	
func _ready() -> void:
	musica.play()
