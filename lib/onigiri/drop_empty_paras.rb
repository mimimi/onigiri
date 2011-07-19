# encoding: utf-8
module Onigiri
  def drop_empty_paras(text)
    dupe = text.class.to_s['Nokogiri::HTML::'] ? text : Nokogiri::HTML::DocumentFragment.parse(text)
    dupe.css('p').each do |p|
      p.remove if p.children.empty?
    end
    dupe.to_s
  end
end
