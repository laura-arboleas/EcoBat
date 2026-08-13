extends Camera2D

var altura_fija = 9
var seguir_jugador = true

func _ready():
	top_level = true
	global_position.y = altura_fija

func _process(_delta):
	if seguir_jugador:
		global_position.x = get_parent().global_position.x
