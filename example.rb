#!/usr/bin/env ruby
require 'pp'
require 'tree'
require_relative 'extractor'


include Tree

def parse_room(content, leaf)
  leaf.content[:data] ||= {}
  leaf.content[:data][:title] = content.split('~')[0]
  leaf.content[:data][:description] = content.split('~')[1]
end

contexts = TreeNode.new("ROOT")
contexts << 
  TreeNode.new("Rooms", {:regex => /#(ROOMS)/ }) << 
    TreeNode.new("room", {:regex => /#([0-9]+)/, :parse => :parse_room})

contexts << 
  TreeNode.new("Mobiles", {:regex => /#(MOBILES)/ }) << 
    TreeNode.new("mobile", {:regex => /#([0-9]+)/})

contexts << 
  TreeNode.new("Objects", {:regex => /#(OBJECTS)/ }) << 
    TreeNode.new("object", {:regex => /#([0-9]+)/})

contexts << 
  TreeNode.new("Specials", {:regex => /#(SPECIALS)/ }) 

contexts << 
  TreeNode.new("Resets", {:regex => /#(RESETS)/ }) 


lines = File.readlines('elenar.are')
result = parse_file(contexts, lines)

pp result
