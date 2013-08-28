RailsExample::Application.routes.draw do
  get 'hi' => 'hello#hi'
  get 'hello' => 'hello#hello'
end
