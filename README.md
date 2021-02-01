# Template Project for HaxeFlixel games

## Run the game in a browser (preferred dev environment)

- `lime test html5 -debug`

## Template features

- Preconfigured libraries
  - FMOD Studio project with menu sound effects and a random song I wrote
  - Ready to use Bitlytics tie-ins
  - Various utility libraries
- Basic state templates
  - Main menu with buttons to load the credits or start the game
  - Credits state with built-in scrolling
- Preconfigured .gitignore
- Github build actions
  - Dev builds on push to master
  - Production builds on releases

## Configuration

- Set the proper Github secrets:
  - `BUTLER_API_KEY`: The Butler API key from itch.io
  - `ANALYTICS_TOKEN`: The InfluxDB access token to the bucket
- Fill out the `assets/data/config.json` fields
  - `analytics.name`: The simplified game name, used as the metrics id and some other things. Should be snake case or similar.
  - `analytics.influx.bucket`: The bucket ID from InfluxDB
- Fill in the `itchGameName` in both workflow files
  - This should be the URL name from itch.io

## Dependencies

### **haxelib.deps**

- `haxelib.deps` - Contains all dependencies needed by the project other than haxe itself
  - It supports two dep styles
    - standard haxelib dependencies
      - Formatted as: `<libName> <libVersion>`
    - git dependencies
      - Formatted as: `<libName> git <gitRepoLocation> <OPTIONAL: gitBranchOrTag>`
- `init.sh` - Script that reads `haxelib.deps` file and configures `haxelib`
  - This script will need to be run any time the dependencies change
  - This script is run by the github actions as part of the build so local and github builds are equivalent

## Maintenance

## **Formatting**

- This projects uses the [haxe-formatter](https://github.com/HaxeCheckstyle/haxe-formatter) package for formatting using default settings
  - Install `formatter` by running: `haxelib install formatter`
  - Apply formatting by running: `haxelib run formatter -s ./source` from the root of the project
  
## Retrospective

### Mike

First off, I suck at jamming now.  I clearly don't get as much done as I used to.  I really only contributed to the initial cutscene which in my opinion turned out pretty lack-luster.  Looking back, I think I should have abandoned the cutscene sooner since it didn't add anything to the game play and it really wasn't a good enough addition to the story to make it worth the time (the entire jam) I spent working on it.  I probably needed to try and contribute to the various features in the game which might have helped us get the ball-button feature in.

The game is still fun to play though even without some of those features.  Certainly the timer up at the top gives you a good incentive to try and go quickly.  I think we did a decent job at not creating too much scope creep, and the idea itself seemed pretty solid.  The mechanic of using your arms to propell you through the level is, I think, fun at its core.  However, it is also a very difficult mechanic to have any sense of control.  So in terms of difficulty, I think we did fine with the complexity of the challenges in the game, but the base mechanic would be much too difficult for most people (hopefully I'll be proven wrong by the analytics).  Also, our build process failing in the final 10 min was annoying.  It ended up requiring a simple workaround, but that is never easy to find when there is only 5 min left before submission.  So we probably need to not just trust the prod deploy 100% and make sure to release a prod build at the beginning of the last day just so we know it works.

Overall, not my best jam, but I still had a good time.  I look forward to doing these in person again.  Thanks for all your hard work guys.
