# LightSwitch.gd
extends Node3D

@onready var label_3d = $Label3D
@export var target_light: Node3D

var player_in_range = false

func _ready():
	# Verify nodes exist
	if not label_3d:
		push_error("Label3D node not found! Check scene structure.")
		return
	
	label_3d.visible = false
	print("LightSwitch ready. Target light: ", target_light)

func _process(_delta):
	if player_in_range:
		label_3d.visible = true
		if Input.is_action_just_pressed("interact"):
			toggle_light()
	else:
		label_3d.visible = false

func _on_detection_area_body_entered(body):
	if body.is_in_group("player"):
		player_in_range = true
		print("Player entered switch area")

func _on_detection_area_body_exited(body):
	if body.is_in_group("player"):
		player_in_range = false
		print("Player left switch area")

func toggle_light():
	if target_light and target_light is Light3D:
		target_light.visible = !target_light.visible
		target_light.light_energy = 1.0 if target_light.visible else 0.0
		print("Light toggled. Now: ", "ON" if target_light.visible else "OFF")
	else:
		print("Error: No valid light assigned")
