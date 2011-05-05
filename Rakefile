# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'

RailsSpace::Application.load_tasks

task :pub do
  `git push heroku master`
  `git push origin master`
end
