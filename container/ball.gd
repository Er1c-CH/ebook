extends RigidBody2D

var hit_count = 0
var max_hits = 3

@onready var sprite: Sprite2D = $Sprite2D
@onready var label: Label = $Label

# IMAGENS DOS ESTADOS
@export var texture_normal: Texture2D
@export var texture_cracked: Texture2D
@export var texture_broken: Texture2D

var texts = [
	"A verdade é incerta.",
	"Não há certezas absolutas.",
	"Suspenda o juízo e encontre paz.",
	"A verdade é incerta."
]

func _ready():
	# Configurar label
	label.visible = false
	_setup_label()
	
	# Definir textura inicial
	if texture_normal:
		_update_texture(texture_normal)
	
	# Conectar o sinal de colisão
	body_entered.connect(_on_body_entered)
	
	# Configurações físicas recomendadas
	contact_monitor = true  # IMPORTANTE: ativa a detecção de colisão
	max_contacts_reported = 4  # Número máximo de contatos reportados

func _setup_label():
	# Posicionar label acima da bola
	var sprite_height = sprite.texture.get_height() if sprite.texture else 64
	label.position = Vector2(0, -sprite_height / 2 - 20)  # 20 pixels acima
	
	# Configurar cor do texto
	label.add_theme_color_override("font_color", Color(0, 0, 0))
	
	# Centralizar o texto
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	
	# Opcional: adicionar contorno/sombra para melhor legibilidade
	label.add_theme_color_override("font_outline_color", Color(0, 0, 0))
	label.add_theme_constant_override("outline_size", 2)

func _on_body_entered(body: Node) -> void:
	print("COLISAO ATIVADA com: ", body.name)
	
	# Tremer ao colidir
	_shake()
	
	# Se colidiu com outra bola
	if body is RigidBody2D:
		hit_count += 1
		print("Bateu:", hit_count)
		
		if hit_count == 1:
			if texture_cracked:
				_update_texture(texture_cracked)
		elif hit_count == 2:
			if texture_broken:
				_update_texture(texture_broken)
			_show_random_text()
		elif hit_count >= max_hits:
			hit_count = max_hits  # Trava no último estado

func _update_texture(new_texture: Texture2D):
	sprite.texture = new_texture
	# Resetar região e centralização
	sprite.region_enabled = false
	sprite.centered = true
	# Opcional: manter escala consistente
	# sprite.scale = Vector2.ONE

func _shake():
	var original_pos = position
	for i in range(3):
		position = original_pos + Vector2(randf_range(-4, 4), randf_range(-4, 4))
		await get_tree().create_timer(0.02).timeout
	position = original_pos

func _show_random_text():
	var msg = texts[randi() % texts.size()]
	label.text = msg
	label.visible = true
	
	# Opcional: esconder o texto após alguns segundos
	await get_tree().create_timer(3.0).timeout
	label.visible = false

func _process(_delta):
	# Manter a label sempre horizontal (sem rotação)
	if label.visible:
		label.rotation = -rotation  # Compensa a rotação da bola
		
func _physics_process(_delta: float) -> void:
	var accel_values = Input.get_accelerometer()
	var dir = sign(accel_values.x)
	'''if Input.is_action_pressed("ui_left"):
		apply_central_impulse(Vector2(-20, 0))
	if Input.is_action_pressed("ui_right"):
		apply_central_impulse(Vector2(20, 0))'''
	apply_central_impulse(Vector2(dir*20, 0))
