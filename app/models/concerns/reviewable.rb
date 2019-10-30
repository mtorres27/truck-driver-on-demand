# frozen_string_literal: true

module Reviewable

  extend ActiveSupport::Concern

  included do |base|
    base::RATING_ATTRS.each do |attr|
      validates attr, inclusion: { in: 1..5, message: "Please select a rating." }
    end

    def average
      (base::RATING_ATTRS.reduce(0) do |sum, attr|
        sum + send(attr)
      end.to_f / base::RATING_ATTRS.length).round
    end
  end

end
