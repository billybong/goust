extends CharacterBody2D

signal hit

var speed = 400 # How fast the player will move (pixels/sec).
var jump_force = -400 # How high the player can jump.
var gravity = 1000 # Gravity force applied to the player.
var screen_size # Size of the game window.
var jump_next = false
var time_to_next_jump = 0

# Define input actions for this instance
var move_right_action = ""
var move_left_action = ""
var jump_action = ""

var hitbox_original_position = Vector2()
var hitbox_flipped_position = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	screen_size = get_viewport_rect().size
	set_process_input(true) # Ensure the node receives input events.
	
	# Store the original and flipped positions of the hitbox
	hitbox_original_position = $HitBox.position
	hitbox_flipped_position = Vector2(-$HitBox.position.x, $HitBox.position.y)

func start(pos, player_number):
	position = pos
	show()
	$HurtBox.disabled = false

	# Assign input actions based on player number
	if player_number == 1:
		move_right_action = "player1_move_right"
		move_left_action = "player1_move_left"
		jump_action = "player1_jump"
	elif player_number == 2:
		flip_direction(true)
		move_right_action = "player2_move_right"
		move_left_action = "player2_move_left"
		jump_action = "player2_jump"

# This function will be called whenever there is an input event.
func _input(event):
	if event.is_action_pressed(jump_action) && time_to_next_jump <= 0:
		jump_next = true

func flip_direction(flip):
	$AnimatedSprite2D.flip_h = flip
	if flip:
		$HitBox.position = hitbox_flipped_position
	else:
		$HitBox.position = hitbox_original_position

func _physics_process(delta): 
	velocity.y += gravity * delta
	time_to_next_jump -= delta

	if jump_next:
		time_to_next_jump = 0.3
		jump_next = false
		if velocity.y > 0:
			velocity.y = 0
		velocity.y += jump_force
		velocity.y = min(velocity.y, 800) # Corrected to min to prevent exceeding the max.

	if Input.is_action_pressed(move_right_action):
		velocity.x = speed
	elif Input.is_action_pressed(move_left_action):
		velocity.x = -speed

	flip_direction(velocity.x < 0)

	if velocity.length() > 0:
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()

	if is_on_floor():
		$AnimatedSprite2D.animation = "walk"
	elif velocity.x != 0 or velocity.y != 0:
		$AnimatedSprite2D.animation = "up"

	move_and_slide()
	position = position.clamp(Vector2.ZERO, screen_size)

	# Debug: Check hitbox and hurtbox positions
	print_debug_info()

func print_debug_info():
	print("Position: ", position)
	print("Velocity: ", velocity)
	print("HurtBox Position: ", $HurtBox.global_position)
	print("HitBox Position: ", $HitBox.global_position)