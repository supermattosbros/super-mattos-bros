extends CanvasLayer

@onready var cherries_counter: Label = $control/container/VBoxContainer/cherries_container/cherries_counter
@onready var gems_counter: Label = $control/container/VBoxContainer/gems_container/gems_counter


@onready var life_container: HBoxContainer = $control/container/VBoxContainer/life_container
@onready var heart_hud = preload("res://comum/ui/hud/hearts/heart_hud.tscn")
@onready var nome_fase_label: Label = $control/container/nome_fase_label

@export var nome_fase: String = "NOME DA FASE"

func _ready():
	nome_fase_label.text = nome_fase
	set_max_hearts(Globals.max_life)
	update_hearts(Globals.player_life)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	cherries_counter.text = str("%02d" % Globals.cherries)
	gems_counter.text = str("%02d" % Globals.gems)
	#score_counter.text = str("%06d" % Globals.score)
	update_hearts(Globals.player_life)
	

func set_max_hearts(max_life: int):
	max_life = int(max_life/4.0)
	for i in range(max_life):
		var heart = heart_hud.instantiate()
		life_container.add_child(heart)

func update_hearts(player_life):
	var hearts = life_container.get_children()
	var full_hearts = int(Globals.player_life/4.0)
	
	for i in range(full_hearts):
		hearts[i].update(4)
	
	if full_hearts == hearts.size():
		return
		
	var remainder = Globals.player_life % 4
	hearts[full_hearts].update(remainder)
	
	for i in range(full_hearts + 1, hearts.size()):
		hearts[i].update(0)
