require_relative '../lib/converter.rb'
require_relative '../lib/data_provider.rb'
require_relative '../lib/data_utils.rb'

require 'rspec'
require 'webmock/rspec'
require 'json'

shared_context 'shared stub data', :a => :b do
  before do
    @stub_raw_data = [
      {"Cur_Abbreviation"=>"USD","Cur_Scale"=>1,"Cur_Name"=>"Доллар США","Cur_OfficialRate"=>2.3898},
      {"Cur_Abbreviation"=>"EUR","Cur_Scale"=>1,"Cur_Name"=>"Евро","Cur_OfficialRate"=>2.7711},
      {"Cur_Abbreviation"=>"PLN","Cur_Scale"=>10,"Cur_Name"=>"Злотых","Cur_OfficialRate"=>6.2861}
    ]

    @stub_data = {
      "USD"=>{"Cur_Scale"=>1,"Cur_Name"=>"Доллар США","Cur_OfficialRate"=>2.3898},
      "EUR"=>{"Cur_Scale"=>1,"Cur_Name"=>"Евро","Cur_OfficialRate"=>2.7711},
      "PLN"=>{"Cur_Scale"=>10,"Cur_Name"=>"Злотых","Cur_OfficialRate"=>6.2861}
    }
  end
end
