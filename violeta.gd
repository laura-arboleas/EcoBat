extends Area2D

func _on_body_entered(body):
	if body.has_method("modificar_vida"):
		body.modificar_vida(25.0) # Le cura 25 de vida
		queue_free() 
