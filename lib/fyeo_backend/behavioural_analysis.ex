defmodule FyeoBackend.BehaviouralAnalysis do
  alias FyeoBackend.Accounts

  def suspicious_attempt?(%Accounts.User{} = user, remote_ip, action) do
    false
  end
end
