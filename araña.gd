extends Area2D

# --- VARIABLES PARA LA LUZ ---
@onready var luz = $PointLight2D 
@export var velocidad_pulso: float = 3.0 
@export var energia_maxima_luz: float = 1.5 

var tiempo: float = 0.0
var posicion_inicial: Vector2

var luz_encendida: bool = false 

func _ready() -> void:
	$AnimatedSprite2D.play("move")
	posicion_inicial = global_position
	luz.enabled = false 

func _process(delta: float):
	if luz_encendida:
		tiempo += delta
		var intensidad_suave = (sin(tiempo * velocidad_pulso) + 1.0) / 2.0
		luz.energy = intensidad_suave * energia_maxima_luz

func prender_luz() -> void:
		luz_encendida = true
		luz.enabled = true

func _on_body_entered(body):
	if body.has_method("modificar_vida"):
		body.modificar_vida(-30.0)
		queue_free()
