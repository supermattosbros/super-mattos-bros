class_name Hitbox
extends Area2D

signal hit_registered(hurtbox: Hurtbox)
@export var damage: int = 1
@export var knockback_force: float = 200.0
@export var knockback_upward: float = -200.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	if area is Hurtbox:
		if area.get_parent() == get_parent():
			return
		
		var direction: float = sign(area.global_position.x-global_position.x)
		
		if direction == 0:
			direction = 1.0
		
		var final_knockback: Vector2 = Vector2(direction*knockback_force, knockback_upward)
		area.take_damage(damage, final_knockback)
		hit_registered.emit(area)
