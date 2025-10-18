:- dynamic grid_fact/3.
:- dynamic seaList/1.
:- dynamic visitedList/1.
seaList([]).

% Generate a simple example grid based on size and difficulty (simplified)
generate_grid(Size, Difficulty) :-
    retractall(grid_fact(_,_,_)),
    % Remove any existing grid facts
    initialize_empty_cells(Size),
    generate_cells(Size, Difficulty).

initialize_empty_cells(Size) :-
    forall((between(1, Size, Row), between(1, Size, Col)), assertz(grid_fact(Row, Col, empty))).

% Define different grids based on size and difficulty
generate_cells(Size, Difficulty) :-
    % Example: Generate fixed cells (this can be replaced with a more complex generator)
    (Size = 4, Difficulty = easy ->
        assert(grid_fact(1, 1, 5)),
        assert(grid_fact(3, 4, 1));
    true).

% Example to convert fixed cells for a 4x4 grid
generate_cells(4, easy) :-
    assert(grid_fact(1, 1, 5)),
    assert(grid_fact(3, 4, 1)).

% Add more cases for different sizes and difficulty levels
generate_cells(6, medium) :-
    assert(grid_fact(1, 1, 3)),
    assert(grid_fact(2, 3, 2)),
    assert(grid_fact(4, 5, 4)),
    assert(grid_fact(6, 2, 1)).

generate_cells(9, hard) :-
    % Place numbers based on hard difficulty logic
    assert(grid_fact(2, 2, 4)),
    assert(grid_fact(5, 5, 6)),
    assert(grid_fact(7, 7, 3)),
    assert(grid_fact(8, 8, 2)).

% Default case for other sizes/difficulties
generate_cells(_, _) :-
    true. % No cells generated

% Display the problem grid
display_problem_grid(Size) :-
    (   between(1, Size, Row),
        display_row(Row, Size),
        fail
    ;   true
    ).

display_row(Row, Size) :-
    (   between(1, Size, Col),
        (   grid_fact(Row, Col, Num),
            number(Num)
        ->  format(' ~w ', [Num])
        ;   grid_fact(Row, Col, sea)
        ->  format(' s ', [])
        ;   grid_fact(Row, Col, empty)
        ->  format(' - ', [])
        ),
        fail
    ;   nl
    ).

% Start the game with specified size and difficulty
start_game(Size, Difficulty) :-
    generate_grid(Size, Difficulty),
    display_problem_grid(Size),
    (solve_grid(Size) ->
        display_problem_grid(Size),
        write('Solution found!'), nl
    ;   write('No solution found.'), nl
    ).

update_grid(Row, Col) :-
    (   grid_fact(Row, Col, empty) ->
        retract(grid_fact(Row, Col, _)),
        assert(grid_fact(Row, Col, sea)),
        seaList(CurrentSeaList),
        NewCell = grid_fact(Row, Col, sea),
        NewSeaList = [NewCell | CurrentSeaList],
        write(' cannot be edited!'),
        retractall(seaList(_)),
        assert(seaList(NewSeaList)),
        display_problem_grid(4) % Ensure this line is within the parentheses
    ;   write('Numbered cells cannot be edited!')
    ).

% Main game loop (simplified for illustration)
game_loop :-
    % Your interactive game loop logic here
    write('Interactive game loop not implemented in this example.'), nl.

% Get grid size
grid_size(Rows, Cols) :-
    grid_fact(grid_size, Rows, Cols).

sea2x2(Row, Col) :-
    % Check that the cell itself is sea
    grid_fact(Row, Col, sea),
    % Check all possible 2x2 sea configurations
    (   Row1 is Row + 1, Col1 is Col + 1,
        grid_fact(Row1, Col, sea),
        grid_fact(Row, Col1, sea),
        grid_fact(Row1, Col1, sea)
    ;   Row1 is Row - 1, Col1 is Col - 1,
        grid_fact(Row1, Col, sea),
        grid_fact(Row, Col1, sea),
        grid_fact(Row1, Col1, sea)
    ;   Row1 is Row + 1, Col1 is Col - 1,
        grid_fact(Row1, Col, sea),
        grid_fact(Row, Col1, sea),
        grid_fact(Row1, Col1, sea)
    ;   Row1 is Row - 1, Col1 is Col + 1,
        grid_fact(Row1, Col, sea),
        grid_fact(Row, Col1, sea),
        grid_fact(Row1, Col1, sea)
    ).

traverse_sea_list :-
    seaList(SeaCells),
    traverse_list(SeaCells).

% Base case: empty list (fail if no 2x2 sea grid was found)
traverse_list([]) :- fail.

% Recursive case: process each sea cell
traverse_list([grid_fact(Row, Col, sea) | T]) :-
    ( sea2x2(Row, Col)
    -> true
    ; traverse_list(T)
    ).

% Check if the current grid configuration is valid
valid_grid :-
    \+ (sea2x2(_, _)), % Ensure no 2x2 sea blocks
    size_equals_number_island. % Ensure the size of each island equals the fixed cell number

% Check if the size of each island equals the fixed cell number
size_equals_number_island :-
    findall((Row, Col, Num), grid_fact(Row, Col, Num), Islands),
    forall(member((Row, Col, Num), Islands), valid_island((Row, Col, Num))).

% Check if an island is valid (all cells have the same fixed number)
valid_island((Row, Col, Num)) :-
    findall((Row1, Col1), connected_island((Row, Col), (Row1, Col1)), IslandCells),
    length(IslandCells, Num).

% Get the fixed number from a cell
get_number((_, _, Num), Num).

% Check if two cells are part of the same island
connected_island((Row, Col), (Row1, Col1)) :-
    grid_fact(Row, Col, Num),
    grid_fact(Row1, Col1, Num),
    (Row1 is Row + 1, Col1 = Col;
     Row1 is Row - 1, Col1 = Col;
     Row1 = Row, Col1 is Col + 1;
     Row1 = Row, Col1 is Col - 1).

% Solve the grid using backtracking
solve_grid(Size) :-
    solve_grid(1, 1, Size).

solve_grid(Row, Col, Size) :-
    (Row > Size -> true;  % Termination condition
        (Col > Size ->
            Row1 is Row + 1,
            solve_grid(Row1, 1, Size)
        ;
            (assign_value(Row, Col),
            (valid_grid ->
                Col1 is Col + 1,
                solve_grid(Row, Col1, Size)
            ;   retract(grid_fact(Row, Col, _)),
                fail
            )
            )
        )
    ).

% Assign a value to a cell (either sea or empty)
assign_value(Row, Col) :-
    (grid_fact(Row, Col, _) -> true;  % Skip pre-filled cells
        (assert(grid_fact(Row, Col, sea));
         assert(grid_fact(Row, Col, empty))
        )
    ).
