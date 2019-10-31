# frozen_string_literal: true

require "net/http"

class GeocoderJob < ApplicationJob

  queue_as :default

  def perform(obj)
    obj.do_geocode
  end

end
