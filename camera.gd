extends Camera2D
var altura_fija = 9

func _ready():
	top_level = true
	# Fijamos la altura de la cámara para siempre
	global_position.y = altura_fija

func _process(_delta):

	global_position.x = get_parent().global_position.x
