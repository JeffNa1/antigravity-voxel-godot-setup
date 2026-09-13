---
name: castle
description: Build a fantastical fairytale castle in blockworld — slender spires, witch-hat turrets, a soaring central keep, banners and gold finials. Use whenever the user asks for a castle, palace, fortress, or stronghold. Read skills/blockworld first for the grid and primitives.
---

# Castle

Not a fortress. A **fairytale** castle — Neuschwanstein, not Caernarfon.
Defensive castles are squat and grim on purpose. This one is the opposite of
that, and every proportion below is chosen to break the military rule.

## The silhouette

Read, in order:

1. **Vertical.** Towers 3–4× the height of the walls. The building should look
   like it is straining upward.
2. **Witch-hat spires.** Steep conical caps, **taller than the tower they sit
   on**. This is the single strongest tell.
3. **Slenderness.** Tall thin towers, not fat ones. A tower wider than r=5
   reads as a grain silo.
4. **A crowd of towers.** Not four. Eight, ten, at different heights — the
   skyline should be busy and irregular.

## The failure mode

Left alone you will build a fortress: a squat grey box, thick round towers,
shallow caps, crenellations, arrow slits. Every element correct for a real
castle and **wrong for this one**.

The five specific errors:

- **Squat.** If the towers are only slightly taller than the wall, it is a
  fort. Triple them.
- **Fat towers.** r=4 is slender. r=8 is a silo.
- **Shallow caps.** A cap must be **taller than it is wide**. Steeper than
  feels right.
- **Grey.** A fairytale castle is white and coloured. Use `marble` and
  `limestone`, not `granite` and `basalt`.
- **Too few towers.** Four corners is a fort. You want a thicket.

## Build order

### 1. Curtain wall — low

`place_box`, hollow, **8–10 blocks tall**. That is *low*, deliberately — it
exists to make the towers look enormous. A 40×40 footprint is a good default
(x, z from −20 to 20).

`limestone` above, two courses of `granite` at the base.

### 2. Corner towers — `place_cylinder`

**r=4, and 26+ blocks tall.** Three times the wall.

`marble`. Slender and pale.

### 3. Witch-hat caps — `place_cone`

The money shot. On each tower: `place_cone` with **r slightly wider than the
tower** (r=5.5 on an r=4 tower — it flares out over the edge) and **height
14+**.

The cone must be **taller than it is wide.** If it looks like a party hat, it
is right. If it looks like a pyramid, it is too shallow — double the height.

Colour them: `tile_purple`, `tile_crimson`, `tile_green`, `copper_verdigris`.
Vary between towers.

**Finial:** one block of `gold` at the apex of every cone. Free, and it makes
the whole skyline sparkle.

### 4. The keep — taller than everything

Centre. `place_cylinder`, **r=8, 34 blocks tall**, `marble`. Then a
`place_cone` cap, r=10, **20 tall**, and a `gold_pale` finial.

The keep should be **half again as tall as the corner towers**. It is the
vertical anchor and it should be unmissable.

### 5. A thicket of spires

**This is what separates a fairytale castle from a fort.** Scatter 4–8 more
slim towers — `place_cylinder` r=2.5, heights **varying** between 18 and 30,
each with its own cone.

Irregular heights. A skyline where every tower is the same height is a
municipal building.

### 6. Gatehouse

Two towers flanking the main approach — r=3.5, 20 tall, `tile_crimson` caps,
gold finials.

Then `remove_box` a gate opening between them: **7 wide, 7 tall**, arched
(remove the top corners so it curves).

### 7. Windows — tall and coloured

**Not arrow slits.** This is not a fortress. Bands of coloured glass:
`place_cylinder` a 2-block-tall ring of `glass_rose`, `glass_azure`, or
`glass_amber` around each tower at a few heights.

Tall, narrow, and lit. If you find yourself carving arrow slits, stop — you
have reverted to building a fort.

### 8. Gold and detail

- `gold` finial on every single spire — no exceptions
- `copper_verdigris` roof trim
- `lantern` blocks flanking the gate
- A `banner` of `tile_crimson` down the keep, if you like

## Proportions

**Call `world_info` first** for the wall height at this grid. Everything else
is a multiple of it — so these ratios hold whatever the block size:

```
                        x wall height
keep + cap    ██████████████████  6.0
corner tower  ████████████        4.5   (3.0 tower + 1.5 cap)
spires        ████████            2.5–4.0   ← vary these
curtain wall  ███                 1.0
```

**If the towers are less than 3x the wall height, rebuild them taller.** That
one ratio is the difference between a fairytale castle and a fort, and it is
the thing you will get wrong.

Cap height must exceed cap width. Always. That is what makes it a witch hat
rather than a pyramid.

## Palette

Pale stone, coloured roofs, gold accents:

- **Walls:** `marble`, `limestone`, `chalk`, `granite` (base only)
- **Roofs:** `tile_purple`, `tile_crimson`, `tile_green`, `copper_verdigris`,
  `slate_dark`
- **Glass:** `glass_rose`, `glass_azure`, `glass_amber`
- **Accent:** `gold`, `gold_pale`, `lantern`

No `basalt`, no `obsidian`, no `iron`. Save those for the dungeon.
