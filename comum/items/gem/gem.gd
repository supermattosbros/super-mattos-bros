extends RigidBody2D

@onready var anim: AnimatedSprite2D = $anim

func _on_player_detector_body_entered(body: Node2D) -> void:
	if body.name == "player":
		Globals.gems += 1
		anim.play("collect")

func _on_anim_animation_finished() -> void:
	queue_free()
