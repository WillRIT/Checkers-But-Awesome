class_name Tile extends Sprite2D

#region Textures
const ICON = preload("uid://dgiqw4yimxh3") #placeholder
#endregion

var y: int
var x: int
var size: int

# link references
@export var northwest: Tile = null
@export var north: Tile = null
@export var northeast: Tile = null
@export var west: Tile = null
@export var east: Tile = null
@export var southwest: Tile = null
@export var south: Tile = null
@export var southeast: Tile = null

func _init(_y: int = y, _x: int = x, _size: int = size) -> void:
	y = _y
	x = _x
	size = _size
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	texture = ICON
	
	name = "Tile(" + str(y) + "," + str(x) + ")"
	
	var texture_scale := Vector2(float(size) / texture.get_width(), float(size) / texture.get_height())
	scale = texture_scale
	position = Vector2(x * size, y * size)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
