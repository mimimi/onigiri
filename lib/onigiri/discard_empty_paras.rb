# encoding: utf-8
module Onigiri
  def discard_empty_paras(text)
    dupe = Nokogiri::HTML::DocumentFragment.parse text
    dupe.css('p').each do |p|
      p.remove if p.children.empty?
    end
  end
end
