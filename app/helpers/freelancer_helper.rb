module FreelancerHelper

  def freelancer_avg_rating(freelancer)
    if freelancer.freelancer_reviews.count == 0
      return []
    end

    f = Freelancer.avg_rating(freelancer)

    rating = (f*2.0).round / 2.0
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


  def company_avg_rating(company)
    if company.company_reviews.count == 0
      return []
    end

    # f = Freelancer.avg_rating(freelancer)
    # f = 3

    c = company.rating
    c = Company.avg_rating(company)

    rating = (c*2.0).round / 2.0

    results = []
    5.times do |index|
      if rating >= 1
        results << "zmdi zmdi-star"
        rating -= 1
      elsif rating == 0
        results << "zmdi zmdi-star-outline"
      elsif rating == 0.5
        results << "zmdi zmdi-star-half"
        rating -= 0.5
      end

      if rating < 0
        rating = 0
      end
    end

    return results
  end


  def freelancer_ratings_link(freelancer)
    "#{freelancer.freelancer_reviews.count} Review#{freelancer.freelancer_reviews.count == 1 ? '' : 's'}"
  end


  def is_favourite(freelancer)
    favourites = current_company.favourites.where(freelancer_id: freelancer.id)

    if favourites.count == 0
      return false
    else
      return true
    end

  end

  def is_verified(freelancer)
    return freelancer.freelancer_profile.verified
  end

  def is_showing_freelancer(path)
    if request.path.include?(company_freelancers_path) && !request.path.include?("hired") && !request.path.include?("favourites")
      true
    else
      false
    end
  end

  def distance_from(freelancer, freelancer_profiles_with_distances)
    return (((freelancer_profiles_with_distances.where(freelancer_id: freelancer.id).first.distance / 1609.344)*10.0)/10.0).round(2) if freelancer_profiles_with_distances.present?
  end


end
