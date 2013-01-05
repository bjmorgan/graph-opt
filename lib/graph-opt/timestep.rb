class Timestep

	attr_reader :nodes, :springs

	def initialize( nodes, springs )
		@nodes = nodes
		@springs = springs
	end

	def zero_forces
		@nodes.each{ |node| node.zero_force }
	end

	def evaluate_forces
		zero_forces
		@springs.each{ |spring| spring.evaluate_forces }
	end

	def r
		@nodes.map{ |node| node.r }
	end

	def a
		@nodes.map{ |node| node.a }
	end

	def v
		@nodes.map{ |node| node.v }
	end

	def f
		@nodes.map{ |node| node.force }
	end

	def copy
		return Marshal.load( Marshal.dump ( self ) )
	end

	def r=( array )
		@nodes.zip(array){ |node, r| node.r = r }
	end

	def v=( array )
		@nodes.zip(array){ |node, v| node.v = v }
	end

	def potential_energy
		@springs.inject(0) { |sum, spring| sum + spring.energy }
	end

	def kinetic_energy
		@nodes.inject(0) { |sum, node| sum + node.ke }
	end

	def energy
		potential_energy + kinetic_energy
	end

end