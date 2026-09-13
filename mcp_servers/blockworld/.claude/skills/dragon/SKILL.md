---
name: dragon
description: Build a dragon in blockworld — sinuous neck and tail, membrane wings, horned skull, clawed limbs. Use whenever the user asks for a dragon, wyvern, drake, wyrm, or serpent. Read skills/blockworld first for the grid and primitives.
---

# Dragon

Everything else in blockworld is architecture. A dragon is not. `place_box`
will not help you here — reach for `place_tube`, `place_sphere`, and `mirror`.

## The silhouette

A dragon reads from four things, in this order:

1. **An S-curve.** Neck arcs up, body dips, tail sweeps out and up. If any
   part of the spine is straight, it is a lizard, not a dragon.
2. **Wings, spread wide.** The wingspan should be **wider than the body is
   long**. Folded wings are for people who have given up.
3. **A wedge skull** with horns swept back.
4. **Taper.** Thick at the shoulders, thin at the tail tip and snout. Nothing
   is a constant thickness.

## The failure mode

Left alone you will build a horizontal tube with a box head, small wings
tacked on the sides, and four stumpy legs. Every part will be individually
present and it will read as **a crocodile with a kite attached**.

The four specific errors:

- **A straight spine.** Fatal. The curve is the animal.
- **Wings too small.** They will look vestigial. Go bigger than feels right,
  then go bigger again.
- **No taper.** A tube of constant radius is a snake, not a dragon.
- **Symmetry done by hand.** Do not build the second wing manually — you will
  get it subtly wrong. Build one, call `mirror`.

## Build order

### 1. The spine — `place_tube`

This is the whole animal. Get it right and the rest is decoration.

One call, a path of 8–12 points, tracing an S from snout to tail tip. Work in
profile (vary `y` and `z`, keep `x` near 0):

```
       ___                        head, high
     /                            neck, arcing up
    |
    \___                          shoulders, the thickest point
        \____                     body, dipping
              \___                hips
                  \____           tail, sweeping out
                       \___/      tail tip, flicking up
```

`r_start: 3` at the head end, `r_end: 0.6` at the tail tip. The taper does
enormous work.

Actually make **two calls** — the tube taper is linear, and a dragon is not:

- **Head → shoulders:** `r_start: 2.5`, `r_end: 5` (neck swells into the body)
- **Shoulders → tail tip:** `r_start: 5`, `r_end: 0.6`

Use `scale_green` or `scale_azure` for the body. Pick one family and hold it.

### 2. Belly

A second `place_tube` along the same path, offset 1–2 blocks down, radius
slightly smaller, in `belly` or `belly_pale`. Pale underside is what makes it
read as an animal rather than a sculpture.

### 3. Skull — `place_sphere`

**Not a box.** An ellipsoid, stretched along the snout: `r: 3, ry: 2.5, rz: 4`.
Wedge-shaped, tapering forward.

Then:
- **Brow ridge** — `place_box`, 1 thick, in `horn`, above the eyes
- **Eyes** — 2 blocks of `ruby` or `flame_core`, deep-set, `place_block`
- **Jaw** — a smaller ellipsoid below, offset forward
- **Teeth** — a row of `scale_bone`, `place_block`, along the jawline

### 4. Horns — `place_tube`

Two, swept **back** from the skull, curving. 3–4 path points each, tapering
`r_start: 1.2` → `r_end: 0.2`, in `horn` or `horn_dark`.

Build one. `mirror` across `x=0`.

### 5. Wings — Create a wing, then `mirror`

**The most important call in the build.** Do not undersell it.

- **Shoulder** at the thickest part of the body, offset a couple of blocks out
  in `x`.
- **Tips**: 4–5 of them, fanning **out and back**, in order along the leading
  edge. The first tip is the wrist (out and forward), the last is the trailing
  edge (back toward the hips).
- Furthest tip should be **at least as far from the shoulder as the body is
  long.** Measure it. If the wingspan is less than the body length, it is too
  small.

Then `mirror` on `x`. One call, and the pair is exact.

### 6. Limbs — `place_tube`

Four, or two if you want a wyvern. Each is 2 tubes — upper limb and lower —
meeting at a bent joint, because a straight leg reads as a table leg.

Feet: 3 `claw` blocks splayed forward, one back.

Build the left pair. `mirror`.

### 7. Spinal ridge

A line of `spine` or `horn` blocks along the top of the tube, from skull to
tail tip. `place_block` in a loop, following the spine path.

This is the cheapest, highest-impact detail in the build. Do not skip it.

### 8. Fire, if you want it

A `place_tube` from the mouth, widening outward — `r_start: 1`, `r_end: 5` —
cycling `flame_core` → `flame_hot` → `flame` → `flame_deep` → `smoke` as it
travels. Three or four short tubes, one per colour band, is easier than one
gradient.

## Scale

**Call `world_info` first.** It tells you how many blocks make a large dragon
at this grid — take that number and build to it.

Then hold these *ratios*, whatever the grid:

```
body length      L              ← from world_info
wingspan         1.5 x L        ← wider than the body is long. Measure it.
shoulder radius  L / 10
tail tip radius  L / 80         ← nearly a point
neck length      L / 3
```

A dragon that is not obviously huge is a lizard. If `world_info` says a large
dragon is 50 blocks, do not build a 20-block one.

## Palette discipline

Pick **one scale family** and stay in it:

- `scale_green` / `scale_green_dk` / `belly` — the classic
- `scale_azure` / `scale_teal` / `belly_pale` — ice
- `scale_crimson` / `scale_rust` / `belly` — fire
- `scale_onyx` / `scale_ash` / `scale_bone` — undead

Then two accents only: `horn` for horns and claws, `membrane` for wings.
A dragon in eleven colours reads as a parrot.
