# Extend this class for your game.
#
# Example:
#   class MyGreatGame < GameWindow
#
class GameWindow < Gosu::Window
  
  include InitializerHooks
  
  # TODO handle more elegantly
  #
  def window
    self
  end
  def destroyed?
    false
  end
  
  include ItIsA # Move up to standard object, also from thing
  
  attr_writer :full_screen,
              :font_name,
              :font_size,
              :damping,
              :caption,
              :screen_width,
              :screen_height,
              :gravity
  attr_reader :environment,
              :moveables,
              :font
  attr_accessor :background_path,
                :background_hard_borders
  
  def initialize
    setup_window
    setup_containers
    
    after_initialize
    
    super self.screen_width, self.screen_height, self.full_screen, 16
    
    setup_background
    setup_menu
    
    setup_steps
    setup_waves
    setup_scheduling
    setup_font
    
    setup_environment
    setup_enemies
    setup_players
    setup_collisions
    
    install_main_loop
  end
  
  def main_loop
    @main_loop ||= lambda do
      next_step
      # Step the physics environment SUBSTEPS times each update.
      #
      SUBSTEPS.times do
        remove_shapes!
        reset_forces
        move_all
        targeting
        handle_input
        step_physics
      end
    end
  end
  
  def install_main_loop
    @current_loop = main_loop
  end
  
  def show_menu
    suspend
  end
  
  def suspend
    return if @suspended
    @current_loop = @menu.loop
    @suspended = Time.now
    p "suspended"
  end
  def continue
    return unless @suspended
    @current_loop = main_loop
    @suspended = false
    p "continued"
  end
  
  def media_path
    @media_path || 'media'
  end
  def full_screen
    @full_screen || false
  end
  def font_name
    @font_name || Gosu::default_font_name
  end
  def font_size
    @font_size || 20
  end
  def damping
    @damping || 0.001
  end
  def caption
    @caption || ""
  end
  def screen_width
    @screen_width || DEFAULT_SCREEN_WIDTH
  end
  def screen_height
    @screen_height || DEFAULT_SCREEN_HEIGHT
  end
  def gravity_vector
    @gravity || @gravity = CP::Vec2.new(0, 0.98/SUBSTEPS)
  end
  
  class << self
    def gravity amount = 0.98
      InitializerHooks.register self do
        self.gravity = CP::Vec2.new 0, amount.to_f/SUBSTEPS
      end
    end
    def width value = DEFAULT_SCREEN_WIDTH
      InitializerHooks.register self do
        self.screen_width = value
      end
    end
    def height value = DEFAULT_SCREEN_HEIGHT
      InitializerHooks.register self do
        self.screen_height = value
      end
    end
    def caption text = ""
      InitializerHooks.register self do
        self.caption = text
      end
    end
    def damping amount = 0.0
      InitializerHooks.register self do
        self.damping = amount
      end
    end
    def font name = Gosu::default_font_name, size = 20
      InitializerHooks.register self do
        self.font_name = name
        self.font_size = size
      end
    end
    def background path, options = {}
      InitializerHooks.register self do
        self.background_path = path
        self.background_hard_borders = options[:hard_borders] || false
      end
    end
    def full_screen
      InitializerHooks.register self do
        self.full_screen = true
      end
    end
    def collisions &block
      raise "collisions are defined in a block" unless block_given?
      InitializerHooks.register self do
        @collision_definitions = block
      end
    end
  end
  
  def setup_menu
    @menu = Menu.new self
  end
  
  def setup_window
    self.caption = self.class.caption || ""
  end
  def setup_background
    @background_image = Gosu::Image.new self, File.join(Resources.root, self.background_path), self.background_hard_borders
  end
  def setup_containers
    @moveables = []
    @controls = []
    @remove_shapes = []
    @players = []
  end
  def setup_steps
    @step = 0
    @dt = 1.0 / 60.0
  end
  def setup_waves
    @waves = Waves.new self
  end
  def setup_scheduling
    @scheduling = Scheduling.new
  end
  def setup_font
    @font = Gosu::Font.new self, self.font_name, self.font_size
  end
  def setup_environment
    @environment = CP::Space.new
    class << @environment
      attr_accessor :window
    end
    @environment.window = self
    @environment.damping = -self.damping + 1 # recalculate the damping such that 0.0 has no damping.
  end
  
  # Override.
  #
  def setup_players; end
  def setup_enemies; end
  
  #
  #
  # Example:
  #   collisions do
  #     add_collision_func ...
  #
  def setup_collisions
    @environment.instance_eval &@collision_definitions
  end
  
  # Add controls for a player.
  #
  # Example:
  #   add_controls_for @player1, Gosu::Button::KbA => :left,
  #                              Gosu::Button::KbD => :right,
  #                              Gosu::Button::KbW => :full_speed_ahead,
  #                              Gosu::Button::KbS => :reverse,
  #                              Gosu::Button::Kb1 => :revive
  #
  def add_controls_for object
    @controls << Controls.new(self, object)
  end
  
  def next_step
    @step += 1
    @waves.check @step # TODO maybe the waves should move into the scheduling
    @scheduling.step
  end
  
  
  # Core methods used by the extensions "framework"
  #
  
  # The main loop.
  #
  # TODO implement hooks.
  #
  def update
    @current_loop.call
  end
  # Each step, this is called to handle any input.
  #
  def handle_input
    @controls.each &:handle
  end
  # Does a single step.
  #
  def step_physics
    # Perform the step over @dt period of time
    # For best performance @dt should remain consistent for the game
    @environment.step @dt
  end
  
  # Things unregister themselves here.
  #
  # Note: Use as follows in a Thing.
  #       
  #       def destroy
  #         threaded do
  #           5.times { sleep 0.1; animate_explosion }
  #           @window.unregister self
  #         end
  #       end
  #
  def unregister thing
    remove thing.shape
  end
  
  # Remove this shape the next turn.
  #
  # Note: Internal use. Use unregister to properly remove a moveable.
  #
  def remove shape
    @remove_shapes << shape
  end
  
  # Run some code at relative time <time>.
  #
  # Example:
  #   # Will destroy the object that calls this method
  #   # in 20 steps.
  #   #
  #   window.threaded 20 do
  #     destroy!
  #   end
  #
  def threaded time = 1, &code
    @scheduling.add time, &code
  end
  
  # Moves each moveable.
  #
  def move_all
    @moveables.each &:move
  end
  
  # Handles the targeting process.
  #
  def targeting
    @moveables.select { |m| m.respond_to? :target }.each do |gun|
      gun.target *@moveables.select { |m| m.kind_of? Enemy }
    end
  end
  
  
  
  
  # Utility Methods
  #
  
  # 
  #
  # Example:
  # * x, y = uniform_random_position
  #
  def uniform_random_position
    [rand(self.width), rand(self.height)]
  end
  
  #
  #
  # Example:
  #   imprint do
  #     circle x, y, radius, :fill => true, :color => :black
  #   end
  #
  def imprint &block
    @background_image.paint &block
  end
  
  # Randomly adds a Thing to a uniform random position.
  #
  def randomly_add type
    thing = type.new self
    thing.warp_to *uniform_random_position
    register thing
  end
  
  # Moveables register themselves here.
  #
  def register moveable
    @moveables << moveable
    moveable.add_to @environment
  end
  
  def remove_shapes!
    # This iterator makes an assumption of one Shape per Star making it safe to remove
    # each Shape's Body as it comes up
    # If our Stars had multiple Shapes, as would be required if we were to meticulously
    # define their true boundaries, we couldn't do this as we would remove the Body
    # multiple times
    # We would probably solve this by creating a separate @remove_bodies array to remove the Bodies
    # of the Stars that were gathered by the Player
    #
    # p @remove_shapes unless @remove_shapes.empty?
    @remove_shapes.each do |shape|
      @environment.remove_body shape.body
      @environment.remove_shape shape
      @moveables.delete_if { |moveable| moveable.shape == shape }
    end
    @remove_shapes.clear
  end
  
  def reset_forces
    # When a force or torque is set on a Body, it is cumulative
    # This means that the force you applied last SUBSTEP will compound with the
    # force applied this SUBSTEP; which is probably not the behavior you want
    # We reset the forces on the Player each SUBSTEP for this reason
    #
    # @player1.shape.body.reset_forces
    # @player2.shape.body.reset_forces
    # @player3.shape.body.reset_forces
    # @players.each { |player| player.shape.body.reset_forces }
  end
  
  # def revive player
  #   return if @moveables.find { |moveable| moveable == player }
  #   register player
  # end
  
  # Drawing methods
  #
  
  def draw
    draw_background
    draw_ambient
    draw_moveables
    draw_ui
  end
  def draw_background
    @background_image.draw 0, 0, Layer::Background, 1.0, 1.0 if @background_image
  end
  def draw_ambient
    
  end
  def draw_moveables
    @moveables.each &:draw
  end
  def draw_ui
    # @font.draw "P1 Score: ", 10, 10, ZOrder::UI, 1.0, 1.0, 0xffff0000
  end
  
  # Escape exits by default.
  #
  def button_down id
    close if exit?(id)
  end
  
  # Override exit? if you want to define another exit rule.
  #
  def exit? id = nil
    id == Gosu::Button::KbEscape
  end
  
end