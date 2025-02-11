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
var flip = false
var player_nr = 0

# TODO
#
# 1. Fix the random pixel noise in one of the sprites
# 2. Adjust Hitbox/Hurtbox size and position and hide them
# 3. Make it less likely both players get a point on a hit
# 4. Better hit sound effect
# 5. Powerup: shooting from your lance



# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	screen_size = get_viewport_rect().size
	set_process_input(true) # Ensure the node receives input events.
	
	# Store the original and flipped positions of the hitbox
	hitbox_original_position = $Weapon/Hitbox.position
	hitbox_flipped_position = Vector2(-$Weapon/Hitbox.position.x, $Weapon/Hitbox.position.y)

func start(pos, player_number):
	position = pos
	show()
	$Hurtbox.disabled = false
	player_nr = player_number

	# Assign input actions based on player number
	if player_number == 1:
		move_right_action = "player1_move_right"
		move_left_action = "player1_move_left"
		jump_action = "player1_jump"
	elif player_number == 2:
		flip = true
		flip_direction()
		move_right_action = "player2_move_right"
		move_left_action = "player2_move_left"
		jump_action = "player2_jump"

# This function will be called whenever there is an input event.
func _input(event):
	if event.is_action_pressed(jump_action) && time_to_next_jump <= 0:
		jump_next = true

func flip_direction():
	$AnimatedSprite2D.flip_h = flip
	if flip:
		$Weapon/Hitbox.position = hitbox_flipped_position
	else:
		$Weapon/Hitbox.position = hitbox_original_position

func _physics_process(delta):
	if($StunTimer.time_left > 0):
		return

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

	if (velocity.x < 0):
		flip = true
	elif (velocity.x == 0):
		flip = flip
	else:
		flip = false

	flip_direction()

	if velocity.length() > 0:
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()

	if is_on_floor():
		$AnimatedSprite2D.animation = "walk"
	elif velocity.x != 0 or velocity.y != 0:
		$AnimatedSprite2D.animation = "up"

	move_and_slide()

	# Debug: Check hitbox and hurtbox positions
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		#print("Player ", player_nr,  " collided with ", collision.get_collider().name)

	screen_wrap()

func screen_wrap():
	position.x = wrapf(position.x, 0, screen_size.x)
	position.y = wrapf(position.y, 0, screen_size.y)

func _on_weapon_area_entered(area):
	if ((area.name == "Player2" && player_nr == 1) || (area.name == "Player1" && player_nr == 2)):
		$DeathSound.play()
		$StunTimer.start()
		await $StunTimer.timeout
		$StunTimer.stop()
		hit.emit()
		print("Player ", player_nr,  " weapon area ", area.name)