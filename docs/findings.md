FINDINGS: 
price/service fee wrong dtype, 
license 99.998% missing, 
minimum nights has impossible negative values, 
availability 365 has out-of-range values (negative and >365).

DATA QUALITY AUDIT — Entry #1

Column -> neighbourhood group
Problem -> Inconsistent categorical values (typos)
Evidence -> brookln (1 row), manhatan (1 row) found via value_counts()
Business Impact -> Fragments true group counts, misleads aggregations/charts
Cleaning Decision -> Standardize to Brooklyn / Manhattan

DATA QUALITY REPORT, Entry #2:

Column -> country
Problem -> Zero variance (constant column)
Evidence -> nunique() = 1, 100% "United States"
Business Impact -> No analytical value, cannot segment/compare
Cleaning Decision -> Drop column

DATA QUALITY REPORT — Entry #3:

Column -> country code
Problem -> Zero variance (constant column)
Evidence -> nunique() = 1, 100% "US"
Business Impact -> No analytical value, cannot segment/compare
Cleaning Decision -> Drop column

DATA QUALITY REPORT — Entry #4:

Column -> host name
Problem -> Missing values
Evidence -> 0.39% missing (approx 406 rows)
Business Impact -> Label field, no aggregation impact, but dropping loses other valid row data
Cleaning Decision -> Fill with "Unknown"

DATA QUALITY REPORT — Entry #5:

Column -> NAME
Problem -> Missing values
Evidence -> 0.24% missing (approx 250 rows)
Business Impact -> Label field, not used for aggregation; dropping loses other valid row data
Cleaning Decision -> Fill with "Unknown"/"Untitled"

DATA QUALITY REPORT — Entry #6:

Column -> host_identity_verified
Problem -> Missing values
Evidence -> 0.28% missing
Business Impact -> Categorical field used in analysis - "Unknown" becomes meaningful group
Cleaning Decision -> Fill with "Unknown"

DATA QUALITY REPORT — Entry #7:

Column -> host_identity_verified
Problem -> Missing values
Evidence -> 0.07% missing
Business Impact -> Categorical field used in analysis — "Unknown" becomes meaningful group
Cleaning Decision -> Fill with "Unknown"

DATA QUALITY REPORT — Entry #8:

Column -> lat / long
Problem -> Missing values
Evidence -> 0.0078% missing (approx 8 rows)
Business Impact -> Geographic coordinates - imputing creates fake/misleading locations
Cleaning Decision -> Drop rows

DATA QUALITY REPORT — Entry #9:

Column -> Construction year
Problem -> Missing values
Evidence -> 0.21% missing (approx 214 rows)
Business Impact -> Numeric, tight distribution (2003–2022), no major skew
Cleaning Decision -> Fill with mean/median (interchangeable here)

DATA QUALITY REPORT — Entry #10:

Column -> minimum nights
Problem -> Missing values + skewed distribution
Evidence -> 0.40% missing (approx 409 rows); mean = 8.14 vs median = 3
Business Impact -> Skewed by legitimate long-term rentals
Cleaning Decision -> Fill with median (after fixing invalid negatives first)

DATA QUALITY REPORT — Entry #11:

Column -> number of reviews
Missing % -> approx 0.18%
Fill Strategy -> Median
Reasoning -> Mean/median far apart → skewed

DATA QUALITY REPORT — Entry #12:

Column -> review rate number
Missing % -> approx 0.32%
Fill Strategy -> Mode
Reasoning -> Bounded rating scale (1-5), mean produces invalid decimal

DATA QUALITY REPORT — Entry #13:

Column -> calculated host listings count
Missing % -> approx 0.31%
Fill Strategy -> Median
Reasoning -> Mean/median far apart → skewed

DATA QUALITY REPORT — Entry #14:

Column -> availability 365
Missing % -> 0.44%
Fill Strategy -> Median (after fixing invalid negatives/>365 values first)
Reasoning -> Real skew (141 vs 96); also has invalid values to fix separately

