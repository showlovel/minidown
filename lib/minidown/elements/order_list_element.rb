module Minidown
  class OrderListElement < Element
    IndentRegexp = /\A\s{4,}(.+)/

    attr_accessor :lists
    
    def initialize *_
      super
      @children << ListElement.new(doc, content)
      @lists = @children.dup
      @put_back = []
    end
    
    def parse
      nodes << self

      while line = unparsed_lines.shift
        doc.parse_line line
        child = nodes.pop
        case child
        when OrderListElement
          if LineElement === nodes.last
            @lists.last.p_tag_content = child.lists.first.p_tag_content = true
          end
          nodes.push *child.children
          @lists.push *child.lists
          break
        when ParagraphElement
          contents = @lists.last.contents
          node = if line =~ IndentRegexp
                   contents.push(contents.pop.paragraph) if TextElement === contents.last
                   doc.parse_line $1
                   nodes.pop
                 else
                   if @blank
                     unparsed_lines.unshift line
                     break
                   end
                   child.text
                 end
          contents << node
        when LineElement
          child.display = false
          nodes << child
        else
          @put_back << child
          break
        end
        @blank = (LineElement === child)
      end
      children_range = (nodes.index(self) + 1)..-1
      children.push *nodes[children_range]
      nodes[children_range] = []
      nodes.push *@put_back
    end
    
    def to_html
      build_tag 'ol' do |content|
        children.each { |child| content << child.to_html}
      end
    end
  end
end
