module Minidown
  class Element
    attr_reader :content, :doc, :nodes

    def raw_content
      @content
    end

    def unparsed_lines
      doc.lines
    end
        
    BlankTypes = [:enter, :blank_line]
    
    def initialize doc, content
      @doc = doc
      @nodes = doc.nodes
      @content = content
      parse
    end

    def parse
      raise NotImplementedError, 'method parse not implemented'
    end

    def to_node
      raise NotImplementedError, 'method to_node not implemented'
    end

    def blank?
      false
    end
  end
end