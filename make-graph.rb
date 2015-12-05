#!/usr/bin/env ruby

require 'ruby-graphviz'

class Graph
  attr_reader :graph

  def initialize
    # Create a new graph
    @graph = GraphViz.new( :G, :type => :digraph )
    @nodes = {}
  end

  def add_node(name)
    raise "Node #{name} is already in the graph!" if @nodes[name]
    @nodes[name] = @graph.add_nodes(name, { label: name, sides: 4 })
  end

  def add_edge(node1_name, node2_name)
    node1 = @nodes[node1_name]
    raise "Unknown node #{node1_name}" unless node1
    node2 = @nodes[node2_name]
    raise "Unknown node #{node2_name}" unless node2

    @graph.add_edges(node1, node2)
  end

  def draw(filename)
    @graph.output( :png => filename )
  end

  def add_dependencies(dependency_hash)
    dependency_hash.each do |key, value|
      value.each do |dependency|
        add_edge(key, dependency)
      end
    end
  end

end

g = Graph.new

# Define node
(1..3).each { |i| g.add_node("1.#{i}") }
(1..5).each { |i| g.add_node("2.#{i}") }
(1..3).each { |i| g.add_node("3.#{i}") }
(1..7).each { |i| g.add_node("4.#{i}") }
(1..3).each { |i| g.add_node("5.#{i}") }
(1..5).each { |i| g.add_node("6.#{i}") }
(1..5).each { |i| g.add_node("7.#{i}") }
(1..2).each { |i| g.add_node("8.#{i}") }
(1..5).each { |i| g.add_node("9.#{i}") }
g.add_node( "end" )

# Create edges
g.add_dependencies({
  "1.1" => %w(1.2 1.3),
  "1.2" => %w(2.1),
  "1.3" => %w(2.1 3.1 3.2 3.3),
  "2.1" => %w(2.2 2.3 2.4 2.5 6.1 6.2 6.3 6.4 6.5 7.1 7.4 7.5 8.1 8.2),
  "2.2" => %w(4.1 5.1 5.2 7.2 9.1),
  "2.3" => %w(4.3 4.6 5.3 7.3 9.2 9.3),
  "2.4" => %w(4.5),
  "2.5" => %w(end),
  "3.1" => %w(5.1 5.2 5.3 8.1 8.2 9.1 9.2 9.3 9.4),
  "3.2" => %w(5.1 5.2 5.3 8.1 8.2 9.1 9.2 9.3 9.4),
  "3.3" => %w(5.1 5.2 5.3 8.1 8.2 9.1 9.2 9.3 9.4),
  "4.1" => %w(4.2 5.1),
  "4.2" => %w(5.1 5.2),
  "4.3" => %w(4.4 5.2),
  "4.4" => %w(end),
  "4.5" => %w(end),
  "4.6" => %w(4.7),
  "4.7" => %w(end),
  "5.1" => %w(end),
  "5.2" => %w(end),
  "5.3" => %w(end),
  "6.1" => %w(end),
  "6.2" => %w(end),
  "6.3" => %w(end),
  "6.4" => %w(end),
  "7.1" => %w(end),
  "7.2" => %w(end),
  "7.3" => %w(end),
  "7.4" => %w(end),
  "7.5" => %w(end),
  "8.1" => %w(end),
  "8.2" => %w(end),
  "9.1" => %w(end),
  "9.2" => %w(end),
  "9.3" => %w(end),
  "9.4" => %w(end),
  "9.5" => %w(end),
})
# Generate output image
g.draw("graph.png")
