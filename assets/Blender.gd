extends Node3D

@export var speed : Vector3 = Vector3(0,50,0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation_degrees += speed * delta
