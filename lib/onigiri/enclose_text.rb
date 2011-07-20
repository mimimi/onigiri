# encoding: utf-8
module Onigiri
  register_handler :enclose_text
  class Document
    def enclose_text
      dupe = dup
      dupe.css('body').children.each do |target|
        if target.text?
          target.add_previous_sibling "<p>#{target.content.strip}</p>"
          target.unlink
        end
      end
      dupe
    end
  end
end
