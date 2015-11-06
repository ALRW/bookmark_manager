require 'sinatra/base'
require_relative './models/link.rb'
require 'data_mapper'
require 'dm-postgres-adapter'
require_relative 'data_mapper_setup'


class BookmarkManager < Sinatra::Base
  get '/' do
    redirect '/links'
  end
  get '/links' do
    @links = Link.all
    erb :links
  end

  get '/sign_up' do
    erb :sign_up
  end

  post '/new_user' do
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
