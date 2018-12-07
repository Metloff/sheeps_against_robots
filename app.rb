class Player
  attr_accessor :x, :y

  def initialize(options={})
    @x = options[:x] || 0
    @y = options[:y] || 0
  end
  
  def right(map_coordinates)
    return if self.x + 1 > map_coordinates[:x1]
    self.x += 1
  end

  def left(map_coordinates)
    return if self.x - 1 < map_coordinates[:x0]
    self.x -= 1
  end
  
  def up(map_coordinates)
    return if self.y + 1 > map_coordinates[:y1]
    self.y += 1
  end

  def down(map_coordinates)
    return if self.y - 1 < map_coordinates[:y0]
    self.y -= 1
  end

  def label
  end
end

class Robot < Player
  def label
    '🤖 '
  end 
end

class Sheep < Player
  def label
    '🐑 '
  end

  def up(map_coordinates)
  end

  def left(map_coordinates)
  end
end


class Game
  attr_accessor :enemies, :player, :game_objects, :map_size

  ENEMY_COUNT = 5.freeze
  MAP_COORDINATES = {
    big: { x0: -24, x1: 24, y0: -12, y1: 12 }
  }.freeze

  def initialize(options={})
    @map_size     = options[:map_size] || :big
    @player       = options[:player]

    @enemies      = Array.new(ENEMY_COUNT) { Robot.new }
    @game_objects = @enemies << @player
  end


  def print_map
    (ymax).downto(ymin) do |y|
      (xmin).upto(xmax) do |x|
        # Проверяем, есть ли у нас в массиве робот с координатами x и y
        found = self.game_objects.find { |obj| obj.x == x && obj.y == y }
        
        # Если найден, рисуем обозначение объекта
        if found
          print found.label
        else
          print '🌲 ' 
        end
      end 
      # Просто переводим строку:
      puts 
    end
  end

  def next_move
    self.game_objects.each do |who|
      m = [:right, :left, :up, :down].sample
      who.send(m, map_coordinates)
    end
  end

  def is_game_over?
    self.game_objects.combination(2).any? do |a, b|
      a.x == b.x && \
      a.y == b.y && \
      a.label != b.label
    end  
  end

  def is_player_win?
    self.player.x == xmax && self.player.y == ymin
  end

  private 

  def map_coordinates
    @map_coordinates ||= MAP_COORDINATES[self.map_size]
  end

  def xmin
    @xmin ||= map_coordinates[:x0]
  end

  def xmax
    @xmax ||= map_coordinates[:x1]
  end

  def ymin
    @ymin ||= map_coordinates[:y0]
  end

  def ymax
    @ymax ||= map_coordinates[:y1]
  end
end

sheep = Sheep.new({x: -12, y: 12})
game = Game.new({player: sheep, map_size: :big})

loop do
  # Хитрый способ очистить экран
  puts "\e[H\e[2J"

  # Рисуем воображаемую сетку. Сетка начинается от -30 до 30 по X, # и от 12 до -12 по Y
  game.print_map

  if game.is_game_over?
    puts 'Game over'
    exit
  end

  if game.is_player_win?
    puts 'Player WIN'
    exit
  end

  # Каждого участника игры двигаем в случайном направлении 
  game.next_move

  sleep 0.1
end
