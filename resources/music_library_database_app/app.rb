# file: app.rb
require 'sinatra'
require "sinatra/reloader"
require_relative 'lib/database_connection'
require_relative 'lib/album_repository'
require_relative 'lib/artist_repository'

DatabaseConnection.connect

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/album_repository'
    also_reload 'lib/artist_repository'
  end

  # get '/albums' do
  #   repo = AlbumRepository.new
  #   albums = repo.all

  #   response = albums.map do |album|
  #     album.title
  #   end

  #   return response.join(', ')
  # end

  get '/' do
    return erb(:index)
  end

  get '/about' do
    return erb(:about)
  end
  
  get '/albums' do
    repo = AlbumRepository.new
    
    @albums = repo.all

    return erb(:albums)
  end

  post '/albums' do
    repo = AlbumRepository.new
    new_album = Album.new
    new_album.title = params[:title]
    new_album.release_year = params[:release_year]
    new_album.artist_id = params[:artist_id]

    repo.create(new_album)

    return ''
  end

  get '/artists' do
    repo = ArtistRepository.new
    
    @artists = repo.all

    return erb(:artists)
  end

  post '/artists' do
    repo = ArtistRepository.new
    new_artist = Artist.new
    new_artist.name = params[:name]
    new_artist.genre = params[:genre]

    repo.create(new_artist)

    return ''
  end

  get '/albums/new' do
    # This route doesn't do much,
    # it returns the view with the HTML form.
    return erb(:new_album)
  end

  get '/albums/:id' do
    album_repo = AlbumRepository.new
    album = album_repo.find(params[:id])

    @album_title = album.title
    @release_year = album.release_year
    
    artist_repo = ArtistRepository.new
    artist = artist_repo.find(album.artist_id)
    @artist_name = artist.name

    return erb(:album)
  end

  get '/artists/:id' do
    artist_repo = ArtistRepository.new
    artist = artist_repo.find(params[:id])

    @artist_name = artist.name
    @genre = artist.genre

    return erb(:artists_id)
  end

  

end