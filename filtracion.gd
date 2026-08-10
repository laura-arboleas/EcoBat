extends Marker2D
@export var escena_gota: PackedScene 

func _on_timer_timeout() -> void:
	# Verificamos que hayamos cargado la escena
	if escena_gota != null:
		# 1. Creamos una copia de la gota
		var nueva_gota = escena_gota.instantiate()
		# 2. La ponemos exactamente en la posición de esta filtración
		nueva_gota.global_position = self.global_position
		
		# 3. La añadimos al nivel principal
		get_tree().current_scene.add_child(nueva_gota)
