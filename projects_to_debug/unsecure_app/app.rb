require 'sinatra/base'
require "sinatra/reloader"

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    return erb(:index)
  end

  post '/hello' do
    @name = params[:name]

    # unless @name.match?(/\A[[:alpha:][:blank:]]+\z/)
    #   return status 400
    # end
    
    # if invalid_request_parameters?
    #   status 400
      
    #   return ''
    # end

    if invalid_characters
      return status 400
    end
    
    @name = params[:name]

    return erb(:hello)
    
  end

  def invalid_characters
    
    invalid_chars = ["<", ">", "&", "'", '"']
    return invalid_chars.any? { |char| @name.include?(char) }

  end

  # def invalid_request_parameters?
  #   return true if params[:name] == nil
  #   return true if params[:name] == ""
  #   return true if params[:name] == "<"
  #   return true if params[:name] == ">"
  #   return true if params[:name] == "'"
  #   return true if params[:name] == "&"
  #   return true if params[:name] == '"'
  #   return true if params[:name].include? '<script>'
  
  #   return false
  # end
end
