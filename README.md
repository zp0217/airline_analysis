# Deployed Website
https://zp0217.github.io/airline_analysis/

# Air Traffic On-Time Performance Analysis
analysis of September 2019 U.S. Domestic Flight Data using MySQL for query and visualization using R
This project examines U.S. domestic airline on-time performance using a dataset of 605,979 flights across 17 airlines and 285 airports during September 2019. Data was queried with MySQL and visualized with R.

# Overview
Unexpected schedule changes occur every day across hundreds of domestic routes — driven by weather events, carrier issues, and national air system disruptions. This project analyzes September 2019 flight records to answer three core operational questions:

Which airlines and airports have the worst departure delay performance?
Which days of the week carry the most flight traffic?
What drives flight cancellations, and which airports are most affected?

# Key findings:

Envoy Air recorded the longest single departure delay at 1,753 minutes; Southwest Airlines had the shortest maximum at 438 minutes
Monday was the busiest day of the week with 106,461 flights — 59% more than Saturday (67,034)
Of 605,979 total flights, 10,016 were cancelled (1.7%), with weather accounting for 86.2% of cancellations — consistent with peak hurricane season


# Project structure

airline_analysis/
│
├── index.qmd                   # Homepage and project overview
├── airline-airport.qmd         # Airline & airport departure delay analysis
├── weekly-performance.qmd      # Day-of-week and rolling flight volume analysis
├── cancellations.qmd           # Cancellation reasons and affected airports
├── code.qmd                    # All MySQL queries and R visualization code
├── plots/                      # All figures used in the site
├── source_code/
│   ├── Mini_project_SQLcode.sql       # MySQL queries for data extraction & cleaning
│   └── R_code_visualization.R         # R code for all visualizations
├── _site/                      # Rendered site output (GitHub Pages source)
├── styles.css                  # Custom site styles
├── _quarto.yml                 # Quarto project configuration
└── air.pdf                     # Full project report (PDF)


# Data source

U.S. Bureau of Transportation Statistics (BTS) On-Time Performance Data
https://transtats.bts.gov/DatabaseInfo.asp?QO_VQ=EFD&DB_URL=
