class Node

	attr_reader :number, :force
	attr_accessor :r, :v

	@@nodes = []
	@@mass = 1.0

	def initialize( r )
		@r = case r.class
		when Vector.class
			r
		when Array.class
			Vector[*r]
		end
		@@nodes << self
		@number = @@nodes.size
		@r = Cell.the_cell.pbc_orthorhombic( @r )
		@v = Vector.elements( [ 0.0, 0.0, 0.0 ] )
	end

	def self.node_from_number( number )
		return @@nodes[ number ]
	end

	def zero_force
		@force = Vector.elements( [ 0.0, 0.0, 0.0 ] )
	end

	def add_force( f )
		@force += f
	end

	def a # acceleration at time t
		@force * @@mass
	end

	def ke
		return 0.5 * @@mass * v.magnitude**2
	end

end