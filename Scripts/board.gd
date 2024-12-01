extends Node3D

@onready var floor_button: StaticBody3D = $FloorButton
@onready var card_1: Sprite3D = $Card1

@onready var subviewport_container = $SubViewportContainer 
@onready var subviewport = $SubViewportContainer/SubViewport 
@onready var text_input: LineEdit = $SubViewportContainer/SubViewport/LineEdit

var cards = []
var card_count = 40


# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	setup_text_input() 
	
	# Example to get input from LineEdit and use it to create cards 
	#text_input.connect("text_submitted", self, "_on_text_submitted")
		
func setup_text_input(): 
	subviewport.size = Vector2(70, 35) 
	# Size of the subviewport 
	#subviewport.gui_input = true # Enable GUI input for the SubViewport 
	text_input.text = "40" 
	text_input.size_flags_horizontal = Control.SIZE_EXPAND_FILL 
	#text_input.rect_min_size = subviewport.size 
	# Display the SubViewport content in 3D 
	

#func _input(event: InputEvent) -> void: 
	#if event is InputEventMouseButton or event is InputEventMouseMotion: 
		#var global_position = event.position 
		#var local_position = subviewport_container.get_global_transform.xform_inv(global_position)
		#subviewport.input(local_position)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
				
				
func remove_all_cards(): 
	for card in cards: 
		card.queue_free() # Safely remove the card from the scene tree 
	
	cards.clear() # Clear the array


func create_cards():
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
	


func _on_line_edit_text_submitted(new_text: String) -> void:
		print(new_text)
		if new_text.is_valid_int():
			card_count = new_text.to_int()


func _on_line_edit_text_changed(new_text: String) -> void:
	print(new_text)
	if new_text.is_valid_int():
		card_count = new_text.to_int()
