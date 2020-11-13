require 'pry-nav'

# \copy (SELECT to_char(time, 'YYYY-MM') FROM postcode_capacities ORDER BY 1) To './gabrielle/postcode_capacities.csv' With CSV

def produce_query(table)
	puts "\\copy (SELECT to_char(time, 'YYYY-MM') FROM #{table} ORDER BY 1) To './gabrielle/#{table}.csv' With CSV"
end

tables = %w(combined_postcode_performances contributions four_digit_postcode_capacities outputs postcode_capacities pvoutput_postcode_performances school_measurements sma_combined_postcode_performances sma_postcode_performances sma_zipcode_capacities solar_analytics_postcode_performances total_demands utilisations)

=begin uncomment the following to produce queries to paste into psql console
tables.each do |table|
	produce_query(table)
end
=end

# downloading files
# scp -r xxxx@xxx.xxx.xxx.xx:/gabrielle ~/Downloads

# generating csv
def generate_csv_for_google_sheeets(csv_name)
  File.open(csv_name) do |raw_data|
    dates_in_year = File.readlines("./daterange.txt")
    new_filename = File.basename(csv_name, ".*") + "_sheety_weety.csv"
    pointer = 0

    data = raw_data.chunk{ |date| date }.to_h.transform_keys{|key| key.delete("\"").chomp}.transform_values{|value| value.length}

    File.open(new_filename,"w") do |sheets_csv|
      sheets_csv.puts("date,count")
      while pointer < dates_in_year.count 
       # data = {"2015-04" => 4, "2015-06" => 6}
       # dates_in_year = [2015-05, 2015-05, 2015-06]   
        date_filler = dates_in_year[pointer].chomp

        if data.has_key?(date_filler)
          sheets_csv.puts("#{date_filler},#{data[date_filler]}")
        else
          sheets_csv.puts("#{date_filler},0")
        end

        pointer +=1

      end
    end
  end
end

# for every file, csv_name, in the folder gabrielle,
# run generate_csv_for_google_sheeets(csv_name)

