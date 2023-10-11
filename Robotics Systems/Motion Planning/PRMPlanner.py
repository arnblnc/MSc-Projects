
import math
import random
import matplotlib.pyplot as plt
import numpy as np
import heapq
import time
from matplotlib.animation import FuncAnimation
from matplotlib.patches import Circle
from queue import PriorityQueue





start = (0, 0) #qstart
goal = (6, 10) #qgoal
obstacleList = [(5, 5, 1), (3, 6, 2), (3, 8, 2), (3, 10, 2), (7, 5, 2), (9, 5, 2), (8, 10, 1)] #Cobj
robot_radius = 0.8


# Define the bounds of the configuration space
x_min = 0
x_max = 15
y_min = 0
y_max = 15


# Define the number of nodes to generate
num_nodes = 500
global start_time
start_time1 = time.time()
# Generate a random sample of nodes in the configuration space (Cfree)
nodes = []
while len(nodes) < num_nodes:
    x = np.random.uniform(x_min, x_max)
    y = np.random.uniform(y_min, y_max)
    is_collision = False
    for ox, oy, r in obstacleList:
        if math.sqrt((ox - x) ** 2 + (oy - y) ** 2) <= r + robot_radius:
            is_collision = True
            break
    if not is_collision:
        nodes.append([x, y])
        


nodes = np.array(nodes)
#print(np.around(nodes,2))

def is_edge_collision_free(node1, node2):
    dx = node2[0] - node1[0]
    dy = node2[1] - node1[1]
    dist = math.sqrt(dx**2 + dy**2)
    if dist == 0:
        return True
    theta = math.atan2(dy, dx)
    d = robot_radius * 2
    steps = int(dist/d)
    for i in range(steps):
        x = node1[0] + d*math.cos(theta)*i
        y = node1[1] + d*math.sin(theta)*i
        if is_collision([x, y]):
            return False
    return True


# Define the number of nearest neighbors to consider
k = 10

# Compute the Euclidean distance between each pair of points
distances = np.sqrt(((nodes[:, np.newaxis] - nodes) ** 2).sum(axis=2))

# Find the k-nearest neighbors for each point
neighbors = np.argsort(distances, axis=1)[:, 1:k+1]

# Initialize an empty list to hold the edges
edges = []

def is_collision(point):
    for obstacle in obstacleList:
        x, y, r = obstacle
        if math.sqrt((x - point[0])**2 + (y - point[1])**2) <= r + robot_radius:
            return True
    return False


def euclidean_distance(node1,node2):
    return math.sqrt((node1[0]-node2[0])**2+(node1[1]-node2[1])**2)
    
# Add edges between each point and its k-nearest neighbors
edges = []
for i in range(num_nodes):
    node1 = nodes[i]
    for j in neighbors[i]:
        node2 = nodes[j]
        if is_edge_collision_free(node1, node2):
            edges.append((i, j))

# Store connections of each node in a dictionary
adj_dict = {}
for i, j in edges:
    if i not in adj_dict:
        adj_dict[i] = []
    if j not in adj_dict: 
        adj_dict[j] = []
    adj_dict[i].append(j)
    adj_dict[j].append(i) # add this line if the graph is undirected 

global end_time
global elapsed_time1
end_time1 = time.time()
elapsed_time1 = end_time1 - start_time1 
  
# visualisation: 
fig, ax = plt.subplots(figsize=(7,7))
ax.scatter(nodes[:, 0], nodes[:, 1])

for obstacle in obstacleList:
    x, y, r = obstacle
    circle = Circle((x, y), r, fill = False, edgecolor = 'black')
    ax.add_patch(circle)

for i, j in edges:
    ax.plot([nodes[i, 0], nodes[j, 0]], [nodes[i, 1], nodes[j, 1]], color='black')
patches = []
robot = Circle(start, robot_radius, fill=True, color='blue',label="Starting position")
patches.append(ax.add_patch(robot))
goal_patch = Circle(goal, robot_radius, fill=True, color='green',label="Goal Position")
patches.append(ax.add_patch(goal_patch))




def dijkstra(nodes, connections, start, end):
    # find the closest nodes to the start and end points
    start_node = np.argmin(np.linalg.norm(nodes - start, axis=1))
    end_node = np.argmin(np.linalg.norm(nodes - end, axis=1))
    
    # initialize distances to all nodes as infinity except the start node, which is 0
    distances = [float("inf")] * len(nodes)
    distances[start_node] = 0
    
    # create a priority queue with the start node
    queue = [(0, start_node)]
    
    # initialize previous nodes array to None
    previous = [None] * len(nodes)
    
    while queue:
        # get the node with the smallest distance from the queue
        current_distance, current = heapq.heappop(queue)
        
        # if we have reached the end node, return the shortest path
        if current == end_node:
            path = []
            while current is not None:
                path.append(current)
                current = previous[current]
            
            return list(reversed(path))
        
        # for each neighbor of the current node, update its distance if necessary
        for neighbor in connections[current]:
            distance = distances[current] + distance_between(nodes[current], nodes[neighbor])
            if distance < distances[neighbor]:
                distances[neighbor] = distance
                previous[neighbor] = current
                heapq.heappush(queue, (distance, neighbor))
        
    # if we reach this point, there is no path from the start to the end node
    return None

def distance_between(p1, p2):
    return np.linalg.norm(p1-p2)

global start_time
start_time2 = time.time()

shortest_path=dijkstra(nodes,adj_dict,start,goal)

plt.plot(nodes[shortest_path,0],nodes[shortest_path,1],c='r',label="Shortest Path via Dijkstra")
plt.legend(bbox_to_anchor=(0.5, 1.05),loc='center')

global end_time
global elapsed_time
end_time2 = time.time()
elapsed_time2 = end_time2 - start_time2 
elapsed_total_time = elapsed_time2 + elapsed_time1 
print("Time taken to execute the code: {:.6f} seconds".format(elapsed_total_time))


plt.show()

total_dist=0
from_start_to_first_node_dist=np.linalg.norm(nodes[shortest_path[0]]-start)
from_last_node_to_goal_dist=np.linalg.norm(goal-nodes[shortest_path[-1]])


for i in range(1,len(shortest_path)):
    
    curr_node_idx=shortest_path[i]
    prev_node_idx=shortest_path[i-1]

    curr_node=nodes[curr_node_idx,:]
    prev_node=nodes[prev_node_idx,:]

    dist_nodes=np.linalg.norm(curr_node-prev_node)
    total_dist=total_dist+dist_nodes

total_dist=total_dist+from_start_to_first_node_dist+from_last_node_to_goal_dist
print(f"Shortest path length via Dijkstra's algorithm is: {total_dist}")











