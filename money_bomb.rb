require 'gosu'

class Tutorial < Gosu::Window
    def initialize
        super 1366, 768
        self.caption = "Money Bomb" 
        @background_image = Gosu::Image.new("#tbd", :tileable => true)
        @player = Player.new
        @player.warp(683, 10)
        @font = Gosu::Font.new(20)
        @scoin_anim = Gosu::Image.new("#tbd", 100, 100)
        @scoin = Array.new
        @lcoin_anim = Gosu::Image.new("#tbd", 100, 100)
        @lcoin = Array.new
        @bomb_anim = Gosu::Image.new("#tbd", 100, 100)
        @bomb = Array.new
    end
    def update
        if Gosu.button_down? Gosu::KB_A or Gosu::button_down? Gosu::GP_LEFT
            @player.turn_left
        end
        if Gosu.button_down? Gosu::KB_LEFT or Gosu::button_down? Gosu::GP_LEFT
            @player.turn_left
        end
        if Gosu.button_down? Gosu::KB_D or Gosu::button_down? Gosu::GP_RIGHT
            @player.turn_right
        end
        if Gosu.button_down? Gosu::KB_RIGHT or Gosu::button_down? Gosu::GP_RIGHT
            @player.turn_right
        end
        @player.move
        @player.collect_scoin
        @player.collect_lcoin
        @player.collect_bomb
    def draw
        @background_image.draw(0, 0, ZOrder::BACKGROUND)
        @player.draw
        @scoin.each { |sc| sc.draw } 
        @lcoin.each { |lc| lc.draw }
        @bomb.each { |boom| boom.draw }
        @font.draw("Start or Restart: R", 10, 1350, ZOrder::UI, 1.0, 1.0, Gosu::Color::BLUE)
    end
    def button_down(id)
        if id == Gosu::KB_ESCAPE
            close
        else
            super
        end
        if id == GOSU::KB_R
            initialize
        end
    end
    if rand(100) < 4 and @scoin.size < 25
        @scoin.push(Sc.new(scoin_anim))
    end
    if rand(100) < 4 and @lcoin.size < 5
        @lcoin.push(Lc.new(lcoin_anim))
    end
end