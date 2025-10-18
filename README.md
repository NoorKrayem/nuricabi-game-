🧩Nurikabe Puzzle Solver

A Prolog-based solver for Nurikabe puzzles (Japanese logic puzzles also known as "Islands in the Stream").

🖋️Description

This project implements a constraint satisfaction solver for Nurikabe puzzles using Prolog's backtracking capabilities.

The game generates puzzle grids of varying sizes and difficulties, then solves them by determining which cells should be "sea" (shaded) and which should be "land" (islands).

✨Features

🔸Multiple Difficulty Levels:

🔸Support for easy (4x4), medium (6x6), and hard (9x9) puzzle grids

🔸Automated Solver: Uses backtracking to find valid solutions

⚙️Constraint Validation:

🔸Enforces Nurikabe rules:No 2×2 blocks of sea cells allowed

🔸Each numbered cell must be part of an island containing exactly that many cells

🔸Islands are connected orthogonally (horizontally or vertically)

🔸Grid Display: Visual representation of puzzle state and solutions

🎮Nurikabe Rules

🔸Numbered cells indicate the size of their island (connected land cells)

🔸All sea cells must be connected

🔸There cannot be any 2×2 blocks of sea cellsEach island must contain exactly one numbered cell

📌Usage

🔸?- start_game(Size, Difficulty).

Examples:start_game(4, easy).

start_game(6, medium).

start_game(9, hard).

🧠Technologies

SWI-Prolog or compatible Prolog interpreter
