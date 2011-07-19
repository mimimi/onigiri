# encoding: utf-8
module Onigiri
  def fix_backslash(text)
    dupe = Nokogiri::HTML::DocumentFragment.parse text
    dupe.css('body').children.each do |target|
      if target.text?
        target.add_previous_sibling "<p>#{target.content.strip}</p>"
        target.unlink
      end
    end
    dupe
  end
end
