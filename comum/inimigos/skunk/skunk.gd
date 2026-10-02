extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $anim
@onready var timer: Timer = $timer
@onready var hitbox: Hitbox = $hitbox
@onready var hurtbox: Hurtbox = $hurtbox


@export_category("Enemy Properties")
@export var speed: float = 50.0
@export var turn_time: float = 1.0
@export var max_health: int = 1

var health
var direction: int = -1
var is_dead: bool = false

func _ready() -> void:
	health = max_health
	hurtbox.damage_received.connect(_on_damage_received)
	#hitbox.hit_registered.connect(_on_feet_hitbox_hit)
	timer.wait_time = turn_time

func _physics_process(_delta: float) -> void:
	if is_dead:
		velocity.x = 0
		move_and_slide()
		return
	
	if not is_on_floor():
		velocity += get_gravity()
	
	velocity.x = speed*direction
	
	if direction > 0:
		anim.flip_h = true
	else:
		anim.flip_h = false
	
	move_and_slide()
	
func _on_timer_timeout() -> void:
	direction *= -1

func die() -> void:
	if is_dead:
		return
	is_dead = true
	velocity = Vector2.ZERO
	anim.play("death")
	
	await get_tree().create_timer(0.5).timeout
	queue_free()
	
func _on_damage_received(amount:int, knockback: Vector2) -> void:
	if is_dead:
		return
		
	health -= amount
	if knockback != Vector2.ZERO:
		velocity = knockback
	
	velocity.y = 0
	
	if health <= 0:
		die()
	else:
		anim.play("hurt")


func _on_anim_animation_finished() -> void:
	if anim.animation == "hurt":
		anim.play("move")
		
