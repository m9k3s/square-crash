extends Node2D
var screen_size = Vector2()

var player_scene = preload("res://scene/player.tscn")
var goal_scene = preload("res://scene/goal.tscn")
var enemy_scene = preload("res://scene/enemy.tscn")
var win_gui_scene = preload("res://scene/win_gui.tscn")
var lose_gui_scene = preload("res://scene/lose_gui.tscn")

var goal_spwan_gap = Vector2(100,100)

var player_life
var player_goal
var target_goal
var game_state

var main_gui_bar_size

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	main_gui_bar_size = get_node("main_gui/bar").size
	add_player()
	add_goal()
	add_enemy()
	player_life = 3
	player_goal = 0
	target_goal = 26
	game_state = ""
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#if Input.is_key_pressed(KEY_1):
		#get_tree().reload_current_scene()
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()
	change_main_gui()
	check_win_lose()
	
func change_main_gui():
	var life_label = get_node("main_gui/label_life")
	var goal_label = get_node("main_gui/label_goal")
	var target_label = get_node("main_gui/label_target")
	life_label.text = "Life = " + str(player_life)
	goal_label.text = "Goal = " + str(player_goal)
	target_label.text ="Target = " + str(target_goal)

func check_win_lose():
	if player_life < 1 and game_state != "lose":
		$player.queue_free()
		add_lose_gui()
		game_state = "lose"
	if player_goal == target_goal and game_state != "win":
		game_state == "win"
		add_win_gui()
		var enemy = get_tree().get_nodes_in_group("enemy")
		for e in enemy:
			e.speed = 0

func add_win_gui():
	var win = win_gui_scene.instantiate()
	var win_box = win.get_node("box")
	var win_box_size = win_box.size
	win.position.x = screen_size.x/2 - win_box_size.x/2
	win.position.y = screen_size.y/2 - win_box_size.y/2 
	add_child(win)

func add_lose_gui():
	var lose = lose_gui_scene.instantiate()
	var lose_box = lose.get_node("box")
	var lose_box_size = lose_box.size
	lose.position.x = screen_size.x/2 - lose_box_size.x/2
	lose.position.y = screen_size.y/2 - lose_box_size.y/2
	add_child(lose)

func add_player():
	var player = player_scene.instantiate()
	var player_sprite = player.get_node("Sprite2D")
	var player_size = player_sprite.texture.get_size()
	add_child(player)
	
	player.position.x = screen_size.x/2 - player_size.x/2
	player.position.y = screen_size.y/2 + main_gui_bar_size.y - player_size.y/2

func add_goal():
	var goal = goal_scene.instantiate()
	var goal_sprite = goal.get_node("Sprite2D")
	var goal_size = goal_sprite.texture.get_size()
	add_child(goal)
	
	goal.position.x = random_number(goal_size.x/2+goal_spwan_gap.x,screen_size.x-goal_size.x/2-goal_spwan_gap.x)
	goal.position.y = random_number(goal_size.y/2+goal_spwan_gap.y+main_gui_bar_size.y,screen_size.y-goal_size.y/2-goal_spwan_gap.y)
	
	goal.connect("goal_crash",goal_crash)
	#print(goal_size)

func goal_crash():
	add_goal()
	add_enemy()
	player_goal += 1
	

func add_enemy():
	var enemy = enemy_scene.instantiate()
	var spwan_location = random_spawn_location()
	enemy.spwan_location = spwan_location
	
	add_child(enemy)
	
	if spwan_location == "top":
		enemy.position.x = random_number(32/2,screen_size.x-32/2)
		enemy.position.y = 32/2 + main_gui_bar_size.y
	if spwan_location == "bot":
		enemy.position.x = random_number(32/2,screen_size.x-32/2)
		enemy.position.y = screen_size.y - 32/2
	if spwan_location == "left":
		enemy.position.x = 32/2
		enemy.position.y = random_number(32/2+main_gui_bar_size.y,screen_size.y-32/2)
	if spwan_location == "right":
		enemy.position.x = screen_size.x - 32/2
		enemy.position.y = random_number(32/2+main_gui_bar_size.y,screen_size.y-32/2)
	
	enemy.connect("enemy_crash",enemy_crash)

func enemy_crash():
	add_enemy()
	player_life -= 1
	
func random_number(start,end):
	var n
	var r = RandomNumberGenerator.new()
	n = r.randi_range(start,end)
	#print(n)
	return n

func random_spawn_location():
	var l = ["top","bot","left","right"]
	var s
	s = l.pick_random()
	return s
	
