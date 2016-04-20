# Handling errors form Google
module GoogleMapsGeocoderErrorHandler
  # Parent class for more concrete errors
  class GeneralGoecodingError < StandardError
    def initialize(response_json = '')
      @json = response_json
      super
    end

    def message
      "Google returned:\n#{@json.inspect}"
    end
  end

  class ZeroResultsError < GeneralGoecodingError; end
  class QueryLimitError < GeneralGoecodingError; end
end
