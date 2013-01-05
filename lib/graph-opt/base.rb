poscar_file = "POSCAR"

structure_id = ARGV[1] ||= nil
unless structure_id.nil?
	connection_list_file = "connections_#{structure_id}.dat"
else
	connection_list_file = "connections.dat"
end

poscar = Poscar.new_from_file( poscar_file )
cell = Cell.init_from_matrix( poscar.cell )
nodes = poscar.coords.map{ |r| Node.new( r ) }
springs = Spring.init_from_file( connection_list_file )
# springs.each{ |spring| puts spring.length }
optimiser = Optimiser.new( nodes, springs )
nodes, springs = optimiser.optimise!

# output new node coordinates to new POSCAR file
poscar.update_coords( nodes.map{ |node| node.r } )
poscar.write_to_file( poscar_file + "_opt")




