#
class Missile < ShortLived
  
  it_is_a Shot
  it_is_a Generator
  generates Smoke, 10, 50, 5
  
  lifetime { 600 + rand(100) }
  image 'missile.png'
  shape :circle
  radius 1.0
  mass 0.1
  moment 0.1
  collision_type :projectile
  friction 0.0001
  velocity { 4 + rand(1) }
  # plays 'cannon-02.wav'
  layer Layer::Players
  
  # def initialize window
  #   # self.lifetime = 600 + rand(100)
  #   
  #   super window
  #   
  #   # @image = Gosu::Image.new window, "media/projectile.png", false
  #   # 
  #   # @shape = CP::Shape::Circle.new(CP::Body.new(0.1, 0.1),
  #   #                                1.0,
  #   #                                CP::Vec2.new(0.0, 0.0))
  #   # @shape.collision_type = :projectile
  #   # 
  #   # self.friction = 0.0001
  #   # self.velocity = 4 + rand(1)
  #   # 
  #   # @sound = Gosu::Sample.new window, 'media/sounds/cannon-02.wav'
  #   # @sound.play
  #   
  #   start_generating
  # end
  
  # # Generates a number of explosions when destroyed!
  # #
  # def destroy!
  #   5.times do
  #     explosion = SmallExplosion.new window
  #     explosion.warp position + random_vector(rand(25))
  #     window.register explosion
  #   end
  #   super
  # end
  
  def move
    bounce_off_border_y # a helper method that makes the player bounce off the walls 100% elastically
    wrap_around_border_x # a helper method that makes the player wrap around the border
  end
  
  # def draw
  #   @image.draw_rot position.x, position.y, ZOrder::Player, drawing_rotation
  # end
  
end