require 'sinatra/base'

class Application < Sinatra::Base
  # GET /
  # root path
  get '/hello' do

    name = params[:name]
    return "Hello #{name}"
  end

  get '/' do

    return 'Hello!'
  end
  
  get '/posts' do
    name = params[:name]
    cohort_name = params[:cohort_name]

    p name
    p cohort_name
    return "Hello #{name}, you are in the cohort #{cohort_name} of posts"
  end

  post '/posts' do
    title = params[:title]

    return "Post was created with title: #{title}"
  end
end