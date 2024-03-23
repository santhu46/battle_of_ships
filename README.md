Game of Battleships

Sample Input:
````
battleship = BattleShip.new(4)
battleship.set_ship_count(4)
battleship.set_ships_positions([[0,1], [0,3],[1,2],[3,3]],'Player 1')
battleship.set_ships_positions([[1,1], [1,3],[1,2],[2,3]])
battleship.set_total_missiles(3)
player1_moves = [[1,1],[1,3],[2,3]]
player2_moves = [[0,1],[0,3],[2,2]]
battleship.play(player1_moves, player2_moves)
````

