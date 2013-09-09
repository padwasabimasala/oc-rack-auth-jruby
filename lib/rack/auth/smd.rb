module Rack
  module Auth
    class SmD

      MS_PER_SECOND = 1000
      MS_PER_MINUTE = 60 * MS_PER_SECOND
      MS_PER_HOUR = 60 * MS_PER_MINUTE

      def initialize params = {}
        @int_range = params[:int_range] || (2 ** 16)
        @ms_per_unit = params[:ms_per_unit] || MS_PER_HOUR
      end

      def int_range
        @int_range
      end

      def ms_per_unit
        @ms_per_unit
      end
    end
  end
end