# itunes_ingestion

A Ruby client library for fetching and downloading iTunes Connect sales report.

## A note about versions

Versions *0.3.x* is a breaking change, please update code that based on pre 0.3.x versions.

## Getting started

To fetch report, use following code:

    require "itunes_ingestion"

    fetcher = ITunesIngestion::Fetcher.new("username", "password", "vendor_number")
    report_data = fetcher.fetch("20120202")

To parse fetched report, use following code:

    require "itunes_ingestion"

    report = ITunesIngestion::SalesReportParser.parse(report_data)

## Copyright

Copyright (c) 2012 Francis Chong. See LICENSE for details.

