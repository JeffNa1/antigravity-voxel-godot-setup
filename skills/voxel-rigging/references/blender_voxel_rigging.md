# Blender Rigging Guide for Voxel Models

## Step-by-Step Setup
1. **Prepare Meshes**:
   - Ensure scale is applied on all meshes: `Ctrl+A -> All Transforms`.
   - Set 3D cursor to world origin: `Shift+S -> Cursor to World Origin`.
2. **Create Armature**:
   - `Shift+A -> Armature -> Single Bone`. Name it `Root`.
   - Set Display to "In Front" under Object Data Properties -> Viewport Display.
3. **Align Joints to Voxel Grid**:
   - Use Vertex Snapping (`Shift+Tab` with Snapping Mode set to `Vertex`).
   - Snap bone heads and tails to the exact corners or edge center of voxel blocks.
4. **Rigid Weight Assignment**:
   - In Edit Mode of each limb mesh:
     - Press `A` to select all vertices of that limb.
     - In Vertex Groups list, select the corresponding bone name.
     - Weight slider: `1.0`. Click `Assign`.
   - Verify in Weight Paint Mode: the limb is solid red (`1.0`), and all other bones show solid blue (`0.0`).
5. **Exporting to glTF 2.0**:
   - Format: `glTF Binary (.glb)`.
   - Include: Selected Objects.
   - Transform: `+Y Up`.
   - Geometry: Apply Modifiers: Yes, UVs: Yes, Normals: Yes.
   - Animation: Group by NLA Track: Yes, Export Deformation Bones Only: Yes.
