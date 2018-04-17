def replace_skill_tag(freelancer, old, new)
  if freelancer.technical_skill_tags.include?(old)
    freelancer.technical_skill_tags.delete(old)
    if new
      freelancer.technical_skill_tags[new] = "1"
    end
    freelancer.save!
  end
end

def replace_job_market(freelancer, old, new, system_integration, live_events)
  if freelancer.job_markets.include?(old)
    freelancer.job_markets.delete(old)
    if live_events
      unless freelancer.job_types && freelancer.job_types.include?("live_events_staging_and_rental")
        freelancer.job_types["live_events_staging_and_rental"] = "1"
      end
    end
    if system_integration
      unless freelancer.job_types && freelancer.job_types.include?("system_integration")
        freelancer.job_types["system_integration"] = "1"
      end
    end
    if new
      freelancer.job_markets[new] = "1"
    end
    freelancer.save!
  end
end

def replace_job_function(freelancer, old, new, system_integration, live_events)
  if freelancer.job_functions.include?(old)
    freelancer.job_functions.delete(old)
    if live_events
      unless freelancer.job_types && freelancer.job_types.include?("live_events_staging_and_rental")
        freelancer.job_types["live_events_staging_and_rental"] = "1"
      end
    end
    if system_integration
      unless freelancer.job_types && freelancer.job_types.include?("system_integration")
        freelancer.job_types["system_integration"] = "1"
      end
    end
    if new
      freelancer.job_functions[new] = "1"
    end
    freelancer.save!
  end
end

Freelancer.all.each do |freelancer|
  p("Updating freelancer with id #{freelancer.id}")
  if !freelancer.technical_skill_tags.nil?
    replace_skill_tag(freelancer, "av_programming", "programming")
    replace_skill_tag(freelancer, "general_labor", "general_laborer")
    replace_skill_tag(freelancer, "stagehand", nil)
  end

  if !freelancer.job_markets.nil?
    replace_job_market(freelancer, "corporate", nil, false, false)
    replace_job_market(freelancer, "government", nil, false, false)
    replace_job_market(freelancer, "broadcast", "broadcast", true, false)
    replace_job_market(freelancer, "retail", "retail_installation", true, false)
    replace_job_market(freelancer, "house_of_worship", nil, false, false)
    replace_job_market(freelancer, "higher_education", "higher_education", true, false)
    replace_job_market(freelancer, "k12_education", "k12_education", true, false)
    replace_job_market(freelancer, "residential", "residential_installation", true, false)
    replace_job_market(freelancer, "commercial_av", "commercial_installation", true, false)
    replace_job_market(freelancer, "live_events_and_staging", nil, true, false)
    replace_job_market(freelancer, "rental", nil, true, false)
    replace_job_market(freelancer, "hospitality", "hospitality", true, false)
  end

  if !freelancer.job_functions.nil?
    replace_job_function(freelancer, "av_installation_technician", "installation_technician", true, false)
    replace_job_function(freelancer, "av_rental_and_staging_technician", "av_set_strike_technician", false, true)
    replace_job_function(freelancer, "av_programmer", "senior_programmer", true, false)
    replace_job_function(freelancer, "general_laborer", "general_laborer", false, true)
    replace_job_function(freelancer, "camera_operator", "camera", false, true)
    replace_job_function(freelancer, "projectionist", "projectionist", false, true)
    replace_job_function(freelancer, "project_manager", "project_manager_system_integration", true, false)
    replace_job_function(freelancer, "drafter", "drafter", true, false)
    replace_job_function(freelancer, "a1_audio_engineer", "a1_head_of_sound", false, true)
    replace_job_function(freelancer, "a2_audio_assist", "a2_sound_assist", false, true)
    replace_job_function(freelancer, "l1_lighting_engineer", "l1_head_of_lighting", false, true)
    replace_job_function(freelancer, "l2_lighting_assist", "l2_lighting_assist", false, true)
    replace_job_function(freelancer, "me_master_electrician", "master_electrician", false, true)
    replace_job_function(freelancer, "v1_video_engineer", "v1_head_of_video", false, true)
    replace_job_function(freelancer, "v2_video_assist", "v2_video_assist", false, true)
  end
  p("Finished updating freelancer with id #{freelancer.id}")
end
p("Done!")