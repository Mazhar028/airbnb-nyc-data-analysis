# Data Dictionary & Key Findings — Airbnb Open Data Project

**Database:** project_airbnb | **Table:** airbnb_listings | **Rows:** 102,036 | **Columns:** 22

## Data Dictionary

| Column | Type | Description |
|
| id | INT (Primary Key) | Unique identifier for each listing,
| NAME | VARCHAR(255)  | Listing title,
| host_id | BIGINT | Unique identifier for the host,
| host_identity_verified | VARCHAR(20) | Whether the host's identity is verified,
| host_name | VARCHAR(100) | Host's display name,
| neighbourhood_group | VARCHAR(50)  | NYC borough (Manhattan, Brooklyn, Queens, Bronx, Staten Island),
| neighbourhood | VARCHAR(100) | Specific neighbourhood within the borough,
| latitude / longitude | DECIMAL(10,7) | Geographic coordinates of the listing,
| instant_bookable | BOOLEAN | Whether the listing can be booked without host approval,
| cancellation_policy | VARCHAR(20) | flexible / moderate / strict ,
| room_type | VARCHAR(50) | Entire home/apt, Private room, Shared room, Hotel room,
| construction_year | SMALLINT | Year the property was built,
| price | DECIMAL(10,2) | Nightly price in USD,
| service_fee | DECIMAL(10,2) | Platform service fee in USD,
| minimum_nights  | INT | Minimum nights required per booking,
| number_of_reviews | INT | Total review count,
| last_review | DATE | Date of most recent review (NULL = never reviewed),
| reviews_per_month | DECIMAL(5,2) | Average monthly review frequency,
| review_rate_number | TINYINT | Guest rating, 1–5,
| calculated_host_listings_count | INT | Platform-reported listings per host,
| availability_365 | SMALLINT  | Days available for booking in the next year (0 –365)

---

## Key Findings

I went through this dataset the same way I'd approach it on the job — start with the obvious business questions, but actually check whether the numbers hold up before writing them down as insights.

**Room type and location are where the platform's real story is.** Entire home/apt and private rooms make up almost the whole dataset (about 97% combined), shared and hotel rooms are a rounding error. Not surprising for a city like New York, but worth confirming rather than assuming.

**Review activity tells a genuinely useful story, and it's the one metric in this dataset I'd actually trust.** Staten Island and Queens have the highest average reviews per listing, Manhattan the lowest — even though Manhattan has by far the most total listings. My read on this: fewer listings competing for the same guests means each individual property in Staten Island or Queens ends up capturing more bookings, so more reviews pile up per listing. Manhattan's sheer volume of competing properties spreads demand thin across each one.

That said, I cross-checked this against availability, and it complicated the story a bit. Staten Island also has the highest average availability — meaning its listings sit unbooked for more of the year than anywhere else. So instead of "Staten Island is the hottest market," a more accurate read is that these are older, well-established listings with a strong historical review count, but not necessarily strong demand right now. I think that's a more honest way to phrase it than just picking the flashier headline.

**Host concentration doesn't really exist in this data.** I expected to find a handful of "power hosts" running dozens of listings each — that's normal on Airbnb in real life. Instead, host_id is basically 1-to-1 with listings (102,035 unique hosts across 102,036 rows). Interestingly, there's a separate column, calculated_host_listings_count, that claims some hosts have 300+ listings — but since I can independently verify host_id by just counting rows, and I can't verify how that other column was calculated, I trust host_id over it. Worth flagging as an inconsistency in the data rather than ignoring it.

**Price is the one column I'd push back on if someone asked me to build a report around it.** I tested it against borough, room type, cancellation policy, instant-bookable status, and guest rating — and none of them showed a real relationship. Room type especially should move price a lot in a real market (an entire apartment vs. a shared room), but here they're within a few dollars of each other. Guest rating actually ran backwards — 1-star listings had a slightly higher average price than 5-star ones, which doesn't make sense in the real world. On top of that, dozens of listings across different boroughs share the exact same maximum price of $1,200.00, which isn't something you'd expect to happen by chance in organic pricing data. My conclusion is that price in this dataset looks randomly assigned rather than reflective of an actual market, so I didn't build any price-based recommendations on top of it — I just noted it clearly as a limitation instead of pretending the numbers meant something they didn't.

**About half of listings are instant-bookable** (49.75%), basically an even split with no strong lean either way.

---

## Why this matters

The point of documenting this isn't just to list numbers — it's to show which findings I'd actually stand behind and which ones I wouldn't. Reviews and availability behave the way you'd expect real-world data to behave, so I trust those. Price doesn't, so I said so, instead of forcing a "which neighbourhood has the best price-to-review ratio" conclusion out of a column that doesn't seem to carry real signal. That distinction — knowing when the data supports a claim and when it doesn't — is the part of this project I think matters more than any individual chart.
