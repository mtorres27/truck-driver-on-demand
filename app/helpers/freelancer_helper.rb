# frozen_string_literal: true

module FreelancerHelper

  def freelancer_avg_rating(freelancer)
    return [] if freelancer.freelancer_reviews.count.zero?

    f = Freelancer.avg_rating(freelancer)

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

    # f = Freelancer.avg_rating(freelancer)
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

  def freelancer_ratings_link(freelancer)
    "#{freelancer.freelancer_reviews.count} Review#{freelancer.freelancer_reviews.count == 1 ? '' : 's'}"
  end

  def favourite?(freelancer)
    favourites = current_company.freelancers.where(id: freelancer.id)

    !favourites.count.zero?
  end

  def verified?(freelancer)
    freelancer.freelancer_profile.verified
  end

  def distance_from(freelancer, freelancer_profiles_with_distances)
    return unless freelancer_profiles_with_distances.present?

    # rubocop:disable Metrics/LineLength
    (((freelancer_profiles_with_distances.where(freelancer_id: freelancer.id).first.distance / 1609.344) * 10.0) / 10.0).round(2)
    # rubocop:enable Metrics/LineLength
  end

  def hash_id(freelancer)
    hashids = Hashids.new(ENV["hash_ids_salt"], 8)
    hashids.encode(freelancer.id)
  end

  def payment_rate(freelancer)
    return unless freelancer.freelancer_profile&.pay_rate.present?

    if freelancer.freelancer_profile&.pay_unit_time_preference == :hourly
      "#{number_to_currency(freelancer.freelancer_profile.pay_rate)}/hour"
    elsif freelancer.freelancer_profile&.pay_unit_time_preference == :daily
      "#{number_to_currency(freelancer.freelancer_profile.pay_rate)}/day"
    end
  end

end
