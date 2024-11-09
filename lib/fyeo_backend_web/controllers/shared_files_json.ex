defmodule FyeoBackendWeb.SharedFilesJSON do
  def get_file(%{encrypted_filedata: encrypted_filedata, iv: iv, tag: tag}) do
    %{encrypted_filedata: encrypted_filedata, iv: iv, tag: tag}
  end
end
