# encoding: utf-8
module Onigiri
  def enclose_text(text)
    dupe = Nokogiri::XML::DocumentFragment.parse text
    dupe.css('body').children.each do |target|
      if target.text?
        target.add_previous_sibling "<p>#{target.content.strip}</p>"
        target.unlink
      end
    end
    dupe.to_html
  end
end
