require "matrix"

class Cell

	def initialize( h, cell_lengths )
		@h = h # expects h is a Matrix
		@cell_lengths = cell_lengths # expects cell_lengths is a Vector
		@@the_cell = self
	end

	def to_s
		output = @h.collect{ |row| row.join(' ') }
		output << @cell_lengths
	end

	def dr( r1, r2 ) # Where r1 and r2 are each length 3 Vectors
		dr_orthorhombic( r1, r2 )
	end

	def dr_orthorhombic( r1, r2 ) # apply minimum image convention to distances
		return Vector.elements( (r2 - r1).to_a.zip(@cell_lengths.to_a).collect do |dr, length|
			dr -= length if ( dr >  length / 2.0 )
			dr += length if ( dr < -length / 2.0 )
			dr
		end )
	end

	def pbc_orthorhombic( r ) # apply periodic boundary conditions
		return Vector.elements( r.to_a.zip( @cell_lengths.to_a).collect do |x, length|
			x -= length if x > length
			x += length if x < 0.0
			x
		end )
	end

	def dr_with_offset( r1, r2, offset ) # do not apply minimum image convention. Instead add vector given in offset.
		return r2 - r1 + offset.vec_times( @cell_lengths )
	end

	def self.init_from_matrix( matrix )
		h = Matrix[ *matrix.row_vectors.map{ |row| row.normalize.to_a } ]
		cell_lengths = Vector.elements( matrix.row_vectors.map{ |row| row.magnitude } )
		return Cell.new( h, cell_lengths )
	end

	def self.the_cell
		return @@the_cell
	end
	
end