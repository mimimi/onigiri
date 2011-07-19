# encoding: utf-8
module Onigiri
  def show_body_only(text)
    dupe = text.class.to_s['Nokogiri::HTML::'] ? text : Nokogiri::HTML::DocumentFragment.parse(text)
    dupe.css('body').first.inner_html
  end
end
