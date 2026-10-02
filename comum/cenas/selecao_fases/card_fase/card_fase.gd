extends PanelContainer


@onready var preview: TextureRect = $MarginContainer/VBoxContainer/Preview
@onready var nome_fase: Label = $MarginContainer/VBoxContainer/Rodape/NomeFase
@onready var icone_estado: TextureRect = $MarginContainer/VBoxContainer/Rodape/IconeEstado

@export var tex_chave_sombra: Texture2D
@export var tex_chave: Texture2D
@export var tex_checkbox_off: Texture2D
@export var tex_checkbox_on: Texture2D

signal hover

var indice_fase: int
var caminho_cena: String

var estilo_normal: StyleBoxFlat
var posicao_normal: Vector2
var cor_fase: Color


func _ready() -> void:
	estilo_normal = get_theme_stylebox("panel").duplicate()
	call_deferred("guardar_posicao")


func guardar_posicao() -> void:
	posicao_normal = position


# --------------------------------------------------
# CONFIGURAÇÃO DO CARD
# --------------------------------------------------

func configurar(
	nome: String,
	imagem: Texture2D,
	cena: String,
	indice: int,
	cor: Color
) -> void:

	nome_fase.text = nome
	nome_fase.add_theme_color_override("font_color", cor)

	preview.texture = imagem

	caminho_cena = cena
	indice_fase = indice
	cor_fase = cor

	atualizar_icone()


# --------------------------------------------------
# ÍCONE DO CARD
# --------------------------------------------------

func atualizar_icone() -> void:

	var total_chaves = Progresso.get_total_chaves()
	var chave_foi_coletada = Progresso.chave_coletada(indice_fase)
	var fase_foi_concluida = Progresso.fase_concluida(indice_fase)


	# Ainda não conseguiu as 4 chaves
	if total_chaves < Progresso.TOTAL_CHAVES_NECESSARIAS:

		if chave_foi_coletada:
			icone_estado.texture = tex_chave
		else:
			icone_estado.texture = tex_chave_sombra


	# Já conseguiu as 4 chaves
	else:

		# Se pegou a chave dessa fase,
		# continua mostrando a chave.
		if chave_foi_coletada:
			icone_estado.texture = tex_chave

		# Não pegou a chave, mas concluiu a fase.
		elif fase_foi_concluida:
			icone_estado.texture = tex_checkbox_on

		# Não pegou a chave e não concluiu a fase.
		else:
			icone_estado.texture = tex_checkbox_off


# --------------------------------------------------
# HOVER
# --------------------------------------------------

func _on_botao_mouse_entered() -> void:

	var estilo_hover: StyleBoxFlat = estilo_normal.duplicate()

	estilo_hover.border_width_left = 3
	estilo_hover.border_width_top = 3
	estilo_hover.border_width_right = 3
	estilo_hover.border_width_bottom = 3

	estilo_hover.border_color = cor_fase

	estilo_hover.shadow_color = Color(0, 0, 0, 0.35)
	estilo_hover.shadow_size = 4
	estilo_hover.shadow_offset = Vector2(0, 3)

	add_theme_stylebox_override("panel", estilo_hover)

	position = posicao_normal + Vector2(0, -3)

	hover.emit()

func _on_botao_mouse_exited() -> void:

	add_theme_stylebox_override("panel", estilo_normal)

	position = posicao_normal


func _on_botao_pressed() -> void:
	if caminho_cena.is_empty():
		return

	get_tree().change_scene_to_file(caminho_cena)
