extends Node3D

@onready var move_button: StaticBody3D = $FloorButton
@onready var card_1: Sprite3D = $Card1

@onready var dice: RigidBody3D = $Dice
@onready var dice_2: RigidBody3D = $Dice2
@onready var player: CharacterBody3D = $Player
@onready var player_instances: Array = []

@onready var subviewport_container = $SubViewportContainer 
@onready var subviewport = $SubViewportContainer/SubViewport 
@onready var text_input: LineEdit = $SubViewportContainer/SubViewport/LineEdit
@onready var score_label_1: Label3D = $Score/ScoreLabel
@onready var score_label_2: Label3D = $Score2/ScoreLabel

var cards = []
var card_count = 40

var result: int = 0
var current_card: int = 0 
var dice_1_finished: bool = false 
var dice_2_finished: bool = false

var offset_x: Vector3 = Vector3(1.6, 0, 0) 
var offset_z: Vector3 = Vector3(0, 0, 1.8)
var num_players: int = 4
var current_player = 0
var player_current_cards = {} # Dictionary to track current card for each player
var used_colors = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	setup_text_input() 
	var global_node = get_tree().root.get_meta("global") 
	if global_node: 
		print("Number of Cards: ", global_node.num_cards) 		
		card_count = global_node.num_cards 
		num_players = global_node.num_players 
		print("Number of Cards: ", card_count) 		
		create_cards()
		create_players()
		
func create_players():
	randomize() # Initialize the random number generator
	player_instances.append(player)
	player_current_cards[player] = 0
	for i in range(1, num_players): 
		
		var new_player = player.duplicate() 
		if i < 3: 
			new_player.position = player.position + offset_x * i
		else: 		
			new_player.position = player.position + offset_x * (i % 3) + offset_z
		
		# Apply random color to BodyMesh 
		var body_mesh = new_player.get_node("BodyMesh") 
		var random_color = generate_unique_color()
		if body_mesh != null: 
			body_mesh.material_override = body_mesh.material_override.duplicate() 
			body_mesh.material_override.albedo_color = random_color
		
		add_child(new_player)
		player_instances.append(new_player)
		player_current_cards[new_player] = 0
	
func generate_unique_color(): 
	var new_color 
	while true: 
		new_color = Color(randf(), randf(), randf()) 
		if new_color not in used_colors: 
			used_colors.append(new_color) 
			break 
			
	return new_color


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
		
func roll_dices()-> void:
	result = 0		
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
		player.position = first_card.position + Vector3(-1,0,-1)


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
	score_label_1.text = str(number)
	dice_1_finished = true
	check_move_player()
	
func _on_dice_2_roll_finished(number: Variant) -> void:	
	result = result + number	
	score_label_2.text = str(number)
	dice_2_finished = true
	check_move_player()
	
func check_move_player(): 
	print("enter check move player")
	if dice_1_finished and dice_2_finished: 
		move_player_to_new_card(player_instances[current_player]) 
		current_player = (current_player + 1) % player_instances.size() # Move to the next player		
		
func move_player_to_new_card(player): 
	var player_card = player_current_cards[player] # Get the player's current card 
	player_card = (player_card + result) % card_count # Update the player's current card	
	var target_card = cards[player_card] 
	
	# Calculate a small radial offset for each player 
	# Calculate a unique radial offset for each player on the same card 
	var used_offsets = [] 
	var offset_radius = 0.4 # Adjust as needed for spacing 
	var angle = randf() * 2 * PI 
	var offset_x = offset_radius * cos(angle) 
	var offset_z = offset_radius * sin(angle) 
	var offset = Vector3() # Init offset
	for other_player in player_instances: 
		if player_current_cards[other_player] == player_card and other_player != player: 
			used_offsets.append(other_player.position - target_card.position) 			
			offset = Vector3() 
			var max_attempts = 10 
			for attempt in range(max_attempts): 
				angle = randf() * 2 * PI 
				offset_x = offset_radius * cos(angle) 
				offset_z = offset_radius * sin(angle) 
				offset = Vector3(offset_x, 0, offset_z) 
				if offset not in used_offsets: 
					break
	
	current_card = (current_card + result) % card_count # Use modulo to cycle back if exceeding total cards 
	player_current_cards[player] = player_card # Save the updated current card
	player.position = target_card.position + offset
	result = 0 # Reset the result after moving 
	dice_1_finished = false # Reset dice finished flags 
	dice_2_finished = false
