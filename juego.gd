extends Node2D

@onready var jugador: CharacterBody2D = $Jugador
@onready var musica = $AudioStreamPlayer
	
func _ready() -> void:
	musica.play()
