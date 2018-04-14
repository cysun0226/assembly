import graphviz as gv
from graphviz import Digraph
import os
os.environ["PATH"] += os.pathsep + 'C:/Program Files (x86)/Graphviz2.38/bin/'


g1 = gv.Digraph( format='png', comment='System chart',  splines = 'polyline')
g1.node('A')
g1.node('B')
g1.node('C')
g1.edge('A', 'B', arrowhead = 'none')
g1.edge('A', 'C')


print(g1.source)


filename = g1.render(filename='img/p0204_1')
print(filename)
