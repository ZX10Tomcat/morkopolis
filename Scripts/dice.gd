extends RigidBody3D

@export var MaxRandomForce = 100

@export var stop_threshold: float = 0.1  # Velocity threshold to consider the dice stopped
@export var stop_time: float = 0.4  # Time in seconds to wait before considering the dice stopped
@export var drag_threshold: float = 0.5 # Velocity below which dice are considered dragging 
@export var drag_time_limit: float = 1.3 # Time limit for dice to drag before re-rolling
@export var position_offset: Vector3 = Vector3(1, 1, 1) # Small offset to apply to the current position

var stop_timer: float = 0.0  # Timer to keep track of how long the dice have been below the threshold
var drag_timer: float = 0.0 # Timer to check for dragging
var is_dragging: bool = false # Flag to track dragging status

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	
	# Check if the dice is dragging 
	#print("state.linear_velocity.length()")	
	#print(state.linear_velocity.length())
	if state.linear_velocity.length() < drag_threshold: 			
		#drag_timer = 0.0 # Reset the timer when dragging starts 
		drag_timer += state.step 
		#print("drag_timer")
		#print(drag_timer)
		if drag_timer > drag_time_limit: # Re-roll the dice if dragging for too long 
			# Calculate a new start position based on current position with a small offset 
			var old_start_pos = start_pos
			start_pos = get_new_start_position()
			roll_dice() 
			start_pos = old_start_pos
			return # Exit to avoid further checks 
	else: 
		#print("reset drag time")
		drag_timer = 0.0
		is_dragging = false # Reset dragging status if not below threshold
			
	# Check if the velocity is below the threshold	
	if state.linear_velocity.length() < stop_threshold:
		#print("integrate forces")
		stop_timer += state.step
		#print(stop_timer)
		# If the dice have been below the threshold for long enough, consider them stopped
		if stop_timer >= stop_time:
			stop_timer = 0.0  # Reset the timer
			dice_stopped()
	else:
		stop_timer = 0.0  # Reset the timer if the velocity is above the threshold

func dice_stopped():
	print("The dice have stopped moving.")
	roll_finished.emit(get_number())


@onready var faces: Node3D = $Faces

var _isMoving = false

var start_pos

signal roll_finished(number)

func _ready() -> void:
	set_notify_transform(true)  # Enable transform notifications
	start_pos = global_position	
	#roll_dice()

func _physics_process(delta: float) -> void:
	_isMoving = linear_velocity.length() > 0.01
	
	
func get_number():
	
	var highest_y
	var number
	
	for node in faces.get_children():
		var y_value = node.global_position.y
		
		if not highest_y || y_value > highest_y:
			highest_y = y_value
			number = node.name
	
	print(str(number))		
	return int(str(number)) 
		
func roll_dice():
	freeze = false
	transform.origin = start_pos
	#if _isMoving: return		
	stop_timer = 0.0 
	drag_timer = 0.0
	is_dragging = false
	
	
	var rng = RandomNumberGenerator.new()
	var randomDirection = [-1,1]
	
	var force = Vector3.ZERO
	
	force.x = randi_range(10, MaxRandomForce) * randomDirection.pick_random()
	force.y = randi_range(10, MaxRandomForce) * randomDirection.pick_random()
	force.z = randi_range(10, MaxRandomForce) * randomDirection.pick_random()
	
	apply_torque(force)
	
func get_new_start_position() -> Vector3: 
	
	var rng = RandomNumberGenerator.new() 
	rng.randomize() 
	# Adjust the current position with a small random offset 
	var new_start_pos = transform.origin 
	new_start_pos += Vector3(rng.randi_range(-position_offset.x, position_offset.x), rng.randi_range(-position_offset.y, position_offset.y), rng.randi_range(-position_offset.z, position_offset.z)) 
	
	return new_start_pos
	
