require 'ruby-graphviz'

class Graph
  attr_reader :graph

  def initialize
    # Create a new graph
    @graph = GraphViz.new( :G, :type => :digraph )
    @graph["nodesep"] = 1.2
    @nodes = {}
  end

  def add_edge(node1_name, node2_name)
    @graph.add_edges(node(node1_name), node(node2_name), {"arrowhead" => "none"})
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

  def table_node(id, name: nil, duration: "", earliest_start: "", latest_start: "", earliest_end: "", latest_end: "")
    name ||= id
    tnode = node(id)
    tnode[:label] = GraphViz::Types::HtmlString.new(%(
      <table align="left" border="0" cellborder="0" cellspacing="0" cellpadding="10">
        <tr>
          <td border="1">#{name}</td>
          <td border="1">#{duration}</td>
        </tr>
        <tr>
          <td colspan="2" cellpadding="0">
            <table align="left" border="0" cellborder="1" cellspacing="0" cellpadding="10">
              <tr>
                <td>#{earliest_start}</td>
                <td>#{latest_start}</td>
              </tr>
              <tr>
                <td>#{earliest_end}</td>
                <td>#{latest_end}</td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
    ))
    tnode[:shape] = "plaintext"
    tnode[:margin] = 0
  end

  private

  def add_node(name)
    raise "Node #{name} is already in the graph!" if @nodes[name]
    @nodes[name] = @graph.add_nodes(name, {
      label: name, shape: "rectangle", margin: 0.3,
    })
  end

end
