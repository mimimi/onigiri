# encoding: utf-8
module Onigiri
  register_handler(:enclose_block_text)
  class Document
    def enclose_block_text
      dupe = dup
      strict_tags = {"noscript" => 1, "form" => 1, "blockquote" => 1}
      dupe.traverse do |elem|
        if strict_tags[elem.name]
          elem.children.each do |target|
            if target.text?
              target.add_previous_sibling "<p>#{target.content.strip}</p>"
              target.unlink
            end
          end
        end
      end
      dupe
    end
  end
end
