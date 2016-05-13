# fluent-plugin-json-schema-filter

[![Build Status](https://travis-ci.org/ansoni/fluent-plugin-json-schema-filter.svg?branch=master)](https://travis-ci.org/ansoni/fluent-plugin-json-schema-filter)
[![Gem Version](https://badge.fury.io/rb/fluent-plugin-json-schema-filter.svg)](https://badge.fury.io/rb/fluent-plugin-json-schema-filter)

[Fluentd](http://fluentd.org) filter plugin to validate records against a [json-schema](http://json-schema.org)

## Installation
Use RubyGems:

    gem install fluent-plugin-json-schema-filter

## Configuration

*Discard Example*:

	<match foo.**>
	  @type json_schema
	  mode discard
	  schema_file /some/path.json #defaults to /etc/td-agent/schema.json
	</match>

will result in records that do not validate being completely discarded.

*Isolate Example*:

	<match foo.**>
	  @type json_schema
	  mode isolate
	  schema_file ...
	  isolate_tag_prefix invalid
          add_validation_error true # results in a validation-error key being added to the record
	</match>

will result in invalid records being tagged as "invalid.<input tag>".  In the example above, invalid records would be invalid.foo.\*\*

*Enrich Example*

	<match foo.**>
	  @type json_schema
	  mode enrich
	  schema_file ...
	  enrich_valid {
	    'valid': 'This is a great document' 
	  } # default valid: true
	  enrich_invalid { 
	    'invalid': 'You suck at the JSON' 
	  } # default valid: false
          add_validation_error true # results in a validation-error key being added to the record
	</match>

will result in messages gaining either the enrich_valid or enrich_invalid depending on how the record validates.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
