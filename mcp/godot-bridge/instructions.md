# Godot Bridge MCP Server — Instructions & Best Practices

## Overview
The `godot-bridge` MCP server enables live bidirectional communication with an active Godot Engine 4.x Editor or running scene via TCP (default port `6000` or `6001`).

## Recommended Workflows
1. **Connection Health Check**:
   - Always run `get_godot_status` or `diagnose_connection` before modifying scenes to ensure the bridge daemon is listening.
2. **Scene Hierarchy Inspection**:
   - Call `scene_tree_dump` to examine the current node tree before attaching scripts or instantiating child nodes.
3. **Safe Node Operations**:
   - Use `batch_scene_edit` for atomic changes to multiple properties.
   - When adding nodes, specify explicit types (`Node3D`, `CharacterBody3D`, `MeshInstance3D`) and verify unique names.
4. **Signal & Script Binding**:
   - Connect signals cleanly using `connect_signal`.
   - Validate any generated GDScript with `validate_scripts` before attaching to nodes.
5. **Visual Verification**:
   - Call `take_screenshot` or `render_scene_preview` after visual tweaks to confirm camera angles, lighting, and materials.
