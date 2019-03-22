defmodule ExampleWeb.Router do
  use ExampleWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ExampleWeb do
    pipe_through :browser

    get "/", LoginController, :index
    post "/", LoginController, :create
  end

  scope "/budget", ExampleWeb do
    pipe_through :browser

    get "/", BudgetController, :index
  end

  scope "/signup", ExampleWeb do
    pipe_through :browser

    get "/", RegistrationController, :index
    post "/", RegistrationController, :create
  end

  # Other scopes may use custom stacks.
  # scope "/api", ExampleWeb do
  #   pipe_through :api
  # end
end
