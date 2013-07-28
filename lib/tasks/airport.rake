require 'csv'

# The airports.dat CSV is formatted:
# Airport_ID, Name, City, Country, IATA/FAA code, ICAO code, Latitude, Longitude, Altitude, Timezone, DST
# Only need:
# Name, City, Country. IATA/FAA code, ICAO code, Latitude, Longitude, Altitude, Timezone, DST

namespace :airport do
  module Column
    Name = 1
    City = 2
    Country = 3
    Iata = 4
    Icao = 5
    Latitude = 6
    Longitude = 7
    Altitude = 8
    Timezone = 9
    DST = 10
  end

  desc "add airport data to database"
  task :add => :environment do
    puts "adding airports"
    CSV.foreach("lib/assets/airports.dat") do |row|
      airport = Airport.new(name: row[Column::Name], city: row[Column::City], country: row[Column::Country],
                            iata_code: row[Column::Iata], icao_code: row[Column::Icao], lat: row[Column::Latitude],
                            long: row[Column::Longitude], altitude: row[Column::Altitude], timezone: row[Column::Timezone],
                            dst: row[Column::DST])
      airport.save
    end
  end

  desc "updates the airport information"
  task :update => :environment do
    puts "updating airports"
    CSV.foreach("lib/assets/airports.dat") do |row|
      # grab an airport with the IATA/FAA code
      airport = Airport.where(iata_code: row[Column::Iata]).first

      # if such an airport exists, update its info
      if airport
        airport.update_attributes(name: row[Column::Name], city: row[Column::City], country: row[Column::Country],
                              icao_code: row[Column::Icao], lat: row[Column::Latitude], long: row[Column::Longitude],
                              altitude: row[Column::Altitude], timezone: row[Column::Timezone], dst: row[Column::DST])
      # else add the new airport
      else
        puts "adding #{row[Column::Name]} with code: #{row[Column::Iata]}"
        airport = Airport.new(name: row[Column::Name], city: row[Column::City], country: row[Column::Country],
                              iata_code: row[Column::Iata], icao_code: row[Column::Icao], lat: row[Column::Latitude],
                              long: row[Column::Longitude], altitude: row[Column::Altitude], timezone: row[Column::Timezone],
                              dst: row[Column::DST])
        airport.save
      end
    end
  end
end
