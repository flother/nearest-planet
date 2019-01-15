Python script to calculate the distance from Earth to Mercury, Venus, and Mars, and an R script to plot that data. Inspired by [an episode of the BBC's More or Less]. See my blog post [Which planet is closest to Earth?] for the full details.

The Python script uses the [Skyfield] package and the Jet Propulsion Laboratory's [DE432 ephemeris] to calculate the planets' distance from Earth between 1950 and 2050. The calculations are dumped to a CSV file, and then used as input for the R script.

To collect the data, run:

```python
pip3 install -r requirements.txt
python3 planets.py > planets.csv
```

Then open the `planets.r` script in RStudio to plot the data. (Make sure to set the working directory: *Session → Set Working Directory → To Source File Location*.)


  [an episode of the BBC's More or Less]: https://www.bbc.co.uk/programmes/m0001y9p
  [Which planet is closest to Earth?]: https://flother.is/2019/which-planet-is-closest-to-earth/
  [Skyfield]: https://rhodesmill.org/skyfield/
  [DE432 ephemeris]: https://en.wikipedia.org/wiki/Jet_Propulsion_Laboratory_Development_Ephemeris
