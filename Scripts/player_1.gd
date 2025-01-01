extends CharacterBody3D


const SPEED = 5.0
const MOVE_SPEED = 12.0
const JUMP_VELOCITY = 4.5
@onready var pivot: Node3D = $CamOrigin
@export var sens = 0.2

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var go = Vector3(0,0,0)

func _ready() -> void:
	pass
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
#func _input(event: InputEvent) -> void:
	#if event is InputEventMouseMotion:
		##rotate_y(deg_to_rad(-event.relative.x * sens))
		#rotate(Vector3.UP, deg_to_rad(event.relative.x * sens))
		##rotate(Vector3.RIGHT, deg_to_rad(event.relative.y * sens))
		##pivot.rotate_x(deg_to_rad(-event.relative.y * sens))
		#pivot.rotation.x = clamp(pivot.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _physics_process(delta: float) -> void:
	
	var move_vec = Vector3(0,0,0)
	var input_vector := Input.get_vector("left", "right", "up", "down")
	var direction := Vector3(input_vector.x, 0.0, input_vector.y)
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_just_pressed("escape"):
		get_tree().quit()
		
	if Input.is_action_just_pressed("up"):
		print("up pressed")
		move_vec.z += MOVE_SPEED
		
	if Input.is_action_just_pressed("down"):
		print("down pressed")
		move_vec.z -= MOVE_SPEED

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	#var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
