defmodule Sage.Responders.UptimeTest do
  use Hedwig.RobotCase
  
  #FIXME: uptime doesn't respond fast enough on heroku
  @tag :skip
  #@tag start_robot: true, name: "alfred", responders: [{Sage.Responders.Uptime, []}]

  test "has been sentient", %{adapter: adapter, msg: msg} do
    send adapter, {:message, %{msg | text: "alfred uptime"}}
    assert_receive {:message, %{text: text}}
    assert String.contains?(text, "I've been sentient for")
  end
end
