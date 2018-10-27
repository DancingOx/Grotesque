extends Control

func _ready():
	pass

func play_animation():
	visible = true
	$'Text/AnimationPlayer'.play('New Anim')