#!/usr/bin/env ruby

require 'ruby-graphviz'

# Create a new graph
g = GraphViz.new( :G, :type => :digraph )

# Create two nodes
one1 = g.add_nodes( "1.1" )
one2 = g.add_nodes( "1.2" )
one3 = g.add_nodes( "1.3" )

two1 = g.add_nodes( "2.1" )
two2 = g.add_nodes( "2.2" )
two3 = g.add_nodes( "2.3" )

three1 = g.add_nodes( "3.1" )
three2 = g.add_nodes( "3.2" )
three3 = g.add_nodes( "3.3" )

# Create an edge between the two nodes
g.add_edges( one1, one2 )
g.add_edges( one1, one3 )
g.add_edges( one2, two1 )
g.add_edges( one3, two1 )
g.add_edges( one3, three1 )
g.add_edges( one3, three2 )
g.add_edges( one3, three3 )
g.add_edges( two1, two2 )
g.add_edges( two1, two3 )

# Generate output image
g.output( :png => "hello_world.png" )
