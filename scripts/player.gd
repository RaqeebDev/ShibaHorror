extends CharacterBody3D

const SPEED = 4.0
const JUMP_VELOCITY = 3.5
@onready var Head = $head
var Sensitivity : float = 0.002
var is_awake := false

@onready var ray = $head/Camera3D/RayCast3D

func _ready() -> void:
	print(ray)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED 
	if ray == null:
		print("RayCast3D not found! Check node path.") # sanity check

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		# Horizontal (yaw) → whole body
		rotate_y(-event.relative.x * Sensitivity)
		
		# Vertical (pitch) → head only
		Head.rotate_x(-event.relative.y * Sensitivity)
		Head.rotation.x = clamp(Head.rotation.x, -PI/2, PI/2)

func _input(event):
	if event.is_action_pressed("interact"):
		print("pressed")
		if ray.is_colliding():
			var collider = ray.get_collider()
			print("colliding")
			if collider != null and collider.is_in_group("switch"):
				collider.toggle_light()

func _fade_out():
	var tween := create_tween()
	tween.tween_property(self, "color:a", 0.0, 2.0)
	tween.tween_callback(func():
		var player = get_tree().get_first_node_in_group("player")
		if player:
			player.is_awake = true
		queue_free()
	)

func _physics_process(delta: float) -> void:
	# Stop movement if not awake
	if not is_awake:
		return  

	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Movement input
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
