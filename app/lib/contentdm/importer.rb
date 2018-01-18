# frozen_string_literal: true
require 'nokogiri'

# An importer for ContentDM exported Metadata
module Contentdm
  class Importer
    attr_reader :doc
    attr_reader :records
    attr_reader :input_file
    def initialize(input_file)
      @input_file = input_file
      @doc = File.open(input_file) { |f| Nokogiri::XML(f) }
      @records = @doc.xpath("//record")
      @collection = collection
      @log = Importer.logger
    end

    # Class level method, to be called, e.g., from a rake task
    # @example
    # Contentdm::Importer.import
    def self.import(input_file)
      Importer.new(input_file).import
    end

    def self.logger
      Logger.new(STDOUT)
    end

    def import
      @records.each do |record|
        begin
          work = process_record(record)
          @log.info Rainbow("Adding #{work.id} to collection: #{collection_name}")
        rescue
          @log.error Rainbow("Could not import record #{record}
").red
          Rails.logger.error "Could not import record #{record}"
        end
      end
      @collection.save
    end

    def document_count
      @records.count
    end

    def process_record(record)
      cdm_record = Contentdm::Record.new(record)
      # TODO: How to know whether a work is a Publication, DataSet, ConferenceProceeding, etc?
      @log.info "Creating new Publication for #{cdm_record.identifer}"
      work = work_model(cdm_record.work_type).new
      work.title = cdm_record.title
      work.creator = cdm_record.creator
      work.contributor = cdm_record.contributor
      work.subject = cdm_record.subject
      work.description = cdm_record.description
      work.visibility = Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
      save_work(cdm_record, work)
      @collection.add_members(work.id)
      work
    end

    ##
    # @return [Array<String>] this returns the name of the collection based on the XML
    def collection_name
      [@doc.xpath("//collection_name").text]
    end

    ##
    # @return [ActiveFedora::Base] return the collection object
    def collection
      CollectionBuilder.new(collection_name).find_or_create
    end

    # Converts a class name into a class.
    # @param class_name [String] the type of work we want to create, 'Publication', 'ConferenceProceeding', or 'DataSet'.
    # @return [Class] return the work's class
    # @example If you pass in a string 'Publication', it returns the class ::Publication
    def work_model(class_name)
      # todo - don't hard-code Publication
      class_name.constantize || Publication
    rescue NameError
      raise "Invalid work type: #{class_name}"
    end

    private

      def save_work(cdm_record, work)
        importer_user = ::User.batch_user
        current_ability = ::Ability.new(importer_user)
        env = Hyrax::Actors::Environment.new(work, current_ability, {})

        if Hyrax::CurationConcern.actor.create(env) != false
          @log.info "Saved work with title: #{cdm_record.title[0]}"
        else
          @log.info Rainbow("Problem saving #{cdm_record.identifier}").red
        end
      end
  end
end
