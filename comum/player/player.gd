extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -400.0

@onready var anim: AnimatedSprite2D = $anim
@onready var hitbox: Hitbox = $hitbox
@onready var hurtbox: Hurtbox = $hurtbox
@onready var ponto_tiro: Marker2D = $ponto_tiro

var projetil_scene = preload("res://comum/player/projetil.tscn")

var knockback_vector = Vector2.ZERO


func _ready() -> void:
	hurtbox.damage_received.connect(_on_damage_received)
	hitbox.hit_registered.connect(_on_feet_hitbox_hit)
	$RemoteTransform2D.remote_path = NodePath("../../camera")
	
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle inputs
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if Input.is_action_just_released("ui_accept") and velocity.y < 0:
		velocity.y = velocity.y/5
	if Input.is_action_just_pressed("atirar"):
		if Globals.cherries > 0:
			atirar()
			Globals.cherries -=1


	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if knockback_vector != Vector2.ZERO:
		velocity = knockback_vector
	update_state(direction)
	move_and_slide()

func update_state(direction) -> void:
	var state = 'idle'
	if direction:
		state = "run"
	if !is_on_floor():
		if velocity.y < 0:
			state = "jump"
		else:
			state = "fall"
	if knockback_vector != Vector2.ZERO:
		state = "hurt"
			
	if direction==1:
		anim.flip_h = false
	if direction==-1:
		anim.flip_h = true
		
	anim.play(state)
	
func atirar() -> void:
	var projetil = projetil_scene.instantiate()

	if anim.flip_h:
		projetil.direcao = -1
	else:
		projetil.direcao = 1

	projetil.global_position = ponto_tiro.global_position
	get_tree().current_scene.add_child(projetil)
	
func _on_damage_received(amount:int, knockback: Vector2) -> void:
	knockback_vector = knockback
	if Globals.player_life <=1:
		get_tree().call_deferred("change_scene_to_file","res://comum/cenas/selecao_fases/selecao_fases.tscn")
	else:
		Globals.player_life -= amount
	if knockback != Vector2.ZERO:
		velocity = knockback
	
func _on_feet_hitbox_hit(_hurtbox: Hurtbox) -> void:
	if velocity.y > 0:
		velocity.y = JUMP_VELOCITY


func _on_anim_animation_finished() -> void:
	if anim.animation == "hurt":
		knockback_vector = Vector2.ZERO
	if anim.animation == "die":
		get_tree().call_deferred("change_scene_to_file","res://comum/cenas/selecao_fases/selecao_fases.tscn")
		

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	get_tree().call_deferred("change_scene_to_file","res://comum/cenas/selecao_fases/selecao_fases.tscn")
