require 'rexml/document'
require 'rest-core'
require 'rest-core/middleware'

module Topcoder
  # Rest-core middleware to parse TopCoder XML
  # We can hardly find a generic way to parse XML to Ruby object
  # However, Topcoder XML feed is naive :)
  class XmlParser
    def self.members; [:xml_parser]; end
    include ::RestCore::Middleware

    def call(env)
      response = app.call(env)
      begin
        response.merge(RESPONSE_BODY => parse_xml(response[RESPONSE_BODY]))
        # response.merge(RESPONSE_BODY => self.class.json_decode("[#{response[RESPONSE_BODY]}]").first)
      rescue Exception => e
        fail(response, e)
      end
    end

    private

    def parse_xml(xml)
      results = []

      doc = REXML::Document.new(xml)
      doc.root.each_element do |row|
        current = {}
        row.each_element do |field|
          current[field.name] = field.text
        end
        results << current
      end

      results
    end

  end
end
