---
name: draw-architecture-diagram
description: Create or revise architecture diagrams as editable SVGs with validated PNG exports. Use when drawing system components, service boundaries, deployment topology, or architecture connections; workflow charts and software-stack diagrams use their own visual conventions.
---

# Draw Architecture Diagram

Create an editable architecture SVG and the requested PNG exports, preserving the system's technical meaning. This workflow is adapted from `nvcf-architecture-diagrams` and generalized for other repositories.

## Establish the diagram

Read the target repository's `AGENTS.md` / `CLAUDE.md`, the relevant architecture sources, and any existing figures or asset provenance files. Follow the user's content and format requirements and the project's established visual system. When no visual system exists, use [the architecture style reference](references/nvidia-cloud-architecture-style.md).

Identify the audience, components, ownership or deployment boundaries, and one primary connection path. Verify relationships against the supplied design or code. Ask only when an unresolved relationship would materially change the architecture; record remaining assumptions alongside the deliverable.

Use the repository's existing figure location. For standalone work, use the user's requested location or a local scratch directory. Keep a short checklist of the requested content, source SVG, exports, and verification in `.scratch/<slug>/` for multi-step work, excluding `.scratch/` through `.git/info/exclude`.

## Author the SVG

- Establish the primary path before secondary or optional paths. Group multiple related components only when the boundary conveys meaning.
- Align components and orthogonal paths to a grid. Reserve connector lanes between groups and rows; keep paths clear of icons, labels, and unrelated cards.
- Route cross-group paths directly from the source to the nearest appropriate boundary, with lateral routing in the open lane outside. End group-level connections at group edges and component-level connections at components.
- Give arrows a straight final approach of at least 16 pt at authored scale, preferably at the target edge midpoint. Arrowhead tips meet the edge. Avoid backtracking and bends immediately before arrowheads.
- Place numbered callouts on open, straight path segments, clear of bends, arrowheads, boundaries, and other callouts.
- Keep labels short, normally six words or fewer. Wrap an approved long name or define a shorter form once; preserve consistent font sizes.
- Select supplied icons by semantics, use one component-icon size, and preserve original icon bytes, proportions, colors, and orientation. Use the library's generic icon for missing components. If no usable library exists, use labeled geometric components and explain the substitution rather than inventing branded icons.
- Read asset provenance before reuse. Embed local raster icons as data URIs in SVG symbols and retain a `data-source` attribute naming the local asset. The renderer accepts PNG, JPEG, and WebP data URIs; other assets need a supported local export.
- Follow the chosen visual system's palette and path styles. With the bundled reference, use 1 pt paths and 4 pt arrowheads on a white canvas. A dark presentation export keeps the white diagram on a white panel over a dark surround.

Give each card an ID and annotate constrained text so the renderer can check containment:

```svg
<rect id="card-worker-api" x="20" y="20" width="160" height="60" />
<text x="40" y="55" data-fit="card-worker-api" data-fit-padding="4">Worker API</text>
```

Keep annotated text and its fit target in the same SVG coordinate system. The fit checker uses local bounding boxes; visually inspect any transformed content separately.

## Render and verify

Validate XML with `xmllint --noout <figure>.svg` or an available XML parser. Run `git diff --check` when working in a Git repository. Then run the bundled renderer, resolving `<skill-root>` to this skill's installed directory:

```sh
node <skill-root>/scripts/render-and-check.cjs \
  <figure>.svg \
  /absolute/output/path/<figure>
```

The renderer requires Node.js, Playwright, and its Chromium browser. Prefer existing project dependencies. If the harness provides workspace dependencies, load them and set `NODE_PATH` to the returned Node package directory. Otherwise use an existing Playwright installation or set up a local scratch environment. Report a missing dependency if setup cannot complete; do not claim rendering succeeded.

The command checks text against the view box and annotated cards and writes `<figure>-light.png` and `<figure>-dark.png` at 2x resolution. It does not check connector collisions or technical accuracy. Inspect both PNGs at normal reading size and fix clipping, overlaps, crowded lanes, detached arrowheads, inconsistent icons, and unclear path direction. Re-render after corrections. Update the SVG and requested exports together, then provide their paths and any unresolved assumptions or verification limits.

Treat input SVG as untrusted. Preserve the renderer's rejection of scripts, event handlers, `foreignObject`, document types, entities, script URLs, CSS imports, and external references. Keep browser JavaScript disabled, service workers blocked, the restrictive content security policy, request blocking, and the single-SVG-root check. Convert needed assets into embedded local raster data instead of relaxing these controls. When changing the renderer, verify a valid figure, text overflow, script and event-handler rejection, and external-image rejection without a network request.
