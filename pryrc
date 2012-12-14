begin
  require 'hirb'
rescue LoadError
  # Missing hirb gem 😞
end

begin
  require 'factory_girl'
rescue LoadError
  # Missing factory_girl gem 😞
end

if defined? Hirb
  # Dirty hack to fully support in-session Hirb.disable/enable toggling
  Hirb::View.instance_eval do
    def enable_output_method
        @output_method = true
        @old_print = Pry.config.print
        Pry.config.print = proc do |output, value|
            Hirb::View.view_or_page_output(value) || @old_print.call(output, value)
        end
    end

    def disable_output_method
        Pry.config.print = @old_print
        @output_method = nil
    end
  end

  Hirb.enable
end

Pry.config.prompt = [
    proc do |obj, nest_level, pry|
        prompt = "[#{pry.input_array.size}]pry(#{obj}:#{nest_level})> "
    end,
    proc do |obj, nest_level, pry|
        prompt = "[#{pry.input_array.size}]pry(#{obj}:#{nest_level})* "
    end
]

if Pry.commands.commands.include? 'continue'
  Pry.commands.alias_command 'c', 'continue'
  Pry.commands.alias_command 's', 'step'
  Pry.commands.alias_command 'n', 'next'
  Pry.commands.alias_command 'f', 'finish'
end

if defined?(Rails) && defined?(FactoryGirl)
  puts "Here?"
  include FactoryGirl::Syntax::Methods
end
