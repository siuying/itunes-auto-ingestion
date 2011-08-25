require 'rest-client'
require 'zlib'
class AutoIngestion
  attr_reader :response

  BASE_URL = "https://reportingitc.apple.com/autoingestion.tft?"
  
  REPORT_TYPE_SALES = "Sales"
  DATE_TYPE_DAILY = "Daily"
  DATE_TYPE_WEEKLY = "Weekly"
  
  REPORT_SUMMARY = "Summary"
  REPORT_OPT_IN = "Opt-In"
  
  PRODUCT_TYPE_IDENTIFIER = {
    "1" => "Free or Paid Apps, iPhone and iPod Touch",
    "7" => "Updates, iPhone and iPod Touch",
    "IA1" => "In Apps Purchase",
    "IA9" => "In Apps Subscription",
    "IAY" => "Auto-Renewable Subscription",
    "1F" => "Free or Paid Apps (Universal)",
    "7F" => "Updates (Universal)",
    "1T" => "Free or Paid Apps, iPad",
    "7T" => "Updates, iPad",
    "F1" => "Free or Paid Apps, Mac OS",
    "F7" => "Updates, Mac OS",    
    "FI1" => "In Apps Purchase, Mac OS",
    "1E" => "Custome iPhone and iPod Touch",
    "1EP" => "Custome iPad",
    "1EU" => "Custome Universal"    
  }
  
  def initialize(username, password, vadnumber)
    @username = username
    @password = password
    @vadnumber = vadnumber
  end

  def fetch(options={})
    params = {
      :USERNAME => @username, :PASSWORD => @password, :VNDNUMBER => @vadnumber
    }
    params[:TYPEOFREPORT] = options[:type_of_report] || REPORT_TYPE_SALES
    params[:DATETYPE] = options[:date_type] || DATE_TYPE_DAILY
    params[:REPORTTYPE] = options[:report_type] || REPORT_SUMMARY
    params[:REPORTDATE] = options[:report_date] || (Time.now-60*60*24).strftime("%Y%m%d")

    @response = RestClient.post BASE_URL, params
    if @response.headers[:"errormsg"]
      raise @response.headers[:"errormsg"]
    elsif @response.headers[:"filename"]
      report = Zlib::GzipReader.new(StringIO.new(@response.body)).read
      parse_report(report)
    else
      nil
    end
  end

  private
  def parse_report(report)
    lines = report.split("\n")
    header = lines.shift # remove first line 
    lines.collect do |line|
      provider, country, sku, developer, title, version, product_type_id, units, developer_proceeds, begin_date, end_date, currency, country_code, currency_of_proceeds, apple_id, customer_price, promo_code, parent_id, subscription, period = line.split("\t")
      {
        :provider => provider.strip, 
        :country => country.strip, 
        :sku => sku.strip, 
        :developer => developer.strip, 
        :title => title.strip, 
        :version => version.strip, 
        :product_type_id => product_type_id.strip, 
        :units => units.to_i, 
        :developer_proceeds => developer_proceeds.to_f, 
        :begin_date => begin_date.strip, 
        :end_date => end_date.strip, 
        :currency => currency.strip, 
        :country_code => country_code.strip, 
        :currency_of_proceeds => currency_of_proceeds.strip, 
        :apple_id => apple_id.to_i, 
        :customer_price => customer_price.to_f, 
        :promo_code => promo_code.strip, 
        :parent_id => parent_id.strip, 
        :subscription => subscription.strip, 
        :period => period
      }
    end
  end
end