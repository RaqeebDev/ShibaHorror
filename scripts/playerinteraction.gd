extends RayCast3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if is_colliding():
		var hit = get_collider()
		if hit and hit.name == "LightSwitch":
			if Input.is_action_just_pressed("interact"):
				var light_setup = get_tree().get_first_node_in_group("light_group")
				if light_setup:
					light_setup.toggle_light()
