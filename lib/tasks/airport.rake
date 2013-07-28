require 'csv'

# The airports.dat CSV is formatted:
# Airport_ID, Name, City, Country, IATA/FAA code, ICAO code, Latitude, Longitude, Altitude, Timezone, DST
# Only need:
# Name, City, Country. IATA/FAA code, ICAO code, Latitude, Longitude, Altitude, Timezone, DST

namespace :airport do
  module AirportColumn
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
      airport = Airport.new(name: row[AirportColumn::Name], city: row[AirportColumn::City], country: row[AirportColumn::Country],
                            iata_code: row[AirportColumn::Iata], icao_code: row[AirportColumn::Icao], lat: row[AirportColumn::Latitude],
                            long: row[AirportColumn::Longitude], altitude: row[AirportColumn::Altitude], timezone: row[AirportColumn::Timezone],
                            dst: row[AirportColumn::DST])
      airport.save
    end
  end

  desc "updates the airport information"
  task :update => :environment do
    puts "updating airports"
    CSV.foreach("lib/assets/airports.dat") do |row|
      # grab an airport with the IATA/FAA code
      airport = Airport.where(iata_code: row[AirportColumn::Iata]).first

      # if such an airport exists, update its info
      if airport
        airport.update_attributes(name: row[AirportColumn::Name], city: row[AirportColumn::City], country: row[AirportColumn::Country],
                              icao_code: row[AirportColumn::Icao], lat: row[AirportColumn::Latitude], long: row[AirportColumn::Longitude],
                              altitude: row[AirportColumn::Altitude], timezone: row[AirportColumn::Timezone], dst: row[AirportColumn::DST])
      # else add the new airport
      else
        puts "adding #{row[AirportColumn::Name]} with code: #{row[AirportColumn::Iata]}"
        airport = Airport.new(name: row[AirportColumn::Name], city: row[AirportColumn::City], country: row[AirportColumn::Country],
                              iata_code: row[AirportColumn::Iata], icao_code: row[AirportColumn::Icao], lat: row[AirportColumn::Latitude],
                              long: row[AirportColumn::Longitude], altitude: row[AirportColumn::Altitude], timezone: row[AirportColumn::Timezone],
                              dst: row[AirportColumn::DST])
        airport.save
      end
    end
  end
end
