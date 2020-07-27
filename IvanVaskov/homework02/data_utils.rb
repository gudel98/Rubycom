module DataUtils
  require 'open-uri'
  require 'json'
  require 'csv'

  def get_raw_json(source =
    'https://www.nbrb.by/api/exrates/rates?periodicity=0')

    json = URI.open(source).read
    JSON.parse(json)
  end


  def hash_to_json_file(hash)
    File.open(File.dirname(__FILE__) + "/data.json","w") { |f| f.write(hash.to_json) }
  end

  def raw_json_to_csv_file(raw_json)
    CSV.open(File.dirname(__FILE__) + "/data.csv", 'wb') do |csv|
      csv << ['Cur_Abbreviation', 'Cur_Scale', 'Cur_Name', 'Cur_OfficialRate']
      raw_json.each do |elem|
        csv << [
          elem['Cur_Abbreviation'],
          elem['Cur_Scale'],
          elem['Cur_Name'],
          elem['Cur_OfficialRate']]
      end
    end
  end
end
