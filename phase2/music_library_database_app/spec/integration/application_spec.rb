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
    xit "returns an hello page if the password is correct" do
      response = get("/", password: 'abcd')

      expect(response.status).to eq 200
      expect(response.body).to include("Hello!")
    end
    
    xit "returns a forbidden page if the password is incorrect" do
      response = get("/", password: 'abcaksdlkajsdlkjoid')

      expect(response.status).to eq 200
      expect(response.body).to include("Access Forbidden!")
    end
  end

  context "GET /albums" do
    it "should return the links to the albums" do
      response = get("/albums")
      
      expect(response.status).to eq 200
      expect(response.body).to include('<p><a href="/albums/1">Doolittle</a></p>')
      expect(response.body).to include('<p><a href="/albums/2">Surfer Rosa</a></p>')
      expect(response.body).to include('<p><a href="/albums/3">Waterloo</a></p>')
      expect(response.body).to include('<p><a href="/albums/12">Ring Ring</a></p>')
    end
  end

  context "GET /albums/:id" do
    it "should return info of the album 1" do
      response = get("/albums/1")
      
      expect(response.status).to eq 200
      expect(response.body).to include('<h1>Doolittle</h1>')
      expect(response.body).to include('Release year: 1989')
      expect(response.body).to include('Artist: Pixies')
    end
  end
  
  context "GET /albums/:id" do
    it "should return info of the album 2" do
      response = get("/albums/2")
      
      expect(response.status).to eq 200
      expect(response.body).to include('<h1>Surfer Rosa</h1>')
      expect(response.body).to include('Release year: 1988')
      expect(response.body).to include('Artist: Pixies')
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
