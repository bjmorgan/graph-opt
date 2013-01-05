class Optimiser

	def initialize( nodes, springs )
		@nodes = nodes
		@springs = springs
	end

	def optimise!
		this_timestep = Timestep.new( @nodes, @springs )
		integrator = Projected_Velocity_Verlet.new( this_timestep )
		convergence = 1.0e-5

		loop do
			integrator.step # generate next timestep
			this_timestep = integrator.this_step
			break if ( integrator.delta_e.magnitude ) < convergence
			integrator.update_step
		end

		return integrator.this_step.nodes, integrator.this_step.springs
	end

end