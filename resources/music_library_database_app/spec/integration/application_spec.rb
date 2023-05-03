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
    it 'should return a list of all the artists' do
      response = get('/artists')

      expected_response = 'Pixies, ABBA, Taylor Swift, Nina Simone'
      
      expect(response.status).to eq (200)
      expect(response.body).to eq (expected_response)
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

  context "GET /albums" do
    it "outputs a list of all albums HTML formatted" do
      response = get('/albums')

      expect(response.status).to eq 200
      expect(response.body).to include('<h1>Albums</h1>')
      expect(response.body).to include('<div>')
      expect(response.body).to include('Title: Doolittle')
      expect(response.body).to include('Released: 1989')
      expect(response.body).to include('Title: Folklore')
      expect(response.body).to include('Released: 2020')
      expect(response.body).to include('Title: Ring Ring')
      expect(response.body).to include('Released: 1973')
    end
  end

end
