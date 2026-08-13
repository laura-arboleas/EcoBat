extends Node2D

@onready var light = $PointLight2D
@onready var ring = $Sprite2D
@onready var musica = $AudioStreamPlayer

const INITIAL_SCALE = 0.1
const FINAL_SCALE = 20
const DURATION = 4

const RING_COUNT = 3     
const RING_DELAY = 0.4

func _ready():
	ring.visible = false
	light.scale = Vector2.ONE * INITIAL_SCALE
	
	var tween = create_tween()
	
	tween.parallel().tween_property(light, "scale", Vector2.ONE * FINAL_SCALE, DURATION)
	tween.tween_interval(0.2)
	tween.tween_property(light, "energy", 0.0, 0.5)
	musica.play()
	for i in range(RING_COUNT):
		disparar_aro(i * RING_DELAY)
	
	var tiempo_maximo = (RING_COUNT * RING_DELAY) + DURATION + 0.7 
	await get_tree().create_timer(tiempo_maximo).timeout
	queue_free()
	
func disparar_aro(retraso_inicial: float):
	var nuevo_aro = ring.duplicate()
	
	nuevo_aro.visible = false 
	add_child(nuevo_aro)
	
	nuevo_aro.scale = Vector2.ONE * INITIAL_SCALE
	nuevo_aro.modulate.a = 1.0 
	
	var tween = create_tween()
	
	if retraso_inicial > 0:
		tween.tween_interval(retraso_inicial)
		
	tween.tween_callback(nuevo_aro.show)

	tween.tween_property(nuevo_aro, "scale", Vector2.ONE * FINAL_SCALE, DURATION)
	tween.tween_interval(0.2)
	tween.tween_property(nuevo_aro, "modulate:a", 0.0, 0.5)
	
	await tween.finished
	nuevo_aro.queue_free()
