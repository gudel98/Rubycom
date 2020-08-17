# frozen_string_literal: true

# Data manipulation utilities
module DataUtils
  require 'open-uri'
  require 'net/http'
  require 'json'
  require 'csv'

  private

  def get_raw_json(source)
    json = URI.open(source).read
    # json = Net::HTTP.get(URI(source))
    JSON.parse(json.to_s)
  end

  def hash_to_json_file(hash, path)
    File.open("#{path}/data.json", 'w') do |f|
      f.write(JSON.pretty_generate(hash))
    end
  end

  def raw_json_to_csv_file(raw_json, path)
    CSV.open("#{path}/data.csv", 'wb') do |csv|
      csv << %w[Cur_Abbreviation Cur_Scale Cur_Name Cur_OfficialRate]
      raw_json.each do |elem|
        csv << [
          elem['Cur_Abbreviation'],
          elem['Cur_Scale'],
          elem['Cur_Name'],
          elem['Cur_OfficialRate']
        ]
      end
    end
  end
end
