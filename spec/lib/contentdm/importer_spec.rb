# frozen_string_literal: true
require 'rails_helper'

describe Contentdm::Importer do
  let(:cdmi) { described_class.new(input_file, data_path, default_model) }
  let(:input_file) { file_fixture('ContentDM_XML_Full_Fields.xml') }
  let(:data_path) { Rails.root.join('spec', 'fixtures', 'files') }
  let(:default_model) { 'DataSet' }

  context 'processing an export file' do
    it 'can instantiate' do
      expect(cdmi).to be_instance_of(described_class)
    end
    it 'has a Nokogiri DOM document' do
      expect(cdmi.doc).to be_instance_of(Nokogiri::XML::Document)
    end
    it 'knows how many documents are in the import file' do
      expect(cdmi.document_count).to eq(1)
    end
    it 'knows which input file it will import' do
      expect(cdmi.input_file).to eq input_file
    end
    it 'can determine the collection title' do
      expect(cdmi.collection_name).to eq(['Sargent and Sims'])
    end
    it 'has a default work type' do
      expect(cdmi.default_work_model).to eq 'DataSet'
    end
  end

  context 'processing a single record' do
    before do
      ActiveFedora::Cleaner.clean!
      @record = cdmi.records.first
    end
    it 'turns a contentdm record into a Fedora object' do
      work = cdmi.process_record(@record)
      expect(work).to be_instance_of(Publication)
    end
    it 'sets the Fedora object\'s visibility to open' do
      work = cdmi.process_record(@record)
      expect(work.visibility).to eq('open')
    end
    it 'adds the object to the collection' do
      work = cdmi.process_record(@record)
      cdmi.collection.save
      expect(cdmi.collection.members.last.id).to eq(work.id)
    end
  end

  describe '#work_model' do
    subject(:model) { cdmi.work_model(model_name) }

    context 'with a valid string name for a model' do
      let(:model_name) { 'ConferenceProceeding' }
      it { is_expected.to eq ConferenceProceeding }
    end

    context 'with an invalid string' do
      let(:model_name) { 'Conference Proceeding' }

      it 'raises an error' do
        expect { model }.to raise_error('Invalid work type: Conference Proceeding')
      end
    end

    context 'with no value' do
      let(:model_name) { nil }

      it 'uses the default work model' do
        expect(model).to eq DataSet
        expect(model.to_s).to eq cdmi.default_work_model
      end
    end
  end
end