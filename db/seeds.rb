# frozen_string_literal: true
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

admin                       = Admin.new
admin.first_name            = 'Tamer'
admin.last_name             = 'Ibrahim'
admin.phone_number          = '1234567890'
admin.email                 = 'tamer@truckker.com'
admin.password              = 'password'
admin.password_confirmation = 'password'
admin.save!

driver = Driver.new
driver.first_name               = 'Truck'
driver.last_name                = 'Driver'
driver.phone_number             = '1234567891'
driver.email                    = 'driver@truckker.com'
driver.password                 = 'password'
driver.password_confirmation    = 'password'
driver.save!AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?