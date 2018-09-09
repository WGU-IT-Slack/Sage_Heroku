defmodule Sage.Responders.Courses do
  @moduledoc """
  Respond with course names and descriptions.

  ### Examples

      User> Man I love C132. It's a blast!
      sage> *C132*: Elements of Effective Communication

      User> sage describe C132
      sage> *C132*: Elements of Effective Communication
      sage> This course introduces learners to elements of communication that
      are valued in college and beyond. Materials are based on five principles:
      being aware of communication with yourself and others; using and
      interpreting verbal messages effectively; using and interpreting nonverbal
      messages effectively; listening and responding thoughtfully to others, and
      adapting messages to others appropriately

  """

  use Sage.Responder

  require Logger

  alias Sage.Support.CourseList

  #Send basic course info

  @usage """
  `<course code>` - Responds with the course code and name
  """
  hear ~r/(?:[a-zA-Z]{1,3})(?:\s|-)?(?:[0-9]{1,4})/i, msg do
    matches = Regex.scan(~r/(?:[a-zA-Z]{1,3})(?:\s|-)?(?:[0-9]{1,4})/i, msg.text)
    Enum.each(matches, fn x-> if(compile(x) != :error) do send msg, compile(x) end end)
  end

  @usage """
  `bubo describe <code>` - Responds with the course description
  """
  respond ~r/describe (([a-zA-Z]{1,3})(?:\s|-)?([0-9]{1,4}))/i, msg do
    code = sanitize(msg.matches[1])

    case CourseList.find_by_code(code) do
      {_code, course} ->
        send msg, course[:desc]
      nil ->
        send msg, "Unable to find that course"
        Logger.warn "No match"
        :ok
    end
  end

  #Send course link

  @usage """
  `bubo link <code>` - Responds with the course provision link
  """
  respond ~r/link (([a-zA-Z]{1,3})(?:\s|-)?([0-9]{1,4}))/i, msg do
    code = sanitize(msg.matches[1])

    case CourseList.find_by_code(code) do
      {_code, course} ->
        send msg, course[:link]
      nil ->
        send msg, "Unable to find that course link"
        Logger.warn "No match"
        :ok
    end
  end

  #Send provision link

  @usage """
  `bubo provision <code>` - Responds with the course provision link
  """
  respond ~r/provision (([a-zA-Z]{1,3})(?:\s|-)?([0-9]{1,4}))/i, msg do
    code = sanitize(msg.matches[1])

    case CourseList.find_by_code(code) do
      {_code, course} ->
        send msg, course[:provision]
      nil ->
        send msg, "https://i.ytimg.com/vi/7qnd-hdmgfk/hqdefault.jpg"
        send msg, "I'm sorry Dave, I am afraid I cannot do that"
        :timer.sleep(2000)
        send msg, "Unable to find that provision link"
        Logger.warn "No match"
        :ok
    end
  end

  # Sanitize user input code.
  @spec sanitize(String.t) :: String.t
  def sanitize(code) do
    code
    |> String.replace(~r/[^a-zA-Z0-9]+/, "")
    |> String.upcase
  end

  def compile(match) do
    match = sanitize(List.to_string(match))
    case CourseList.find_by_code(match) do
      {_code, course} ->
        "*#{match}*: #{course[:name]}"
      nil ->
        Logger.warn "No match"
        :error
    end
  end
end
