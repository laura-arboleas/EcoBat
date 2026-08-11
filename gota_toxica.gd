extends Area2D

@export var velocidad_caida: float = 250.0
@export var dano: float = 20.0

func _ready() -> void:
	$AnimatedSprite2D.visible = true
	$PointLight2D.enabled = false


func _process(delta: float) -> void:
	# Hacemos que caiga constantemente hacia abajo (eje Y)
	position.y += velocidad_caida * delta

	
func _on_body_entered(body: Node2D) -> void:
	if body.has_method("modificar_vida"):
		body.modificar_vida(-dano)
	impactar()
	
func impactar() -> void:
	velocidad_caida = 0 
	$CollisionShape2D.set_deferred("disabled", true)
	$AnimatedSprite2D.visible = false
	$PointLight2D.enabled = true
	$AudioStreamPlayer2D.play()
	await $AudioStreamPlayer2D.finished
	$PointLight2D.enabled = false
	queue_free()
	
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
