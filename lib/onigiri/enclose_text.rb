# encoding: utf-8
module Onigiri
  def enclose_text(text)
    dupe = text.class.to_s['Nokogiri::HTML::'] ? text : Nokogiri::HTML::DocumentFragment.parse(text)
    dupe.css('body').children.each do |target|
      if target.text?
        target.add_previous_sibling "<p>#{target.content.strip}</p>"
        target.unlink
      end
    end
    dupe.to_html
  end
end
