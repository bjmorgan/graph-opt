class Velocity_Verlet # integrator for timesteps

	@@dt = 0.5

	attr_accessor :this_step
	attr_reader :next_step

	def initialize( timestep )
		@this_step = timestep
		@this_step.evaluate_forces
	end

	def step
		@next_step = new_timestep_with_coords( next_r ) # create timestep with predicted positions
		@next_step.evaluate_forces # evaluate forces for next set of positions
		@next_step.v = next_v.row_vectors # update velocities at next step 
		return @next_step # step forwards (dt)
	end

	def r
		Matrix.rows( @this_step.r.collect{ |vector| vector.to_a } )
	end

	def a
		Matrix.rows( @this_step.a.collect{ |vector| vector.to_a } )
	end

	def v
		Matrix.rows( @this_step.v.collect{ |vector| vector.to_a } )
	end

	def next_a
		Matrix.rows( @next_step.a.collect{ |vector| vector.to_a } )
	end

	def next_v
		v + 0.5 * ( a + next_a ) * @@dt
	end

	def next_r
		r + v * @@dt + 0.5 * a * @@dt**2
	end

	def new_timestep_with_coords( coords )
		new_step = @this_step.copy
		new_step.r = coords.row_vectors
		return new_step
	end

	def delta_e
		@next_step.energy - @this_step.energy
	end

	def update_step
		@this_step = @next_step
	end

end