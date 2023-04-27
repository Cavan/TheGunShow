extends Actor

enum DIRECTION {LEFT = -1, RIGHT = 1}

export(DIRECTION) var WALKING_DIRECTION = DIRECTION.RIGHT

var state

onready var wall_left = $Raycasting/WallLeft
onready var wall_right = $Raycasting/WallRight

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state = WALKING_DIRECTION


func _physics_process(delta: float) -> void:
	apply_base_movement(delta)


func apply_base_movement(delta: float) -> void:
	# Input.get_action_strength() Returns a value between zero and one-based on
	# the players input.
	#
	# For buttons, the value will either be zero or one, but this function
	# supports analog input for joysticks and trigger buttons, giving you a
	# whole range of possible values.
	_horizontal_direction = (
		Input.get_action_strength("enemy_move_right")
			- Input.get_action_strength("enemy_move_left")
	)
	
	
	
	# The character moves horizontally without acceleration, but we constantly
	# apply the gravity to trigger collisions with the floor.
	_velocity.x = _horizontal_direction * speed
	_velocity.y += gravity * delta
	print("Horizontal Velocity: %s" % _velocity.x)
	
	_velocity = move_and_slide_with_snap(_velocity, 
										 _snap_vector, 
										 UP_DIRECTION, 
										 do_stop_on_slope, 
										 MAX_SLIDES, 
										 MAX_SLOPE_ANGLE, 
										 has_infinite_inertia)
	
	

func _on_HitBox_area_entered(area: Area2D) -> void:
	print("Damage taken from player missile")


func _on_HitBox_body_entered(body: Node) -> void:
	print("Tank collision detected")
