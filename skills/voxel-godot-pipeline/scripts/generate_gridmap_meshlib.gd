@tool
extends EditorScript
# Utility to create a MeshLibrary for GridMap from a folder of voxel meshes in Godot 4.
func _run() -> void:
    var mesh_lib := MeshLibrary.new()
    print("MeshLibrary generation template initialized. Add mesh instances to populate library.")
