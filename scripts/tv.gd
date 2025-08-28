# TV.gd
extends Node3D

@onready var interaction_label = $InteractionLabel
@onready var viewport = $SubViewport
@onready var video_player = $SubViewport/VideoStreamPlayer
@onready var tv_screen = $TVScreen  # Your TV screen mesh

var player_in_range = false
var is_playing = false

func _ready():
	# Set up label
	interaction_label.visible = false
	interaction_label.text = "Press E to play"
	interaction_label.billboard = true
	interaction_label.position = Vector3(0, 1.5, 0)
	
	# Set up video player (LOOPING ENABLED!)
	video_player.autoplay = false
	video_player.paused = true
	video_player.loop = true
	
	# Set up SubViewport to not block mouse
	viewport.handle_input_locally = false  # ← THIS FIXES MOUSE BLOCKING!
	
	# Apply video texture to TV screen
	apply_video_texture()
	
	print("TV ready - Mouse won't be blocked!")

func _process(_delta):
	# Show/hide label when player is near
	interaction_label.visible = player_in_range
	
	# Check for E key press
	if player_in_range and Input.is_action_just_pressed("interact"):
		toggle_video()

func _on_detection_area_body_entered(body):
	if body.is_in_group("player"):
		player_in_range = true
		update_label_text()

func _on_detection_area_body_exited(body):
	if body.is_in_group("player"):
		player_in_range = false

func toggle_video():
	if is_playing:
		stop_video()
	else:
		play_video()
	update_label_text()

func play_video():
	if not video_player.stream:
		print("No video file assigned!")
		return
	
	video_player.play()
	video_player.paused = false
	is_playing = true
	print("Video playing on TV screen")

func stop_video():
	video_player.stop()
	is_playing = false
	print("Video stopped")

func update_label_text():
	if player_in_range:
		interaction_label.text = "Press E to stop" if is_playing else "Press E to play"

func apply_video_texture():
	# Create material using SubViewport texture
	var material = StandardMaterial3D.new()
	
	# Create ViewportTexture
	var viewport_texture = ViewportTexture.new()
	viewport_texture.viewport_path = viewport.get_path()
	
	# Apply to material
	material.albedo_texture = viewport_texture
	material.emission_enabled = true
	material.emission_texture = viewport_texture
	material.emission_energy_multiplier = 2.0  # Make it bright!
	
	# Apply material to TV screen
	tv_screen.material_override = material
