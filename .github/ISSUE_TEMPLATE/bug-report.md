---
name: Bug report
about: Create a report to help us improve
labels: 'bug'
---

# Description

Provide as much background as you need to get the implementer up to speed on the problem to be solved. This can also include screenshots and links to other issues or pull requests.

# Steps to Reproduce

Don't forget to point out the difference between what *should* happen and what *does* happen. Here's an example:

1. Try geocoding "1600 Pennsylvania Ave":
    ```ruby
    white_house = GoogleMapsGeocoder.new('1600 Pennsylvania Ave')
    ```
2. The formatted address doesn't match the White House:
   ```ruby
   white_house.formatted_address
   => "1600 Pennsylvania Ave, Charleston, WV 25302, USA"
   ```
