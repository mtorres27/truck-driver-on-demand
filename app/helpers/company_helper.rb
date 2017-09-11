module CompanyHelper
  def company_avg_rating(company)
    if company.company_reviews_count == 0
      return []
    end

    c = company.rating
    c = Company.avg_rating(company)

    rating = (c*2.0).round / 2.0
    results = []
    5.times do |index|
      if rating >= 1
        results << "fa fa-star"
        rating -= 1
      elsif rating == 0
        results << "fa fa-star-o"
      elsif rating == 0.5
        results << "fa fa-star-half"
        rating -= 0.5
      end

      if rating < 0
        rating = 0
      end
    end

    return results
  end


  def company_ratings_link(company)
    "#{company.company_reviews_count} Review#{company.company_reviews_count == 1 ? '' : 's'}"
  end

  
  def is_favourite(company)
    favourites = current_freelancer.favourites.where({company_id: company.id})

    if favourites.count == 0
      return false
    else
      return true
    end

  end


  def is_showing_company(path)
    if request.path.include?(freelancer_companies_path) && !request.path.include?("worked_for") && !request.path.include?("favourites")
      true
    else
      false
    end
  end


  def distance_from(company)
    return (((company.distance / 1609.344)*10.0)/10.0).round(2)
  end
end