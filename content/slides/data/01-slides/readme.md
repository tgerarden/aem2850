# Data sources

## S&P 500 prices

https://fred.stlouisfed.org/series/SP500

Frequency: daily, close
Timeframe: Max

## Weather

Climate Data Online
https://www.ncei.noaa.gov/cdo-web/

Search tool > Daily Summaries > Select Date Range [January] > Search for [States] > Enter a Search Term [New York] > click on New York > Add to Cart > Select the Output Format [Custom GHCN-Daily CSV] > Continue > Select [Nothing -- do not include Station Name] > Select [Precipitation] > Select [Air Temperature] > Continue > Enter email address > Continue

Note: after downloading, station names were manually removed, and excel converted the date formatting, so code was modified to work with those data rather than the raw data.

Need to fetch data from current and past year each time I prep the course (since past year data will be incomplete).