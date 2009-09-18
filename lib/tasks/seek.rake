require 'rubygems'
require 'rake'
require 'model_execution'
require 'active_record/fixtures'

namespace :seek do

  task(:rebuild_project_organisms=>:environment) do
    organism_taggings=Tagging.find(:all, :conditions=>['context=? and taggable_id > 0', 'organisms'])
    puts "found #{organism_taggings.size} organism taggings"
    organism_taggings.each do |tagging|
      if tagging.taggable_type == "Project"
        tag=tagging.tag
        project=tagging.taggable
        organism=Organism.find(:first, :conditions=>["title=?", tag.name])
        if organism.nil?
          puts "unable to find organism #{tag.name} required for project #{project.title}"
        else
          puts "adding #{organism.title} to #{project.title} "
          class << project
            def record_timestamps
              false
            end
          end
          project.organisms << organism unless project.organisms.include?(organism)
          project.save!
        end
      else
        puts "Tagging with id #{tagging.id} is not for Project"
      end

    end

  end

  task(:refresh_controlled_vocabs=>:environment) do
    other_tasks=["culture_growth_types","model_types","model_formats","assay_types","disciplines","organisms","technology_types","recommended_model_environments","measured_items","units","roles","repop_cv","update_first_letters"]
    other_tasks.each do |task|
      Rake::Task[ "seek:#{task}" ].execute      
    end

  end

  task(:list_dubious_tags=>:environment) do
    tags=Tag.find(:all)
    dubious=tags.select{|tag| dubious_tag?(tag.name)}
    dubious.each{|tag| puts "#{tag.id}\t#{tag.name}" }
  end

  task(:culture_growth_types=>:environment) do
    CultureGrowthType.delete_all
    Fixtures.create_fixtures(File.join(RAILS_ROOT, "config/default_data" ), "culture_growth_types")
  end

  task(:model_types=>:environment) do
    ModelType.delete_all
    Fixtures.create_fixtures(File.join(RAILS_ROOT, "config/default_data" ), "model_types")
  end

  task(:model_formats=>:environment) do
    ModelFormat.delete_all
    Fixtures.create_fixtures(File.join(RAILS_ROOT, "config/default_data" ), "model_formats")
  end

  task(:assay_types=>:environment) do
    AssayType.delete_all
    Fixtures.create_fixtures(File.join(RAILS_ROOT, "config/default_data" ), "assay_types")
  end

  task(:disciplines=>:environment) do
    Discipline.delete_all
    Fixtures.create_fixtures(File.join(RAILS_ROOT, "config/default_data" ), "disciplines")
  end

  task(:organisms=>:environment) do
    Organism.delete_all
    Fixtures.create_fixtures(File.join(RAILS_ROOT, "config/default_data" ), "organisms")
  end

  task(:technology_types=>:environment) do
    TechnologyType.delete_all
    Fixtures.create_fixtures(File.join(RAILS_ROOT, "config/default_data" ), "technology_types")
  end

  task(:recommended_model_environments=>:environment) do
    RecommendedModelEnvironment.delete_all
    Fixtures.create_fixtures(File.join(RAILS_ROOT, "config/default_data" ), "recommended_model_environments")
  end

  task(:measured_items=>:environment) do
    MeasuredItem.delete_all
    Fixtures.create_fixtures(File.join(RAILS_ROOT, "config/default_data" ), "measured_items")
  end

  task(:units=>:environment) do
    Unit.delete_all
    Fixtures.create_fixtures(File.join(RAILS_ROOT, "config/default_data" ), "units")
  end

  task(:roles=>:environment) do
    Role.delete_all
    Fixtures.create_fixtures(File.join(RAILS_ROOT, "config/default_data" ), "roles")
  end

  task(:repop_cv=>:environment) do

    File.open('config/expertise.list').each do |item|
      unless item.blank?
        item=item.chomp
        if Person.expertise_counts.find{|tag| tag.name==item}.nil?
          tag=Tag.new(:name=>item)
          taggable=Tagging.new(:tag=>tag, :context=>"expertise", :taggable_type=>"Person")
          taggable.save!
        end
      end
    end

    File.open('config/tools.list').each do |item|
      unless item.blank?
        item=item.chomp
        if Person.tool_counts.find{|tag| tag.name==item}.nil?
          tag=Tag.new(:name=>item)
          taggable=Tagging.new(:tag=>tag, :context=>"tools", :taggable_type=>"Person")
          taggable.save!
        end
      end
    end
    
  end

  desc "Generate an XMI db/schema.xml file describing the current DB as seen by AR. Produces XMI 1.1 for UML 1.3 Rose Extended, viewable e.g. by StarUML"
  task :xmi => :environment do
    require 'lib/uml_dumper.rb'
    File.open("doc/data_models/schema.xmi", "w") do |file|
      ActiveRecord::UmlDumper.dump(ActiveRecord::Base.connection, file)
    end
    puts "Done. Schema XMI created as doc/data_models/schema.xmi."
  end

  task :update_first_letters => :environment do
    (Person.find(:all)|Project.find(:all)|Institution.find(:all)).each do |p|
      #suppress the timestamps being recorded.
      class << p
        def record_timestamps
          false
        end
      end
      p.save #forces the first letter to be updated
      puts "Updated for #{p.class.name} : #{p.id}"
    end
  end

  private

  #returns true if the tag is over 30 chars long, or contains colons, semicolons, comma's or forward slash
  def dubious_tag?(tag)
     tag.length>30 || [";",",",":","/"].detect{|c| tag.include?(c)}
  end

end