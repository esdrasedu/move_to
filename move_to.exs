defmodule MoveTo do
  def watch(src, dst, re) do
    files = File.ls!(src)
    regex = Regex.compile!(re)
    Enum.map(files, &(Path.expand("#{src}/#{&1}")))
    |> Enum.filter(&(Regex.match?(regex, &1)))
    |> Enum.each(fn(file)->
      dst_end = Regex.replace(regex, file, dst)
      case File.rename(file, dst_end) do
        :ok ->
          IO.puts "[SUCCESS] #{file} -> #{dst_end}"
        {:error, _reason} ->
          IO.puts "[FAILED] #{file} -> #{dst_end}"
      end
    end)
  end
end

watch = fn(arg, time, func) ->
  spawn_link(MoveTo, :watch, arg)
  if time > 0 do
    :timer.sleep(time)
    func.(arg, time, func)
  end
end

case System.argv do
  [_src, _dst, _re] ->
    watch.(System.argv, 1000, watch)
  _ ->
    IO.puts "move_on [source] [destination] [regular_expression]"
end
