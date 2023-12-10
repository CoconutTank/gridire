class_name MapTile
extends Area2D


# Stores the tile display type for this map tile.
# This type should map to a key being used in GlobalCache.TILE_MAPPING.
var tile_display_type : String


# Stores the coordinates of this map tile relative to the map it is on.
# These coordinates should be in units of map tiles.
# Coordinates are different from innate position, which is in units of pixels
# and determines where the map tile should be drawn on screen.
# Coordinates are also always expected to be integers (and not floats).
var coordinates : Vector2


# A "set" of tags.
# To add a tag, add the tag as itself mapped to "null".
var tags = {}


# A "set" of modifiers.
# To add a modifier, add the modifier as itself mapped to "null".
var modifiers = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# Updates tile_display_type for this tile, and also sets this tile to display
# the animation mapped to this tile_display_type.
func set_tile_display_type(display_type : String):
	tile_display_type = display_type
	$MapTileAnims.play(tile_display_type)
