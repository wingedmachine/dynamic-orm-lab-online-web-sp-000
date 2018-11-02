require_relative "../config/environment.rb"
require 'active_support/inflector'

class InteractiveRecord
  def self.table_name
    self.to_s.downcase.pluralize
  end

  def self.column_names
    DB[:conn].execute("PRAGMA table_info('#{table_name}')").map do |column|
      column["name"]
    end.compact
  end

  def initialize(options = {})
    options.each do |property, value|
      self.send("#{property}=", value)
    end
    self
  end

  def table_name_for_insert
    self.class.table_name
  end

  def col_names_for_insert
    col_names = self.class.column_names
    col_names.delete("id")
    col_names.join(", ")
  end

  def values_for_insert
    self.class.column_names.map { |attribute| self.send(attribute) } 
  end
end
