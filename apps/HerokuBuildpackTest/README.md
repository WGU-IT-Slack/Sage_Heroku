# HerokuBuildpackTest

Sample app to test with the [Heroku Elixir Buildpack](http://github.com/HashNuke/heroku-buildpack-elixir)

## Usage

To create an app run the following commands:

```
$ git clone https://github.com/HashNuke/heroku-buildpack-elixir-test.git
$ cd heroku-buildpack-elixir-test
$ heroku create --buildpack "https://github.com/HashNuke/heroku-buildpack-elixir.git"
$ git push heroku master
```

----

If you are HashNuke, then there's already a Heroku app at http://heroku-buildpack-elixir-test.herokuapp.com
Add the following to your repo to use it.

```
git remote add heroku https://git.heroku.com/heroku-buildpack-elixir-test.git
```
