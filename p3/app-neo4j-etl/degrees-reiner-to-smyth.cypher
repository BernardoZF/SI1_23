MATCH p=shortestPath((p1:Person)-[*]-(p2:Person))
WHERE p1.name = "Reiner, Carl" AND p2.name = "Smyth, Lisa (I)"
RETURN p
