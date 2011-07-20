# encoding: utf-8
module Onigiri
  register_handler :merge_divs
  register_handler :merge_spans
  class Document

    def merge_divs
      self.merge_by_tag('div')
    end

    def merge_spans
      self.merge_by_tag('span')
    end

    # This is going to be ugly
    def merge_by_tag(tag_name)
      dupe = dup
      # First pass. Finding deepest <div>s that require merging upwards.
      mergers = dupe.find_merger_elements(tag_name)
      # Second pass. Traverse tree upwards from each merger <div> gathering attributes on our way
      mergers.each do |merger|
        data = singular_upverse(merger)
        merger.children.each do |survivor|
          data['root'] << survivor
        end
        data['deletion_node'].remove
        data['root']['class'] = data['class'] if data['class']
        data['root']['style'] = data['style'] if data['style']
      end
      dupe
    end

    def find_merger_elements(tag_name)
      result = []
      self.css(tag_name).each do |elem|
        # !(node.next_sibling || node.previous_sibling) vs. node.parent.children.size
        result << elem if elem.parent.children.size == 1 && elem.parent.name == tag_name
      end
      result
    end

    def singular_upverse(node)
      if node.parent.name == node.name && !(node.next_sibling || node.previous_sibling)
        data = singular_upverse(node.parent)
        # If we got root node we should set a deletion point for root.
        # If we have a deletion point - no need to reset it.
        data['deletion_node'] ||= node if data['root']
      else
        data = Hash.new
        data['root'] = node
      end

      # Ensuring uglyness
      data['style'] ? (data['style'] += " #{node['style']}" if node['style']) : data['style'] = node['style']
      data['class'] ? (data['class'] += " #{node['class']}" if node['class']) : data['class'] = node['class']

      data
    end
  end
end
