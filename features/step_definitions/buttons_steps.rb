When("I press {string}") do |label|
  click_on label
end

When("I check {string}") do |checkbox_label_or_id|
  check checkbox_label_or_id
end
