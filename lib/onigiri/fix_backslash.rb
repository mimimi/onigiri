# encoding: utf-8
module Onigiri
  register_handler :fix_backslash
  class Document
    def fix_backslash
      dupe = dup
      attrset = ['src', 'longdesc', 'href', 'action']
      dupe.css("[#{attrset.join('], [')}]").each do |target|
        attrset.each do |attr|
          target[attr] = target[attr].gsub("\\", "/") if target[attr]
        end
      end
      dupe
    end
  end
end
