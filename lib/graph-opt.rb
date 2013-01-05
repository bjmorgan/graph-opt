#!/usr/local/bin/ruby

# November 30, 2012

$: << "/Users/ben/Documents/Code/Ruby/graph-opt/lib/"

path = 'graph-opt'

files = %w{
	poscar
	spring
	node
	vector
	timestep
	velocity_verlet
	projected_velocity_verlet
	cell
	optimiser
	base
}

files.each{ |file| require "#{path}/#{file}" }
