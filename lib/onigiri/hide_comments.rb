# encoding: utf-8
module Onigiri
  register_handler :hide_comments
  class Document
    def hide_comments
      dupe = dup
      dupe.traverse {|elem| elem.remove if elem.class == Nokogiri::XML::Comment}
      dupe
    end
  end
end
