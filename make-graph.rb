#!/usr/bin/env ruby

require 'ruby-graphviz'

class Graph

  def initialize
    # Create a new graph
    @graph = GraphViz.new( :G, :type => :digraph )
    @nodes = {}
  end

  def add_node(name)
    raise "Node #{name} is already in the graph!" if @nodes[name]
    @nodes[name] = @graph.add_nodes(name)
  end

  def add_edge(node1, node2)
    @graph.add_edges(node1, node2)
  end

  def draw(filename)
    @graph.output( :png => filename )
  end

end

g = Graph.new

# Define nodes
g.add_node( "1.1" )
g.add_node( "1.2" )
g.add_node( "1.3" )

g.add_node( "2.1" )
g.add_node( "2.2" )
g.add_node( "2.3" )

g.add_node( "3.1" )
g.add_node( "3.2" )
g.add_node( "3.3" )

# Create edges
g.add_edge( "1.1", "1.2" )
g.add_edge( "1.1", "1.3" )
g.add_edge( "1.2", "2.1" )
g.add_edge( "1.3", "2.1" )
g.add_edge( "1.3", "3.1" )
g.add_edge( "1.3", "3.2" )
g.add_edge( "1.3", "3.3" )
g.add_edge( "2.1", "2.2" )
g.add_edge( "2.1", "2.3" )

# Generate output image
g.draw("graph.png")
