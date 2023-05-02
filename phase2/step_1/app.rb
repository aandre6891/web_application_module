require 'sinatra/base'

class Application < Sinatra::Base
  
  get '/hello' do
    name = params[:name]
    return "Hello #{name}!"
  end

  get '/names' do
    return "Julia, Mary, Karim"
  end
end