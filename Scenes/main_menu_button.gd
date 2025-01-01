extends StaticBody3D

@onready var button: MeshInstance3D = $Button
@onready var label_3d: Label3D = $Label3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label_3d.text = "Main menu"
	var material = StandardMaterial3D.new()
	material.albedo_color = Color(0.8, 0.8, 0.8)
	button.material_override = material

func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton: 
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed: 				
				get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
