require 'ruby-graphviz'

DEFAULT_COLOR = "#999999FF"
CRITICAL_PATH_COLOR = "red"

class GraphRenderer
  def self.draw(graph, filetype, filename)
    self.new(graph).draw(filetype, filename)
  end

  def initialize(graph)
    @graph = graph
  end

  def draw(filetype, filename)
    @graphviz = GraphViz.new( :G, :type => :digraph, :splines => "ortho" )

    draw_nodes
    draw_edges

    @graphviz.output( filetype => "#{filename}.#{filetype}" )
  end

  private

  def draw_nodes
    @graphviz_nodes = {}
    @graph.nodes.each do |node|
      @graphviz_nodes[node] = draw_node(node)
    end
  end

  def draw_edges
    @graph.nodes.each do |node|
      node.dependencies.each do |dependency|
        color = node.in_critical_path && dependency.in_critical_path ? CRITICAL_PATH_COLOR : DEFAULT_COLOR
        @graphviz.add_edges(dependency, node, { color: color })
      end
    end
  end

  def draw_node(node)
    border_width = 1
    node_options = {}
    if node.in_critical_path
      node_options[:color] = CRITICAL_PATH_COLOR
      node_options[:fontcolor] = CRITICAL_PATH_COLOR
    end
    if node.milestone
      node_options[:shape] = "diamond"
    else
      node_options[:shape] = "plaintext"
    end
    node_options[:label] = GraphViz::Types::HtmlString.new(%(
      <table align="left" border="0" cellborder="0" cellspacing="0" cellpadding="10">
        <tr>
          <td cellpadding="0">
            <table align="left" border="0" cellborder="#{border_width}" cellspacing="0" cellpadding="10">
              <tr>
                <td>#{node.name}</td>
                <td>Duration: #{node.duration}</td>
              </tr>
              <tr>
                <td>Earliest start: #{node.earliest_start}</td>
                <td>Latest start: #{node.latest_start}</td>
              </tr>
              <tr>
                <td>Earliest end: #{node.earliest_end}</td>
                <td>Latest end: #{node.latest_end}</td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td border="#{border_width}">
            Buffer: #{node.buffer}
          </td>
        </tr>
        <tr>
          <td border="#{border_width}">
            ID: #{node.id}
          </td>
        </tr>
      </table>
    ))
    node_options[:margin] = 0
    @graphviz.add_nodes(node.id, node_options)
  end
end
