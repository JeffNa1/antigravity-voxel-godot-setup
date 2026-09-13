#!/usr/bin/env node
/**
 * blockworld — MCP server (stdio) + WebSocket bridge (:8080)
 *
 * NEVER console.log here — stdout is the MCP protocol channel.
 * Use console.error (stderr) for anything you want to see.
 */

import { McpServer }            from '@modelcontextprotocol/sdk/server/mcp.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import { WebSocketServer }      from 'ws';
import { z }                    from 'zod';
import { MATERIAL_NAMES }       from './palette.js';
import { BLOCK_SIZE, gridLabel } from './config.js';

/* ---------------------------------------------------------------- *
 * world state
 * ---------------------------------------------------------------- */

const blocks = new Map();                       // "x,y,z" -> {x,y,z,material}
const key = (x, y, z) => `${x},${y},${z}`;

const set = (x, y, z, material) =>
  blocks.set(key(x, y, z), { x, y, z, material });

/* ---------------------------------------------------------------- *
 * websocket bridge
 * ---------------------------------------------------------------- */

// Bind with a free port so a leftover process never kills MCP handshake.
// Prefer 8080; fall back if it's already taken.
let wss = null;
const WS_PORTS = [8080, 8081, 8082, 8083];

function attachWss(server) {
  server.on('connection', (sock) => {
    sock.send(JSON.stringify({ type: 'snapshot', blocks: [...blocks.values()] }));
    console.error(`[blockworld] viewer connected (${blocks.size} blocks)`);
  });
  server.on('error', (err) => {
    console.error(`[blockworld] websocket error: ${err.message}`);
  });
}

function broadcast(msg) {
  if (!wss) return;
  const payload = JSON.stringify(msg);
  for (const c of wss.clients) if (c.readyState === 1) c.send(payload);
}

function listenWs(portIndex = 0) {
  if (portIndex >= WS_PORTS.length) {
    console.error('[blockworld] no free websocket port — MCP still works, viewer disabled');
    return;
  }
  const port = WS_PORTS[portIndex];
  const candidate = new WebSocketServer({ port, host: '127.0.0.1' });
  candidate.once('error', (err) => {
    if (err.code === 'EADDRINUSE') {
      console.error(`[blockworld] :${port} in use, trying next…`);
      try { candidate.close(); } catch { /* ignore */ }
      listenWs(portIndex + 1);
      return;
    }
    console.error(`[blockworld] websocket failed: ${err.message}`);
  });
  candidate.once('listening', () => {
    wss = candidate;
    attachWss(wss);
    console.error(`[blockworld] websocket listening on :${port}`);
  });
}

listenWs();

/* ---------------------------------------------------------------- *
 * MCP
 * ---------------------------------------------------------------- */

const server = new McpServer({ name: 'blockworld', version: '2.0.0' });
const ok = (text) => ({ content: [{ type: 'text', text }] });

// 100 materials is too many to enum into every schema — validate by hand
// and return a useful error listing near-misses.
const MatSet = new Set(MATERIAL_NAMES);
const Material = z.string().describe(
  'One of 100 materials. Call list_materials to see them all.'
);

function checkMat(m) {
  if (MatSet.has(m)) return null;
  const stem = String(m).split('_')[0];
  const near = MATERIAL_NAMES
    .filter(n => n.startsWith(stem) || n.split('_')[0] === stem)
    .slice(0, 6);
  return `Unknown material "${m}".` +
    (near.length ? ` Did you mean: ${near.join(', ')}?` : '') +
    ' Call list_materials for the full list.';
}

/* --- world_info ---------------------------------------------------- */

server.tool(
  'world_info',
  'Report the physical scale of the world. CALL THIS FIRST, before any ' +
  'build — you cannot infer the block size from the other tool signatures, ' +
  'and every dimension you choose depends on it.',
  {},
  async () => ok(
    `One block is ${gridLabel()}.\n\n` +
    `Reference dimensions, in BLOCKS:\n` +
    `  human           ${Math.round(1.8 / BLOCK_SIZE)} tall\n` +
    `  doorway         ${Math.round(1.0 / BLOCK_SIZE)} wide x ${Math.round(2.1 / BLOCK_SIZE)} tall\n` +
    `  storey          ${Math.round(3.0 / BLOCK_SIZE)} tall\n` +
    `  castle wall     ${Math.round(9.0 / BLOCK_SIZE)} tall\n` +
    `  castle tower    ${Math.round(26 / BLOCK_SIZE)} tall\n` +
    `  large dragon    ${Math.round(50 / BLOCK_SIZE)} long\n\n` +
    `Scale every dimension in your build to these. A structure sized for a ` +
    `coarser grid will look like a model; one sized for a finer grid will ` +
    `not fit on screen.`
  )
);

