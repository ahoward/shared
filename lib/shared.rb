# shared.rb provides a super easy way to share code between classes or modules
# in a simple way.  shared code can be at the class and/or instance level and
# users deferred evaluation so this is more powerful that the normal ruby
# module inclusion facilities on which it is based.
#
# basic usage:
#
#
#   require 'shared'
#   
#   Shared 'methods' do
#     class << self
#       attr :classname
#     end
#   
#     @classname = name.downcase
#   
#     def objectname
#       self.class.classname + "(#{ object_id })"
#     end
#   end    
#   
#   class C
#     include Shared('methods')
#   end
#   
#   class B
#     include Shared('methods')
#   end
#   
#   p C.classname      #=> 'c'
#   p C.new.objectname #=> 'c(1234)'
#   
#   p B.classname      #=> 'b'
#   p B.new.objectname #=> 'b(4567)'
#   


unless defined?(Shared)
  module Shared
    Shared::VERSION = '1.1.1' unless defined?(Shared::VERSION)
    def version() Shared::VERSION end

    def Shared.description
      'a clean way to factor class/instance mixins in ruby'
    end

    Code = {}

    def load key
      key = key_for(key)
      unless Code.has_key?(key)
        ::Kernel.load("shared/#{ key }.rb")
      end
    end

    def shared name, options = {}, &block
      key = key_for name
      via = (options[:via]||options['via']||:eval).to_s.to_sym

      if block.nil?
        Shared.load(key)
        return Code[key] 
      end

      m = (Code[key] || Module.new)

      case via
        when :eval
          singleton_class(m) do
            unless m.respond_to?(:blocks)
              blocks = []

              define_method(:blocks){ blocks }

              define_method(:included) do |other|
                blocks.each{|b| other.send(:module_eval, &b)}
              end

              define_method(:extend_object) do |other|
                Shared.singleton_class(other) do
                  m.blocks.each{|b| module_eval &b}
                end
              end
            end
          end
          m.blocks << block

        when :module
          m.send(:module_eval, &block)
      end

      Code[key] ||= m
    end
    
    alias_method 'share', 'shared'
    alias_method 'for', 'shared'

    def key_for name
      name.to_s.strip.downcase
    end

    def singleton_class object, &block
      singleton_class =
        class << object
          self
        end
      block ? singleton_class.module_eval(&block) : singleton_class
    end

    extend self
  end

  module Kernel
  private
    def Share(*a, &b)
      if a.empty? and b.nil?
        ::Shared
      else
        Shared.share(*a, &b)
      end
    end

    def Shared(*a, &b)
      if a.empty? and b.nil?
        ::Shared
      else
        Shared.shared(*a, &b)
      end
    end
  end
end
