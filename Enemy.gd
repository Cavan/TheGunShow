extends Actor

enum DIRECTION {LEFT = -1, RIGHT = 1}

var EnemyBullet: Resource = preload("res://src/Projectiles/EnemyBullet.tscn")

export(DIRECTION) var WALKING_DIRECTION = DIRECTION.RIGHT
export var muzzle_velocity = 350

onready var firing_timer = $FiringTimer


var state

onready var wall_left = $Raycasting/WallLeft
onready var wall_right = $Raycasting/WallRight

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state = WALKING_DIRECTION
	firing_timer.connect("timeout", self, "_on_timer_timeout")


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
	
	
	if  wall_right.is_colliding():
		state = DIRECTION.LEFT
		print("Colliding with the right wall")
	
	if  wall_left.is_colliding():
		state = DIRECTION.RIGHT
		print("Colliding with the left wall")
	
	# The character moves horizontally without acceleration, but we constantly
	# apply the gravity to trigger collisions with the floor.
	_velocity.x = state * speed
	_velocity.y += gravity * delta
		
	_velocity = move_and_slide_with_snap(_velocity, 
										 _snap_vector, 
										 UP_DIRECTION, 
										 do_stop_on_slope, 
										 MAX_SLIDES, 
										 MAX_SLOPE_ANGLE, 
										 has_infinite_inertia)
	

func shoot() -> void:
	var b = EnemyBullet.instance()
	b.transform = $Muzzle/MuzzleFirePosition.global_transform
	b.velocity = b.transform.x * muzzle_velocity
	get_parent().add_child(b)

func _on_timer_timeout() -> void:
	print("Timer has elapsed")
	shoot()	

	

func _on_HitBox_area_entered(area: Area2D) -> void:
	print("Damage taken from player missile")


func _on_HitBox_body_entered(body: Node) -> void:
	print("Tank collision detected")
