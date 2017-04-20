class Bug < ApplicationRecord
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    before_create :add_number

    has_one :state
    accepts_nested_attributes_for :state , :allow_destroy => true

    
    enum status: [:neww, :in_progress, :closed ]
    enum priority: [:minor, :major, :critical ]

   def self.index_mapping
    __elasticsearch__.client.perform_request('GET', "#{index_name}/_mapping", {}, nil).body[index_name]['mappings'][ActiveSupport::Inflector.singularize(index_name)]
  end

  def self.search(query = nil, options = {})
    search_definition = {
      size: options[:size] || 10,
    }

    if query.present?
      search_definition[:query] = {
        bool: {
          should: [
            multi_match: {
              query: query,
              type: "phrase_prefix",
              fields: %w(comment),
              operator: 'and'
            }
          ]
        }
        # query: { multi_match: { query: query, fields: ['comment^5'] } } }

      }
    end

    __elasticsearch__.search(search_definition).response.hits
  end

    private

    def add_number
        self.class.exists?(application_token: application_token) ? self.number = Bug.where(application_token: application_token).pluck("number").sort.last + 1 : self.number = 1	
    end


end
Bug.import