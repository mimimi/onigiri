# encoding: utf-8
module Onigiri
  register_handler :enclose_text
  class Document
    def enclose_text
      dupe = dup
      body = dupe.css('body').children
      body = dupe.children if body.empty?
      body.each do |target|
        if target.parent && (target.text? || target.description.inline?)
          wrap = target.add_previous_sibling("<p>")[0]
          wrap << target.unlink
        end
      end
      dupe
    end
  end
end
