## 8/10/21
- Hold note quad rework (from Schmovin')
- Added modifiers (PathModifier, Bumpy, Infinite)
- Fixed note positions
- Improved some code
- Fixed hold size (+= 6)

## 8/10/21 (2)
- Hold scale fix

## 12/10/24
- Hold graphic subdivition system (from Schmovin')
	- A subdivision system was already in, but hold notes were literally splited, causing you to gain or lose more heatlh (plus it caused more lag, as well as causing visual issues with texture)
	- Also because of the new subdivision system in hold notes, now to implement this library in cne it is no longer necessary to change anything within the source code.
- Fixed hold notes position and scale when scaling by Z or Zoom.
- Code improvements
- Optimization.

## 12/10/24 (2)
- Schmovin Drunk & Tipsy Math (false paradise recreation upcoming >:3)

## 12/10/24 (3)
- Fix broken hold spacing when bpm changes

# 15/10/24
- Custom mods examples
- Modchart Examples
- More stuff im forgeting
- False paradise stuff... modchart still wip !! some modifiers are not working, dont play it yet

# 24/10/24
- Improved Infinite Modifier
- Optimization and code improvement
- Bounce Mod

# 31/10/24
- Changed List to Array in ModchartGroup (for better performance)
- Added arrow paths (need to enable by Manager.renderArrowPaths = true)
- Arrow path Sub mods
  - Alpha
  - Thickness
  - Scale (Length / Limit)

# 3/11/24
- Fixed critical memory leak in the arrow path renderer (it went from 70MB to more than 4GB in a very short time).
- Optimized a bit the arrow path renderer.
- Added X mod

# 5/11/24
- New Optimized Path Manager written by Me
- Small code improvements

# 06/12/24
- 3D Rotation for regular notes (also holds)
- AngleX, AngleY, AngleZ now are visuals components.
- Custom 3D Camera (Matrix3D)
- Skew Mods
- Stealth mods (alpha, glows) now are smoother on holds.