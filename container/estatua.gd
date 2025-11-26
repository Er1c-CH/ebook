extends Node

@onready var audio_player = $audio_player
@onready var background = $background
@onready var change_timer = $change_timer

var images := []   # lista das texturas
var current_index := 0

func _ready():
	# Carrega as imagens do loop
	images = [
		load("res://assets/fala1.png"),
		load("res://assets/fala2.png"),
		load("res://assets/fala3.png"),
		load("res://assets/fala4.png"),
		load("res://assets/fala5.png")
	]

	background.texture = images[0]

	change_timer.timeout.connect(_change_background)
	audio_player.finished.connect(_on_audio_finished)


func play_audio(stream: AudioStream):
	audio_player.stream = stream
	audio_player.play()

	current_index = 0
	background.texture = images[current_index]

	change_timer.wait_time = 0.2  # quanto menor, mais rápido
	change_timer.start()


func _change_background():
	current_index = (current_index + 1) % images.size()
	background.texture = images[current_index]


func _on_audio_finished():
	change_timer.stop()
	current_index = 0
	background.texture = images[0]


func _on_buttonpergaminho_pressed() -> void:
	play_audio(load("res://audios/pergaminho.wav"))


func _on_buttoncoruja_pressed() -> void:
	play_audio(load("res://audios/coruja.wav"))


func _on_buttonlampada_pressed() -> void:
	play_audio(load("res://audios/lampada.wav"))


func _on_buttonmoeda_pressed() -> void:
	play_audio(load("res://audios/moeda.wav"))
