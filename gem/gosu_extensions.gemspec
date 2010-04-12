# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{gosu_extensions}
  s.version = "0.2.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Florian Hanke"]
  s.date = %q{2010-04-12}
  s.description = %q{}
  s.email = %q{florian.hanke@gmail.com}
  s.files = [
    "Rakefile",
     "VERSION",
     "generator/gogogosu.rb",
     "lib/core/collision.rb",
     "lib/core/control.rb",
     "lib/core/controls.rb",
     "lib/core/environment.rb",
     "lib/core/game_window.rb",
     "lib/core/initializer_hooks.rb",
     "lib/core/it_is_a.rb",
     "lib/core/layer.rb",
     "lib/core/moveables.rb",
     "lib/core/remove_shapes.rb",
     "lib/core/resources.rb",
     "lib/core/scheduling.rb",
     "lib/core/trait.rb",
     "lib/core/traits.rb",
     "lib/core/vector_utilities.rb",
     "lib/core/wave.rb",
     "lib/core/waves.rb",
     "lib/extensions/module.rb",
     "lib/extensions/numeric.rb",
     "lib/gosu_extensions.rb",
     "lib/traits/attachable.rb",
     "lib/traits/controllable.rb",
     "lib/traits/damaging.rb",
     "lib/traits/generator.rb",
     "lib/traits/hitpoints.rb",
     "lib/traits/imageable.rb",
     "lib/traits/lives.rb",
     "lib/traits/moveable.rb",
     "lib/traits/pod.rb",
     "lib/traits/shooter.rb",
     "lib/traits/short_lived.rb",
     "lib/traits/shot.rb",
     "lib/traits/targetable.rb",
     "lib/traits/targeting.rb",
     "lib/traits/targeting/closest.rb",
     "lib/traits/turnable.rb",
     "lib/units/sprite.rb",
     "lib/units/thing.rb"
  ]
  s.homepage = %q{http://www.github.com/floere/gosu_extensions}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Default extensions built onto the popular Gosu Framework. Uses Chipmunk for game physics. That's it for now. I'm working on them. Anyway, GAME ON!}
  s.test_files = [
    "spec/lib/core/collision_spec.rb",
     "spec/lib/core/control_spec.rb",
     "spec/lib/core/controls_spec.rb",
     "spec/lib/core/initializer_hooks_spec.rb",
     "spec/lib/core/it_is_a_spec.rb",
     "spec/lib/core/layer_spec.rb",
     "spec/lib/core/moveables_spec.rb",
     "spec/lib/core/remove_shapes_spec.rb",
     "spec/lib/core/trait_spec.rb",
     "spec/lib/core/traits_spec.rb",
     "spec/lib/extensions/module_spec.rb",
     "spec/lib/extensions/numeric_spec.rb",
     "spec/lib/traits/attachable_spec.rb",
     "spec/lib/traits/controllable_spec.rb",
     "spec/lib/traits/damaging_spec.rb",
     "spec/lib/traits/imageable_spec.rb",
     "spec/lib/traits/shooter_spec.rb",
     "spec/lib/traits/short_lived_spec.rb",
     "spec/lib/traits/shot_spec.rb",
     "spec/lib/traits/targetable_spec.rb",
     "spec/lib/traits/targeting_spec.rb",
     "spec/lib/traits/turnable_spec.rb",
     "spec/lib/units/thing_spec.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<gosu>, [">= 0"])
      s.add_runtime_dependency(%q<chipmunk>, [">= 0"])
    else
      s.add_dependency(%q<gosu>, [">= 0"])
      s.add_dependency(%q<chipmunk>, [">= 0"])
    end
  else
    s.add_dependency(%q<gosu>, [">= 0"])
    s.add_dependency(%q<chipmunk>, [">= 0"])
  end
end

