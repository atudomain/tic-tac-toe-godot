extends Node


onready var current_player = -1
onready var win_coordinates = []
onready var game_ready = false

onready var os = OS.get_name()

var board = [
	[0, 0, 0], 
	[0, 0, 0], 
	[0, 0, 0]
]

var rows_coordinates = [
	[[0,0],[0,1],[0,2]],
	[[1,0],[1,1],[1,2]],
	[[2,0],[2,1],[2,2]]
]

var columns_coordinates = [
	[[0,0],[1,0],[2,0]],
	[[0,1],[1,1],[2,1]],
	[[0,2],[1,2],[2,2]]
]

var diagonals_coordinates = [
	[[0,0],[1,1],[2,2]],
	[[0,2],[1,1],[2,0]]
]

func get_board_value(coordinates):
	return board[coordinates[0]][coordinates[1]]

func is_win():
	if win_coordinates:
		return true
	for row_coordinates in rows_coordinates:
		var row_sum = sum(
			[
				get_board_value(row_coordinates[0]), 
				get_board_value(row_coordinates[1]), 
				get_board_value(row_coordinates[2])
			]
		)
		if row_sum == 3 or row_sum == -3:
			win_coordinates = row_coordinates
			return true
	for column_coordinates in columns_coordinates:
		var column_sum = sum(
			[
				get_board_value(column_coordinates[0]), 
				get_board_value(column_coordinates[1]), 
				get_board_value(column_coordinates[2])
			]
		)
		if column_sum == 3 or column_sum == -3:
			win_coordinates = column_coordinates
			return true
	for diagonal_coordinates in diagonals_coordinates:
		var diagonal_sum = sum(
			[
				get_board_value(diagonal_coordinates[0]), 
				get_board_value(diagonal_coordinates[1]), 
				get_board_value(diagonal_coordinates[2])
			]
		)
		if diagonal_sum == 3 or diagonal_sum == -3:
			win_coordinates = diagonal_coordinates
			return true
	return false

func is_draw():
	for i in range(3):
		for j in range(3):
			if board[i][j] == 0:
				return false
	return true

func sum(a):
	var result = 0
	for x in a:
		result += x
	return result

func reset():
	current_player = -1
	win_coordinates = []
	board = [[0, 0, 0], [0, 0, 0], [0, 0, 0]]
