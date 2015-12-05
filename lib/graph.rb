require 'ruby-graphviz'

class Graph
  attr_reader :graph

  def initialize(dependency_tree)
    @dependency_tree = dependency_tree
    # Create a new graph
    @graph = GraphViz.new( :G, :type => :digraph )
    @graph["nodesep"] = 1.2
    @nodes = {}
    calculate_earliest_times
    calculate_latest_times
    parse_tree
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

  def add_edge(node1_name, node2_name)
    @graph.add_edges(node(node1_name), node(node2_name))
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
  end

  def parse_tree
    @dependency_tree.each do |node_id, descriptor|
      descriptor[:dependencies].each do |dependency|
        add_edge(node_id, dependency)
      end
    end
  end

  def add_node(id)
    raise "Node #{id} is already in the graph!" if @nodes[id]
    new_node = @graph.add_nodes(id, {
      label: id, shape: "rectangle", margin: 0.3,
    })
    @nodes[id] = new_node
    render_table_for_node(id)
    new_node
  end

  def render_table_for_node(id)
    name ||= id
    tnode = node(id)
    descriptor = node_descriptor(id)
    raise "No descriptor for #{id.inspect}" unless descriptor
    tnode[:label] = GraphViz::Types::HtmlString.new(%(
      <table align="left" border="0" cellborder="0" cellspacing="0" cellpadding="10">
        <tr>
          <td border="1">#{descriptor[:name] || id}</td>
          <td border="1">#{descriptor[:duration]}</td>
        </tr>
        <tr>
          <td colspan="2" cellpadding="0">
            <table align="left" border="0" cellborder="1" cellspacing="0" cellpadding="10">
              <tr>
                <td>#{descriptor[:earliest_start]}</td>
                <td>#{descriptor[:latest_start]}</td>
              </tr>
              <tr>
                <td>#{descriptor[:earliest_end]}</td>
                <td>#{descriptor[:latest_end]}</td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
    ))
    tnode[:shape] = "plaintext"
    tnode[:margin] = 0
  end
end