/* --- list_materials ------------------------------------------------ */

server.tool(
  'list_materials',
  'List all 100 available materials. Call this once before building so ' +
  'you know the palette.',
  {},
  async () => ok(MATERIAL_NAMES.join(', '))
);

/* --- place_block --------------------------------------------------- */

server.tool(
  'place_block',
  'Place one block. Detail only — single stones, eyes, claw tips. Use the ' +
  'bulk primitives for anything larger.',
  {
    x: z.number().int(), y: z.number().int().min(0), z: z.number().int(),
    material: Material,
  },
  async ({ x, y, z, material }) => {
    const err = checkMat(material); if (err) return ok(err);
    set(x, y, z, material);
    broadcast({ type: 'place', x, y, z, material });
    return ok(`placed ${material}`);
  }
);

/* --- place_box ----------------------------------------------------- */

server.tool(
  'place_box',
  'Fill a rectangular volume between two corners (inclusive). ' +
  'hollow=true gives a shell — use for walls and rooms.',
  {
    x1: z.number().int(), y1: z.number().int().min(0), z1: z.number().int(),
    x2: z.number().int(), y2: z.number().int().min(0), z2: z.number().int(),
    material: Material,
    hollow: z.boolean().default(false),
  },
  async ({ x1, y1, z1, x2, y2, z2, material, hollow }) => {
    const err = checkMat(material); if (err) return ok(err);
    const [ax, bx] = [Math.min(x1, x2), Math.max(x1, x2)];
    const [ay, by] = [Math.min(y1, y2), Math.max(y1, y2)];
    const [az, bz] = [Math.min(z1, z2), Math.max(z1, z2)];

    const placed = [];
    for (let x = ax; x <= bx; x++)
      for (let y = ay; y <= by; y++)
        for (let z = az; z <= bz; z++) {
          const shell = x === ax || x === bx || y === ay ||
                        y === by || z === az || z === bz;
          if (hollow && !shell) continue;
          set(x, y, z, material);
          placed.push({ x, y, z, material });
        }

    broadcast({ type: 'batch', blocks: placed });
    return ok(`placed ${placed.length} ${material}`);
  }
);

/* --- place_cylinder ------------------------------------------------ */

server.tool(
  'place_cylinder',
  'Vertical cylinder — the primitive for round towers.',
  {
    x: z.number().int(), z: z.number().int(),
    r: z.number().min(1).max(30),
    h: z.number().int().min(1).max(120),
    y: z.number().int().min(0).default(0),
    material: Material,
    hollow: z.boolean().default(true),
  },
  async ({ x: cx, z: cz, r, h, y: y0, material, hollow }) => {
    const err = checkMat(material); if (err) return ok(err);
    const placed = [];
    for (let y = y0; y < y0 + h; y++)
      for (let x = Math.floor(cx - r); x <= Math.ceil(cx + r); x++)
        for (let z = Math.floor(cz - r); z <= Math.ceil(cz + r); z++) {
          const d = Math.hypot(x - cx, z - cz);
          if (d > r + 0.5) continue;
          if (hollow && d < r - 0.9) continue;
          set(x, y, z, material);
          placed.push({ x, y, z, material });
        }
    broadcast({ type: 'batch', blocks: placed });
    return ok(`placed ${placed.length} ${material}`);
  }
);

/* --- place_cone ---------------------------------------------------- */

