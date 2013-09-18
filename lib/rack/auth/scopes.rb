module Rack
  module Auth
    class Scopes

      def initialize scope_string = ""
        @scope_array = scope_string_to_array scope_string
        @scope_map = scope_array_to_hash @scope_array
      end

      def has_scope? scope
        @scope_map.has_key? scope
      end

      def has_scopes? scopes
        return false if scopes.nil?
        array = clean_scope_array scopes
        return false if array.empty?
        array.each { |s| return false if !has_scope?(s) }
        true
      end

      private

      def clean_scope_array array
        array.to_a.map(&:strip).reject(&:empty?)
      end

      def scope_string_to_array scope_string
        clean_scope_array scope_string.split(/[ ,;:]/)
      end

      def scope_array_to_hash array
        hash = Hash.new
        array.each_with_index { |k, i| hash[k] = i }
        hash
      end
    end
  end
end