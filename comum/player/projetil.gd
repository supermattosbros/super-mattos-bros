extends Area2D

@export var velocidade: float = 400.0

@onready var hitbox: Hitbox = $hitbox


var direcao: float = 1.0
	
func _ready() -> void:
	hitbox.hit_registered.connect(_on_hit_registered)

func _physics_process(delta: float) -> void:
	position.x += velocidade * direcao * delta

func _on_hit_registered(hurtbox: Hurtbox) -> void:
	if hurtbox.get_parent().is_in_group("inimigos"):
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
