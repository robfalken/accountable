defmodule Accountable.Controller do
  import Plug.Conn

  def init(options), do: options

  def call(%{params: params} = conn, :authenticate) do
    with %{"email" => email, "password" => password} <- params,
         {:ok, user} <- Accountable.user_by_credentials(email, password),
         {:ok, token} <- Accountable.token_for_user(user) do
      conn
      |> put_resp_cookie("AccessToken", token)
      |> put_resp_content_type("application/json")
      |> send_resp(200, ~s({"accessToken": "#{token}", "userId": "#{user.id}"}))
    else
      _ ->
        send_error_response(conn)
    end
  end

  def call(conn, :refresh) do
    with %{cookies: %{"AccessToken" => token}} <- fetch_cookies(conn),
         {:ok, user} <- Accountable.user_by_token(token),
         {:ok, token} <- Accountable.token_for_user(user) do
      conn
      |> put_resp_cookie("AccessToken", token)
      |> put_resp_content_type("application/json")
      |> send_resp(200, ~s({"accessToken": "#{token}", "userId": "#{user.id}"}))
    else
      _ ->
        conn
        |> delete_resp_cookie("AccessToken")
        |> send_error_response()
    end
  end

  def call(conn, :logout) do
    conn
    |> delete_resp_cookie("AccessToken")
    |> send_resp(200, "{}")
  end

  defp send_error_response(conn) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(401, error_response())
  end

  defp error_response do
    Poison.encode!(%{error: "Authentication failed"})
  end
end
