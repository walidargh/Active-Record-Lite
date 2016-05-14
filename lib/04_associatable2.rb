require_relative '03_associatable'

module Associatable

  def has_one_through(name, through_name, source_name)
    define_method(name) do
          through_options = self.class.assoc_options[through_name]
          source_options = through_options.model_class.assoc_options[source_name]
          source_options = through_options.model_class.assoc_options[source_name]
          p key = self.send(through_options.foreign_key)
      result = DBConnection.execute2(<<-SQL, key)
        SELECT
          #{source_options.table_name}.*
        FROM
          #{through_options.table_name}
        JOIN
          #{source_options.table_name}.first
    end
  end
end
