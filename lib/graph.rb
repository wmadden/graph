require 'ruby-graphviz'

DEFAULT_COLOR = "#999999FF"
CRITICAL_PATH_COLOR = "red"

class Graph
  attr_reader :graph

  def initialize(dependency_tree)
    @dependency_tree = dependency_tree
    # Create a new graph
    @graph = GraphViz.new( :G, :type => :digraph, :splines => "ortho" )
    @nodes = {}
    calculate_earliest_times
    calculate_latest_times
    add_nodes_and_edges
  end

  def draw(filetype, filename)
    @graph.output( filetype => "#{filename}.#{filetype}" )
  end

  def node(name)
    @nodes[name] ||= add_node(name)
  end

  private

  def node_descriptor(id)
    @dependency_tree[id]
  end

  def add_edge(node1_id, node2_id)
    edge = @graph.add_edges(node(node1_id), node(node2_id))
    if node_descriptor(node1_id)[:in_critical_path] && node_descriptor(node2_id)[:in_critical_path]
      edge[:color] = CRITICAL_PATH_COLOR
    else
      edge[:color] = DEFAULT_COLOR
    end
  end

  def set_earliest_start(node_id, earliest_start)
    descriptor = node_descriptor(node_id)
    descriptor[:earliest_start] = earliest_start
    descriptor[:earliest_end] = descriptor[:earliest_start] + descriptor[:duration]
  end

  def calculate_earliest_times
    @dependency_tree.each do |node_id, descriptor|
      set_earliest_start(node_id, 0) unless descriptor[:earliest_start]

      descriptor[:dependencies].each do |dependency_id|
        dependency_descriptor = node_descriptor(dependency_id)
        if descriptor[:earliest_end] > (dependency_descriptor[:earliest_start] || 0)
          set_earliest_start(dependency_id, descriptor[:earliest_end])
        end
      end
    end
  end

  def calculate_latest_times
    @dependency_tree.each do |node_id, descriptor|
      calculate_latest_times_for(node_id)
    end
  end

  def calculate_latest_times_for(node_id)
    descriptor = node_descriptor(node_id)
    return descriptor[:latest_end] if descriptor[:latest_end]
    if descriptor[:dependencies].length == 0
      descriptor[:latest_start] = descriptor[:earliest_start]
      descriptor[:latest_end] = descriptor[:earliest_end]
    else
      latest_start_dates = descriptor[:dependencies].map { |d| calculate_latest_times_for(d); node_descriptor(d)[:latest_start] }
      descriptor[:latest_end] = latest_start_dates.min
      descriptor[:latest_start] = descriptor[:latest_end] - descriptor[:duration]
    end
    descriptor[:buffer] = descriptor[:latest_end] - descriptor[:earliest_end]
    descriptor[:in_critical_path] = descriptor[:buffer] == 0
  end

  def add_nodes_and_edges
    @dependency_tree.each do |node_id, descriptor|
      descriptor[:dependencies].each do |dependency|
        add_edge(node_id, dependency)
      end
    end
  end

  def add_node(id)
    raise "Node #{id} is already in the graph!" if @nodes[id]
    new_node = @graph.add_nodes(id, {
      label: id, shape: "rectangle", margin: 0.3, color: DEFAULT_COLOR,
    })
    @nodes[id] = new_node
    render_table_for_node(id)
    new_node
  end

  def render_table_for_node(id)
    name ||= id
    tnode = node(id)
    descriptor = node_descriptor(id)
    border_width = 1
    if descriptor[:in_critical_path]
      tnode[:color] = CRITICAL_PATH_COLOR
      tnode[:fontcolor] = CRITICAL_PATH_COLOR
    end
    tnode[:label] = GraphViz::Types::HtmlString.new(%(
      <table align="left" border="0" cellborder="0" cellspacing="0" cellpadding="10">
        <tr>
          <td cellpadding="0">
            <table align="left" border="0" cellborder="#{border_width}" cellspacing="0" cellpadding="10">
              <tr>
                <td>#{descriptor[:name] || id}</td>
                <td>Duration: #{descriptor[:duration]}</td>
              </tr>
              <tr>
                <td>Earliest start: #{descriptor[:earliest_start]}</td>
                <td>Latest start: #{descriptor[:latest_start]}</td>
              </tr>
              <tr>
                <td>Earliest end: #{descriptor[:earliest_end]}</td>
                <td>Latest end: #{descriptor[:latest_end]}</td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td border="#{border_width}">
            Buffer: #{descriptor[:buffer]}
          </td>
        </tr>
        <tr>
          <td border="#{border_width}">
            ID: #{id}
          </td>
        </tr>
      </table>
    ))
    tnode[:shape] = "plaintext"
    tnode[:margin] = 0
  end
end
