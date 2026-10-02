extends Area2D

@onready var anim: AnimatedSprite2D = $anim

func _on_body_entered(_body: Node2D) -> void:
	Globals.cherries += 1
	anim.play("collect")


func _on_anim_animation_finished() -> void:
	queue_free()
