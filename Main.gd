extends Node

var p1_score: int
var p2_score: int


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func game_over():
	$ScoreTimer.stop()
	$HUD.show_game_over()
	#$Music.stop()
	$DeathSound.play()
	Rect2(1,2,3, 2)


func new_game():
	$Player1.start($StartPosition.position, 1)
	$Player2.start($StartPosition2.position, 2)
	$StartTimer.start();
	$HUD.update_score(p1_score, p2_score)
	$HUD.show_message("Get Ready")
	#$Music.play()

func _on_start_timer_timeout():
	pass

func player1_hit_player2():
	print_debug("player1_hit_player2")
	p1_score += 1
	on_player_hit(1)

func player2_hit_player1():
	print_debug("player2_hit_player1")
	p2_score += 1
	on_player_hit(2)

func on_player_hit(player_hitting):
	$HUD.update_score(p1_score, p2_score)
	new_game()
