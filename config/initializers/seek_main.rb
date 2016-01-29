#DO NOT EDIT THIS FILE.
#TO MODIFY THE DEFAULT SETTINGS, COPY seek_local.rb.pre to seek_local.rb AND EDIT THAT FILE INSTEAD

require 'object'
require 'active_record_extensions'
require 'acts_as_taggable_extensions'
require 'seek/acts_as_isa/acts_as_isa'
require 'acts_as_yellow_pages'
require 'seek/acts_as_uniquely_identifiable'
require 'seek/acts_as_fleximage_extension'
require 'acts_as_favouritable'
require 'seek/acts_as_asset/acts_as_asset'
require 'send_subscriptions_when_activity_logged'
require 'send_notification_emails_when_announcement_created'
require 'modporter_extensions'
require "attachment_fu_extension"
require 'seek/taggable'
require 'bio'
require 'uuid'

require 'sunspot_rails'
require 'cancan'
require 'in_place_editing'
require 'seek/breadcrumbs'
require 'string_extension'
require 'recaptcha'
require 'acts_as_list'
require 'acts_as_trashable'

require 'country-select'
require 'will_paginate'
require 'piwik_analytics'
require 'responds_to_parent'
require 'pothoven-attachment_fu'

require 'rightfield/rightfield'
require 'seek/rdf/rdf_generation'
require 'background_reindexing'
require 'subscribable'
require 'seek/permissions/publishing_permissions'

require 'seek/scalable'

require 'taverna_player_callbacks'
require 'taverna_player_renderers'

require 'seek/search/common_fields'

require 'seek/project_hierarchies/project_extension'
require 'mimemagic'
require 'site_announcements'

SEEK::Application.configure do
  GLOBAL_PASSPHRASE="ohx0ipuk2baiXah" unless defined? GLOBAL_PASSPHRASE

  ASSET_ORDER = ['Person', 'Project', 'Institution', 'Investigation', 'Study', 'Assay', 'Sample','Specimen','Strain', 'DataFile', 'Model', 'Sop', 'Publication', 'Presentation','SavedSearch', 'Organism', 'Event']

  PORTER_SECRET = "" unless defined? PORTER_SECRET

  Seek::Config.propagate_all

  #Need to load defaut_locale file for internationalization used in Inflector below
  #coz this file is loaded at a later point
  I18n.load_path << File.join(File.dirname(__FILE__), "../locales/en.yml")
  #these inflections are put here, because the config variables are just loaded after the propagation
  ActiveSupport::Inflector.inflections do |inflect|
    inflect.human 'Specimen', I18n.t('biosamples.sample_parent_term')
    inflect.human 'specimen', I18n.t('biosamples.sample_parent_term')
    inflect.human 'Assay', I18n.t('assays.assay')
    inflect.human 'assay', I18n.t('assays.assay')
    inflect.human 'Sop', I18n.t('sop')
    inflect.human 'sop', I18n.t('sop')
    inflect.human 'Presentation', I18n.t('presentation')
    inflect.human 'presentation', I18n.t('presentation')
    inflect.human 'DataFile', I18n.t('data_file')
    inflect.human 'data_file', I18n.t('data_file')
    inflect.human 'Investigation', I18n.t('investigation')
    inflect.human 'investigation', I18n.t('investigation')
    inflect.human 'Study', I18n.t('study')
    inflect.human 'study', I18n.t('study')
    inflect.human 'Model', I18n.t('model')
    inflect.human 'model', I18n.t('model')
    inflect.human 'Event', I18n.t('event')
    inflect.human 'event', I18n.t('event')
    inflect.human 'Project', I18n.t('project')
    inflect.human 'project', I18n.t('project')
  end


  Annotations::Config.attribute_names_to_allow_duplicates.concat(["tag"])
  Annotations::Config.versioning_enabled = false

  ENV['LANG'] = 'en_US.UTF-8'

  begin
    if ActiveRecord::Base.connection.table_exists? 'delayed_jobs'
      SendPeriodicEmailsJob.create_initial_jobs
      NewsFeedRefreshJob.create_initial_job
    end
  rescue Exception=>e
    Rails.logger.error "Error creating default delayed jobs - #{e.message}"
  end

  ConvertOffice::ConvertOfficeConfig.options =
      {
          :java_bin=>"java",
          :soffice_port=>8100,
          :nailgun=>false,
          :verbose=>false,
          :asynchronous=>false
      }

end