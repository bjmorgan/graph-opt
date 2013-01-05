require "matrix"

class Poscar

	attr_reader :cell, :coords

	def initialize( data )
		@title = data[:title]
		@scale = data[:scale]
		@cell = data[:cell]
		@representation = data[:representation]
		@species = data[:species]
		@coords = data[:coords]
	end

	def self.new_from_file( filename )

		input = File.new( filename, 'r' ).readlines.map{ |line| line.strip }

		title = input.shift
		scale = input.shift.to_f
		cell = Matrix[ *input.shift(3).map{ |line| line.split.map{ |e| e.to_f } } ]
		names = input.shift.split.map{ |e| e.to_sym }
		ion_numbers = input.shift.split.map{ |e| e.to_i }
		representation = input.shift
		coords = input.map{ |line| Vector.elements( line.split.map{ |e| e.to_f } ) }
		if representation == "Direct" 
			coords.map!{ |c| cell * c } 
			representation = "Cartesian"
		end
		species = Hash[*names.zip(ion_numbers).flatten]

		return Poscar.new( { :title          => title,
												 :scale          => scale, 
												 :cell           => cell, 
												 :species        => species, 
												 :representation => representation, 
												 :coords         => coords } )

	end

	def write_to_file( filename )
		
		output = File.new( filename, 'w' )
	
		output.puts @title
		output.puts @scale
		@cell.row_vectors.each{ |row| output.puts row.to_a.join(' ') }
		output.puts @species.keys.join(' ')
		output.puts @species.values.join(' ')
		output.puts @representation
		@coords.each{ |coord| output.puts coord.to_a.join(' ') }

	end

	def update_coords( coords )
		@coords = coords
		representation = "Cartesian"
	end

end