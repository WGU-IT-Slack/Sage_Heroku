defmodule HerokuBuildpackTest.AppWorker do

  def start_link do
    Plug.Adapters.Cowboy.http MyPlug, [], port: 8080
  end

end
