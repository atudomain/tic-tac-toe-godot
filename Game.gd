extends Node2D

signal mouse_button_left_released

onready var buttons = [
	[$GridContainer/FieldButton1, $GridContainer/FieldButton2, $GridContainer/FieldButton3],
	[$GridContainer/FieldButton4, $GridContainer/FieldButton5, $GridContainer/FieldButton6],
	[$GridContainer/FieldButton7, $GridContainer/FieldButton8, $GridContainer/FieldButton9],
]

onready var TEXTURES = {
	-1: preload("res://assets/13RedCross.png"),
	0: null,
	1: preload("res://assets/13GreenCircle.png")
}
onready var WIN_TEXTURES = {
	-1: preload("res://assets/13RedCrossBackground.png"),
	1: preload("res://assets/13GreenCircleBackground.png")
}

func _input(event):
	if event.is_action_released("mouse_button_left"):
		emit_signal("mouse_button_left_released")
		print("BUTTON_RELEASED")
		if get_node_or_null("CanvasLayer"):
			$CanvasLayer.queue_free()
		if $GameState.current_player == 0:
			reset()

func disable_buttons():
	for button_row in buttons:
		for button in button_row:
			button.disabled = true
	
func enable_buttons():
	for button_row in buttons:
		for button in button_row:
			button.disabled = false

func _ready():
	reset()

func reset():
	$GameState.reset()
	randomize()
	var percent = randf()
	if percent < 0.5:
		move_ai()
	present_board()
	enable_buttons()

func move_player(coordinate_x, coordinate_y):
	if $GameState.board[coordinate_x][coordinate_y] != 0:
		return
	if $GameState.is_win():
		return
	var player = $GameState.current_player
	$GameState.board[coordinate_x][coordinate_y] = player
	$GameState.current_player = -player
	present_board()
	move_ai()

func move_ai():
	print("MOVING AI")
	var player = $GameState.current_player
	if $GameState.is_draw():
		print("THE GAME IS DRAW")
		disable_buttons()
		$GameState.current_player = 0
		return
	if $GameState.is_win():
		print("THE WINNER IS " + str(player))
		disable_buttons()
		$GameState.current_player = 0
		return
	var board_representation: PoolStringArray = []
	board_representation.append(str(player))
	for i in range(3):
		for j in range(3):
			board_representation.append(str($GameState.board[i][j]))
	var output = []
	if $GameState.os == "X11":
		OS.execute('./engine.out', board_representation, true, output)
	elif $GameState.os == "Windows":
		OS.execute('engine.exe', board_representation, true, output)
	else:
		get_tree().quit()
	var result = output[0].split(' ')
	print("ENGINE RESPONSE")
	print(result)
	var x = int(result[1])
	var y = int(result[2])
	$GameState.board[x][y] = player
	$GameState.current_player = -player
	if $GameState.is_win():
		print("THE WINNER IS " + str(player))
		disable_buttons()
		$GameState.current_player = 0
	if $GameState.is_draw():
		print("THE GAME IS DRAW")
		disable_buttons()
		$GameState.current_player = 0
	present_board()

func present_board():
	for i in range(3):
		for j in range(3):
			buttons[i][j].texture_normal = TEXTURES[$GameState.board[i][j]]
	if $GameState.win_coordinates:
		print("PRINTING WIN")
		for coordinates in $GameState.win_coordinates:
			var x = coordinates[0]
			var y = coordinates[1]
			buttons[x][y].texture_normal = WIN_TEXTURES[$GameState.board[x][y]]

func _on_FieldButton1_pressed():
	move_player(0, 0)

func _on_FieldButton2_pressed():
	move_player(0, 1)

func _on_FieldButton3_pressed():
	move_player(0, 2)

func _on_FieldButton4_pressed():
	move_player(1, 0)

func _on_FieldButton5_pressed():
	move_player(1, 1)

func _on_FieldButton6_pressed():
	move_player(1, 2)

func _on_FieldButton7_pressed():
	move_player(2, 0)

func _on_FieldButton8_pressed():
	move_player(2, 1)

func _on_FieldButton9_pressed():
	move_player(2, 2)
