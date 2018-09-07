# Sage_Heroku
Heroku version of sage bot.

This is an umbrella Elixir application that runs 2 elixir applicatons: 
  1. 'sage-bot' also known as 'bubo' on the WGU IT Slack
  2. A 'Hello World' application copied from the maker of the Heroku Elixir Buildpack https://github.com/HashNuke/heroku-buildpack-elixir       This application responds on the port assigned by Heroku, which allows this application to satisfy Heroku's requirements. If you           would like to make this do something useful, feel free to try.
  

The application structure is as follows:
  
  Sage Umbrella
   - HerokuBuildPackTest
   - Sage (calls HerokuBuildPackTest as a dependency)
    
Both can be found in their respective folders under .\apps

__PROTOCOL__:
  - Create a new branch and make a pull request
  - If admin approves, you're done! Congratulations! 
  - If admin creates a review application, navigate to the given url to wake it up and then test in #testing.
  - Comment on pull request after successful testing.
  - Admin approve pull request. Congratulations!

__ADMIN TO DO__:
  - Forward a domain to the web app
  
__CONTRIBUTOR TO DO__:
  - Add all courses to the course list
  - Create other triggers
  - Add interesting information to the web portion
