require_relative "../config/environment.rb"
require 'active_support/inflector'
require 'interactive_record.rb'

class Student < InteractiveRecord
  def self.table_name
    self.to_s.downcase.pluralize
  end

  def self.column_names
    DB[:conn].execute("PRAGMA table_info('#{table_name}')").map do |column|
      column["name"]
    end.compact
  end

  self.column_names.each do |column_name|
    attr_accessor column_name.to_sym
  end

  def initialize(attributes = {})
    Student.column_names.each do |property, value|
      self.send("#{property}=", value)
    end
  end
end
