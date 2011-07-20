require "rubygems"
require "nokogiri"

module Onigiri
  extend self
  @@registry ||= {}

  class OnigiriHandlerTaken < StandardError
    def description
      "There was an attempt to override registered handler. This usually indicates a bug in Onigiri."
    end
  end

  def clean(data, *params)
    dupe = Onigiri::Document.parse data
    params.flatten.each do |method|
      dupe = dupe.send(method) if @@registry[method]
    end
    dupe.to_html
  end

  class Document < Nokogiri::HTML::DocumentFragment
    class << self
      def parse(tags)
        # Remove formatting whitespaces
        # Those do not represent any data while messing up the tree
        tags = tags.gsub(/(\r|\n)/, '').gsub(/> *</, '><')
        super
      end
    end
  end

  private

  def register_handler(name)
    unless @@registry[name]
      @@registry[name] = true
    else
      raise OnigiriHandlerTaken
    end
  end

end

require "onigiri/drop_empty_paras"
require "onigiri/enclose_block_text"
require "onigiri/enclose_text"
require "onigiri/fix_backslash"
require "onigiri/show_body_only"
require "onigiri/merge_by_tag"
