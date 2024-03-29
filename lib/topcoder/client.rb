require 'rest-core'

module Topcoder
  Client = ::RestCore::Builder.client do
    use ::RestCore::DefaultSite , 'http://www.topcoder.com/'
    use ::RestCore::DefaultQuery, {:module => 'BasicData'}
    use ::Topcoder::Parser, :data
    use ::RestCore::CommonLogger, method(:puts)
    run ::RestCore::RestClient
  end
  class Client
    def get_coder_list
      get('tc', {:c => 'dd_coder_list'})
    end
    def get_active_algorithm_list
      get('tc', {:c => 'dd_active_algorithm_list'})
    end
    def get_algorithm_round_list
      get('tc', {:c => 'dd_round_list'})
    end
    def get_algorithm_round_results(round_id)
      get('tc', {:c => 'dd_round_results', :rd => round_id})
    end
    def get_algorithm_rating_history(coder_id)
      get('tc', {:c => 'dd_rating_history', :cr => coder_id})
    end
  end
end


