require "spec_helper"
require "rack/test"
require_relative '../../app'

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  def reset_tables
  seed_sql = File.read('spec/seeds/music_library.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
  connection.exec(seed_sql)
  end

  before(:each) do 
    reset_tables
  end

  context "GET /" do
    it "returns an html list of names" do
      response = get("/")

      expect(response.status).to eq 200
      expect(response.body).to include("<p>Anna</p>")
      expect(response.body).to include("<p>Kim</p>")
      expect(response.body).to include("<p>Josh</p>")
      expect(response.body).to include("<p>David</p>")
      
    end
  end

  context "GET /albums" do
    it "should return the list of albums" do
      response = get("/albums")

      expected_response = "Doolittle, Surfer Rosa, Waterloo, Super Trouper, Bossanova, Lover, Folklore, I Put a Spell on You, Baltimore, Here Comes the Sun, Fodder on My Wings, Ring Ring"
      
      expect(response.status).to eq 200
      expect(response.body).to eq(expected_response)
    end
  end
  
  context "POST /albums" do
    it "should add a new album" do 
      response = post(
        '/albums', 
        title: 'Voyage', 
        release_year: '2022', 
        artist_id: '2'
      )
      expect(response.status).to eq(200)
      expect(response.body).to eq("")
      
      response = get("/albums")
      
      expect(response.body).to include("Voyage")
    end 
  end
  
  context "GET /artists" do
    it "should return the list of artists" do
      response = get("/artists")

      expected_response = "Pixies, ABBA, Taylor Swift, Nina Simone"
      
      expect(response.status).to eq 200
      expect(response.body).to eq(expected_response)
    end
  end

  context "POST /artists" do
    it "should add 'Wild nothing' to the artists" do
      response = post("/artists", name: 'Wild nothing', genre: 'Indie')
      expect(response.status).to eq 200
      
      response = get("/artists")
      expect(response.body).to include("Wild nothing")
      expect(response.body).to eq("Pixies, ABBA, Taylor Swift, Nina Simone, Wild nothing")
    end
  end
  
end
