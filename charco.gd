extends Area2D

func _on_area_entered(area: Area2D) -> void:
	# Verificamos si el área que entró es una gota (sabiendo que tiene la función impactar)
	if area.has_method("impactar"):
		area.impactar()
		$AnimatedSprite2D.play("move")
		await $AnimatedSprite2D.animation_finished
		$AnimatedSprite2D.play("quieto")
