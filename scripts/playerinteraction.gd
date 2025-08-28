extends RayCast3D


func _physics_process(delta: float) -> void:
	if is_colliding():
		var hit = get_collider()
		if "light_switch" in hit.name:
			if Input.is_action_just_pressed("interact"):
				hit.get_parent().toggle_light()
