extends Node3D

@export var light: Node3D
@export var on = false
@export var on_mat: StandardMaterial3D
@export var off_mat: StandardMaterial3D

func _ready() -> void:
	$off.visible = !on
	$on.visible = on
	light.get_node("light").visible = on
	if on:
		light.get_node("mesh").material_override = on_mat
	if !on:
		light.get_node("mesh").material_override = off_mat

func toggle_light():
	on = !on
	$off.visible = !on
	$on.visible = on
	light.get_node("light").visible = on
	if on:
		light.get_node("mesh").material_override = on_mat
	if !on:
		light.get_node("mesh").material_override = off_mat
