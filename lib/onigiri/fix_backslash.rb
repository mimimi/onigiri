# encoding: utf-8
module Onigiri
  register_handler(:fix_backslash)
  class Document
    def fix_backslash
      dupe= dup
      attrset = {'src' => 1, 'longdesc' => 1, 'href' => 1, 'action' => 1}
      dupe.css("[#{attrset.keys.join('], [')}]").each do |target|
        target.attributes.each_pair do |name, attribute|
          if attrset[name]
            attribute.value = attribute.value.gsub("\\", "/")
          end
        end
      end
      dupe
    end
  end
end
