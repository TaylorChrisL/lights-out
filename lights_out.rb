require 'gosu'
require 'matrix'
require_relative 'credit'


class Lights_Out < Gosu::Window
  attr_reader :c, :grid, :moves_made

  def initialize
    super 800, 600
    self.caption = "Lights Out"
    @scene = :start
    @visible = 0
    @game_background_image = Gosu::Image.new("media/grid.png", :tileable => true)
    @start_background_image_one = Gosu::Image.new('media/start1.png', :tileable => true)
    @start_background_image_two = Gosu::Image.new('media/start2.png', :tileable => true)
    @c = Gosu::Color::BLUE
    @font_moves = Gosu::Font.new(22)
  end

  def initialize_game
    @moves_made = 0
    @scene = :game
    @beep_sound = Gosu::Sample.new('media/beep.wav')
    while true
      @grid = [
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0]
      ]
      randomize_grid
      if check_solvability
        break
      end
      pp "reset"
    end
  end

  def initialize_end
    @top_message = "You Won in #{moves_made} moves!!!"
    @bottom_message = "Press P to play again, or Q to quit."
    @message_font = Gosu::Font.new(28)
    @credits = []
    y = 700
    File.open('credits.txt').each do |line|
      @credits.push(Credit.new(self, line.chomp, 100, y))
      y += 30
    end
    @scene = :end
  end

  def update
    case @scene
    when :start
      update_start
    when :game
      update_game
    when :end
      update_end
    end
  end
  
  
  def update_start
    @visible -= 1
    @visible = 20 if @visible < -10 && rand < 0.05
  end
  
  def update_game
  end

  def update_end
    @credits.each do |credit|
      credit.move
    end
    if @credits.last.y < 150
      @credits.each do |credit|
        credit.reset
      end
    end
  end

  def draw
    case @scene
    when :start
      draw_start
    when :game
      draw_game
    when :end
      draw_end
    end
  end

  def draw_start
    @start_background_image_one.draw(0,0,0)
    if @visible > 0
      @start_background_image_two.draw(0,0,1)
    end
  end
    
  
  def draw_game
    @game_background_image.draw(0, 0, 0)
    draw_grid
    @font_moves.draw("Moves Made: #{@moves_made.to_s}", 630, 20, 2)
  end

  def draw_end
    clip_to(50, 140, 700, 360) do
      @credits.each do |credit|
        credit.draw
      end
    end
    draw_line(0, 140, Gosu::Color::RED, 800, 140, Gosu::Color::RED)
    @message_font.draw(@top_message, 40, 40, 1, 1, 1, Gosu::Color::FUCHSIA)
    draw_line(0, 500, Gosu::Color::RED, 800, 500, Gosu::Color::RED)
    @message_font.draw(@bottom_message, 180, 540, 1, 1, 1, Gosu::Color::BLUE)
  end

  def draw_grid
    y = 1
    grid.each do |row|
      x = 1
      row.each do |square|
        if square == 1
          draw_rect((13 * x) + (105 * (x - 1)), (13 * y) + (105 * (y - 1)), 105, 105, c, z = 1, mode = :default)
        end
        x += 1
      end
      y += 1
    end
  end

  def randomize_grid
    @beep_sound.play
    row = 0
    while row < @grid.length
      square = 0
      while square < @grid[row].length
        rand(1..2) == 1 ? @grid[row][square] = 0 : @grid[row][square] = 1
        square += 1
      end
      row += 1
    end
  end 

  def choose_space(row_number, column_number)
    @moves_made += 1
    @grid[row_number][column_number] = change_state(@grid[row_number][column_number])
    @grid[row_number + 1][column_number] = change_state(@grid[row_number + 1][column_number]) unless row_number == 4
    @grid[row_number - 1][column_number] = change_state(@grid[row_number - 1][column_number]) unless row_number == 0
    @grid[row_number][column_number + 1] = change_state(@grid[row_number][column_number + 1]) unless column_number == 4
    @grid[row_number][column_number - 1] = change_state(@grid[row_number][column_number - 1]) unless column_number == 0
    @beep_sound.play
    if won?
      initialize_end
    end
  end

  def won?
    @grid.each do |row|
      row.each do |square|
        if square == 1
          return false
        end
      end
    end
    return true
  end

  def change_state(number)
    number == 0 ? number = 1 : number = 0
    return number
  end

  def button_down(id)
    case @scene
    when :start
      button_down_start(id)
    when :game
      button_down_game(id)
    when :end
      button_down_end(id)
    end
  end

  def button_down_start(id)
    if id == Gosu::MsLeft
      initialize_game
    end
  end

  def button_down_game(id)
    if id == Gosu::MsLeft
      y = 1
      grid.each do |row|
        x = 1
        row.each do
          if Gosu.distance(mouse_x, mouse_y, (12 * x + 52) + (105 * (x - 1)), (12 * y + 52) + (105 * (y - 1))) < 50
            choose_space(y - 1, x - 1)
          end
          x += 1
        end
        y += 1
      end
    end
  end

  def button_down_end(id)
    if id == Gosu::KbP
      initialize_game
    elsif id == Gosu::KbQ
      close
    end
  end

  def check_solvability
    hold_array = []
    grid.each do |row|
      row.each do |square|
        hold_array << square
      end
    end
    a = Vector.[](*hold_array)
    #a.send(hold_array)
    check_one = Vector[0,1,1,1,0, 1,0,1,0,1, 1,1,0,1,1, 1,0,1,0,1, 0,1,1,1,0]
    check_two = Vector[1,0,1,0,1, 1,0,1,0,1, 0,0,0,0,0, 1,0,1,0,1, 1,0,1,0,1]

    if a.inner_product(check_one) % 2 > 0 || a.inner_product(check_two) % 2 > 0
      return false
    end
    return true 

  end
end

Lights_Out.new.show