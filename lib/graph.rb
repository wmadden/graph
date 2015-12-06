require 'ruby-graphviz'

DEFAULT_COLOR = "#999999FF"
CRITICAL_PATH_COLOR = "red"

class Node
  attr_accessor(
    :id,
    :name,
    :duration,
    :milestone,
  )

  attr_reader(
    :dependencies,
    :dependent_nodes,
  )

  def initialize(id: nil, name: nil, duration: 0, milestone: nil)
    @dependencies = []
    @dependent_nodes = []
    @id = id
    @name = name
    @duration = duration
    @milestone = milestone
  end

  def earliest_start
    @earliest_start ||= (@dependencies.map { |dependency| dependency.earliest_end }.max || 0)
  end

  def earliest_end
    earliest_start + @duration
  end

  def latest_end(indent = 0)
    @latest_end ||= @dependent_nodes.map { |dependent| dependent.latest_start(indent + 1) }.min || earliest_end
  end

  def latest_start(indent = 0)
    latest_end - @duration
  end

  def depends_on?(node)
    node == self || dependencies.any? { |dependency| dependency.depends_on?(node) }
  end

  def add_dependency(node)
    find_cycle_with(node)
    dependencies << node unless dependencies.include?(node)
    node.add_dependent_node(self)
  end

  def buffer
    latest_end - earliest_end
  end

  def in_critical_path
    buffer == 0
  end

  protected

  def find_cycle_with(node, cycle = [])
    cycle += [self]
    if node == self
      raise "Cyclic dependency: #{cycle.map{|n| n.name}.join(', ')}, #{node.name}"
    end
    dependencies.each { |d| d.find_cycle_with(node, cycle)}
  end

  def add_dependent_node(node)
    find_cycle_with(node)
    dependent_nodes << node unless dependent_nodes.include?(node)
  end
end

class GraphBuilder
  def self.from_hash(dependency_tree)
    self.new.send(:build_from_hash, dependency_tree)
  end

  private

  def initialize
    @nodes_by_id = {}
    @graph = Graph.new(@nodes_by_id.values)
  end

  def build_from_hash(dependency_tree)
    dependency_tree.each do |node_id, attributes|
      dependencies = attributes.delete(:dependencies)
      node = get_or_create_node(node_id, attributes)
      dependencies.each do |dependency_id|
        dependency_attributes = dependency_tree[dependency_id].reject { |k| k == :dependencies }
        dependency_node = get_or_create_node(dependency_id, dependency_attributes)
        dependency_node.add_dependency( node ) # Fuck it, reverse it
      end
    end
    @graph
  end

  def get_or_create_node(node_id, attributes)
    node = @nodes_by_id[node_id]
    attributes[:id] = node_id
    attributes[:name] ||= node_id
    unless node
      node = Node.new(attributes)
      @nodes_by_id[node_id] = node
      @graph.nodes << node
    end
    node
  end
end

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

class Graph
  attr_reader :nodes

  def initialize(nodes)
    @nodes = nodes
  end
end
