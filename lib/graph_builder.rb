require "./lib/graph"
require "./lib/node"

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
