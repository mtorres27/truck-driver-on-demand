# frozen_string_literal: true

module DriverHelper

  def driver_avg_rating(driver)
    return [] if driver.driver_reviews.count.zero?

    f = Driver.avg_rating(driver)

    rating = (f * 2.0).round / 2.0
    results = []
    5.times do |_index|
      if rating >= 1
        results << "fa fa-star"
        rating -= 1
      elsif rating.zero?
        results << "fa fa-star-o"
      elsif rating == 0.5
        results << "fa fa-star-half"
        rating -= 0.5
      end

      rating = 0 if rating.negative?
    end

    results
  end

  def company_avg_rating(company)
    return [] if company.company_reviews.count.zero?

    # f = Driver.avg_rating(driver)
    # f = 3

    c = Company.avg_rating(company)

    rating = (c * 2.0).round / 2.0

    results = []
    5.times do |_index|
      if rating >= 1
        results << "zmdi zmdi-star"
        rating -= 1
      elsif rating.zero?
        results << "zmdi zmdi-star-outline"
      elsif rating == 0.5
        results << "zmdi zmdi-star-half"
        rating -= 0.5
      end

      rating = 0 if rating.negative?
    end

    results
  end

  def driver_ratings_link(driver)
    "#{driver.driver_reviews.count} Review#{driver.driver_reviews.count == 1 ? '' : 's'}"
  end

  def favourite?(driver)
    favourites = current_company.drivers.where(id: driver.id)

    !favourites.count.zero?
  end

  def verified?(driver)
    driver.driver_profile.verified
  end

  def distance_from(driver, driver_profiles_with_distances)
    return unless driver_profiles_with_distances.present?

    (((driver_profiles_with_distances.where(driver_id: driver.id).first.distance / 1609.344) * 10.0) / 10.0).round(2)
  end

  def hash_id(driver)
    hashids = Hashids.new(ENV["hash_ids_salt"], 8)
    hashids.encode(driver.id)
  end

  def payment_rate(driver)
    return unless driver.driver_profile&.pay_rate.present?

    if driver.driver_profile&.pay_unit_time_preference == :hourly
      "#{number_to_currency(driver.driver_profile.pay_rate)}/hour"
    elsif driver.driver_profile&.pay_unit_time_preference == :daily
      "#{number_to_currency(driver.driver_profile.pay_rate)}/day"
    end
  end

end
