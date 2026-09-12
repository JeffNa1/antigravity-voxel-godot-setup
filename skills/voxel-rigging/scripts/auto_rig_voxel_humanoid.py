"""
Blender Python Script: Auto-Rig Voxel Humanoid
Run inside Blender to generate a clean humanoid armature sized for standard voxel proportions
and bind limb meshes rigidly.
"""
import bpy

def create_voxel_armature():
    # Remove existing armature if present
    if "VoxelArmature" in bpy.data.objects:
        bpy.data.objects.remove(bpy.data.objects["VoxelArmature"], do_unlink=True)

    armature = bpy.data.armatures.new("VoxelArmature")
    obj = bpy.data.objects.new("VoxelArmature", armature)
    bpy.context.collection.objects.link(obj)
    bpy.context.view_layer.objects.active = obj
    obj.select_set(True)

    bpy.ops.object.mode_set(mode='EDIT')
    eb = armature.edit_bones

    # Root
    root = eb.new("Root")
    root.head = (0, 0, 0)
    root.tail = (0, 0, 0.2)

    # Hips
    hips = eb.new("Hips")
    hips.head = (0, 0, 1.0)
    hips.tail = (0, 0, 1.2)
    hips.parent = root

    # Spine & Chest
    spine = eb.new("Spine")
    spine.head = (0, 0, 1.2)
    spine.tail = (0, 0, 1.5)
    spine.parent = hips

    # Head
    head = eb.new("Head")
    head.head = (0, 0, 1.5)
    head.tail = (0, 0, 2.0)
    head.parent = spine

    # Left & Right Legs
    for side, sign in [("L", 1), ("R", -1)]:
        u_leg = eb.new(f"UpperLeg.{side}")
        u_leg.head = (sign * 0.2, 0, 1.0)
        u_leg.tail = (sign * 0.2, 0, 0.5)
        u_leg.parent = hips

        l_leg = eb.new(f"LowerLeg.{side}")
        l_leg.head = (sign * 0.2, 0, 0.5)
        l_leg.tail = (sign * 0.2, 0, 0.0)
        l_leg.parent = u_leg

    # Left & Right Arms
    for side, sign in [("L", 1), ("R", -1)]:
        u_arm = eb.new(f"UpperArm.{side}")
        u_arm.head = (sign * 0.4, 0, 1.5)
        u_arm.tail = (sign * 0.4, 0, 1.0)
        u_arm.parent = spine

        l_arm = eb.new(f"LowerArm.{side}")
        l_arm.head = (sign * 0.4, 0, 1.0)
        l_arm.tail = (sign * 0.4, 0, 0.6)
        l_arm.parent = u_arm

    bpy.ops.object.mode_set(mode='OBJECT')
    obj.show_in_front = True
    print("Voxel Armature created successfully!")

if __name__ == "__main__":
    create_voxel_armature()