DATA QUALITY REPORT — Entry #15:

Column -> Full dataset
Problem -> Duplicate rows
Evidence -> 541 duplicate ids = 541 full-row duplicates (exact match across all columns)
Business Impact -> Inflates listing counts in aggregations
Cleaning Decision -> Drop using drop_duplicates()

DATA QUALITY REPORT — Entry #16:

Column -> last review
Problem -> Wrong dtype (object instead of datetime)
Evidence -> dtype: object
Business Impact -> Breaks chronological sorting, date filtering, time-based calculations, Power BI time intelligence
Cleaning Decision -> Convert using pd.to_datetime() (Step 7)

DATA QUALITY REPORT — Entry #17:

Column -> price
Problem -> Wrong dtype (text with $)
Evidence -> Stored as object with $/,
Business Impact -> Cannot calculate, aggregate, or analyze numerically
Cleaning Decision -> Stripped symbols → converted via pd.to_numeric() → now float64

DATA QUALITY REPORT — Entry #18:

Column -> service fee
Problem -> Wrong dtype (text with $)
Evidence -> Stored as object with $/,
Business Impact -> Cannot calculate, aggregate, or analyze numerically
Cleaning Decision -> Stripped symbols → converted via pd.to_numeric() → now float64, 273 missing

DATA QUALITY REPORT — Entry #19 & #20:

Column -> price
Problem -> approx 0.24% (247 rows)
Evidence -> Mean (approx 625)
Ressoning -> Mean ≈ median, no significant skew

DATA QUALITY REPORT — Entry #20:

Column -> service fee
Problem -> approx 0.27% (273 rows)
Evidence -> Mean (approx 125)
Ressoning -> Mean ≈ median, no significant skew 

DATA QUALITY REPORT — Entry #21:

Column -> last review
Problem -> Wrong dtype (text)
Evidence -> Was object, now datetime64[ns]
Business Impact -> Enables sorting, filtering, time intelligence in Power BI
Cleaning Decision -> Converted via pd.to_datetime(); missing values (15,832) left as NaT — meaningful (no reviews ever), not imputed

DATA QUALITY REPORT — Entry #22:

Column -> neighbourhood group, neighbourhood, room type, cancellation_policy, host_identity_verified
Check -> Whitespace mismatch check
Result -> 0 mismatches in all
Decision -> No action needed

DATA QUALITY REPORT — Entry #23:

Column -> minimum nights
Check -> Impossible negative values
Business -> Cannot logically exist; distorts stats if kept
Cleaning Decision -> Drop these 13 rows

DATA QUALITY REPORT — Entry #24:
a) Column -> availability 365
   Problem -> Impossible negative values
   Evidence -> 431 rows, range -1 to -10
   Cleaning Decision -> Cap at 0

b) Column -> availability 365
   Problem -> Mildly over 365
   Evidence -> 2,752 rows, range 366-411
   Cleaning Decision -> Cap at 0

c) Column -> availability 365
   Problem -> Extreme outlier
   Evidence -> 1 row, value 3677
   Cleaning Decision -> Drop row

d) Column -> availability 365
   Problem -> Missing values
   Evidence -> 448 rows
   Cleaning Decision -> Fill with median (after above fixes)

DATA QUALITY REPORT — Entry #25:

a) Column -> number of reviews
   Check -> IQR outlier check
   Finding -> 11120 rows flagged (>76 reviews)
   Decision -> Keep as-is — legitimate high engagement, not data errors

b) Column -> price
   Check -> IQR outlier check
   Finding -> 0 rows flagged
   Decision -> No outliers; but distribution looks suspiciously uniform (noted for report limitations)

DATA QUALITY REPORT — Entry #26:

Column -> house_rules
Problem -> 51% missing, free text
Evidence -> Drop (for this project)
Ressoning -> Cannot be structurally analyzed in SQL/BI; potential future NLP use noted as limitation