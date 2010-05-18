module Preformatter
  
  def self.included(base)
    base.extend ClassMethods
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
          replace = {'á' => 'a','é' => 'e','í' => 'i','ó' => 'o','ú' => 'u', 
                     'ñ' => 'n', 'Ñ' => 'N', 
                     'Á' => 'A' , 'É' => 'E',  'Í' => 'I', 'Ó' => 'O','Ú' => 'U'}
          unless attribute.nil?
            attribute.gsub!(/[#{replace.keys.join('|')}]/).each do |c|
              replace[c]
            end
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
            RAILS_DEFAULT_LOGGER.debug attribute
          end
        end
      end
    end
    
  end
      
end

class ActiveRecord::Base
  include Preformatter
end