extends Area2D

func _on_body_entered(body):
	body.checkpoint_position = global_position
	body.colgarse_de_rama()
