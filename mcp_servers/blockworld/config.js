/**
 * blockworld — world configuration.
 *
 * THIS IS THE ONE DIAL. Change BLOCK_SIZE here and it propagates to:
 *   - the viewer (mesh scale, grid helper, title block readout)
 *   - the server (describe_world, world_info)
 *   - the agent (via the world_info tool, which the skill tells it to call)
 *
 * Nothing else should hardcode a block size. If you find a literal "1m"
 * anywhere, it's a bug.
 */

export const BLOCK_SIZE = 0.5;      // metres per block

/**
 * Everything in the skills is written in BLOCKS, not metres — so the skills
 * do not need to change when BLOCK_SIZE changes. This function is how the
 * agent converts, and how the viewer labels itself.
 */
export const toMetres = (blocks) => blocks * BLOCK_SIZE;
export const toBlocks = (metres) => Math.round(metres / BLOCK_SIZE);

/** Human-readable, for the title block and the world_info tool. */
export const gridLabel = () =>
  BLOCK_SIZE >= 1
    ? `${BLOCK_SIZE} m`
    : `${BLOCK_SIZE * 100} cm`;
