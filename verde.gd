extends Area2D
func _ready() -> void:
	$AnimatedSprite2D.play("move")
	
func _on_body_entered(body):
	if body.has_method("aplicar_veneno"):
		body.aplicar_veneno(10.0) # Le manda el tiempo de duración
		queue_free()
