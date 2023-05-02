require 'sinatra/base'

class Application < Sinatra::Base
  
  get '/hello' do
    name = params[:name]
    return "Hello #{name}!"
  end

  get '/names' do
    return "Julia, Mary, Karim"
  end
  
  post '/sort-names' do
    names = params[:names]
    sorted = names.split(",").sort!
    
    return sorted.join(",")
  end
end