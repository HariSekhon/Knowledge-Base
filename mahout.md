# Mahout

Open source library of Machine Learning algorithms.

Mahout is Hindi for Elephant Driver ie. it drives Hadoop, for which the elephant is the mascot.

<!-- INDEX_START -->

- [Key Points](#key-points)
- [Input](#input)
- [Output](#output)

<!-- INDEX_END -->

## Key Points

- Hadoop is not strictly necessary (can run in local mode without Hadoop)
- version of Hadoop varies by Mahout version
- `$JAVA_HOME` environemnt variable must be set
- `hadoop` executable must in in `$PATH` if using Hadoop
- ratings data must be in CSV format
- users and items must be integers
- malformed ratings can skew predictions (XXX: strongly validate input data)
- output or temp directory existence causes non-fast failure (not initially checked. XXX: write checks for this)
- only files in input directory should be input data, stray files can result in `ArrayIndexOutOfBoundsException`

```shell
yum install mahout
```

to run in local mode without Hadoop set `MAHOUT_LOCAL` environment variable to any value:

```shell
export MAHOUT_LOCAL=true
```

```shell
cat > users.txt <<EOF
6037
6038
6039
6040
EOF
```

```shell
hadoop fs -put users.txt
```

Always use `--booleanData` for binary preferences for Tannimoto / LogLiklihood

## Input

Schema always same hence mahout assumes schema and just works

For binary preferences:

```text
userid1,trueitem1
userid1,trueitem2
```

For numeric preferences:

```csv
user,item,preference
```

- `--usersFile`, `--itemsFile` - only recommend for this list of users / items
- `--filterFile` - exclude user,item pairs from recommendations

```shell
mahout recommenditembased --input movierating --output recs --usersFile users.txt --similarityClassname SIMILARITY_LOGLIKELIHOOD --booleanData
```

Other values for the `--similarityClassname` option:

```text
SIMILARITY_TANIMOTO_COEFFICIENT --booleanData
```

```text
SIMILARITY_EUCLIDEAN_DISTANCE
```

```text
SIMILARITY_COSINE
```

```text
SIMILARITY_PEARSON_CORRELATION
```

## Output

```text
user_id [item1:score1, ... itemN:scoreN]
```

**Ported from private Knowledge Base pages 2013+**
