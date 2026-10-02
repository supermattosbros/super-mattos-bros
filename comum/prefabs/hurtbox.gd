class_name Hurtbox
extends Area2D

signal damage_received(amount: int, knockback: Vector2)

func take_damage(amount: int, knockback: Vector2 = Vector2.ZERO) -> void:
	damage_received.emit(amount, knockback)
