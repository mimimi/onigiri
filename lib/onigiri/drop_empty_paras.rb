# encoding: utf-8
module Onigiri
  register_handler :drop_empty_paras
  class Document
    def drop_empty_paras
      dupe = dup
      dupe.css('p').each do |p|
        p.remove if p.children.empty?
      end
      dupe
    end
  end
end
