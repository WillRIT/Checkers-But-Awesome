extends Node2D
#A bunch of PsuedoCode until stuff is implemented
enum GAMESTATE{
	LEVELSELECT,
	GAME,
	WIN,
	LOSE
}
var levels = [
"#OO
OXO
OOO",
"  #OO
  OXO
OOOOO
OXOXO
OOOOO",
"#XOXO
OOOOX
OXOXO",
"OOOOO
OXOXO
OOOOO
XOOOX
OX#XO",
"OOOXOOO
OXOOOXO
OOOO#OO
XOOXOXO
OXOOOOO",
"OOOXOOO
OXOOXOO
OXOOOOO
OOX XXO
OO# OOO",
"OXOOOOOXO
OOOXOXOXO
..OOOOO..
OXOXOOOXO
OX#OOXOXO",
"OO#XO
XXOXO
OXOXO",
"OOOOOXOXO
OXXXOXOXO
OOOO#OOOO
XXOXX    
OOOOO    ",
"     OOOO
     OXXO
OX#XOOOOO
OXOXOXOXO
OOOXOXOOO"
]
@export var level : int
@export var state : GAMESTATE
@export var start_scene: PackedScene

var board : Node
var pieces : Array
var player : Node
var boardoffset : int
func _ready() -> void:
	
	board = find_child("Board");

func _process(_delta: float) -> void:
	match state:
		GAMESTATE.GAME:
			if(board.numOfPieces <= 0):
				state_change(GAMESTATE.WIN)
			##if(player cant move)
				##state_change(GAMESTATE.LOSE)
			""""""
			
			
func state_change(newstate: GAMESTATE) -> void:
	match newstate:
		GAMESTATE.GAME:
			board.loadable = levels[level-1]
			board.load_string()
			if(board.width < 9):
				board.position.x = 380.0
				board.find_child("Reset").position.x = 0
				board.position.x += (9 - board.width)/2 * 50
				board.find_child("Reset").position.x -= (9 - board.width)/2 * 50
			else:
				board.position.x = 380.0
				board.find_child("Reset").position.x = 0
			board.show()
			find_child("Level Selection").hide();
			find_child("Next Level").hide();
			#pieces gets filled
			state = newstate
		GAMESTATE.LEVELSELECT:
			board.hide()
			find_child("Next Level").hide();
			find_child("Level Selection").show();
			board.load_string()
			state = newstate
		GAMESTATE.WIN:
			board.hide()
			find_child("Next Level").show();
			if(level == 10):
				find_child("Next Level").find_child("Button").hide()
			else:
				find_child("Next Level").find_child("Button").show()
			
			state = newstate
		GAMESTATE.LOSE:
			#Lose Screen is shown
			state = newstate
func change_scene(scene: PackedScene):
	if scene:
		get_tree().change_scene_to_packed(scene)
	else:
		push_error("Scene is not assigned!")

func _on_button_pressed(selected : int) -> void:
	level = selected;
	state_change(GAMESTATE.GAME)
func _next_level() -> void:
	if(level != levels.size()):
		level += 1
		board.loadable = levels[level-1]
		state_change(GAMESTATE.GAME)
func _reset_level()->void:
	board.load_string()
func _back_to_select() -> void:
	state_change(GAMESTATE.LEVELSELECT)
