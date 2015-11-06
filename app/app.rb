require 'sinatra/base'
require 'data_mapper'
require 'dm-postgres-adapter'
require_relative 'data_mapper_setup'


class BookmarkManager < Sinatra::Base
  helpers do
    def current_user
      @current_user ||= User.get(session[:user_id])
    end
  end
  enable :sessions

  set :session_secret, 'super secret'

  get '/' do
    redirect '/links'
  end

  get '/links' do
    current_user
    @links = Link.all
    erb :links
  end

  get '/sign_up' do
    erb :sign_up
  end

  post '/new_user' do
    user = User.create(:user_name => params[:user_name], :email_address => params[:email_address], :password_digest => params[:password])
    session[:user_id] = user.id
    redirect '/links'
  end

  get '/links/new' do
    erb :new_link_form
  end

  post '/links' do
    link = Link.create(:url => params[:url], :title => params[:title])
    tags = params[:tag]
    tags.split.each do |tag|
    link.tags << Tag.create(:name => tag)
    end
    link.save
    redirect '/links'
  end

  get '/search' do
    erb :search
  end

  post '/search' do
    redirect "/tags/#{params[:tags]}"
  end

  get "/tags/:tag" do
    @tag = Tag.all(name: params[:tag])
    @links = @tag.links
    erb :results
  end


  # start the server if ruby file executed directly
  run! if app_file == $0
end
