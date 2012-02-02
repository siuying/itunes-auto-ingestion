module ITunesIngestion
  class ITunesConnectError < RuntimeError; end
  
  autoload :Fetcher, 'itunes_ingestion/fetcher'
  autoload :SalesReportParser, 'itunes_ingestion/sales_report_parser'
end
