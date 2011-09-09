require 'rest-core'
require 'rest-core/middleware'
require 'nokogiri'

module Topcoder
  # Rest-core middleware to parse TopCoder BasicData XML
  class Parser
    def self.members; [:topcoder_parser]; end
    include ::RestCore::Middleware

    VALID_PARSERS = [:xml, :data]

    def call(env)
      response = app.call(env)

      parser_type = topcoder_parser(env)
      data = self.class.parse(parser_type, response[RESPONSE_BODY])
      response.merge(RESPONSE_BODY => data)
    end

    class << self
      def parse(parser_type, body)
        if [:xml, :data].include?(parser_type)
          schema_name, data = parse_xml(body)
          data = parse_data(schema_name, data) if parser_type==:data
          data
        else
          body
        end
      end

      def parse_xml(xml)
        data = []

        doc = Nokogiri::XML(xml)
        schema_name = doc.root.name
        doc.root.children.each do |row|
          tuples = row.elements.map { |f| [f.name.to_sym, f.text] }
          data << Hash[tuples]
        end
        [schema_name, data]
      end

      def parse_data(schema_name, data)
        raise "Unknown schema #{schema_name}" unless DataConverter.instance_methods.include?(schema_name)
        data.each do |datum|
          DataConverter.new(datum).send(schema_name)
        end
        data
      end
    end
  end
end
