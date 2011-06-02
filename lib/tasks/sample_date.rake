require 'active_record'
require 'active_record/fixtures'
namespace :db do
	DATA_DIRECTORY="#{Rails.root.to_s}/lib/tasks/sample_data"
	namespace :sample_data do
		TABLES=%w(users specs faqs)
		MIN_USER_ID=1000
		desc 'Load sample data'
		task :load=> :environment do |t|
			class_name=nil
			TABLES.each do |table_name|
				fixture=Fixtures.new(ActiveRecord::Base.connection, table_name, class_name, File.join(DATA_DIRECTORY,table_name.to_s))
				fixture.insert_fixtures
				puts "load date from #{table_name}.yaml"
			end
			puts "load finished!"
		end
		desc "Remove sample data"
		task :delete=> :environment do |t|
			User.delete_all("id>=#{MIN_USER_ID}")
			Spec.delete_all("id>=#{MIN_USER_ID}")
			Faq.delete_all("id>=#{MIN_USER_ID}")
			puts "delete finished!"
		end
	end
end
