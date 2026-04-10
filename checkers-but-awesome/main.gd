extends Node2D
#A bunch of PsuedoCode until stuff is implemented
enum GAMESTATE{
	LEVELSELECT,
	GAME,
	WIN,
	LOSE
}
var levels = [ "OOOOO
OXOXO
OOOOO
XOOOX
OX#XO",
"OOOXOOO
OXOOXOO
OXOOOOO
OOX XXO
OO# OOO",
"  OOO  
  OXX  
OXO OO#
OX   XX
OOO OOO
  OXO  
  OXO  ",
"OXOOOOOXO
OOOXOXOXO
  OOOOO  
OXOXOOOXO
OX#OOXOXO",
"  OOO
  OXX
OX#XO
XXO  
OOO  "
]
@export var level : int
@export var state : GAMESTATE
var board : Node
var pieces : Array
var player : Node
func _ready() -> void:
	board = find_child("Board");

func _process(delta: float) -> void:
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
			board.show()
			find_child("Level Selection").hide();
			find_child("Next Level").hide();
			#pieces gets filled
			state = newstate
		GAMESTATE.LEVELSELECT:
			board.hide()
			find_child("Level Selection").show();
			board.load_string()
			state = newstate
		GAMESTATE.WIN:
			board.hide()
			find_child("Next Level").show();
			state = newstate
		GAMESTATE.LOSE:
			#Lose Screen is shown
			state = newstate


func _on_button_pressed() -> void:
	level = 1;
	state_change(GAMESTATE.GAME)
func _next_level() -> void:
	if(level != levels.size()):
		level += 1
		board.loadable = levels[level-1]
		state_change(GAMESTATE.GAME)
func _reset_level()->void:
	board.load_string()
