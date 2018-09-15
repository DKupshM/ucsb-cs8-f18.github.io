module GitHubPages
  module HealthCheck
    class Checkable

      # Array of symbolized methods to be included in the output hash
      HASH_METHODS = []

      def check!
        raise "Not implemented"
      end
      alias_method :valid!, :check!

      # Runs all checks, returns true if valid, otherwise false
      def valid?
        check!
        true
      rescue GitHubPages::HealthCheck::Error
        false
      end

      # Returns the reason the check failed, if any
      def reason
        check!
        nil
      rescue GitHubPages::HealthCheck::Error => e
        e
      end

      def to_hash
        @hash ||= begin
          hash = {}
          self.class::HASH_METHODS.each do |method|
            hash[method] = public_send(method)
          end
          hash
        end
      end
      alias_method :[], :to_hash
      alias_method :to_h, :to_hash

      def to_json
        require 'json'
        to_hash.to_json
      end

      def to_s
        printer.simple_string
      end

      def to_s_pretty
        printer.pretty_print
      end
      alias_method :pretty_print, :to_s_pretty

      private

      def printer
        @printer ||= GitHubPages::HealthCheck::Printer.new(self)
      end
    end
  end
end