server.tool(
  'place_cone',
  'A cone — witch-hat tower caps and spires. Set r2 for a truncated cone.',
  {
    x: z.number().int(), z: z.number().int(),
    y: z.number().int().min(0),
    r: z.number().min(1).max(30),
    h: z.number().int().min(1).max(80),
    r2: z.number().min(0).max(30).default(0)
      .describe('Radius at the top. 0 = a point.'),
    material: Material,
  },
  async ({ x: cx, z: cz, y: y0, r, h, r2, material }) => {
    const err = checkMat(material); if (err) return ok(err);
    const placed = [];
    for (let i = 0; i < h; i++) {
      const rr = r + (r2 - r) * (i / Math.max(h - 1, 1));
      const y = y0 + i;
      for (let x = Math.floor(cx - rr); x <= Math.ceil(cx + rr); x++)
        for (let z = Math.floor(cz - rr); z <= Math.ceil(cz + rr); z++)
          if (Math.hypot(x - cx, z - cz) <= rr + 0.4) {
            set(x, y, z, material);
            placed.push({ x, y, z, material });
          }
    }
    broadcast({ type: 'batch', blocks: placed });
    return ok(`placed ${placed.length} ${material}`);
  }
);

/* --- place_sphere -------------------------------------------------- */

server.tool(
  'place_sphere',
  'A sphere or ellipsoid — dragon skulls, joints, orbs, domes. Give ry/rz ' +
  'to stretch it.',
  {
    x: z.number().int(), y: z.number().int().min(0), z: z.number().int(),
    r: z.number().min(1).max(30),
    ry: z.number().min(0).max(30).default(0).describe('Vertical radius. 0 = use r.'),
    rz: z.number().min(0).max(30).default(0).describe('Depth radius. 0 = use r.'),
    material: Material,
    hollow: z.boolean().default(false),
  },
  async ({ x: cx, y: cy, z: cz, r, ry, rz, material, hollow }) => {
    const err = checkMat(material); if (err) return ok(err);
    const RX = r, RY = ry || r, RZ = rz || r;
    const placed = [];
    for (let x = Math.floor(cx - RX); x <= Math.ceil(cx + RX); x++)
      for (let y = Math.max(0, Math.floor(cy - RY)); y <= Math.ceil(cy + RY); y++)
        for (let z = Math.floor(cz - RZ); z <= Math.ceil(cz + RZ); z++) {
          const d = Math.hypot((x - cx) / RX, (y - cy) / RY, (z - cz) / RZ);
          if (d > 1.05) continue;
          if (hollow && d < 0.78) continue;
          set(x, y, z, material);
          placed.push({ x, y, z, material });
        }
    broadcast({ type: 'batch', blocks: placed });
    return ok(`placed ${placed.length} ${material}`);
  }
);

/* --- place_tube ---------------------------------------------------- */

server.tool(
  'place_tube',
  'A tapering tube swept through a path of points — THE primitive for ' +
  'dragon necks, bodies, and tails. Radius interpolates along the path, so ' +
  'pass r_start > r_end to taper. Give 3+ points for a curve.',
  {
    path: z.array(z.object({
      x: z.number().int(), y: z.number().int().min(0), z: z.number().int(),
    })).min(2).max(24).describe('Spine points. The tube is swept through them.'),
    r_start: z.number().min(0.5).max(24),
    r_end:   z.number().min(0.3).max(24),
    material: Material,
  },
  async ({ path, r_start, r_end, material }) => {
    const err = checkMat(material); if (err) return ok(err);
    const placed = [];
    const seen = new Set();
    const segs = path.length - 1;

    for (let s = 0; s < segs; s++) {
      const a = path[s], b = path[s + 1];
      const len = Math.hypot(b.x - a.x, b.y - a.y, b.z - a.z);
      const steps = Math.max(2, Math.ceil(len * 2));

      for (let i = 0; i <= steps; i++) {
        const t  = (s + i / steps) / segs;            // 0..1 along the whole path
        const u  = i / steps;
        const cx = a.x + (b.x - a.x) * u;
        const cy = a.y + (b.y - a.y) * u;
        const cz = a.z + (b.z - a.z) * u;
        const rr = r_start + (r_end - r_start) * t;

        for (let x = Math.floor(cx - rr); x <= Math.ceil(cx + rr); x++)
          for (let y = Math.max(0, Math.floor(cy - rr)); y <= Math.ceil(cy + rr); y++)
            for (let z = Math.floor(cz - rr); z <= Math.ceil(cz + rr); z++) {
              if (Math.hypot(x - cx, y - cy, z - cz) > rr + 0.35) continue;
              const k = key(x, y, z);
              if (seen.has(k)) continue;
              seen.add(k);
              set(x, y, z, material);
              placed.push({ x, y, z, material });
            }
      }
    }
    broadcast({ type: 'batch', blocks: placed });
    return ok(`placed ${placed.length} ${material}`);
  }
);

