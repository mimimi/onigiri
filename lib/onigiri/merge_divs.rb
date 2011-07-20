# encoding: utf-8
module Onigiri
  register_handler :merge_divs
  class Document
    # This is goign to be ugly
    def merge_divs
      dupe = dup
      # First pass. Finding deepest <div>s that require merging upwards.
      mergers = dupe.find_merger_elements('div')
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
      else
        data = Hash.new
        data['deletion_node'] = node.children.first
        data['root'] = node
      end

      # Ensuring uglyness
      node_style = node['style']
      node_class = node['class']
      data['style'] ? (data['style'] += " #{node_style}" if node_style) : data['style'] = node_style
      data['class'] ? (data['class'] += " #{node_class}" if node_class) : data['class'] = node_class
      data
    end
  end
end
