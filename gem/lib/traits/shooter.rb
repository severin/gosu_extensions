module Shooter
  
  def self.manual!
    puts <<-MANUAL
      MANUAL FOR #{self}
      Defines:
        range <some range> # This is only needed for targeted shooting, e.g. automatic cannons
        frequency <some shooting frequency> # TODO block
        shoots <class:thing>
        muzzle_position { position calculation } || frontal # a block
        muzzle_velocity { velocity calculation }
        muzzle_rotation { rotation calculation }
      
      Example:
        frequency 20
        shoots Bullet
        muzzle_position { self.position + self.rotation_vector.normalize*self.radius }
        muzzle_velocity { |_| self.rotation_vector.normalize }
        muzzle_rotation { |_| self.rotation }
      Change Shooter.manual! -> Shooter, to not show the manual anymore.
    MANUAL
    self
  end
  
  def self.included base
    base.extend ClassMethods
  end
  
  module ClassMethods
    def range amount
      InitializerHooks.register self do
        self.shooting_range = amount
      end
    end
    def frequency amount
      InitializerHooks.register self do
        self.shooting_rate = ((SUBSTEPS**2).to_f/amount)/2
      end
    end
    def shoots type
      InitializerHooks.register self do
        self.shot_type = type
      end
    end
    def muzzle_position &block
      InitializerHooks.register self do
        muzzle_position_func &block
      end
    end
    def muzzle_velocity &block
      InitializerHooks.register self do
        muzzle_velocity_func &block
      end
    end
    def muzzle_rotation &block
      InitializerHooks.register self do
        muzzle_rotation_func &block
      end
    end
  end
  
  # attr_reader :muzzle_position, :muzzle_velocity, :muzzle_rotation
  attr_accessor :shot_type, :shooting_range, :shooting_rate
  
  def shot
    self.shot_type.new @window
  end
  
  def muzzle_position
    instance_eval &@muzzle_position
  end
  def muzzle_velocity target = nil
    instance_eval &@muzzle_velocity
  end
  def muzzle_rotation target = nil
    instance_eval &@muzzle_rotation
  end
  def muzzle_position_func &position
    @muzzle_position = position
  end
  def muzzle_velocity_func &velocity
    @muzzle_velocity = velocity
  end
  def muzzle_rotation_func &rotation
    @muzzle_rotation = rotation
  end
  def shoot? target = nil
    target.nil? ? true : target.distance_from(self) < self.range
  end
  def shoot target = nil
    return unless shoot? target
    
    sometimes :loading, self.shooting_rate do
      projectile = self.shot.shoot_from self
      projectile.rotation = self.muzzle_rotation
      projectile.speed = self.muzzle_velocity * projectile.velocity + self.speed
    end
  end
  
  if self.kind_of?(::Targeting)
    def target *targets
      return if targets.empty?
      target = acquire *targets
      shoot target
    end
  end
  
end