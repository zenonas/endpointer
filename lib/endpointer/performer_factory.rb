require 'endpointer/performers'
require 'endpointer/errors/performer_not_found_error'

module Endpointer
  class PerformerFactory

    PERFORMERS = {
      get: Endpointer::Performers::Get
    }

    def self.create(method)
      PERFORMERS.fetch(method) {
        raise Endpointer::Errors::PerformerNotFoundError.new 'The method you selected has no performer to execute it. Make sure you only use supported methods'
      }.new
    end
  end
end
