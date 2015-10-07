defmodule MoveTo do

  def watch(src, dst, re) do
    files = File.ls!(src)
    regex = Regex.compile!(re)
    Enum.filter(files, &(Regex.match?(regex, &1)))
    |> Enum.each(fn(file)->
      dst_end = Regex.replace(regex, file, dst)
      IO.puts "#{file} -> #{dst_end}"
    end) 
  end

  def move([src_file|src_files], [dst_file|dst_files]) do
    File.rename(src_file, dst_file)
    move(src_files, dst_files)
  end

  def move([], []), do: IO.puts "End move"

end

case System.argv do
  [src, dst, re] ->
    spawn_link(MoveTo, :watch, [src, dst, re])
  _ ->
    IO.puts "move_on [source] [destination] [regular_expression]"
end
