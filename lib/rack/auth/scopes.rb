module Rack
  module Auth
    class Scopes

      def initialize scope_string = ""
        @scopes = scope_string_to_hash scope_string
      end

      private

      def scope_string_to_hash scope_string
        array_to_ordinal_hash(split_scope_string(scope_string))
      end

      def split_scope_string scope_string
        scope_string.split(',').map(&:strip).reject(&:empty?)
      end

      def array_to_ordinal_hash array
        hash = Hash.new
        array.each_with_index { |k, i| hash[k] = i }
        hash
      end
    end
  end
end