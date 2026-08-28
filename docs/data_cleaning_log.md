DATA QUALITY REPORT — Entry #1 (updated to show execution):

Part 1
column -> neighbourhood group
Problem	-> Typos (brookln, manhatan)
Cleaning Decision -> Standardize via .replace()
Status -> Executed 

DATA QUALITY REPORT — Entry #10 (corrected):

column -> minimum nights
Problem	-> Impossible negative values
Evidence -> 13 rows
Cleaning Decision -> Dropped by index (NaN-safe method)
Status -> Executed 

DATA QUALITY REPORT — Entry #10 (corrected):

column -> minimum nights
Problem	-> Missing values (400)
Cleaning Decision -> Filled with median
Status -> Executed 

DATA QUALITY REPORT — Entry #24 (partial execution):

Column -> availability 365
Problem -> Extreme outlier (3677)
Status -> Dropped (1 row)

DATA QUALITY REPORT — Entry #24 (fully executed):

a) Column -> availability 365
   Problem -> Negative values (431 rows)
   Status -> Capped at 0

b) Column -> availability 365
   Problem -> Mildly over 365 (2,752 rows)
   Status -> Capped at 365

c) Column -> availability 365
   Problem -> Extreme outlier (1 row)
   Status -> Dropped

d) Column -> availability 365
   Problem -> Missing values
   Status -> Filled with median

DATA QUALITY REPORT — Entry #26 (executed):

Column -> country, country code, license, house_rules
Decision -> Drop
Status -> Executed

DATA QUALITY REPORT (Correction/update)

Column -> instant_bookable
Problem -> Missing values (approx 104 rows)
Original Decision -> Filled "Unknown"
Corrected Decision -> Filled with mode (False), then converted to int (0/1)
Reasoning -> Column is strictly binary in the real world, "Unknown" isn't a valid state a listing can actually have, unlike open-ended categorical fields

...................................................................................................
FINAL DATA QUALITY REPORT — Missing Value Fills

SEGMENT 1: Categorical/Text Columns → Filled "Unknown"

column -> NAME, host_identity_verified, host name, cancellation_policy, neighbourhood group, neighbourhood, instant_bookable
Problem	-> Missing values
Evidence -> approx 29–404 rows (varies by column)
Cleaning Decision -> Filled with "Unknown"
Status -> Executed 

SEGMENT 2: Numeric Columns → Filled Mean (symmetric distributions)

column -> price, service fee, Construction year
Problem	-> Missing values
Evidence -> 214–273 rows (varies by column)
Cleaning Decision -> Filled with mean
Status -> Executed 

Segment 3: Numeric Columns → Filled Median (skewed distributions)

column -> 	number of reviews, review rate number, calculated host listings count
Problem	-> Missing values
Evidence -> 183–319 rows (varies by column)
Cleaning Decision -> Filled with median
Status -> Executed 