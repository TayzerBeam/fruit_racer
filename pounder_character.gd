extends CharacterBody3D

# Script for the CharacterBody3D object doing the pushing
func _physics_process(delta):
	# Lock rotation on X and Z axes to prevent spinning
	var current_rotation = rotation_degrees
	current_rotation.x = 0
	current_rotation.z = 0
	rotation_degrees = current_rotation

