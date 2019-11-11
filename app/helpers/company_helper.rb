# frozen_string_literal: true

module CompanyHelper

  def company_avg_rating(company)
    return [] if company.company_reviews.count.zero?

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

  def company_ratings_link(company)
    "#{company.company_reviews.count} Review#{company.company_reviews.count == 1 ? '' : 's'}"
  end

  def _favourite?(company)
    favourites = current_user.favourite_companies.where(company_id: company.id)

    !favourites.count.zero?
  end

  def favourite_company?(company)
    favourites = current_user.company_favourites.where(company_id: company.id)

    !favourites.count.zero?
  end

  def showing_company?(_path)
    # rubocop:disable Metrics/LineLength
    request.path.include?(driver_companies_path) && !request.path.include?("av_companies") && !request.path.include?("favourites")
    # rubocop:enable Metrics/LineLength
  end

  def distance_from(company, company_datas_with_distances)
    return unless company_datas_with_distances.present?

    (((company_datas_with_distances.where(company_id: company.id).first.distance / 1609.344) * 10.0) / 10.0).round(2)
  end

end
