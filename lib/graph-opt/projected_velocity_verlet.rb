class Projected_Velocity_Verlet < Velocity_Verlet

	def next_f
		Matrix.rows( @next_step.f.collect{ |vector| vector.to_a } )
	end

	def next_v
		next_v = v + 0.5 * ( a + next_a ) * @@dt
		next_v = Matrix.rows( next_v.row_vectors.zip( next_f.row_vectors ).map do |v,f|
			( v.inner_product(f) * f ).to_a
		end )	
	end

end