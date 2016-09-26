require 'fluent/filter'

module Fluent
  class JsonSchemaFilter < Filter
    Fluent::Plugin.register_filter('json_schema', self)

    # Define `router` method of v0.12 to support v0.10 or earlier
    unless method_defined?(:router)
      define_method("router") { Fluent::Engine }
    end

    config_param :mode, :enum, :list=>[:discard, :isolate, :enrich], :default => 'isolate'
    config_param :schema_file, :string, :default => '/etc/td-agent/schema.json'
    config_param :enrich_valid, :hash, :default => { 'valid' => true }
    config_param :enrich_invalid, :hash, :default => { 'valid' => false }
    config_param :isolate_tag_prefix, :string, :default => "invalid"
    config_param :add_validation_error, :bool, :default => true

    def initialize
      super
      require "json-schema"
    end

    def start
      super
    end 

    def shutdown
      super
    end

    def configure(conf)
      super
    end

    def filter_stream(tag, es)
      new_es = MultiEventStream.new
      es.each { |time, record|
        new_record = record.dup
        begin
          valid, error_msg = validate(record)
          log.debug "Match: #{valid}"
          log.debug "Message: #{error_msg}"

          if not valid
            new_record['validation-error']=error_msg if @add_validation_error

            case @mode
            when :discard
              next 
            when :enrich
              @enrich_invalid.each_pair{|k,v| new_record[k]=v}
            when :isolate
              router.emit("#{@isolate_tag_prefix}.#{tag}", time, new_record)
              next 
            end
          else
            case @mode
            when :enrich
              @enrich_valid.each_pair{|k,v| new_record[k]=v}
            end
          end
          
          new_es.add(time, new_record)
        rescue => e
          router.emit_error_event(tag, time, record, e)
        end
      }
      new_es
    end

    private 

    def validate(record) 
      begin
        JSON::Validator.validate!(@schema_file, record)
      rescue JSON::Schema::ValidationError => e
         return false, e.message
      end
      return true, nil
    end

  end
end
