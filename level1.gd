extends Node3D

var mesh_slicer = MeshSlicer.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	
	#var Transform = $blade.global_transform
	#var MeshInstance = $"banana_car/Banana/pasted__pCube11 group"
	#
	#Transform.origin = $"banana_car/Banana/pasted__pCube11 group".to_local(Transform.origin)
	#Transform.basis.x = $"banana_car/Banana/pasted__pCube11 group".to_local(Transform.basis.x+MeshInstance.global_position)
	#Transform.basis.y = $"banana_car/Banana/pasted__pCube11 group".to_local(Transform.basis.y+MeshInstance.global_position)
	#Transform.basis.z = $"banana_car/Banana/pasted__pCube11 group".to_local(Transform.basis.z+MeshInstance.global_position)
	#
	#var meshes =  mesh_slicer.slice_mesh(Transform,MeshInstance.mesh)
	#
	#MeshInstance.mesh = meshes[0]
	#
	## reassign the mesh to the other meshes
	#$"banana_car/Banana/pasted__pCube11 group2".mesh = meshes[1]
	#
	#var root = get_tree().root
	#
	#$"banana_car/Banana/pasted__pCube11 group2".get_parent().remove_child($"banana_car/Banana/pasted__pCube11 group2")
	#
	#root.add_child($"banana_car/Banana/pasted__pCube11 group2")
	
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
