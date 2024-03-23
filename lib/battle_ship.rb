class BattleShip
  attr_accessor :grid_size, :ship_count, :total_missiles,
                :player1_grid, :player2_grid, :errors
  
  INVALID_NUMBER = 'Please enter number'
  NOT_IN_RANGE = 'Please enter number Between 1-10'
  SHIP_COUNT_MISMATCH = 'Ship count is not matched'
  MISSILE_NOT_IN_RANGE = 'Please enter number Between 1-10'
  INVALID_SHIP_POSITION = 'Invalid ship Position'
  INVALID_FIRE_POSITION = 'Invalid fire Position'
  FIRE_COUNT_MISMATCH = 'Uniq fire positions are not matched'

  def initialize(grid_size)
    @errors = []
    @grid_size = grid_size
    @errors << INVALID_NUMBER and return unless grid_size.class == Integer
    @errors << NOT_IN_RANGE unless grid_size.between?(1, 10)
    initialize_grids
  end

  def set_ship_count(count)
    return flash_error unless errors.none?
    
    @errors << INVALID_NUMBER and return unless count.class == Integer
    max_ships = (grid_size**2)/2
    @errors << "Max ships entered can be: #{max_ships}" if count > max_ships

    @ship_count = count
  end

  def set_ships_positions(ships_positions, player = 'Player 2')
    return flash_error unless errors.none?
    return @errors << SHIP_COUNT_MISMATCH unless ships_positions.uniq.length == ship_count
    return @errors << INVALID_SHIP_POSITION if invalid_positions?(ships_positions)

    grid = player == 'Player 1' ? player1_grid : player2_grid

    place_ships(grid, ships_positions)
  end

  def invalid_positions?(ships_positions)
    ships_positions.any?{|k,v| k >= grid_size || v >= grid_size }
  end

  def set_total_missiles(total_missiles)
    return flash_error unless errors.none?

    @errors << MISSILE_NOT_IN_RANGE unless total_missiles.between?(1, 100)
    @total_missiles = total_missiles
  end

  def play(player1_moves, player2_moves)
    if player1_moves.uniq.length != total_missiles || player2_moves.uniq.length != total_missiles
      @errors << FIRE_COUNT_MISMATCH
    end
    @errors << INVALID_FIRE_POSITION if invalid_positions?(player1_moves) || invalid_positions?(player2_moves)
    return flash_error unless errors.none?

    
    puts "Initial Grid" 
    puts print_grids

    player1_score = process_moves(player1_moves, 'Player 1')
    player2_score = process_moves(player2_moves)

    puts "Final Grid"
    puts print_grids

    puts result(player1_score, player2_score)
  end

  private

  def result(player1_score, player2_score)
    return "Player 1 wins!" if player1_score > player2_score
    return "Player 2 wins!" if player2_score > player1_score

    "It's a draw!"
  end

  def print_grids
    puts "Player 1 Grid"
    player1_grid.each{|row| puts row.join(' ') }
    puts "Player 2 Grid"
    player2_grid.each{|row| puts row.join(' ') }
    puts "******************"
  end

  def process_moves(moves, player_detail='Player 2')
    score = 0
    grid = player_detail == 'Player 1' ? player1_grid : player2_grid
    target_grid = player_detail == 'Player 1' ? player2_grid : player1_grid
    moves.each do |move|
      row, col = move
      score += 1 if fire(target_grid, row, col)        
    end
    score
  end

  def flash_error
    puts @errors.join(', ')
  end

  def initialize_grids
    @player1_grid = create_grid
    @player2_grid = create_grid
  end

  def create_grid
    Array.new(grid_size) { Array.new(grid_size, "-") } 
  end

  def place_ships(player_grid, ships)
    ships.each do |ship|
      row, col = ship
      player_grid[row][col] = "S"
    end
  end

  def fire(player_grid, row, col)
    if player_grid[row][col] == "S"
      player_grid[row][col] = "X"
      true
    else
      player_grid[row][col] = "O"
      false
    end
  end
end
