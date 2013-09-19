require 'rest-client'
require 'zlib'

module ITunesIngestion
  class Fetcher
    BASE_URL = "https://reportingitc.apple.com/autoingestion.tft?"
  
    REPORT_TYPE_SALES = "Sales"
    DATE_TYPE_DAILY = "Daily"
    DATE_TYPE_WEEKLY = "Weekly"
  
    REPORT_SUMMARY = "Summary"
    REPORT_OPT_IN = "Opt-In"

    # Create new instance of Fetcher
    # 
    # username - username
    # password - password
    # vadnumber - vadnumber
    # proxy - proxy url if applicable
    def initialize(username, password, vadnumber, proxy=nil)
      @username = username
      @password = password
      @vadnumber = vadnumber
      @proxy = proxy
    end

    # Fetch and unzip report from itunes connect
    # 
    # options - Hash of options:
    #  - :type_of_report can only be REPORT_TYPE_SALES at the moment
    #  - :date_type either DATE_TYPE_DAILY or DATE_TYPE_WEEKLY, default DATE_TYPE_DAILY
    #  - :report_type either REPORT_OPT_IN or REPORT_SUMMARY, default REPORT_SUMMARY
    #  - :report_date date in YYYYMMDD
    #
    # Returns text file downloaded and unzipped from iTunes
    def fetch(options={})
      params = {
        :USERNAME => @username, :PASSWORD => @password, :VNDNUMBER => @vadnumber
      }
      params[:TYPEOFREPORT] = options[:type_of_report] || REPORT_TYPE_SALES
      params[:DATETYPE] = options[:date_type] || DATE_TYPE_DAILY
      params[:REPORTTYPE] = options[:report_type] || REPORT_SUMMARY
      params[:REPORTDATE] = options[:report_date] || (Time.now-60*60*24).strftime("%Y%m%d")

      RestClient.proxy = @proxy
      response = RestClient.post BASE_URL, params
      if response.headers[:"errormsg"]
        raise ITunesConnectError.new response.headers[:"errormsg"]
      elsif response.headers[:"filename"]
        Zlib::GzipReader.new(StringIO.new(response.body)).read
      else
        raise "no data returned from itunes: #{response.body}"
      end
    end
  end
end
