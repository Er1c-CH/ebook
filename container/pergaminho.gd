extends Sprite2D

# Imagem alternada vem por parâmetro no Inspector
@export var alternate_texture : Texture2D

var original_texture : Texture2D
var last_tap_time := 0.0
var double_tap_threshold := 0.25  # segundos

func _ready():
	# Define a textura inicial fixa
	original_texture = load("res://assets/pergaminhofechado.png")
	texture = original_texture


func _input(event):
	# Duplo toque para alternar imagem
	if event is InputEventScreenTouch and event.pressed:
		var now = Time.get_ticks_msec() / 1000.0
		if now - last_tap_time < double_tap_threshold:
			_toggle_image()
		last_tap_time = now

	# Arrastar
	if event is InputEventScreenDrag:
		global_position += event.relative

	# Zoom (pinça)
	if event is InputEventMagnifyGesture:
		scale *= event.factor

	# Rotação (dois dedos deslizando)
	if event is InputEventPanGesture:
		rotation += deg_to_rad(event.delta.x) * 0.1


func _toggle_image():
	if texture == original_texture:
		if alternate_texture:
			texture = alternate_texture
	else:
		texture = original_texture
