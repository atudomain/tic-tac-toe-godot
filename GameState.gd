extends Node


onready var current_player = -1

onready var board = [[0, 0, 0], [0, 0, 0], [0, 0, 0]]

func is_win():
	var sums = []
	for i in range(3):
		sums.append(sum(board[i]))
	for i in range(3):
		var current_sum = 0
		for j in range(3):
			current_sum += board[j][i]
		sums.append(current_sum)
	var current_sum = 0
	for x in [[0,0], [1,1], [2,2]]:
		current_sum += board[x[0]][x[1]]
	sums.append(current_sum)
	current_sum = 0
	for x in [[0,2], [1,1], [2,0]]:
		current_sum += board[x[0]][x[1]]
	sums.append(current_sum)
	for x in sums:
		if x == -3 or x == 3:
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
	board = [[0, 0, 0], [0, 0, 0], [0, 0, 0]]
