# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

GeolocationObject.create(
  ip: "84.254.92.149",
  ip_type: "ipv4",
  continent_code: "EU",
  continent_name: "Europe",
  country_code: "CH",
  country_name: "Switzerland",
  region_code: "ZH",
  region_name: "Zurich",
  city: "Zürich",
  zip: 8048,
  latitude: 47.38486099243164,
  longitude: 8.477149963378906
)

GeolocationObject.create(
  url: "professional.ch",
  ip: "34.65.137.34",
  ip_type: "ipv4",
  continent_code: "EU",
  continent_name: "Europe",
  country_code: "CH",
  country_name: "Switzerland",
  region_code: "ZH",
  region_name: "Zurich",
  city: "Zürich",
  zip: 8043
)

GeolocationObject.create(
  url: "momslearntocode.com",
  ip: "185.199.109.153",
  ip_type: "ipv4",
  continent_code: "NA",
  continent_name: "North America",
  country_code: "US",
  country_name: "United States",
  region_code: "CA",
  region_name: "California",
  city: "San Francisco",
  zip: 94107
)