/* --- mirror -------------------------------------------------------- */

server.tool(
  'mirror',
  'Mirror the whole build across a plane. Build one wing, one half of a ' +
  'castle facade, then mirror across x=0 for symmetry.',
  {
    axis:  z.enum(['x', 'z']),
    plane: z.number().int().default(0),
  },
  async ({ axis, plane }) => {
    const placed = [];
    for (const b of [...blocks.values()]) {
      const c = { ...b };
      c[axis] = 2 * plane - b[axis];
      if (blocks.has(key(c.x, c.y, c.z))) continue;
      set(c.x, c.y, c.z, c.material);
      placed.push(c);
    }
    broadcast({ type: 'batch', blocks: placed });
    return ok(`mirrored ${placed.length} blocks across ${axis}=${plane}`);
  }
);

/* --- remove -------------------------------------------------------- */

server.tool(
  'remove_block',
  'Remove one block. Carve openings — gates, arrow slits, eye sockets.',
  { x: z.number().int(), y: z.number().int().min(0), z: z.number().int() },
  async ({ x, y, z }) => {
    const had = blocks.delete(key(x, y, z));
    if (had) broadcast({ type: 'remove', blocks: [{ x, y, z }] });
    return ok(had ? `removed ${x},${y},${z}` : `nothing at ${x},${y},${z}`);
  }
);

server.tool(
  'remove_box',
  'Remove every block in a volume — the fast way to carve a gate or window.',
  {
    x1: z.number().int(), y1: z.number().int().min(0), z1: z.number().int(),
    x2: z.number().int(), y2: z.number().int().min(0), z2: z.number().int(),
  },
  async ({ x1, y1, z1, x2, y2, z2 }) => {
    const [ax, bx] = [Math.min(x1, x2), Math.max(x1, x2)];
    const [ay, by] = [Math.min(y1, y2), Math.max(y1, y2)];
    const [az, bz] = [Math.min(z1, z2), Math.max(z1, z2)];

    const gone = [];
    for (let x = ax; x <= bx; x++)
      for (let y = ay; y <= by; y++)
        for (let z = az; z <= bz; z++)
          if (blocks.delete(key(x, y, z))) gone.push({ x, y, z });

    if (gone.length) broadcast({ type: 'remove', blocks: gone });
    return ok(`removed ${gone.length} blocks`);
  }
);

/* --- clear / describe ---------------------------------------------- */

server.tool(
  'clear',
  'Empty the world. Call before starting a new build.',
  {},
  async () => {
    blocks.clear();
    broadcast({ type: 'clear' });
    return ok('world cleared');
  }
);

server.tool(
  'describe_world',
  'Block count and bounding box of the current build.',
  {},
  async () => {
    if (!blocks.size) return ok('The world is empty.');
    const xs = [], ys = [], zs = [];
    for (const b of blocks.values()) { xs.push(b.x); ys.push(b.y); zs.push(b.z); }
    const sp   = a => `${Math.min(...a)}..${Math.max(...a)}`;
    const span = a => Math.max(...a) - Math.min(...a) + 1;
    return ok(
      `${blocks.size} blocks. x ${sp(xs)}, y ${sp(ys)}, z ${sp(zs)}. ` +
      `One block is ${gridLabel()}; extent is ` +
      `${(span(xs)*BLOCK_SIZE).toFixed(1)}m x ${(span(zs)*BLOCK_SIZE).toFixed(1)}m x ` +
      `${(span(ys)*BLOCK_SIZE).toFixed(1)}m.`
    );
  }
);

/* ---------------------------------------------------------------- */

await server.connect(new StdioServerTransport());
console.error(`[blockworld] mcp ready — ${MATERIAL_NAMES.length} materials, ${gridLabel()} blocks`);
