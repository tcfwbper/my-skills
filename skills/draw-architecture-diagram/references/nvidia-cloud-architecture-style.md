# NVIDIA Cloud Architecture Diagrams Style Guide

Adapted from the architecture-diagram workflow and style summary supplied for this skill. This reference captures reusable visual conventions; it does not bundle an icon library or fonts. Apply the target project's established visual system when one exists; otherwise use these conventions. Use a locally available sans-serif font when NVIDIA Sans is unavailable.

## Scope

Cloud architecture diagrams document components and their relationships. They may range from highly technical to explanatory or executive-summary views. They are not workflow diagrams or software-stack diagrams.

Start with a high-level sketch of API interactions and the essential components. Choose the detail level for the audience, then simplify without losing the primary relationship.

## Paths

- Prefer the project's existing primary, secondary, optional, and API-access styles. Without a supplied style library, use solid black for the primary path, gray for secondary paths, dashed gray for optional paths, and short labels to identify API access.
- The guide's base path uses a 1 pt stroke, 4 pt arrowhead, and rounded corners.
- Path labels are optional. Use them only when they clarify meaning; over-labeling reduces readability.
- Keep path labels to roughly six words, in NVIDIA Sans Medium at 10 pt.
- Use title case for names and titles. Use sentence case without a period for action phrases.
- Place path icons or numbered callouts directly on the path.

## Icons and labels

- Use one of the standard icon sizes consistently across the entire diagram; never mix sizes. Small icons are the default for technical diagrams. Large icons are for simple executive diagrams.
- The guide identifies 48 x 48 pt and 63 x 72 pt presets, with a 42 pt minimum.
- Keep icon labels short, normally about six words, in NVIDIA Sans Regular at 12 pt with approximately 10 pt clearance.
- Do not remove "NVIDIA" from an NVIDIA product or invent a new abbreviation.
- Do not place icons everywhere; use them where they improve identification.

## Component categories and palette

Use color only for the category or ownership meaning assigned by the guide.

| Category | Color |
| --- | --- |
| NVIDIA service, microservice, or container | `#76b900` |
| Resource | `#8922b9` |
| Function | `#ffbc01` |
| Actor | `#2290c7` |
| Third-party service | `#c2262d` |
| Third-party application | `#d128a8` |
| Location | `#1dbfa4` |
| Data | `#d96421` |
| Primary paths and text | `#000000` |
| Optional path | `#999999` |
| Group boundary | `#cccccc` |
| Partner-service group | `#f4f7f7` |
| Diagram background and icon interior | `#ffffff` |

NVIDIA Green identifies NVIDIA-owned or NVIDIA-powered components. Do not use it decoratively. For a third-party component powered by NVIDIA, use the guide's green underline or chevron below the icon rather than recoloring the icon.

## Groups and layout

- A group contains more than one component.
- Use groups to organize relationships, but do not overuse, recolor, or restyle them.
- Supported semantics include generic groups, third-party service groups, NVIDIA service groups, NVIDIA-powered generic groups, and sidecar groups.
- Keep ample breathing room around icons, labels, paths, and group edges.

## Background and exports

Architecture diagrams are always presented on white. On a dark slide or application background, place the white diagram on a white panel. Do not create a dark/inverted architecture palette.

The guide's PowerPoint export settings are 200% zoom, zero border, page size, light appearance, no shadow, and no grid. It recommends a transparent PNG for placement on a white panel. For documentation that explicitly requires a white-background PNG, flatten the export onto solid white without changing the diagram.

This skill authors editable SVG figures. Preserve these visual semantics while following the target repository's file layout and validation rules.
