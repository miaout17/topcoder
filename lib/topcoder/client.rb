require 'rest-core'

module Topcoder
  Client = ::RestCore::Builder.client do
    use ::RestCore::DefaultSite , 'http://www.topcoder.com/tc'
    use ::RestCore::DefaultQuery, {:module => 'BasicData'}
    use ::Topcoder::XmlParser
    use ::RestCore::CommonLogger, method(:puts)
    run ::RestCore::RestClient
  end
  Client.send(:include, ::Topcoder::API)
end


