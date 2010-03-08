class SpaceBattle < GameWindow
  
  width  1022
  height  595
  # full_screen # comment if you want a windowed app.
  caption "Incredible Space Battles!"
  
  # font Gosu::default_font_name, 20
  
  background 'space.png', :hard_borders => false
  damping 0.1
  
  gravity 0.5
  
  collisions do
    add_collision_func :projectile, :projectile, &nil
    add_collision_func :projectile, :player, &nil # do |projectile_shape, player_shape| # &nil
      # self.remove projectile_shape
      # @moveables.each { |possible_player| possible_player.shape == player_shape && possible_player.hit! }
    # end
    add_collision_func :projectile, :enemy do |projectile_shape, enemy_shape|
      # TODO
      #
      # projectile_shape.destroy!
      #
      # def destroy!
      #   window.destroy! self # @moveables.each { |thing| thing.shape == shape && thing.destroy! }
      # end
      #
      @moveables.each { |projectile| projectile.shape == projectile_shape && projectile.destroy! }
    end
  end
  
  # Overridden, called in the setup.
  #
  def setup_players
    @player1 = Player.new self
    @player1.warp_to 400, 320
                     
    @players << @player1
    
    register @player1
  end
  
end