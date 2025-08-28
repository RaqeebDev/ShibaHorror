extends RigidBody3D

var is_held = false
var player = null
var hold_offset = Vector3(0, 0, -2) # in front of camera

func _physics_process(delta):
	if is_held and player:
		var cam = player.get_node("head/Camera3D")
		global_transform.origin = cam.global_transform.origin + cam.global_transform.basis.z * hold_offset.z
		linear_velocity = Vector3.ZERO
		angular_velocity = Vector3.ZERO

func pick_up(p):
	is_held = true
	player = p
	mode = RigidBody3D.MODE_KINEMATIC

func throw(force = 10):
	if is_held:
		is_held = false
		mode = RigidBody3D.MODE_RIGID
		var cam = player.get_node("head/Camera3D")
		linear_velocity = -cam.global_transform.basis.z * force
		player = null
