# encoding: utf-8
module Onigiri
  def fix_backslash(text)
    dupe = text.class.to_s['Nokogiri::HTML::'] ? text : Nokogiri::HTML::DocumentFragment.parse(text)
    attrset = {'src' => 1, 'longdesc' => 1, 'href' => 1, 'action' => 1}
    dupe.css("[#{attrset.keys.join('], [')}]").each do |target|
      target.attributes.each_pair do |name, attribute|
        if attrset[name]
          attribute.value = attribute.value.gsub("\\", "/")
        end
      end
    end
    dupe.to_s
  end
end
