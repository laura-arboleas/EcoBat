extends Area2D

func _on_body_entered(body):
	if body.has_method('agarrar_power'):
		body.agarrar_power()
		queue_free()
