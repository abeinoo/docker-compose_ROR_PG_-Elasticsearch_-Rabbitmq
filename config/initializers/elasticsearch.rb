ELASTICSEARCH_CONFIG = proc do
  host = ENV['ELEASTIC_HOST']
  port = ENV['ELEASTIC_PORT']
  elestic_ready = host.present? and port.present?
  elesticsearch_url = if elestic_ready
    "http://#{host}:#{port}"
  else
    "http://localhost:9200"
    end
  end

  Elasticsearch::Model.client = Elasticsearch::Client.new(url: ELASTICSEARCH_CONFIG.call, retry_on_failure: 5)
