# encoding: utf-8
module Onigiri
  register_handler :enclose_text
  class Document
    def enclose_text
      # TODO: Beautify this without triggering another set of segfaults ._.
      dupe = dup
      wrapper = Onigiri::Document.parse('<p>').child
      container = Onigiri::Document.parse('<body>')
      dupe = container.child << dupe.dup.children if dupe.css('body').empty?
      body = dupe.css('body').children
      body = dupe.children if body.empty?
      body.each do |target|
        if target.parent && (target.text? || target.description.inline?)
          wrap = target.replace(wrapper << target.dup)
        end
      end
      Onigiri::Document.parse dupe.children.to_s
    end
  end
end
