defmodule Sage.Responders.Triggers do
  @moduledoc """
  A map of triggers to respond to.

  Keep the keys in this module lowercase and with no whitespace.

  However, usage is case-insensitive.

  ### Examples

      User> !hello
      sage> Hi there!

      User> !NO
      sage> Noooo! https://www.youtube.com/watch?v=umDr0mPuyQc

  """

  use Sage.Responder

  @triggers %{
    "mods"  => ":mod: The current mods are: Desi, Selenity Lunare, & ItsFortyBelow (with hammer as the admin). :mod:\nIf you see a problem and believe moderator intervention is needed, please do not hesitate to directly message them or tag them within the channel (by adding the '@' sign in front of their name, example: @bubo).\n_Moderators are elected every 6 months. The next moderator election is due: August 10, 2019_",
    "hello" => "Hi there!",
    "howdy" => "Howdy partner! :face_with_cowboy_hat:",
    "goodbye" => "See ya!",
    "no" => "Noooo! https://www.youtube.com/watch?v=umDr0mPuyQc",
    "nope" => "https://media.giphy.com/media/6h4z4b3v6XWxO/giphy.gif",
    "darkmode" => "#000000,#000000,#000000,#000000,#000000,#000000,#000000,#000000",
    "colors" => "#003057,#4986AD,#C69214,#FFFFFF,#4986AD,#FFFFFF,#509E2F,#862633",
    "git" => "https://github.com/WGU-IT-Slack/Sage_Heroku/tree/master/apps/sage",
    "contributing" => "To help me get better you can *fork* https://github.com/WGU-IT-Slack/Sage_Heroku, *commit* your changes, and then make a *pull request*!",
    "googledrive" => "Repo with eBooks and More! Sign up with your @wgu.edu email address. https://drive.google.com/folderview?id=0B1S7OJNChk1-cWhwNWZTb2JNY1E",
    "linkedin" => "Connect with your fellow slackers. https://docs.google.com/document/d/1ajGLPZpWuxzDtEmWiVxvwxbwFRy0BcdPI0koaa_Zvc4/edit",
    "onthehub" => "https://wgudreamspark.onthehub.com/WebStore/ProductsByMajorVersionList.aspx?cmi_cs=1&cmi_mnuMain=2b44b80c-dfc9-e111-971c-f04da23e67f6",
    "ugt" => "UGT (abbr.): Universal Greeting Time.\n_UGT_ is a convention that states that it is always morning when person comes into a channel, and it is always late night when person leaves. Local time of any member of channel is irrelevant.",
    "y" => "http://i.imgur.com/yZRYrIF.jpg",
    "portal" => "Here's the WGU portal! :wgu: https://my.wgu.edu",
    "reddit" => "Here's the WGU subreddit! :reddit: https://www.reddit.com/r/WGU/",
    "bcuz" => "http://i.imgur.com/j6nbopM.png",
    "pluralsight" => "Get free access to Pluralsight here: https://lrps.wgu.edu/provision/114583870",
    "skillsoft" => "Access to SkillSoft: https://lrps.wgu.edu/provision/102605",
    "labsim" => "Access Net+ Labsim via: http://lrps.wgu.edu/provision/6147901 and Sec+ via: https://lrps.wgu.edu/provision/42540372",
    "noice" => "https://www.youtube.com/watch?v=h3uBr0CCm58",
    "noice-kp" => "https://www.youtube.com/watch?v=rQnYi3z56RE&t=5s",
    "discount"=> "Student Discount List. Need to add a discount to this list? Post in #feedback for changes: https://docs.google.com/document/d/1cU-6kOuv-wGVaDbfY-H369gF0noasYc-p-bNnltKpD4/edit?usp=sharing",
    "exercism"=> "Want to practice coding problems and see solutions from other WGU students/alumni? Our team is: http://exercism.io/teams/wgu/streams",
    "freebook" => "",
    "promoteme" => "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
    "guidelines" => "1. Personal attacks are unacceptable. Bullying or harassment will not be tolerated. \n2. Hate speech is not permitted.\n3. Do not deliberately disrupt the community.\n4. Illegal activity, XXX content, and discussion of politics are not allowed.\n5. No soliciting, advertising, or marketing (unless it’s for a job posting in the #job-listings channel).\n6. Nothing allowed that may be against the WGU Student Code of Conduct.\n7. Use the proper channel for discussions.\n\nSlack members that don’t adhere to these guidelines will be given warnings, and chronic offenders may be removed from the Slack. We want to create the best possible atmosphere for WGU IT students, and keeping our group respectful and accessible is priority.",
    "trello" => "Have an idea for Bubo? Add it to Trello! https://trello.com/invite/b/TqiSb2K5/6886caa935984aad67d0caa9e591da60/bubo"
  }

  @trigger_matches Map.keys(@triggers) |> Enum.join("|")

  @trigger_char Config.get_env(:sage, :trigger_char, "!")

  # Respond with one of the trigger responses... ᕕ( ᐛ )ᕗ
  hear ~r/^#{@trigger_char}(#{@trigger_matches})$/i, msg do
    cond do
     to_string(msg.matches[1]) == "freebook" ->
      send msg, to_string(getbook)
     to_string(msg.matches[1]) != "freebook" ->
      send msg, Map.get(@triggers, sanitize(msg.matches[1]))
    end

  end

  @usage """
  `hedwig list triggers` - Respond with a list of available triggers
  """
  respond ~r/list triggers/, msg do
    send msg,
      @triggers
      |> Map.keys()
      |> Enum.map(fn trigger -> "`#{@trigger_char}#{trigger}`" end)
      |> Enum.join(", ")
  end

  # Sanitize the input
  defp sanitize(match) do
    match
    |> String.downcase()
  end

  def add_day(date) do
    cond do
      date.day < Date.days_in_month(date) ->
        {:ok, new_date} = Date.new(date.year, date.month, date.day+1)
        new_date
      date.month < 12 ->
        {:ok, new_date} = Date.new(date.year, date.month+1, 1)
        new_date
      true ->
        {:ok, new_date} = Date.new(date.year+1, 1, 1)
        new_date
    end
  end

  def getbook do
    Application.ensure_all_started :inets

    today = '#{Date.utc_today}T00:00:00.000Z'
    tomorrow = '#{Date.utc_today |> add_day}T00:00:00.000Z'
    offersURL = 'https://services.packtpub.com/free-learning-v1/offers?dateFrom=#{today}&dateTo=#{tomorrow}'
    {:ok, resp} = :httpc.request(:get, {offersURL, []}, [], [body_format: :binary])
    {{_, 200, 'OK'}, _headers, body} = resp
    productId = get_in(Poison.decode!(body), ["data", Access.at(0), "productId"])
    if productId != nil do
      summaryURL = 'https://static.packt-cdn.com/products/#{productId}/summary'
      {:ok, resp} = :httpc.request(:get, {summaryURL, []}, [], [body_format: :binary])
      {{_, 200, 'OK'}, _headers, body} = resp
      json = Poison.decode!(body)
      title = json["title"]
      author = hd(json["authors"])
      authorURL = 'https://static.packt-cdn.com/authors/#{author}'
      {:ok, resp} = :httpc.request(:get, {authorURL, []}, [], [body_format: :binary])
      {{_, 200, 'OK'}, _headers, body} = resp
      json = Poison.decode!(body)
      "Today's free book is: \n#{title}\nBy:#{json["author"]}\nhttps://www.packtpub.com/packt/offers/free-learning"
    else
      "There is no free book today\nhttps://www.packtpub.com/packt/offers/free-learning"
    end
  end
end
