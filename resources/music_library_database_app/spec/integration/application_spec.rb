require "spec_helper"
require "rack/test"
require_relative '../../app'

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  def reset_all_table
    seed_sql = File.read('spec/seeds/music_library.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
    connection.exec(seed_sql)
  end
    
  before(:each) do
    reset_all_table
  end

  # context 'GET /albums' do
  #   it 'should return a list of albums' do
  #     response = get('/albums')
      
  #     expected_response = 'Doolittle, Surfer Rosa, Waterloo, Super Trouper, Bossanova, Lover, Folklore, I Put a Spell on You, Baltimore, Here Comes the Sun, Fodder on My Wings, Ring Ring'

  #     expect(response.status).to eq (200)
  #     expect(response.body).to eq (expected_response)
  #   end
  # end

  context 'POST /albums' do
    it 'should create a new album' do
      response = post('/albums', title: 'Ok Computer', release_year: '1997', artist_id: '1')

      expect(response.status).to eq (200)
      expect(response.body).to eq ('')

      response = get('/albums')
      expect(response.body).to include('Ok Computer')
    end
  end

  context 'GET /artists' do
    it "outputs a list of all artists HTML formatted" do
      response = get('/artists')

      expect(response.status).to eq 200
      expect(response.body).to include('<h1>Artists</h1>')
      expect(response.body).to include("<a href='/artists/1'>Pixies</a>")
      expect(response.body).to include('Genre: Rock')
      expect(response.body).to include("<a href='/artists/2'>ABBA</a>")
      expect(response.body).to include('Genre: Pop')
    end
  end

  context 'POST /artists' do
    it 'creates a new artist' do
      response = post('./artists', name: 'Wild Nothing', genre: 'Indie')

      expect(response.status).to eq (200)
      expect(response.body).to eq ('')

      response = get('/artists')
      expect(response.body).to include('Wild Nothing')
    end
  end

  context 'GET /albums/:id' do
    it 'returns the data of a single album formatted in html' do
      response = get('/albums/1')
      expect(response.status).to eq (200)
      expect(response.body).to include ('<h1>Doolittle</h1>')
      expect(response.body).to include ('Release year: 1989')
      expect(response.body).to include ('Artist: Pixies')      
    end
  end

  context 'GET /artists/:id' do
    it 'returns the data for a single artist' do
      response = get('/artists/1')
      expect(response.status).to eq (200)
      expect(response.body).to include ('<h1>Pixies</h1>')
      expect(response.body).to include ('Genre: Rock')
    end
  end

  context "GET /albums" do
    it "outputs a list of all albums HTML formatted" do
      response = get('/albums')

      expect(response.status).to eq 200
      expect(response.body).to include('<h1>Albums</h1>')
      expect(response.body).to include("<a href='/albums/1'>Doolittle</a>")
      expect(response.body).to include('Released: 1989')
      expect(response.body).to include("<a href='/albums/12'>Ring Ring</a>")
      expect(response.body).to include('Released: 1973')
    end
  end

  context "GET /albums/new" do
    it 'returns the form page' do
      response = get('/albums/new')
  
      expect(response.status).to eq(200)
      expect(response.body).to include('<form action="/albums/created" method="POST">')
      
  
      # We can assert more things, like having
      # the right HTML form inputs, etc.
    end
  end
  
  context "POST /albums/created" do
    it 'returns a success page' do
      # We're now sending a POST request,
      # simulating the behaviour that the HTML form would have.
      response = post(
        '/albums/created',
        title: 'Surfer Rosa',
        release_year: '1988',
        artist_id: 2
      )
  
      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Album successfully created</h1>')
    end
  
    it 'responds with 400 status if parameters are invalid' do
      response = post('/albums/created')

      expect(response.status).to eq (400)
    end
  end

end
