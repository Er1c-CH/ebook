extends Button

@export var pagina_destino: String

func _pressed() -> void:
	if pagina_destino != "":
		get_tree().change_scene_to_file(pagina_destino)
