def find_context(line, current_context, current_result)
  
  child = current_context.children.find { |c| c.content[:regex] =~ line }
  return child, current_result if child
  return nil if current_context.parent.nil?
  return find_context(line, current_context.parent, current_result.parent)
end

def parse_file(contexts, lines)
  result = TreeNode.new("ROOT", {:lines => ""})
  current_result = result

  current_context = contexts
  lines.each do |line|
    found_context, found_result = find_context(line, current_context, current_result)
    if found_context
      current_context = found_context
      current_result = found_result
      identifier = current_context.content[:regex].match(line)[0]
      current_result << TreeNode.new(identifier, {:lines => "", :context => current_context})
      current_result = current_result.children.last
    else
      current_result.content[:lines] += line
    end
    
  end

  result.each_leaf do |l|
    unless l.content[:context].nil? or l.content[:context].content[:parse].nil?
      send(l.content[:context].content[:parse], l.content[:lines], l)
    end
    l.content.delete(:context)
    l.content.delete(:lines)
  end

  result.each do |l|
    puts l.name
    unless l.parent.nil?
      l.content[:data] ||= {}
      l.parent.content[:data] ||= {}
      l.parent.content[:data][l.name] ||= (l.content[:data] || {})
    end
  end
  return result.content[:data]
end

