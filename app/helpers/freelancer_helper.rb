module FreelancerHelper
  
  def freelancer_avg_rating(freelancer)
    if freelancer.freelancer_reviews_count == 0
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


  def freelancer_ratings_link(freelancer)
    "#{freelancer.freelancer_reviews_count} Review#{freelancer.freelancer_reviews_count == 1 ? '' : 's'}"
  end


  def self.round_point5
    (self.to_f*2.0).round / 2.0
  end


  def is_favourite(freelancer)
    favourites = current_company.favourites.where({freelancer_id: freelancer.id})

    if favourites.count == 0
      return false
    else
      return true
    end

  end

  def is_verified(freelancer)
    return freelancer.verified
  end

  def is_showing_freelancer(path)
    if request.path.include?(company_freelancers_path) && !request.path.include?("hired") && !request.path.include?("favourites")
      true
    else
      false
    end
  end

  RAD_PER_DEG = Math::PI / 180
  RM = 6371000 # Earth radius in meters

  def distance_from(freelancer)
    return (((freelancer.distance / 1609.344)*10.0)/10.0).round(2)
  end


  def calc_distance(lat1, lat2, lon1, lon2)
    if (lat1.nil? or lat2.nil? or lon1.nil? or lon2.nil?)
      return "N/A"
    end

    lat1_rad, lat2_rad = lat1 * RAD_PER_DEG, lat2 * RAD_PER_DEG
    lon1_rad, lon2_rad = lon1 * RAD_PER_DEG, lon2 * RAD_PER_DEG

    a = Math.sin((lat2_rad - lat1_rad) / 2) ** 2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin((lon2_rad - lon1_rad) / 2) ** 2
    c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1 - a))

    @meters = RM * c 
    @miles = @meters/1609.344

    @rounded_miles = ((@miles*10.0).round)/10.0
  end
end