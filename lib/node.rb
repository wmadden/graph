class Node
  attr_accessor(
    :id,
    :name,
    :duration,
    :milestone,
  )

  attr_reader(
    :dependencies,
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

  def depends_on?(node)
    node == self || @dependencies.any? { |dependency| dependency.depends_on?(node) }
  end

  def find_cycle_with(node, cycle = [])
    cycle += [self]
    if node == self
      raise "Cyclic dependency: #{cycle.map{|n| n.name}.join(', ')}, #{node.name}"
    end
    @dependencies.each { |d| d.find_cycle_with(node, cycle)}
  end

  def add_dependent_node(node)
    find_cycle_with(node)
    @dependent_nodes << node unless @dependent_nodes.include?(node)
  end
end
