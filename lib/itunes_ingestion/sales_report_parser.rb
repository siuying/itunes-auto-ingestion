require 'date'

module ITunesIngestion
  class SalesReportParser
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

    # Parse sales report
    # 
    # report - text based report form itunesconnect
    # 
    # Returns array of hash, each hash contains one line of sales report
    def self.parse(report)
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
          :begin_date => Date.strptime(begin_date.strip, '%m/%d/%Y'), 
          :end_date => Date.strptime(end_date.strip, '%m/%d/%Y'), 
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

end
