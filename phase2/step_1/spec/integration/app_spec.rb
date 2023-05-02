require 'spec_helper'
require 'rack/test' 
require_relative '../../app'

describe Application do
  include Rack::Test::Methods

  let(:app) { Application.new }

  context "When param 'name' is 'Andy" do
    it "should return 'Hello Andy!'" do
      response = get("/hello?name=Andy")
      expect(response.status).to eq(200)
      expect(response.body).to eq("Hello Andy!")
      end
    end

  context "When param 'name' is 'John" do
    it "should return 'Hello John!'" do
    response = get("/hello?name=John")
    expect(response.status).to eq(200)
    expect(response.body).to eq("Hello John!")
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