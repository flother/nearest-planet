"""
Calculate the distance from Earth to Mercury, Venus, and Mars.

Uses the Skyfield package and the Jet Propulsion Laboratory's DE432
ephemeris to calculate the planets' distance from Earth between 1950 and
2050. The calculations are dumped to `stdout` as a CSV file.
"""
import csv
import datetime
import sys

from skyfield.api import load


output = csv.writer(sys.stdout)
output.writerow(("planet", "date", "distance"))

# DE421 is an ephemeris covering 1900-2050. See also DE423 (1800-2200) and
# DE422 (3000 BCE to 3000 CE).
planets = load("de421.bsp")
mercury, venus, earth, mars = (
    planets["Mercury"],
    planets["Venus"],
    planets["Earth"],
    planets["Mars"],
)
other_planets = [mercury, venus, mars]

ts = load.timescale()
# Using DE421 the start date can be between 1900 and 2050.
date = datetime.date(1950, 1, 1)

# Loop through every day from the start date until the last day of 2050 and
# calculate the distance from Earth for every planet in the `other_planets`
# list.
while date.year != 2051:
    t = ts.utc(date)
    earth_at_time = earth.at(t)
    for planet in other_planets:
        astrometric = earth_at_time.observe(planet)
        _, _, distance = astrometric.radec()
        output.writerow(
            (planet.target_name, t.utc_strftime("%Y-%m-%d"), distance.au)
        )
    date += datetime.timedelta(days=1)
