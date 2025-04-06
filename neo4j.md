# Neo4j

<https://neo4j.com/>

Graph database that uses a [Cypher](#cypher) language for querying.

<!-- INDEX_START -->

- [Key Points](#key-points)
- [Quickstart](#quickstart)
- [Monitoring](#monitoring)
- [ETL](#etl)
  - [1. Small - Neo4j web page](#1-small---neo4j-web-page)
  - [2. Medium - Neo4j-shell-tools](#2-medium---neo4j-shell-tools)
  - [3. Medium - Neo4j Browser Tool](#3-medium---neo4j-browser-tool)
  - [4. Large - Bulk batch graph.db writer](#4-large---bulk-batch-graphdb-writer)
- [Cypher](#cypher)
  - [Query Template](#query-template)
  - [Updating the Graph](#updating-the-graph)
  - [Explore](#explore)
- [Libraries](#libraries)

<!-- INDEX_END -->

## Key Points

- Use Case is complex queries that would be too expensive with many cartesian product joins in [RDBMS](databases.md)
- Not as suited to simple aggregates / large set-oriented / graph global operations

<!-- -->

- Labeled Property Graph (LPG) Database of nodes and relationships
- Small footprint
- powerful traversal framework
- Cypher - declarative query language (SQL for graphs but instead uses ASCII art to represent patterns)
- Gremlin Traversal Language
- ACID compliant
- granular modelling (don't use rich properties, split in to entities and link them to allow for more flexible querying)
- avoid dense/super nodes - too highly connected as this impacts traversal performance
  - create artificial "meta" nodes of 100 relationships to fan out the user base to an artist

<!-- -->

- Community Edition - Single Server (no horizontal scalability)

<!-- -->

- Enterprise Edition:
  - Clustering (HA & LB) - Master -> Slaves, LB different queries to different slaves to get shard caching of subsets of the graph on each node for better performance
  (3.0+)           - HA master election is based on Paxos
  - advanced monitoring
  - advanced caching
  - online backups

graph local -> anchor vertex (node), traverse edges (relationships) from there

- specialised graph modelling required based on use case queries
- highly flexible schema / dynamic schema evolution

Example:

- news index ElasticSearch tokenize nouns -> neo4j <- clients  Sentiment

## Quickstart

```shell
neo4j start
```

Browse to:

<http://localhost:7474>

Nodes <--- Relationships ---> Nodes

Nodes + Relationships each have Properties (key:value pairs)

`node.property` / `relationship.property` - boolean, numeric, string or array of boolean, numeric, string

Label - organizes nodes into groups (added in 2.0 late 2013)

nouns      => entities
verbs      => relationships
adjectives => properties

## Monitoring

[Nagios](nagios.md) TODO:

- neo4j replication lag check

## ETL

`Talend` -> `JDBC` -> `Rest API` (inefficient)

### 1. Small - Neo4j web page

Generate Cypher `create` statements on the Neo4j web page.

### 2. Medium - Neo4j-shell-tools

- reads nodes + relationships CSV, generate CSVs + import using:

```shell
import-cypher -d ',' -i 'nodes.csv' -o 'nodes-output.log' 'CREATE (n:#{Label}) {id:{Node},name:{Name}}) RETURN *';
```

```shell
import-cypher -d ',' -i 'rels.csv' -o 'rels-output.log' 'MATCH (from {id:{From}}), (to {id:{To}}) CREATE from-[:#{Relationship Type}]->to RETURN *;'
```

### 3. Medium - Neo4j Browser Tool

```cypher
LOAD CSV WITH HEADERS FROM "file:/path/to/file.csv" AS NODES CREATE (n {id: nodes.Node, name: nodes.Name, type: nodes.Label}) RETURN n;
```

For 200k+ rows

```cypher
LOAD CSV WITH HEADERS FROM "file:/path/to/file.csv" AS RELS MATCH (from {id: rels.From}), (to {id: rels.To}) CREATE from-[:REL {type: rels {type: rels.`Relationship Type`}]->to RETURN from,to;
```

Assign labels:

```cypher
MATCH (m {type:"Male"}), (f {type:"Female"}) SET m:Male, f:Female RETURN m,f;
```

Create relationships:

```cypher
MATCH (n)-[r1 {type:"MOTHER_OF"}]->(m), (s)-[r2 {type:"FATHER_OF"}]->(t) CREATE n[:MOTHER_OF]->m, s-[:FATHER_OF]->(t) RETURN *;
```

Remove duplicate relationships:

```cypher
MATCH ()->[r:REL]-() delete r;
```

### 4. Large - Bulk batch graph.db writer

[:octocat: jexp/batch-import](https://github.com/jexp/batch-import)

- can append, default overwrite
- tsv nodes - node name label
- rels - start end type

```shell
import.sh test.db nodes.tsv rels.tsv &&
mv test.db "$NEO4J_HOME/data" &&
neo4j start
```

## Cypher

The query language used by Neo4j.

Identifier used for query reference purpose to `RETURN` identifier.properties

| Syntax                     | Description                                                                                                                              |
|----------------------------|------------------------------------------------------------------------------------------------------------------------------------------|
| `(a)`                      | Nodes given identifier `a`                                                                                                               |
| `(a) --> (b)`              | Nodes `a` have a relationship to nodes `b`                                                                                               |
| `(a) -[r]-> (b)`           | Relationship given identifier `r` between nodes `a` and `b`                                                                              |
| `(a)-[:ACTED_IN]->(m)`     | Find nodes `a` that have an `ACTED_IN` type relationship to nodes `m`. Relationship type is by convention all UPPERCASE_WITH_UNDERSCORES |
| `(m {title:"The Matrix"})` | Find nodes where the `title` property equals `"The Matrix"`                                                                              |

### Query Template

```cypher
MATCH (node:Label)-[relationship_id:relationship_type)->(node2:Label)

RETURN node.propertyA, node2.propertyB, relationship_id.propertyC, type(relationship_id) ;

WHERE - both these queries are equivalent ways

MATCH (node:Label) WHERE node.property = "value" AND node.property2 = "value2"

MATCH (node:Label {property:"value", property2:"value2"} )
```

```cypher
CREATE INDEX ON :Label(property);
```

Find all `a` nodes with any relationships to any other nodes:

```cypher
MATCH (a) ---> ( )
RETURN a
```

| Command      | Description                                                |
|--------------|------------------------------------------------------------|
| `MATCH`      | Matches the given graph pattern in the graph data          |
| `WHERE`      | Filters using predicates or anchors pattern elements       |
| `RETURN`     | Returns and projects result data, also handles aggregation |
| `ORDER BY`   | Sorts the query result                                     |
| `SKIP/LIMIT` | Paginates the query result                                 |

### Updating the Graph

| Command         | Description                                                                           |
|-----------------|---------------------------------------------------------------------------------------|
| `CREATE`        | Creates nodes and relationships                                                       |
| `MERGE`         | Creates nodes uniquely                                                                |
| `CREATE UNIQUE` | Creates relationships uniquely                                                        |
| `DELETE`        | Removes nodes, relationships                                                          |
| `SET`           | Updates properties and labels                                                         |
| `REMOVE`        | Removes properties and labels                                                         |
| `FOREACH`       | Performs updating actions once per element in a list                                  |
| `WITH`          | Divides a query into multiple, distinct parts and passes results from one to the next |
| `INDEX`         |                                                                                       |
| `DISTINCT`      |                                                                                       |

```cypher
MATCH (actor)-[:ACTED_IN]->(movie)<-[:DIRECTED]-(director)
RETURN actor.name, movie.title, director.name;
```

Path:

```cypher
MATCH p=(a)-->(b)
RETURN p
```

Return just the nodes or the relationships:

```cypher
RETURN nodes(p)
RETURN rels(p)
```

```cypher
MATCH (a)-[:ACTED_IN]->(m)
RETURN a.name, m.title
SKIP 10
LIMIT 10;
```

```cypher
MATCH (p:Person)
RETURN p.name
ORDER BY p.born
LIMIT 5;
```

### Explore

Browse nodes:

```cypher
MATCH (n) RETURN (n) LIMIT 20;
```

See Labels:

```cypher
MATCH (n) WHERE has(n.name) RETURNS labels(n);
```

See types of relationships:

```cypher
MATCH (n:Person)-[r]->() RETURN DISTINCT type(r);
```

```cypher
MATCH (a)-[:ACTED_IN]->()
RETURN DISTINCT a
ORDER BY a.born
LIMIT 5
```

Aggregate functions:

```cypher
count(x)
min(x)
max(x)
avg(x)
sum(x)
collect(x) # Collect all the values into a list
```

## Libraries

- graphaware
- [graphql](https://neo4j.com/product/graphql-library/)
- [py2neo](https://neo4j-contrib.github.io/py2neo/) - end-of-life

**Ported from private Knowledge Base page 2013+**
