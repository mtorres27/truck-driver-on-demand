# frozen_string_literal: true

require 'csv'

class DriverTestImporter

  def self.import_tests(file_text)
    csv = CSV.parse(file_text, :headers => true)
    csv.each do |row|
      driver_test = DriverTest.where(name: row["Test Name"]).first_or_create
      TestQuestion.create!(
        driver_test: driver_test, 
        question: row["Question"],
        options: options_json_from_row(row)
      )
    end
  end

  private

  def self.options_json_from_row(row)
    options = []
    (1..7).each do |n|
      next if row["Option #{n}"].nil?
      options << { answer: row["Option #{n}"], correct: (row["Answer"] == n.to_s) }
    end
    options
  end

end
