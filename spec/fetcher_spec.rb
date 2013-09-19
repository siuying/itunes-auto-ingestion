require 'itunes_ingestion'

describe ITunesIngestion::Fetcher do
  it 'fetches the sales report' do
    fetcher = ITunesIngestion::Fetcher.new(ENV['ITUNES_CONNECT_USERNAME'],
                                           ENV['ITUNES_CONNECT_PASSWORD'],
                                           ENV['ITUNES_CONNECT_VADNUMBER'])
    report_date = (Date.today - 2).strftime("%Y%m%d")
    expect { fetcher.fetch(report_date: report_date) }.to_not raise_error
  end
end

