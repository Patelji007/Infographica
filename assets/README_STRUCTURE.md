# Infographica Content Structure

To add new content to your app, you must mirror this structure in your GitHub repository: `Patelji007/Infographica`.

## 1. Infographics (Library & Home Feed)
Location: `assets/infographics/[Category]/[Folder_Name]/`

Every infographic needs its own folder containing exactly two files:
1. `infographic.png` (The image)
2. `info.txt` (The metadata)

**Format for `info.txt`:**
Line 1: Title of the infographic
Line 2: Brief description

**Example:**
`assets/infographics/physics/quantum_physics/`
- `infographic.png`
- `info.txt`

## 2. Data & Statistics
Location: `assets/data/[india_or_world]/`

Just upload your PNG images directly into these folders. The app will use the filename (without .png) as the title.

**Example:**
`assets/data/india/`
- `Population_Growth.png` (Title will be "Population Growth")
- `GDP_Stats.png` (Title will be "GDP Stats")

`assets/data/world/`
- `Global_Climate.png`

---
**Note:** The app automatically refreshes every time it is opened or when you pull down to refresh on the Home screen.
