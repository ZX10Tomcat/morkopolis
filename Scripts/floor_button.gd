extends StaticBody3D

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var board: Node3D = $".."


func _ready(): 
	set_process_input(true)

#func _on_area_3d_body_entered(body: Node3D) -> void:
	#print("pressed")
	#anim.play("pressdown")
	#
#
#func _on_area_3d_body_exited(body: Node3D) -> void:
	#print("released")
	#anim.play("pressup")
	
	

#func _input(event: InputEvent) -> void:
	#if event is InputEventMouseButton: 
		#if event.button_index == MOUSE_BUTTON_LEFT:
			#if event.pressed: 
				#print("pressed") 
				#anim.play("pressdown")
				#board.create_cards()
				#
			#else: 
				#print("released")
				#anim.play("pressup")


func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton: 
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed: 
				print("pressed") 
				anim.play("pressdown")
				board.remove_all_cards()
				board.create_cards()
				
			else: 
				print("released")
				anim.play("pressup")
