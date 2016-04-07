require_relative '02_searchable'
require 'active_support/inflector'
require 'byebug'

# Phase IIIa
class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    # @model_class ||= self.class_name.constantize
    @class_name.constantize
  end

  def table_name
    # @table_name ||= self.class_name.underscore.pluralize
    model_class.table_name
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    defaults = {
      :foreign_key => "#{name.to_s.underscore}_id".to_sym,
      :class_name => name.to_s.singularize.camelcase,
      :primary_key => :id
    }

    defaults.keys.each do |key|
      self.send("#{key}=", options[key] || defaults[key])
    end

  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    defaults = {
      :foreign_key => "#{self_class_name.to_s.underscore}_id".to_sym,
      :class_name => name.to_s.singularize.camelcase,
      :primary_key => :id
    }

    defaults.keys.each do |key|
      self.send("#{key}=", options[key] || defaults[key])
    end
  end
end

module Associatable
  # Phase IIIb
  def belongs_to(name, options = {})
    self.assoc_options[name] = BelongsToOptions.new(name, options)
    define_method(name) do
      options = self.class.assoc_options[name]
      foreign_key_val = self.send(options.foreign_key)
      return nil if foreign_key_val.nil?
      result = DBConnection.execute2(<<-SQL)
        SELECT
          #{options.table_name}.*
        FROM
          #{options.table_name}
        WHERE
          #{options.table_name}.#{options.primary_key} = #{foreign_key_val}
      SQL
      options.model_class.parse_all(result[1..-1]).first
    end
  end

  def has_many(name, options = {})
    options = HasManyOptions.new(name, self.name, options)
    define_method(name) do
      primary_key_val = self.send(options.primary_key)
      return nil if primary_key_val.nil?
      result = DBConnection.execute2(<<-SQL)
        SELECT
          #{options.table_name}.*
        FROM
          #{options.table_name}
        WHERE
          #{options.table_name}.#{options.foreign_key} = #{primary_key_val}
      SQL
      options.model_class.parse_all(result[1..-1])
    end
  end

  def assoc_options
    # Wait to implement this in Phase IVa. Modify `belongs_to`, too.
    @assoc_options ||= {}
    @assoc_options
  end
end

class SQLObject
  # Mixin Associatable here...
  extend Associatable
end