module Preformatter
  
  def self.included(base)
    base.extend ClassMethods
  end
  
  def self.has_spanish_chars?(string)
    string.index(/[áéíóúñÑÁÉÍÓÚ]/) rescue nil
  end
  
  def self.replace_spanish_chars_in(string)
    replace = {'á' => 'a','é' => 'e','í' => 'i','ó' => 'o','ú' => 'u', 
               'ñ' => 'n', 'Ñ' => 'N', 
               'Á' => 'A' , 'É' => 'E',  'Í' => 'I', 'Ó' => 'O','Ú' => 'U'}
    unless string.nil?
      string_with_no_spanish_chars = string.gsub(/[#{replace.keys.join('|')}]/).each do |c|
        replace[c]
      end
      return string_with_no_spanish_chars
    end
  end
  
  module ClassMethods
    
    def no_spaces_in(*args) 
      args.each do |field|
        before_validation do |record|
          attribute = record.send("#{field.to_s}")
          attribute.delete!(' ') unless attribute.nil?
        end
      end
    end
    
    def no_accents_in(*args)
      args.each do |field|
        before_validation do |record|
          attribute = record.send("#{field.to_s}")
          unless attribute.nil?
            record.send "#{field.to_s}=", Preformatter.replace_spanish_chars_in(attribute)
          end
        end
      end
    end
    
    def no_special_characters(chars, options = {})
      options[:in] ||= []
      options[:in].each do |field|
        before_validation do |record|
          attribute = record.send("#{field.to_s}")
          unless attribute.nil?
            attribute = attribute.delete!(chars)
          end
        end
      end
    end
    
    def include_ascii_for_fields(*args)
      args.each do |field|
        before_validation do |record|
          attribute = record.send("#{field.to_s}")
          if Preformatter.has_spanish_chars?(attribute)
            record.send "ascii_#{field.to_s}=", Preformatter.replace_spanish_chars_in(attribute)
          end
        end
      end
    end
    
    def remove_extra_white_spaces(*args)
      args.each do |field|
        before_save do |record|
          attribute = record.send("#{field.to_s}")
          attribute.strip! if !attribute.nil? and !attribute.strip!.nil?
          attribute.gsub!(/[ ]+/, ' ') if !attribute.nil? and !attribute.gsub!(/[ ]+/, ' ').nil?
        end
      end
    end
    
  end
  
      
end

class ActiveRecord::Base
  include Preformatter
end