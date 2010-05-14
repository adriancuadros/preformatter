module Preformatter
          
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
          replace = {'á' => 'a','é' => 'e','í' => 'i','ó' => 'o','ú' => 'u'}
          unless attribute.nil?
            attribute.gsub!(/[#{replace.keys.join('|')}]/).each do |c|
              replace[c]
            end
          end
        end
      end
    end
    
    def no_special_characters_in(*args)
      
    end
      
end