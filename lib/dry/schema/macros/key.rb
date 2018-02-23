require 'dry/schema/macros/core'
require 'dry/schema/macros/each'
require 'dry/schema/macros/maybe'

module Dry
  module Schema
    module Macros
      class Key < Core
        option :name

        def each(*args, &block)
          macro = Each.new
          macro.value(*args, &block)
          trace << macro
          self
        end

        def maybe(*args, **opts, &block)
          macro = Maybe.new
          macro.value(*args, **opts, &block)
          trace << macro
          self
        end

        def to_rule
          if trace.nodes.empty?
            super
          else
            [super, trace.to_rule(name)].reduce(operation)
          end
        end

        def to_ast
          [:predicate, [:key?, [[:name, name], [:input, Undefined]]]]
        end
      end
    end
  end
end
