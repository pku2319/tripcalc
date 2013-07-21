class CreateAirlines < ActiveRecord::Migration
  def change
    create_table :airlines do |t|
      t.string :name
      t.string :airline_alias
      t.string :iata_code
      t.string :icao_code
      t.string :callsign
      t.string :country
      t.boolean :active

      t.timestamps
    end
  end
end
