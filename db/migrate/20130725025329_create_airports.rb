class CreateAirports < ActiveRecord::Migration
  def change
    create_table :airports do |t|
      t.string :name
      t.string :city
      t.string :country
      t.string :iata_code
      t.string :icao_code
      t.float :lat
      t.float :long
      t.integer :altitude
      t.float :timezone
      t.string :dst

      t.timestamps
    end
  end
end
