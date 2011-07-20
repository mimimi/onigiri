# encoding: utf-8
module Onigiri
  register_handler :show_body_only
  class Document
    def show_body_only
      dupe = Onigiri::Document.parse ""
      self.css('body').first.children.each do |child|
        dupe << child
      end
      dupe
    end
  end
end
