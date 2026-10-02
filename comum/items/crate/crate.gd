extends StaticBody2D

const CRATE_PIECE = preload("res://comum/items/crate/crate_piece.tscn")
const GEM = preload("res://comum/items/gem/gem.tscn")

@onready var head_detector: Area2D = $head_detector
@onready var spawn_point: Marker2D = $spawn_point

@export var pieces: Array[Texture2D]
@export var hitpoints: int = 3

var impulse: float = 200.0

func break_crate():
	
	for piece in pieces.size():
		var piece_instance = CRATE_PIECE.instantiate() as RigidBody2D
		add_sibling(piece_instance)
		piece_instance.get_node("texture").texture = pieces[piece]
		piece_instance.global_position = spawn_point.global_position
		piece_instance.apply_impulse(Vector2(randf_range(-impulse*0.5,impulse*0.5),randf_range(impulse*1.5,impulse*2.5)))
	queue_free()

func drop_gem():
	var gem_instance = GEM.instantiate() as RigidBody2D
	call_deferred("add_sibling",gem_instance)
	gem_instance.global_position = global_position
	gem_instance.apply_impulse(Vector2(randf_range(-50,50),-300))
	

func _on_head_detector_body_entered(body: Node2D) -> void:
	if body.name == "player":
		if hitpoints <= 1:
			break_crate()
		else:
			hitpoints -= 1
			drop_gem()
			hit_flash()

func hit_flash():
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	
	tween.parallel().tween_property(self, "scale",Vector2(1.3,0.5), 0.2)
	tween.parallel().tween_property(self, "modulate",Color.WHITE*5.0, 0.1)
	tween.chain().set_trans(Tween.TRANS_SPRING)
	tween.tween_property(self, "scale",Vector2.ONE, 0.05)
	tween.tween_property(self, "modulate",Color.WHITE, 0.1)
