extends KinematicBody2D

class_name Actor

## A direction vector perpendicular to the floor. We pass it to the
## move_and_slide_with_snap() function so Godot knows if the body is on the
## floor, touching a wall, or against the ceiling.
const UP_DIRECTION := Vector2.UP

# We use these constant to calculate a snap vector when we want the character to
# snap to the floor.
#
# We use them below to initialize the `_snap_vector` variable.
const SNAP_DIRECTION := Vector2.DOWN
const SNAP_VECTOR_LENGTH := 32.0
const FLOOR_NORMAL: = Vector2.UP

## This is the maximum number of times Godot will try to move and slide the body
## against a wall or a slope to move it smoothly.
const MAX_SLIDES := 4

## The maximum angle a slope can have before the character starts to slide down,
## in radians.
##
## We use the deg2rad() function and to calculate a maximum slope of 46°,
## allowing the player to walk slopes with a 45° angle.
const MAX_SLOPE_ANGLE := deg2rad(46)

## The character's horizontal movement speed in pixels per second.
##
## When pressing the left and right arrow keys, the character instantly goes at
## this speed, as in games like Megaman.
export var speed:= 250.0
## When the character jumps, we set their upward velocity to this value.
export var jump_strength := 1400.0
## This is the gravity in pixels per second squared, which we will apply every frame.
export var gravity:= 3500.0

## The following 2 properties are arguments of the move_and_slide() function. We
## exported variables to toggle them on and off in different demos.
export var do_stop_on_slope := false
export var has_infinite_inertia := true

## The following pseudo-private variables keep track of the characters velocity,
## the snap vector, and the horizontal input direction, which we change regularly
## in the code.
var _velocity: = Vector2.ZERO
var _snap_vector := SNAP_DIRECTION * SNAP_VECTOR_LENGTH
var _horizontal_direction := 0.0


func _physics_process(delta: float) -> void:
	_velocity.y += gravity * delta
