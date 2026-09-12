# Greedy Meshing for Voxel Assets

Greedy Meshing is an optimization algorithm that combines adjacent coplanar quads of the same voxel type or color into larger rectangles.

## Why Greedy Meshing is Essential
- **Without Greedy Meshing**: A 16x16x16 solid cube has up to 1,536 visible quads (3,072 triangles).
- **With Greedy Meshing**: The same 16x16x16 solid cube is reduced to exactly 6 quads (12 triangles).
- **Vertex Cache & Fill Rate**: Reduces vertex processing overhead drastically in engines like Godot and Unity.

## Algorithm Overview
1. **Slice Through Axis**: For each axis (X, Y, Z) and for each slice direction (forward/backward face):
2. **Build 2D Mask**: Create a 2D boolean or color mask of visible faces at the current slice.
3. **Find Unvisited Voxel**: Find the first unvisited face in the 2D grid.
4. **Expand Width**: Determine the maximum width of continuous identical faces along axis 1.
5. **Expand Height**: Expand downwards along axis 2 as far as the entire row matches the same width and properties.
6. **Emit Quad**: Generate a single quad covering `width x height`.
7. **Mark Visited**: Mark the visited area in the 2D mask.
8. **Repeat** until all faces in the slice are covered.

## Godot & Engine Considerations
- In Godot 4, ensure normal generation handles the non-uniform quad aspect ratios correctly.
- Use flat shading (`shading_mode = SHADING_MODE_PER_PIXEL` or vertex flat normals) to retain crisp voxel edges.
