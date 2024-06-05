MATCH (p1:Person)-[:ACTED_IN|:DIRECTED]->(m:Movie)<-[:ACTED_IN|:DIRECTED]-(p2:Person)
WHERE p1 <> p2
WITH p1, p2, COUNT(m) AS collaborations
WHERE collaborations > 1
RETURN p1.name AS Person1, p2.name AS Person2, collaborations
ORDER BY collaborations DESC
