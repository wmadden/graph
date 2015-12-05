require 'ruby-graphviz'

class Graph
  attr_reader :graph

  def initialize
    # Create a new graph
    @graph = GraphViz.new( :G, :type => :digraph )
    @graph["fontname"] = "Arial"
    @nodes = {}
  end

  def add_edge(node1_name, node2_name)
    @graph.add_edges(node(node1_name), node(node2_name))
  end

  def draw(filetype, filename)
    @graph.output( filetype => "#{filename}.#{filetype}" )
  end

  def add_dependencies(dependency_hash)
    dependency_hash.each do |key, value|
      value.each do |dependency|
        add_edge(key, dependency)
      end
    end
  end

  def node(name)
    @nodes[name] ||= add_node(name)
  end

  private

  def add_node(name)
    raise "Node #{name} is already in the graph!" if @nodes[name]
    @nodes[name] = @graph.add_nodes(name, {
      label: name, shape: "house", margin: 0.3,
    })
  end

end
