extends Node

var score: int


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
	score = 0
	$Player.start($StartPosition.position, 1)
	$Player2.start($StartPosition2.position, 2)
	$StartTimer.start();
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	#$Music.play()


func _on_start_timer_timeout():
	$ScoreTimer.start()


func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)