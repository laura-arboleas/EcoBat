extends Marker2D
@export var escena_gota: PackedScene 

@export var frame_primera_gota: int = 4 # Cámbialo al frame donde cae la 1ra
@export var frame_segunda_gota: int = 8 # Cámbialo al frame donde cae la 2da

func _on_timer_timeout() -> void:
	if escena_gota == null:
		return
	$AnimatedSprite2D.play("move")
	while $AnimatedSprite2D.frame != frame_primera_gota:
		await $AnimatedSprite2D.frame_changed
	soltar_gota(self.global_position) 
	
	while $AnimatedSprite2D.frame != frame_segunda_gota:
		await $AnimatedSprite2D.frame_changed
		
	soltar_gota($gota2.global_position) # Soltamos la segunda
	
	# 3. Esperamos que termine toda la animación
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.play("quieto")

func soltar_gota(posicion_inicial: Vector2) -> void:
	var nueva_gota = escena_gota.instantiate()
	nueva_gota.global_position = posicion_inicial
	get_tree().current_scene.add_child(nueva_gota)
