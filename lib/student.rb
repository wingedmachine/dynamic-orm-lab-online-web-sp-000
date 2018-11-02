require_relative "../config/environment.rb"
require 'active_support/inflector'
require 'interactive_record.rb'

class Student < InteractiveRecord
  def self.table_name
    self.to_s.downcase.pluralize
  end

  def self.column_names
    DB[:conn].execute("PRAGMA table_info('#{table_name}')").map do |column|
      column[:name]
    end.compact
  end
end
