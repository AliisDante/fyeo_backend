defmodule FyeoBackend.Watermark do
  import Mogrify

  defp get_random_filename() do
    filename = :rand.bytes(16) |> Base.url_encode64()
    Path.join(System.tmp_dir!(), filename)
  end

  def generate_watermark_image(message, size) do
    filename = get_random_filename() <> ".png"
    File.write(filename, "")

    %Mogrify.Image{path: "", ext: ""}
    |> gravity("Center")
    |> custom("background", "transparent")
    |> custom("fill", "gray")
    |> custom("size", size)
    |> format("png")
    |> create(path: System.tmp_dir!)
  end
end
