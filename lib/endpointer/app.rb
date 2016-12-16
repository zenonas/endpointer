require 'sinatra/base'

module Endpointer
  class App < Sinatra::Base

    not_found do
      content_type 'application/json'
      JSON.generate({
        'error' => 'URL not configured. You need to configure all urls that Endpointer will listen to in your json file'
      })
    end

  end
end
