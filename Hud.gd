extends CanvasLayer

signal start_game

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over():
	show_message("Game over")
	await $MessageTimer.timeout

	$Message.text = "Joust!"
	$Message.show()

	await get_tree().create_timer(1.0).timeout
	$StartButton.show()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func update_score(p1_score: int, p2_score: int):
	$P1ScoreLabel.text = str(p1_score)
	$P2ScoreLabel.text = str(p2_score)

func _on_start_button_pressed():
	$StartButton.hide()
	start_game.emit()


func _on_message_timer_timeout():
	$Message.hide()
