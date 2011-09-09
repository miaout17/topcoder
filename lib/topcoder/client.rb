require 'rest-core'

module Topcoder
  Client = ::RestCore::Builder.client do
    use ::RestCore::DefaultSite , 'http://www.topcoder.com/tc'
    use ::RestCore::DefaultQuery, {:module => 'BasicData'}
    use ::Topcoder::Parser, :data
    use ::RestCore::CommonLogger, method(:puts)
    run ::RestCore::RestClient
  end
  class Client
    def get_algorithm_round_list
      get('', {:c => 'dd_round_list'})
    end
  end
end


