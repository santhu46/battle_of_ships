require './lib/battle_ship'

describe 'initialize' do
  it 'sets the grid size' do
    ship = BattleShip.new(10)
    expect(ship.grid_size).to eq(10)
  end

  it 'initializes errors array' do
    ship = BattleShip.new(10)
    expect(ship.errors).to eq([]) 
  end

  it 'adds error if size is invalid' do
    ship = BattleShip.new('ten')
    expect(ship.errors).to include(BattleShip::INVALID_NUMBER)
  end
end

describe '#set_ship_count' do
  it 'sets the count' do
    ship = BattleShip.new(10)
    ship.set_ship_count(5)
    expect(ship.ship_count).to eq(5)
  end

  it 'adds error if count is invalid' do
    ship = BattleShip.new(10)
    ship.set_ship_count('five')
    expect(ship.errors).to include(BattleShip::INVALID_NUMBER) 
  end
end

describe '#play' do
  let(:battleship) { BattleShip.new(4) }
  before do
    battleship.set_ship_count(4)
    battleship.set_ships_positions([[0,1],[0,3],[1,2],[3,3]],'Player 1')
    battleship.set_ships_positions([[1,1],[1,3],[1,2],[2,3]])
    battleship.set_total_missiles(3)
  end

  it 'adds error if move counts do not match missiles' do
    battleship.play([[1,2]], [])
    expect(battleship.errors).to include(BattleShip::FIRE_COUNT_MISMATCH)
  end

  it 'calculates scores' do
    player1_moves = [[1,1],[1,3],[2,3]]
    player2_moves = [[0,1],[0,3],[2,2]]
    expect(battleship).to receive(:process_moves).twice.and_return(3,2)
    battleship.play(player1_moves, player2_moves)
  end

  it 'send results' do
    player1_moves = [[1,1],[1,3],[2,3]]
    player2_moves = [[0,1],[0,3],[2,2]]
    expect(battleship).to receive(:result).and_return('Player 1 wins!')
    battleship.play(player1_moves, player2_moves)
  end
  
  it 'adds error for invalid positions' do
    allow(battleship).to receive(:invalid_positions?).and_return(true)
    battleship.play([1,2], [3,4])
    expect(battleship.errors).to include(BattleShip::INVALID_FIRE_POSITION)
  end
end
