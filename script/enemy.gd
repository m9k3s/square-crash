extends Area2D

signal enemy_crash
var direction = Vector2()
var speed = 300
var sprite_size
var screen_size = Vector2()
var spwan_location
var can_check_wall
var main_gui_bar_size

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("enemy")
	check_spwan()
	can_check_wall = false
	sprite_size = $Sprite2D.texture.get_size()
	screen_size = get_viewport_rect().size
	main_gui_bar_size = get_parent().get_node("main_gui/bar").size
	print(main_gui_bar_size)
	# connect to area enter and emit siginal
	connect("area_entered",crash)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Vector2()

	direction = direction.normalized()
	velocity = direction * speed * delta
	position += velocity
	
	check_wall()

func check_wall():
	if  position.x <= 0 + sprite_size.x/2 or position.x >= screen_size.x - sprite_size.x/2:
		direction.x = - direction.x
	
	if position.y <= 0 + sprite_size.y/2 + main_gui_bar_size.y or position.y >= screen_size.y - sprite_size.y/2:
		direction.y = - direction.y

func check_spwan():
	if spwan_location == "top":
		direction.x = random_direction()
		direction.y = random_float()
	if spwan_location == "bot":
		direction.x = random_direction()
		direction.y = -random_float()
	if spwan_location == "left":
		direction.x = random_float()
		direction.y = random_direction()
	if spwan_location == "right":
		direction.x = -random_float()
		direction.y = random_direction()
	

func random_direction():
	var d
	var r = RandomNumberGenerator.new()
	var s = r.randi_range(0,1)
	var f = random_float()
	if s == 0:
		d = -f
	else:
		d = f
	
	return d
	
func random_float():
	var f
	var r = RandomNumberGenerator.new()
	f = r.randf()
	return f;

func emit_enemy_crash():
	emit_signal("enemy_crash")

func crash(s):
	if s.name == "player":
		call_deferred("emit_enemy_crash")
		queue_free()
