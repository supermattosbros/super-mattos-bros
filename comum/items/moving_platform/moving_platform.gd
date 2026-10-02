@tool
extends AnimatableBody2D

@export var speed: float = 80.0
@export var distance: float = 128.0
@export var direction: Vector2 = Vector2.RIGHT
@export var wait_time: float = 0.0
@export var loop: bool = true

var _origin: Vector2
var _destination: Vector2
var _forward := true
var _waiting := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_origin = global_position
	_destination = _origin + direction.normalized() * distance
	queue_redraw()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
		
	if _waiting:
		return
	var target := _destination if _forward else _origin
	
	global_position = global_position.move_toward(target, speed*delta)
	
	if global_position == target:
		if not loop:
			return
		
		if wait_time > 0:
			_wait()
		
		_forward = !_forward

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		queue_redraw()

func _wait() -> void:
	_waiting = true
	await  get_tree().create_timer(wait_time).timeout
	_waiting = false
	
func _draw() -> void:
	if not Engine.is_editor_hint():
		return
	
	var dir := direction.normalized()
	var target := dir*distance
	
	draw_dashed_line(Vector2.ZERO,target, Color(1.0,0.3,0.3,0.8), 2.0, 6.0)
	draw_circle(Vector2.ZERO, 5.0, Color(0.3,0.8,1.0,0.9))
	draw_circle(target, 7.0, Color(1.0,0.3,0.3,0.9))
	
	var cross_size := 10.0
	draw_line(target + Vector2(-cross_size,0),target + Vector2(cross_size,0),Color(1.0,0.3,0.3,0.9),2.0)
	draw_line(target + Vector2(0,-cross_size),target + Vector2(0,cross_size),Color(1.0,0.3,0.3,0.9),2.0)
