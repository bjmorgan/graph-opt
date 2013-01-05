class Spring

	attr_reader :from_node, :to_node

	@@equilibrium_length = 1.973
	@@spring_constant = 1.0

	def initialize( node_i, node_j, cell_offset )
		@ends = [ node_i, node_j ]
		@cell_offset = Vector.elements( cell_offset )
		@from_node = Node.node_from_number( node_i )
		@to_node = Node.node_from_number( node_j )
		@equilibrium_length = @@equilibrium_length
		@k = @@spring_constant
	end

	def self.init_from_file( file )
		springs = []
		File.new( file, 'r' ).readlines.each_with_index do |line,i|
			next if line.strip.empty?
			# match numbers in e.g. 1 -> 2 [ +1 -1 0 ]
			data = line.scan(/(\d+)\s+->\s+(\d+)\s+\[\s+([\+\-]?\d+)\s+([\+\-]?\d+)\s+([\+\-]?\d+)\s+\]/)[0]
			abort( "  Syntax: i -> j [ a b c ]\n  line #{i+1} in #{file} not recognized:\n    #{line}" ) if data.nil?
			data.map!{ |e| e.to_i }
			springs << Spring.new( data[0]-1, data[1]-1, data[2..4] )
		end
		return springs
	end

	def from
		return @ends[0]
	end

	def to
		return @ends[1]
	end

	def length
		return Cell.the_cell.dr_with_offset( @from_node.r, @to_node.r, @cell_offset ).magnitude
	end

	def direction
		return Cell.the_cell.dr_with_offset( @from_node.r, @to_node.r, @cell_offset ).normalize
	end

	def tension
		return @k * ( length - @equilibrium_length )
	end

	def energy
		return 0.5 * @k * ( length - @equilibrium_length )**2
	end

	def force_on_node( node )
		case node
		when @from_node
			direction * tension
		when @to_node
			-1.0 * direction * tension
		else
			Vector.elements( [ 0.0, 0.0, 0.0 ] )
		end
	end

	def evaluate_forces
		@from_node.add_force( force_on_node( @from_node ) )
		@to_node.add_force( force_on_node( @to_node ) )
	end

end
