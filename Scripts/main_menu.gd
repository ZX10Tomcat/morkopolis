extends Control

@onready var players_line_edit: LineEdit = $PlayersLineEdit
@onready var cards_line_edit: LineEdit = $CardsLineEdit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_start_game_pressed() -> void:
	print("start game pressed")
	var global_node = load("res://Scripts/Global.gd").new() 
	get_tree().root.add_child(global_node) 
	get_tree().root.set_meta("global", global_node) 
	global_node.num_cards = cards_line_edit.text.to_int() 
	global_node.num_players = players_line_edit.text.to_int() 
	
	get_tree().change_scene_to_file("res://Scenes/board.tscn")


func _on_exit_game_pressed() -> void:
	print("exit game pressed")
	get_tree().quit()


func _on_cards_line_edit_focus_exited() -> void:
	var num_cards = cards_line_edit.text.to_int() 
	if num_cards < 20: 
		num_cards = 20 
	elif num_cards > 40: 
		num_cards = 40 
		
	cards_line_edit.text = str(num_cards)


func _on_players_line_edit_focus_exited() -> void:
	var num_players = players_line_edit.text.to_int()  
	if num_players < 2: 
		num_players = 2 
	elif num_players > 6: 
		num_players = 6 
		
	players_line_edit.text = str(num_players)
