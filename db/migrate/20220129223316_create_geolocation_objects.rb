class CreateGeolocationObjects < ActiveRecord::Migration[7.0]
  def change
    create_table :geolocation_objects do |t|
      t.string :url
      t.string :ip, null: false
      t.string :ip_type
      t.float :latitude
      t.float :longitude
      t.string :continent_code
      t.string :continent_name
      t.string :country_code
      t.string :country_name
      t.string :region_code
      t.string :region_name
      t.string :city
      t.integer :zip

      t.timestamps
    end
  end
end
