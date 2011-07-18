# encoding: utf-8
module Onigiri
  def enclose_block_text(text)
    dupe = Nokogiri::XML::DocumentFragment.parse text
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
    dupe.to_s
  end
end
