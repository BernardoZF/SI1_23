MATCH (a1:Person)-[:ACTED_IN]->(m:Movie)<-[:ACTED_IN]-(common:Person)-[:ACTED_IN]->(m)<-[:ACTED_IN]-(a2:Person)
WHERE a2.name = 'Winston, Hattie' AND a1 <> a2
WITH a1, collect(DISTINCT common) AS common_actors
WHERE NONE(common_actor IN common_actors WHERE common_actor.name = 'Winston, Hattie')
RETURN a1.name AS Actor
ORDER BY a1.name
LIMIT 10
