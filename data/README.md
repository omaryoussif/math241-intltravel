# **Examining International Air Travel Within the United States**

### Reed College: Math 241 with Adrien Allorant - Data Science

In this ***data*** folder, there is a csv file named "us-dot-air-intl-2023.csv" that contains all of the data for this project. It has 766,693 rows and 16 columns. There are also dat files from OpenFlights that talk about airports, airlines, and countries.

### Codebook for **airports.dat** (sourced from [OpenFlights.org](https://openflights.org/data.php))

| Variable Name            | Definition                                                                                                                                                                                                                                                              |
|--------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Airport ID**           | Unique OpenFlights identifier for this airport.                                                                                                                                                                                                                         |
| **Name**                 | Name of airport. May or may not contain the **City** name.                                                                                                                                                                                                              |
| **City**                 | Main city served by airport. May be spelled differently from **Name**.                                                                                                                                                                                                  |
| **Country**              | Country or territory where airport is located.                                                                                                                                                                                                                          |
| **IATA**                 | 3-letter IATA code. Null if not assigned/unknown.                                                                                                                                                                                                                       |
| **ICAO**                 | 4-letter ICAO code. Null if not assigned.                                                                                                                                                                                                                               |
| **Latitude**             | Decimal degrees, usually to six significant digits. Negative is South, positive is North.                                                                                                                                                                               |
| **Longitude**            | Decimal degrees, usually to six significant digits. Negative is West, positive is East.                                                                                                                                                                                 |
| **Altitude**             | In feet.                                                                                                                                                                                                                                                                |
| **Timezone**             | Hours offset from UTC. Fractional hours are expressed as decimals, eg. India is 5.5.                                                                                                                                                                                    |
| **DST**                  | Daylight savings time. One of E (Europe), A (US/Canada), S (South America), O (Australia), Z (New Zealand), N (None) or U (Unknown).                                                                                                                                    |
| **Tz database timezone** | Timezone in ["tz" (Olson) format](https://en.wikipedia.org/wiki/Tz_database), eg. "America/Los_Angeles".                                                                                                                                                                |
| **Type**                 | Type of the airport. Value "airport" for air terminals, "station" for train stations, "port" for ferry terminals and "unknown" if not known. In airports.csv, only type=airport is included.                                                                            |
| **Source**               | Source of this data. "OurAirports" for data sourced from [OurAirports](https://ourairports.com/data/), "Legacy" for old data not matched to OurAirports (mostly DAFIF), "User" for unverified user contributions. In airports.csv, only source=OurAirports is included. |

### Codebook for **countries.dat** (sourced from [OpenFlights.org](https://openflights.org/data.php))

| Variable Name  | Definition                                                                            |
|----------------|---------------------------------------------------------------------------------------|
| **name**       | Full name of the country or territory.                                                |
| **iso_code**   | Unique two-letter ISO 3166-1 code for the country or territory.                       |
| **dafif_code** | FIPS country codes as used in DAFIF. Obsolete and primarily of historical interested. |

### Codebook for **airlines.dat** (sourced from [OpenFlights.org](https://openflights.org/data.php))

| Variable Name  | Definition                                                                          |
|----------------|-------------------------------------------------------------------------------------|
| **Airline ID** | Unique OpenFlights identifier for this airline.                                     |
| **Name**       | Name of the airline.                                                                |
| **Alias**      | Alias of the airline. For example, All Nippon Airways is commonly known as "ANA".   |
| **IATA**       | 2-letter IATA code, if available.                                                   |
| **ICAO**       | 3-letter ICAO code, if available.                                                   |
| **Callsign**   | Airline callsign.                                                                   |
| **Country**    | Country or territory where airport is located.                                      |
| **Active**     | "Y" if the airline is or has until recently been operational, "N" if it is defunct. |

### Codebook for **us-dot-air-intl-2023.csv** (sourced from U.S. Department of Transportation)

| Variable Name    | Definition                                                                                          |
|------------------|-----------------------------------------------------------------------------------------------------|
| **Year**         | Data Year                                                                                           |
| **Month**        | Data Month                                                                                          |
| **usg_apt_id**   | US Gateway Airport ID - assigned by US DOT to identify an airport                                   |
| **usg_apt**      | US Gateway Airport Code - usually assigned by IATA, but in absense of IATA designation              |
| **usg_wac**      | US Gateway World Area Code - assigned by US DOT to represent a geographic territory                 |
| **fg_apt_id**    | Foreign Gateway Airport ID - assigned by US DOT to identify an airport                              |
| **fg_apt**       | Foreign Gateway Airport Code - usually assigned by IATA, but in absense of IATA designation         |
| **airlineid**    | Airline ID - assigned by US DOT to identify an air carrier                                          |
| **carrier**      | IATA-assigned air carrier code. If carrier has no IATA code, ICAO- or FAA-assigned code may be used |
| **carriergroup** | Carrier Group Code - 1 denotes US domestic air carriers, 0 denotes foreign air carriers             |
| **type**         | Defines the type of flight operated                                                                 |
| **Scheduled**    | Number of passengers carried by scheduled service operations                                        |
| **Charter**      | Number of passengers carried by charter operations                                                  |
| **Total**        | Total passengers carried by scheduled service and charter operations                                |

Data tables relating to Airline ID, Carrier, World Area Code may be found at [this link](http://www.transtats.bts.gov/TableInfo.asp?Table_ID=304&DB_Short_Name=Aviation%20Support%20Tables&Info_Only=1).

------------------------------------------------------------------------

Credits: **Omar Youssif (\@omaryoussif)**

Data Source: U.S. Department of Transportation (**data** **owner: Randall Keizer at randall.keizer\@dot.gov**) and is accessible through [this link](https://data.transportation.gov/Aviation/International_Report_Passengers/xgub-n9bw/about_data).
