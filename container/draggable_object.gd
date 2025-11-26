extends Node2D

@export var object_texture : Texture2D
@export var slide_speed : float = 600.0
@export var corner_distance : float = 80.0

var dragging := false
var sprite : Sprite2D
var particles : CPUParticles2D
var audio_player : AudioStreamPlayer2D
var screen_size : Vector2
var has_collided := false   # evita explosões repetidas


func _ready():
	sprite = $Sprite2D
	particles = $CPUParticles2D
	audio_player = $AudioStreamPlayer2D

	sprite.texture = object_texture
	particles.emitting = false
	screen_size = get_viewport_rect().size


func _input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			if sprite.get_rect().has_point(sprite.to_local(event.position)):
				dragging = true
				particles.emitting = true
				has_collided = false   # pronto para uma nova explosão
		else:
			dragging = false
			particles.emitting = false

	elif dragging and event is InputEventScreenDrag:
		global_position += event.relative


func _process(delta):
	if not dragging:
		_slide_if_near_corner(delta)


func _slide_if_near_corner(delta):
	var near_corner := false

	if global_position.x < corner_distance:
		global_position.x -= slide_speed * delta
		near_corner = true
	elif global_position.x > screen_size.x - corner_distance:
		global_position.x += slide_speed * delta
		near_corner = true

	if global_position.y < corner_distance:
		global_position.y -= slide_speed * delta
		near_corner = true
	elif global_position.y > screen_size.y - corner_distance:
		global_position.y += slide_speed * delta
		near_corner = true

	if near_corner and not has_collided:
		_trigger_collision_effect()
		has_collided = true


func _trigger_collision_effect():
	# Explosão de partículas no impacto
	particles.amount = 250
	particles.lifetime = 0.4
	particles.one_shot = true
	particles.emitting = true

	# Tocar som metálico
	if audio_player.stream and not audio_player.playing:
		audio_player.play()
