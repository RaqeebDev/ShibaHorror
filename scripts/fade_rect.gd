extends ColorRect

@onready var wake_label := $"../WakeLabel"
@onready var crosshair := $"../Crosshair"
@onready var player := get_tree().get_first_node_in_group("player")

var asleep := true

func _ready():
	color = Color(0, 0, 0, 1)	# start fully black
	wake_label.visible = true
	crosshair.visible = false   # hide dot until awake
	if player:
		player.is_awake = false

func _process(delta):
	if asleep and Input.is_action_just_pressed("interact"):  # E key
		asleep = false
		wake_label.visible = false   # hide wake up text
		_fade_out()

func _fade_out():
	var tween := create_tween()
	tween.tween_property(self, "color:a", 0.0, 2.0)
	tween.tween_callback(func():
		if player:
			player.is_awake = true   # unlock movement
		crosshair.visible = true     # show dot now
		queue_free()
	)
