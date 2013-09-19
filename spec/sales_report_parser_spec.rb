require 'itunes_ingestion'

describe ITunesIngestion::SalesReportParser do
  let (:data) { open(File.expand_path("../fixtures/report.txt", __FILE__)).read }
  
  it "parse report" do
    report = ITunesIngestion::SalesReportParser.parse(data)
    report.class.should == Array
    report.length.should == 2

    first_report = report.first
    first_report[:sku].should == "UT124500"
    first_report[:product_type_id].should == "10"
    first_report[:title].should == "App1"
    first_report[:begin_date].should == Date.new(2011, 2, 1)
    first_report[:country_code].should == "TW"
    first_report[:currency].should == "USD"
    first_report[:currency_of_proceeds].should == "USD"
  end
end
