# frozen_string_literal: true

require 'sinatra/base'
require 'logger'

# App is the main application where all your logic & routing will go
class App < Sinatra::Base
  set :erb, escape_html: true
  enable :sessions

  attr_reader :logger

  def initialize
    super
    @logger = Logger.new('log/app.log')
  end

  def title
    'Summer Instititue App'
  end
    
    def projects_root
        "#{__dir__}/projects/"
    end
  get '/examples' do
    erb(:examples)
  end
    

def sanitizeName(name = "")
    name.downcase.gsub(" ", "_")
end
  get '/' do
    logger.info('requsting the index')
    @flash = session.delete(:flash) || { info: 'Welcome to Summer Institute!' }
    @projectDirect = Dir.children(projects_root).select do |path|
        Pathname.new("#{projects_root}/#{path}").directory?
    end.sort_by(@:to_s)
    erb(:index)
  end
  
    post '/projects/new' do
     
     name = params[:name].downcase.gsub(" ", "_")
     FileUtils.mkdir_p("#{projects_root}/#{name}")
     session[:flash] = {info: "Made the project #{name}"}
     redirect(url("/projects/#{name}"))
    end
  get '/projects/:name' do
    if params[:name] == 'new'
      erb(:new_project)
    else
      @directory = Pathname.new("#{projects_root}/#{params[:name]}")
      if(@directory.directory? && @directory.readable?)
        erb(:show_project)
      else
        session[:flash] = { danger: "#{@directory} does not exist" }
        redirect(url('/'))
      end
    end
  end
end
