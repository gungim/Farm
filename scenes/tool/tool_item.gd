extends Node2D
class_name ToolItem

@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var animated: AnimatedSprite2D = $AnimatedSprite2D

@export var used: bool = false


func _ready():
	animated.visible = false


func use():
	used = true


func unuse():
	used = false


func action():
	pass
