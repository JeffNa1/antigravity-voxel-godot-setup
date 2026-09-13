---
name: blockworld
description: Core conventions for the blockworld MCP — how to find the world's scale, the 100-material palette, the primitive set, and build order. Read this before any blockworld build. Style skills (castle, dragon) layer on top of it.
---

# Blockworld

## First: ask how big a block is

**Call `world_info` before you place anything.**

You cannot infer the block size from `place_block(x, y, z)` — the signature is
identical whether a block is 10cm or 10m. The server knows. Ask it.

`world_info` returns the scale *and* a table of reference dimensions already
converted into blocks — how tall a human is, how tall a castle wall is, how
long a large dragon is. **Build to that table.** It is the only thing standing
between you and a structure that is silently ten times too small.

This is the single most common failure in this world, and it is invisible until
you look at the render.

## Everything below is in BLOCKS

Not metres. The style skills give dimensions in blocks, and `world_info` gives
you the conversion. So this skill stays correct whatever the grid is set to.

## Coordinates

`x` / `z` are the ground plane, `y` is up. `y = 0` is ground. Never go below.

Centre the build on the origin — the viewer frames it automatically.

## 100 materials

Call `list_materials` once before you start. They are grouped:

| Family | Examples |
|---|---|
| Stone | `granite` `limestone` `marble` `slate` `obsidian` `brick` |
| Timber | `oak` `walnut` `ebony` `pine` `bamboo` `thatch` |
| Roofing | `terracotta` `copper_verdigris` `tile_purple` `tile_crimson` |
| Metal | `gold` `silver` `bronze` `iron` `brass` |
| Glass | `glass_rose` `glass_azure` `glass_amber` `crystal` `lantern` |
| Gem | `amethyst` `sapphire` `emerald` `ruby` `jade` `opal` |
| Scale | `scale_green` `scale_azure` `scale_crimson` `belly` |
| Horn | `horn` `claw` `membrane` `spine` |
| Flame | `flame` `flame_core` `ember` `frost` `arcane` |

**Discipline beats variety.** Pick 4–6 materials for a build and hold them.
A structure in thirty colours reads as noise, not richness.

## Primitives

Never place a large form block by block.

| Tool | For |
|---|---|
| `world_info` | **call this first** — the grid scale |
| `place_box` | walls, floors, rooms (`hollow: true` for a shell) |
| `place_cylinder` | towers, columns |
| `place_cone` | spires, witch-hat caps, horns |
| `place_sphere` | domes, skulls, orbs (`ry`/`rz` to stretch) |
| `place_tube` | **curved organic forms** — necks, tails, bodies |
| `mirror` | build one half, mirror it — never hand-build symmetry |
| `remove_box` | carve gates, windows, sockets |
| `place_block` | detail only — eyes, finials, single stones |

`place_tube` and `mirror` are the two that change what is possible. A dragon is
four `place_tube` calls and a `mirror`. Learn them.

These primitives rasterize a shape into cubes on the server. You describe the
*form* — a path, a radius, a taper — and the server works out which blocks fall
inside it. Do not compute cube positions yourself; that is what these are for.

## Build order

The viewer animates each block as it lands, so build order is what the audience
watches. Work bottom-up, big-to-small.

1. `world_info`, then `clear`
2. Mass — the big forms
3. Structure — towers, limbs
4. Carve — `remove_box` for openings
5. Detail — `place_block` for finials, eyes, teeth

## Budget

A good build is **150–400 tool calls**. If you are looping `place_block` more
than about 30 times for one surface, you have reached for the wrong primitive.

Detail comes from *more features* — teeth, ridges, finials, trim — not from
finer resolution. The grid is what it is. Spend your calls on ornament.

## Style skills

Shape comes from a style skill, not from here:

- `skills/castle` — fairytale castle, spires and gold
- `skills/dragon` — sinuous body, membrane wings

If no style is named, ask, or pick one and say which.
