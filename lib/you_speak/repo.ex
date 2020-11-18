defmodule YouSpeak.Repo do
  use Ecto.Repo,
    otp_app: :you_speak,
    adapter: Ecto.Adapters.Postgres
end
