class Player
  attr_accessor :x, :y

  def initialize(options={})
    @x = options[:x] || 0
    @y = options[:y] || 0
  end
  
  def right
    self.x += 1
  end

  def left
    self.x -= 1
  end
  
  def up
    self.y += 1
  end

  def down
    self.y -= 1
  end

  def label
  end
end

class Robot < Player
  def label
    '🤖'
  end 
end

class Sheep < Player
  def label
    '🐑'
  end

  def up
  end

  def left 
  end
end


class Game
  attr_accessor :enemies, :player, :game_objects

  ENEMY_COUNT = 5.freeze

  def initialize(player)
    @enemies = Array.new(ENEMY_COUNT) { Robot.new }
    @player = player
    @game_objects = @enemies << @player
  end


  def print_map
    (12).downto(-12) do |y|
      (-24).upto(24) do |x|
        # Проверяем, есть ли у нас в массиве робот с координатами x и y
        found = self.game_objects.find { |obj| obj.x == x && obj.y == y }
        
        # Если найден, рисуем обозначение объекта
        if found
          print found.label
        else
          print '.' 
        end
      end 
      # Просто переводим строку:
      puts 
    end
  end

  def next_move
    self.game_objects.each do |who|
      m = [:right, :left, :up, :down].sample
      who.send(m)
    end
  end

  def is_game_over?
    self.game_objects.combination(2).any? do |a, b|
      a.x == b.x && \
      a.y == b.y && \
      a.label != b.label
    end  
  end
end

sheep = Sheep.new({x: -12, y: 12})
game = Game.new(sheep)

loop do
  # Хитрый способ очистить экран
  puts "\e[H\e[2J"

  # Рисуем воображаемую сетку. Сетка начинается от -30 до 30 по X, # и от 12 до -12 по Y
  game.print_map

  if game.is_game_over?
    puts 'Game over'
    exit
  end

  # Каждого участника игры двигаем в случайном направлении 
  game.next_move

  sleep 0.1
end
