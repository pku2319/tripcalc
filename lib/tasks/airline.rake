require 'csv'

# The airlines.dat CSV is formatted:
# Airline_ID, Name, Alias, IATA/FAA code, ICAO code, Callsign, Country, Active
# Note for active: "Y" if the airline is or has until recently been operational, "N" if it is defunct.
# This field is not reliable: in particular, major airlines that stopped flying long ago, but have not
# had their IATA code reassigned (eg. Ansett/AN), will incorrectly show as "Y".

# Only need:
# Name, Alias, IATA/FAA code, ICAO code, Callsign, Country, Active

namespace :airline do
  module AirlineColumn
    Name = 1
    Alias = 2
    Iata = 3
    Icao = 4
    Callsign = 5
    Country = 6
    Active = 7
  end

  desc "adding airlines for the first time"
  task :add => :environment do
    puts "adding airlines"
    CSV.foreach("lib/assets/airlines.dat") do |row|
      airline = Airline.new(name: row[AirlineColumn::Name], airline_alias: row[AirlineColumn::Alias], country: row[AirlineColumn::Country],
                            iata_code: row[AirlineColumn::Iata], icao_code: row[AirlineColumn::Icao], callsign: row[AirlineColumn::Callsign],
                            active: row[AirlineColumn::Active] == 'Y' ? 1 : 0)
      airline.save
    end
  end

  desc "updates the airline information"
  task :update => :environment do
    puts "updating airlines"
    CSV.foreach("lib/assets/airlines.dat") do |row|
      # grab an airline with the IATA/FAA code
      airline = Airline.where(iata_code: row[AirlineColumn::Iata]).first

      # if such an airline exists, update its info
      if airline
        airline.update_attributes(name: row[AirlineColumn::Name], airline_alias: row[AirlineColumn::Alias], country: row[AirlineColumn::Country],
                              icao_code: row[AirlineColumn::Icao], callsign: row[AirlineColumn::Callsign], active: row[AirlineColumn::Active] == 'Y' ? 1 : 0)
      # else add the new airline
      else
        puts "adding #{row[AirlineColumn::Name]} with code: #{row[AirlineColumn::Iata]}"
        airline = Airline.new(name: row[AirlineColumn::Name], airline_alias: row[AirlineColumn::Alias], country: row[AirlineColumn::Country],
                              iata_code: row[AirlineColumn::Iata], icao_code: row[AirlineColumn::Icao], callsign: row[AirlineColumn::Callsign],
                              active: row[AirlineColumn::Active] == 'Y' ? 1 : 0)
        airline.save
      end
    end
  end

end
