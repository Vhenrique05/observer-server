defmodule Web.Db.Users do
  require SecureRandom

  alias Comeonin.Bcrypt
  alias RedisPoolex, as: Redis

  def verify_key(api_key) do
    Redis.query(["EXISTS", api_key]) == "1"
  end

  def register(%{email: nil, password: _password}), do: {:error, :missing_email}
  def register(%{email: _email, password: nil}), do: {:error, :missing_password}
  def register(%{email: email, password: password}) do
    api_key = SecureRandom.base64(8)
    Redis.query_pipe([
      ["hmset", api_key,
       "email", email,
       "password", Bcrypt.hashpwsalt(password)]
    ])
    {:ok, api_key}
  end
end
