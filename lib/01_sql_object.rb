require_relative 'db_connection'
require 'active_support/inflector'
require 'byebug'

class SQLObject
  def self.columns
    if @column_names.nil?
      arr = DBConnection.execute2(<<-SQL)
        SELECT
          *
        FROM
          #{self.table_name}
        LIMIT
          1
      SQL
      @column_names = arr[0].map(&:to_sym)
    else
      @column_names
    end

  end

  def self.finalize!
    self.columns.each do |column_name|
      define_method(column_name) {attributes[column_name]}
      define_method("#{column_name}=") {|value| attributes[column_name] = value}
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name ||= self.name.underscore.pluralize
  end

  def self.all
    array_of_vals= DBConnection.execute2(<<-SQL)
      SELECT
        #{self.table_name}.*
      FROM
        #{self.table_name}
    SQL
    self.parse_all(array_of_vals[1..-1])
  end

  def self.parse_all(results)
    parsed = []
    results.each { |result| parsed << self.new(result) }
    parsed
  end

  def self.find(id)
    found = DBConnection.execute2(<<-SQL, id: id)
      SELECT
        #{self.table_name}.*
      FROM
        #{self.table_name}
      WHERE
        #{self.table_name}.id = :id
    SQL
    return nil if found[1].nil?
    parse_all(found[1..-1])[0]
  end

  def initialize(params = {})
    params.each do |attr_name, value|
      unless self.class.columns.include?(attr_name.to_sym)
        raise "unknown attribute '#{attr_name}'"
      end

      send("#{attr_name}=".to_sym, value)
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    self.class.columns.map {|attr| self.send(attr)}
  end

  def insert
    col_names = self.class.columns.join(', ')
    question_marks = (["?"] * attribute_values.count).join(', ')
    DBConnection.execute2(<<-SQL, *attribute_values )
      INSERT INTO
        #{self.class.table_name} (#{col_names})
      VALUES
        (#{question_marks})

    SQL
    self.id = DBConnection.last_insert_row_id
  end

  def update
    attribute_values = self.attribute_values
    id = self.id
    cols = self.class.columns.map {|attr_name| "#{attr_name} = ?"}.join(', ')
    updating_attribute_values = attribute_values[1..-1]

    DBConnection.execute2(<<-SQL, *attribute_values, id)
      UPDATE
        #{self.class.table_name}
      SET
        #{cols}
      WHERE
        id = ?
    SQL
  end

  def save
    if self.id.nil?
      self.insert
    else
      self.update
    end
  end
  
end
