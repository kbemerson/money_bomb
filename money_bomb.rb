require 'gosu'


class Tutorial < Gosu::Window
    def initialize
        super 1366, 768
        self.caption = "Money Bomb" 
        @background_image = Gosu::Image.new("media/background.jpg", :tileable => true)
        @player = Player.new
        @player.warp(683, 700)
        
        @scoin_img = Gosu::Image.new("media/coin.png")
        @scoins = Array.new
        
        @lcoin_img = Gosu::Image.new("media/coin.png")
        @lcoins = Array.new
        
        @bomb_img = Gosu::Image.new("media/bomb.png")
        @bombs = Array.new
        
        @playerimage = Gosu::Image.new("media/character.png")
        @font = Gosu::Font.new(20)
    end

    def update
        if Gosu.button_down? Gosu::KB_A or Gosu::button_down? Gosu::GP_LEFT
            @player.move_left
        end
        
        if Gosu.button_down? Gosu::KB_D or Gosu::button_down? Gosu::GP_RIGHT
            @player.move_right
        end
        
        @player.collect_scoins(@scoins)
        @player.collect_lcoins(@lcoins)
        @player.collect_bombs(@bombs)

        if rand(100) < 4 and @scoins.size < 25
            @scoins.push(Sc.new(@scoin_img))
        end
    
        if rand(100) < 4 and @lcoins.size < 10
            @lcoins.push(Lc.new(@lcoin_img))
        end
    
        if rand(100) < 4 and @bombs.size < 2
            @bombs.push(Bomb.new(@bomb_img))
        end
    end

    def draw
        @background_image.draw(0, 0, ZOrder::BACKGROUND)
        @player.draw
        @scoins.each { |sc| sc.draw } 
        @lcoins.each { |lc| lc.draw }
        @bombs.each { |bomb| bomb.draw }

        @font.draw("Score: #{@player.score}", 10, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::BLUE)
 
        @scoins.each do |scoin|
            scoin.move_down
        end
    end

    def button_down(id)
        if id == Gosu::KB_ESCAPE
            close
        else
            super
        end
        
        if id == Gosu::KB_R
            initialize
        end
    end
end


class Player
    attr_reader :score
    
    def initialize
        @image = Gosu::Image.new("media/character.png")
        @ching = Gosu::Sample.new("media/kaching.wav")
        @explosion = Gosu::Sample.new("media/bomb.wav")
        @x = @y = @vel_x = @angle = 0.0
        @vel_x = 3.0
        @score = 0
    end

    def warp(x, y)
        @x, @y = x, y
    end

    def move_left
        @x -= @vel_x
    end

    def move_right
        @x += @vel_x
    end

    def move_down
        @y -= 1
    end

    def draw
        @image.draw_rot(@x, @y, 1, @angle)
    end
    
    def collect_scoins(scoins)
        scoins.reject! do |sc|
            if Gosu.distance(@x, @y, sc.x, sc.y) < 35
                @score += 1
                @ching.play
                true
            else 
                false
            end
        end
    end
   
    def collect_lcoins(lcoins)
        lcoins.reject! do |lc|
            if Gosu.distance(@x, @y, lc.x, lc.y) < 35
                @score += 10
                @ching.play
                true
            else 
                false
            end
        end
    end
  
    def collect_bombs(bombs)
        bombs.reject! do |boom|
            if Gosu.distance(@x, @y, boom.x, boom.y) < 35
                @bomb.play
                @font.draw("Game Over! Press R to Restart", 683, 384, ZOrder::UI, 1.0, 1.0, Gosu::Color::BLUE)
            else 
                false
            end
        end
    end
end


module ZOrder
    BACKGROUND, SCOIN, LCOIN, BOMB, PLAYER, SCORE, UI = *0..7
end


class Sc
    attr_reader :x, :y
  
    def initialize(image)
        @image = image
        @color = Gosu::Color::BLACK.dup
        @color.red = 237
        @color.green = 215
        @color.blue = 164
        @x = rand * 1366
        @y = 10
    end

    def draw
        @image.draw(@x, @y, ZOrder::SCOIN, 0.5, 0.5)
    end
end


class Lc
    attr_reader :x, :y
    def initialize(image)
        @image = image
        @color = Gosu::Color::BLACK.dup
        @color.red = 237
        @color.green = 215
        @color.blue = 164
        @x = rand * 1366
        @y = 10
    end

    def draw
        @image.draw(@x, @y, ZOrder::LCOIN, 1.0, 1.0)
    end
end


class Bomb
    attr_reader :x, :y
    def initialize(image)
        @image = image
        @color = Gosu::Color::BLACK.dup
        @color.red = 75
        @color.green = 50
        @color.blue = 50
        @x = rand * 1366
        @y = 5
    end

    def draw
        @image.draw(@x, @y, ZOrder::BOMB, 1.0, 1.0)
    end
end


Tutorial.new.show