extends Node2D

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

func _ready():
	reset()

func reset():
	$GameState.reset()
	randomize()
	var percent = randf()
	if percent < 0.5:
		move_ai()
	present_board()

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
		$GameState.current_player = 0
		return
	if $GameState.is_win():
		print("THE WINNER IS " + str(player))
		$GameState.current_player = 0
		return
	var board_representation: PoolStringArray = []
	board_representation.append(str(player))
	for i in range(3):
		for j in range(3):
			board_representation.append(str($GameState.board[i][j]))
	var output = []
	OS.execute('engine/engine', board_representation, true, output)
	var result = output[0].split(' ')
	print("ENGINE RESPONSE")
	print(result)
	var x = int(result[1])
	var y = int(result[2])
	$GameState.board[x][y] = player
	$GameState.current_player = -player
	present_board()
	if $GameState.is_win():
		print("THE WINNER IS " + str(player))
		$GameState.current_player = 0
	if $GameState.is_draw():
		print("THE GAME IS DRAW")
		$GameState.current_player = 0

func present_board():
	for i in range(3):
		for j in range(3):
			buttons[i][j].texture_normal = TEXTURES[$GameState.board[i][j]]

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
