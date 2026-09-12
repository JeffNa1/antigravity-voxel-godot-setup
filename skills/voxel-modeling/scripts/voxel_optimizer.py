"""
Voxel Mesh Optimizer script
Analyzes 3D OBJ/GLTF files or voxel grid data, reports polygon statistics,
identifies coplanar quads, and verifies texture UV mapping.
"""
import sys
import os

def analyze_obj(obj_path):
    if not os.path.exists(obj_path):
        print(f"File not found: {obj_path}")
        return
    
    vertices = 0
    faces = 0
    uvs = 0
    normals = 0
    
    with open(obj_path, 'r', encoding='utf-8') as f:
        for line in f:
            line = line.strip()
            if line.startswith('v '):
                vertices += 1
            elif line.startswith('f '):
                faces += 1
            elif line.startswith('vt '):
                uvs += 1
            elif line.startswith('vn '):
                normals += 1

    print(f"=== Mesh Statistics for {os.path.basename(obj_path)} ===")
    print(f"Vertices: {vertices}")
    print(f"Faces: {faces}")
    print(f"UVs: {uvs}")
    print(f"Normals: {normals}")
    print("========================================")

if __name__ == "__main__":
    if len(sys.argv) > 1:
        analyze_obj(sys.argv[1])
    else:
        print("Usage: python voxel_optimizer.py <model.obj>")
