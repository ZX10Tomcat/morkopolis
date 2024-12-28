extends Node3D

@onready var floor_button: StaticBody3D = $FloorButton
@onready var card_1: Sprite3D = $Card1

@onready var dice: RigidBody3D = $Dice
@onready var dice_2: RigidBody3D = $Dice2
@onready var player_1: CharacterBody3D = $Player1

@onready var subviewport_container = $SubViewportContainer 
@onready var subviewport = $SubViewportContainer/SubViewport 
@onready var text_input: LineEdit = $SubViewportContainer/SubViewport/LineEdit
@onready var score_label: Label3D = $Score/ScoreLabel

var cards = []
var card_count = 40

var result: int = 0
var current_card: int = 0 
var dice_1_finished: bool = false 
var dice_2_finished: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	setup_text_input() 
	var global_node = get_tree().root.get_meta("global") 
	if global_node: 
		card_count = global_node.num_cards 
		#player_count = global_node.num_players 
		print("Number of Cards: ", card_count) 
		#print("Number of Players: ", player_count) 
		create_cards()
	
		
func setup_text_input(): 
	subviewport.size = Vector2(70, 35) 
	
	text_input.text = "40" 
	text_input.size_flags_horizontal = Control.SIZE_EXPAND_FILL 
	#text_input.rect_min_size = subviewport.size 
	# Display the SubViewport content in 3D 
	

#func _input(event: InputEvent) -> void: 
	#if event is InputEventMouseButton or event is InputEventMouseMotion: 
		#var global_position = event.position 
		#var local_position = subviewport_container.get_global_transform.xform_inv(global_position)
		#subviewport.input(local_position)

func _input(event: InputEvent) -> void: 
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT): 
		result = 0
		score_label.text = str(result)
		dice.roll_dice()
		dice_2.roll_dice()
		
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
				
				
				
func remove_all_cards(): 
	for card in cards: 
		card.queue_free() # Safely remove the card from the scene tree 
	
	cards.clear() # Clear the array


func create_cards():
	print("create cards")
	var center = Vector3(0, 1, 0) # Center of the circle, adjusted to (0, 1, 0) for the Y position 
	var radius = 25.0 
	var num_cards = card_count 
	var angle_step = 2 * PI / num_cards
	
	for i in range(num_cards): 
		var angle = i * angle_step 
		var x = center.x + radius * cos(angle) 
		var z = center.z + radius * sin(angle)
		
		var new_card = card_1.duplicate()
		
		new_card.position = Vector3(x, center.y, z)
		var direction = center - new_card.position 
		var rotation_angle = atan2(direction.x, direction.z) 
		new_card.rotation.y = rotation_angle + PI
		new_card.visible = true
		
		self.add_child(new_card)
		cards.append(new_card)

	# Place player_1 in the center of the first card 
	if num_cards > 0 and cards.size() > 0: 
		var first_card = cards[0] 
		player_1.position = first_card.position # Place Player1 at the center of the first card	


func _on_line_edit_text_submitted(new_text: String) -> void:
		print(new_text)
		if new_text.is_valid_int():			
			card_count = new_text.to_int()
			print(card_count)


func _on_line_edit_text_changed(new_text: String) -> void:
	print(new_text)
	if new_text.is_valid_int():
		card_count = new_text.to_int()
		print(card_count)

func _on_dice_roll_finished(number: Variant) -> void:	
	result = result + number	
	score_label.text = str(result)
	dice_1_finished = true
	check_move_player()
	
func _on_dice_2_roll_finished(number: Variant) -> void:	
	result = result + number	
	score_label.text = str(result)
	dice_2_finished = true
	check_move_player()
	
func check_move_player(): 
	print("enter check move player")
	if dice_1_finished and dice_2_finished: 
		move_player_to_new_card()
		
func move_player_to_new_card(): 
	current_card = (current_card + result) % card_count # Use modulo to cycle back if exceeding total cards 
	var target_card = cards[current_card] 
	player_1.position = target_card.position 
	result = 0 # Reset the result after moving 
	dice_1_finished = false # Reset dice finished flags 
	dice_2_finished = false
