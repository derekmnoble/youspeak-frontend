defmodule YouSpeakWeb.Router do
  use YouSpeakWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug YouSpeakWeb.Plugs.SetUser
    plug YouSpeakWeb.Plugs.SetTeacher
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug YouSpeakWeb.Plugs.SetUser
    plug YouSpeakWeb.Plugs.SetTeacher
  end

  scope "/", YouSpeakWeb do
    pipe_through :browser

    get "/", PageController, :index

    get "/teachers/registration/new", Teachers.RegistrationController, :new
    post "/teachers/registration/", Teachers.RegistrationController, :create

    resources "/groups", Groups.GroupController, except: [:delete] do
      resources "/meetings", Meetings.MeetingController, except: [:delete] do
        resources "/comments", Meetings.CommentController, only: [:create]
      end
    end
  end

  scope "/api", YouSpeakWeb do
    pipe_through :api

    scope "/groups/:group_id" do
      scope "/meetings/:meeting_id" do
        resources "/comments", Meetings.CommentController, only: [:create]
      end
    end
  end

  scope "/auth", YouSpeakWeb do
    pipe_through :browser

    get "/signout", Auth.AuthController, :signout
    get "/:provider", Auth.AuthController, :request
    get "/:provider/callback", Auth.AuthController, :callback
  end


  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: YouSpeakWeb.Telemetry
    end
  end
end
