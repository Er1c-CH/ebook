extends TextureButton

@export var audio_path: String = ""  # Caminho do áudio a tocar
var icone_play = preload("res://assets/ligarsom.png")
var icone_pause = preload("res://assets/desligarsom.png")

var audio_player: AudioStreamPlayer

func _ready():
	# Cria e adiciona o AudioStreamPlayer dinamicamente
	audio_player = AudioStreamPlayer.new()
	add_child(audio_player)

	# Carrega o áudio definido no Inspector (ou direto no código se preferir)
	if audio_path != "":
		var stream = load(audio_path)
		if stream:
			audio_player.stream = stream
		else:
			push_warning("⚠️ Caminho de áudio inválido: " + audio_path)
	else:
		push_warning("⚠️ Nenhum áudio definido em 'audio_path'")

	# Ícone inicial: som desligado
	texture_normal = icone_play

	# Conecta sinais
	pressed.connect(_on_pressed)
	audio_player.finished.connect(_on_audio_finished)


func _on_pressed():
	if audio_player.playing:
		# Se já está tocando, para o áudio e muda o ícone
		audio_player.stop()
		texture_normal = icone_play
	else:
		# Se não está tocando, toca e muda o ícone
		audio_player.play()
		texture_normal = icone_pause


func _on_audio_finished():
	# Quando o áudio termina naturalmente, volta para o ícone de ligar som
	texture_normal = icone_play


func _exit_tree():
	# Para o áudio ao sair da cena (ex: mudança de página)
	if audio_player:
		audio_player.stop()
	texture_normal = icone_play
