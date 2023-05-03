require 'spec_helper'
require 'rack/test' 
require_relative '../../app'

describe Application do
  include Rack::Test::Methods

  let(:app) { Application.new }

  context "GET /" do
    it "returns Hello!" do
      response = get("/hello")

      expect(response.status).to eq 200
      expect(response.body).to include("<h1>Hello!</h1>")
    end
  end

  context "when param names is 'Julia, Mary, Karim'" do
    it "should return 'Julia, Mary, Karim'" do
      response = get "/names"
      expect(response.status).to eq 200
      expect(response.body).to eq "Julia, Mary, Karim"
    end
  end

  context "when it receive these names: 'Joe,Alice,Zoe,Julia,Kieran'" do
    it "should return 'Alice,Joe,Julia,Kieran,Zoe'" do
      names = 'Joe,Alice,Zoe,Julia,Kieran'
      response = post("/sort-names?names=#{names}")

      expect(response.status).to eq 200
      expect(response.body).to eq("Alice,Joe,Julia,Kieran,Zoe")
    end
  end
end