module DataUtils
  require 'open-uri'
  require 'json'
  require 'csv'

  def get_raw_json(source)

    json = URI.open(source).read
    JSON.parse(json)
  end


  def hash_to_json_file(hash, path)
    File.open("#{path}/data.json","w") { |f| f.write(hash.to_json) }
  end


  def raw_json_to_csv_file(raw_json, path)
    CSV.open("#{path}/data.csv", 'wb') do |csv|
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
