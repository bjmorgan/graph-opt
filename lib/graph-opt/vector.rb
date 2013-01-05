class Vector

	def v( operation, v ) # abbreviated form of "vector_operation"
		return vector_operation( operation, v )
	end

	def vector_operation( operation, v )
		return Vector.elements( self.to_a.zip( v.to_a ).map{ |i,j| i.send( operation, j ) } )
	end

	def vec_times( v )
		return vector_operation( :*, v )
	end

	def vec_div( v )
		return vector_operation( :/, v )
	end

	def map( &block )
		Vector.elements( self.to_a.map( &block ) )
	end

	def map!( &block )
		Vector.elements( self.to_a.map!( &block ) )
	end

end