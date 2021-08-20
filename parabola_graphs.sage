# This program was written in Sage 9.3. 
# For more information on Sage, see https://www.sagemath.org/
# Computations of independence numbers were done using version 2.2 of
# the MaxCliquePara program, developed by Depolli, Konc, Rozman, Trobec, and Janežič. 
# That program is available at https://e6.ijs.si/~matjaz/maxclique/

import itertools


# This function defines the parabola graph \Pi_p
def parabola_graph(p):
	verts = GF(p)^2
	parabola = [verts((x,x^2)) for x in GF(p)]
	edges = [e for e in itertools.combinations(verts,2) if e[0]+e[1] in parabola]
	# Sage does not allow vertices to be unhashable vectors
	final_verts = [tuple(v) for v in verts]
	final_edges = [tuple(map(tuple,e)) for e in edges]
	return Graph([final_verts,final_edges], format='vertices_and_edges')


# This function defines the limited parabola graph \Lambda_p
def limited_parabola_graph(p):
	verts = GF(p)^2
	parabola = [verts((x,x^2)) for x in GF(p)]
	edges = [e for e in itertools.combinations(verts,2) if e[0][1] != e[1][1] and e[0]+e[1] in parabola]
	final_verts = [tuple(v) for v in verts]
	final_edges = [tuple(map(tuple,e)) for e in edges]
	return Graph([final_verts,final_edges], format='vertices_and_edges')


# This function defines the Paley sum graph P_p
def paley_sum_graph(p):
	verts = GF(p)
	residues = [x^2 for x in GF(p)]
	edges = [e for e in itertools.combinations(verts,2) if e[0] != e[1] and e[0]+e[1] in residues]
	return Graph([verts, edges], format='vertices_and_edges')


# The MaxCliquePara program requires its input to be in the DIMACS graph format;
# this function converts a Sage graph to that format.
def dimacs(G):
	eList = G.edges()
	vList = G.vertices()
	out = 'p edge %d %d\n'%(len(vList), len(eList))
	for x in eList:
		out += 'e %d %d\n'%(vList.index(x[0])+1, vList.index(x[1])+1)
	return out



# Confirm that the parabola graph for p=17 is C_4-free; this command prints 0.
print(parabola_graph(17).subgraph_search_count(graphs.CycleGraph(4)))


# For small graphs, it is simpler to use Sage's built-in clique number functionality,
# but this is much slower for large graphs.
print(paley_sum_graph(17).complement().clique_number())


# This produces the files which serve as inputs to the MaxCliquePara program.
# Note that MaxCliquePara computes clique numbers, so one needs to take
# complements before writing the data.
for p in Primes()[1:15]:
    G = parabola_graph(p).complement()
    open('parabola-%d.clq'%p, 'w').write(dimacs(G))