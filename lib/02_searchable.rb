require_relative 'db_connection'
require_relative '01_sql_object'

module Searchable
  def where(params)
    values = params.values
    where_line = params.keys.map {|param| "#{param} = ?"}.join(' AND ')

    matches = DBConnection.execute2(<<-SQL, *values)
      SELECT
        #{self.table_name}.*
      FROM
        #{self.table_name}
      WHERE
        #{where_line}
    SQL

    parse_all(matches[1..-1])
  end
end

class SQLObject
  extend Searchable
end
