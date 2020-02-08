// Naming this grammar as 'N1ql'
grammar N1ql;
// Parser Rules

  // High level Phrase recognition
dropPrimaryIndex:       'DROP' 'PRIMARY' 'INDEX' 'ON' namedKeyspaceRef indexUsing?;
lookupJoinPredicate:    'ON' 'PRIMARY'? 'KEYS' expr;
namedBucketRef:         (poolName ':')? bucketName;
viewIndexStmt:          (createViewIndex|dropViewIndex);
rankFunctions:          ('RANK'|'DENSE_RANK'|'PERCENT_RANK'|'CUME_DIST');
pathFor:                'FOR' (variable 'IN' path (',' variable 'IN' path)*) ('WHEN' cond) 'END';
nullsTreatment:         ('RESPECT'|'IGNORE') 'NULLS';
nthvalFrom:             'FROM' ('FIRST'|'LAST');
rangeXform:             ('ARRAY'|'FIRST'|'OBJECT' nameExpr ':') expr 'FOR' ((var ('WITHIN'|('IN' (var ',' expr 'IN'))))|(nameVar ':' var ('IN'|'WITHIN'))) expr ('WHEN' cond)? 'END';

  // Clauses
fromClause:             'FROM' fromTerm;
groupByClause:          (lettingClause|('GROUP' 'BY' (expr (',' expr)*) lettingClause? havingClause?));
havingClause:           'HAVING' cond;
joinClause:             joinType? 'JOIN' fromKeyspace ('AS'? alias)? joinPredicate;
  joinPredicate:          (lookupJoinPredicate|indexJoinPredicate);
  joinType:               ('INNER'|('LEFT' 'OUTER'?));
keyClause:              'PRIMARY'? 'KEY' expr; // This ones diagram is bugged i think
keysClause:             'KEYS' expr;
letClause:              'LET' (alias '=' expr (',' alias '=' expr)*);
lettingClause:          'LETTING' (alias '=' expr (',' alias '=' expr)*);
limitClause:            'LIMIT' expr;
nestClause:             joinType? 'NEST' fromKeyspace ('AS'? alias)? joinPredicate;
offsetClause:           'OFFSET' expr;
onKeysClause:           'ON' 'PRIMARY'? 'KEYS' expr;
orderByClause:          'ORDER' 'BY' (orderingTerm (',' orderingTerm));
  orderingTerm:         expr ('ASC'|'DESC')? ('NULLS' ('FIRST'|'LAST'))?;
returningClause:        'RETURNING' ((resultExpr (',' resultExpr)*)|(('RAW'|'ELEMENT'|'VALUE') expr));
selectClause:           'SELECT' ('ALL'|'DISTINCT')? ((resultExpr(',' resultExpr)*)|(('RAW'|'ELEMENT'|'VALUE') expr ('AS'? alias)?));
setClause:              'SET' (path '=' expr updateFor? (',' path '=' expr updateFor?)*);
  setOp:                ('UNION'|'INTERSECT'|'EXCEPT');
  
unsetClause:            'UNSET' ( path updateFor? (',' path updateFor?)*);
useClause:              (useKeysClause|useIndexClause);
  useIndexClause:       'USE' 'INDEX' '(' (indexRef ('.' indexRef)*) ')';
  useKeysClause:        'USE' 'PRIMARY'? 'KEYS' expr;
valueClause:            ('VALUE'|'VALUES') expr;
valuesClause:           'VALUES' ('(' expr ',' expr ')' ('VALUES'? ',' '(' expr ',' expr ')')*);
whereClause:            'WHERE' cond;

  // Expressions

    // Expression parsing
mexpr:                  (expr|rcvexpr|first); // might be left recursion error
lexpr:                  (mexpr|prepare|cursor);
rcvexpr:                '<-' mexpr;  // might be left recursion error

    // Basic Expressions
expr:                   literal
                          |identifier
                          |nestedExpr
                          |caseExpr
                          |logicalTerm
                          |comparisonTerm
                          |arithmeticTerm
                          |concatenationTerm
                          |windowFunction
                          |functionCall
                          |subqueryExpr
                          |collectionExpr
                          |constructionExpr
                          |'(' expr ')';
      
      // CASE Expreressions
caseExpr:               (simpleCaseExpr|searchedCaseExpr);
fullCase:               'CASE'('WHEN' mcond 'THEN' block)* ('ELSE' block)? 'END';
searchedCase:           'CASE' mexpr ('WHEN' mexpr 'THEN' block)* ('ELSE' block)? 'END';
searchedCaseExpr:       'CASE' ('WHEN' cond 'THEN' expr)* ('ELSE' expr)? ;
simpleCaseExpr:         'CASE' expr ('WHEN' expr 'THEN' expr)* ('ELSE' expr)? 'END';

      // COLLECTION Expreressions
collectionCond:         ('ANY'|'SOME'|'EVERY') (variable ('IN'|'WITHIN') expr) (variable ('IN'|'WITHIN') expr)* ('SATISFIES' cond) 'END';

// collectionExpr:         (existsExpr|inExpr|withinExpr|rangeCond|rangeXform);
collectionExpr:         (existsExpr|inExpr|withinExpr|rangeXform);

      // MISC Expressions
mapExpr:                'MAP' (variable (',' variable)*) 'IN' (expr (',' expr)*) ('TO' expr)? ('WHEN' cond)? 'END';
nameExpr:               expr;
inExpr:                 expr 'NOT'? 'IN' expr;
arrayExpr:              'ARRAY' expr 'FOR' (variable('IN'|'WITHIN') expr) (',' variable('IN'|'WITHIN'))? ('WHEN' cond)? 'END';
fieldExpr:              expr '.' (identifier|(escapedIdentifier ('|')?));
firstExpr:              'FIRST' expr 'FOR'
                          (variable ('IN'|'WITHIN') expr)
                          (',' variable ('IN'|'WITHIN') expr)?
                          ('WHEN' cond)? 'END';
constructionExpr:       (object|array);

// collectionExpr:         (existsExpr|inExpr|withinExpr|rangeCond|rangeXform);
existsExpr:             'EXISTS' expr;
elementExpr:            expr '[' expr ']';
existentialExpr:        'EXISTS' '(' select ')';
// existsExpr:             'EXISTS' expr;
nestedExpr:             (fieldExpr|elementExpr|sliceExpr);
reduceExpr:             'REDUCE' (variable (',' variable)*) 'IN' (expr (',' expr)*) 'TO' expr ('WHEN' cond)? 'END';
resultExpr:             (((path '.')? '*')|(expr('AS'? alias)?));
sliceExpr:              expr '[' expr ':' expr? ']';
subqueryExpr:           '(' select ')';
withinExpr:             expr 'NOT'? 'WITHIN' expr;


  // Functions
keyspaceRef:            (namespace ';')? keyspace ('AS'? alias)?;
namedKeyspaceRef:       (namespace ':')? keyspace;
  namespace:              identifier;
  keyspace:               identifier;

    // Higher Level Functions
aggregateFunctions:     ('ARRAY_AGG'|'AVG'|'COUNT'|'COUNTIN'|'MAX'|'MEAN'|'MEDIAN'|'MIN'|'SUM'|'STDDEV_SAMP'|'STDDEV_POP'|'VARIENCE'|'VAR_SAMP'|'VAR_POP');
aggregateQualifier:     ('ALL'|'DISTINCT');

    // Window Functions


    // Control Functions
ctrl:                   (if|case|loop|break|continue|pass|return|deliver); // defer was in here, but there was no parser diagrams

if:                     mcond 'THEN' block ('ELSEIF' mcond 'THEN' block)* ('ELSE' block)? 'END';
case:                   (fullCase|searchedCase);
// case:                   (fullCase|searchedCase);
concatenationTerm:      expr '||' expr;
collectionPredicate:    ('ANY'|'ALL') cond 'OVER' expr ('AS'? alias)? (('OVER' subpath ('AS' alias)?)+)?; 
collectionXform:        (arrayExpr|firstExpr);
loop:                   label? (while|for);
break:                  'BREAK' labelName?;
continue:               'CONTINUE' labelName?;
comprehension:          '[' expr 'OVER' expr ('AS'? alias)? ('IF' expr)? (('OVER' subpath ('AS' alias)? ('IF' expr)?)+)? ']';
pass:                   'PASS';
return:                 'RETURN' (lexpr (',' lexpr));
deliver:                'DELIVER' ('WHEN' commop 'THEN' block)* ('ELSE' block)? 'END';
// defer: ;                /////////////////////////////////// this is not in the database
ddlStmt:                indexStmt;
dmlStmt:                (insert|upsert|delete|update|merge);
for:                    (forIter|forMap);
forIter:                'FOR' var 'IN' (mexpr|cursor) 'DO' block 'END';
  forMap:                 'FOR' keyVar ',' valVar 'IN' mexpr 'DO' block 'END';
delete:                 'DELETE' 'FROM' keyspaceRef useClause? whereClause? limitClause? returningClause?;
execute:                'EXECUTE' mexpr ('USING' mexpr (',' mexpr)*)?;
first:                  'FIRST' cursor;
cursor:                 (query|execute);
dataset:                path ('AS'? alias)? (('OVER' subpath ('AS'? alias)?)+)?;
start:                  'START' 'TRANSACTION';
while:                  'WHILE' mcond 'DO' block 'END';
query:                  (select|dmlStmt);
  subquery:               select;
label:                  labelName ':';
labelName:              identifier;
function:               functionName '(' ('DISTINCT'? (((path '.')? '*')|(expr (',' expr))))?;
  functionName:         identifier;
  functionCall:         functionName '(' ('*'|((expr (',' expr)*)|'DISTINCT'))?;
fullpath:               (poolName ':')? path;
commop:                 (sendop|rcvop);
  sendop:                 var '<-' mexpr;
  rcvop:                  var (',' var)? (':='|'::=') rcvexpr;
rollback:               'ROLLBACK' 'WORK'?;
truncate:               'TRUNCATE' keyspaceRef;
unset:                  'UNSET' mexpr '.' subpath;
update:                 'UPDATE' keyspaceRef useClause? setClause? unsetClause? whereClause? limitClause? returningClause?;
updateFor:              ('FOR' (nameVar ':')? var ('IN'|'WITHIN') path (',' (nameVar ':')? var ('IN'|'WITHIN') path)*)* ('WHEN' cond)? 'END';
upsert:                 'UPSERT' 'INTO' keyspaceRef (insertValues|insertSelect) returningClause?;
using:                  'USING' ('VIEW'|'GSI');
prepare:                'PREPARE' (query|mexpr) ('USING' (var (',' var)*))?;
partition:              'PARTION' 'BY' expr;
pair:                   nameExpr ':' expr;

  // N1ql parsing commands
assign:                 (var(',' var)*) ':=' (lexpr(',' lexpr)*);
init:                   (var (',' var)*) '::=' (lexpr (',' lexpr)*);
decl:                   'DECLARE' (var(',' var)*) (':=' (lexpr (',' lexpr)*))?;

  // Basic Parses

    // PATH
path:                   identifier ('[' expr ']')* ('.' path)?; // This loop ('[' expr ']')* is questionable because there is no seperators like commas and stuff
subpath:                identifier ('[' int ']')? ('.' subpath);

    // Logic Syntax
logicalTerm:            ((cond ('AND'|'OR'))|'NOT') cond;
    
    // Conditions
cond:                   expr;
mcond:                  mexpr;

    //Begin
begin:                  'BEGIN' block 'END';

    // Block  
block:                  terminatedStmt;
terminatedStmt:         stmt (';'|newline);
transactionStmt:        (start|commit|rollback);
//stmt:                   (begin|ded|init|assign|unset|sendop|ctrl|lexpr);
stmt:                   (begin|init|assign|unset|sendop|ctrl|lexpr);

    // From
fromKeyspace:           (namespace ':')? keyspace;
fromPath:               (namespace ':')? path;
fromSelectCore:         fromClause letClause? whereClause? groupByClause? selectClause;
fromSelect:             fromClause letClause? whereClause? groupByClause? selectClause;
// fromTerm:               ((fromKeyspace ('AS'? alias)? useClause?)|('(' select ')' 'AS'? alias)|(expr ('AS' alias)?)|(fromTerm (joinClause|nestClause|unnestClause)));
fromTerm:               ((fromKeyspace ('AS'? alias)? useClause?)|('(' select ')' 'AS'? alias)|(expr ('AS' alias)?)|(fromTerm (joinClause|nestClause)));

    // Select
select:                 (selectTerm ('ALL'? setOp selectTerm)*) orderByClause? limitClause? offsetClause?;
subselect:              (selectFrom|fromSelect);
selectCore:             (selectFromCore|fromSelectCore);
selectFor:              select 'FOR' ('UPDATE'|'SHARE') ('OF' (keyspaceRef (',' keyspaceRef)*))?;
selectFromCore:         selectClause fromClause? letClause? whereClause? groupByClause?;
selectFrom:             selectClause fromClause? letClause? whereClause? groupByClause?; // BAD PARSING, replace all the selectfromcore with selectFrom
selectTerm:             (subselect|'(' select ')');

    // Insert
insert:                 'INSERT' 'INTO' keyspaceRef (insertValues|insertSelect) returningClause?;
insertSelect:           '(' 'PRIMARY' 'KEY' expr (',' 'VALUE' expr)? ')' select;
insertValues:           ('(' 'PRIMARY'? 'KEY' ',' 'VALUE' ')')? valuesClause;

    // Window
windowClause:           windowPartitionClause? (windowOrderClause (windowFrameClause (windowFrameExclusion)?)?)?;
// windowFrameClause:      ('ROWS'|'RANGE'|'GROUPS') (('UNBOUNDED' 'PRECEDING')|('CURRENT' 'ROW')|(valexpr 'FOLLOWING')|('BETWEEN'(('UNBOUNDED' 'PRECEDING')|('CURRENT' 'ROW')|(valexpr 'FOLLOWING')|('BETWEEN' (('UNBOUNDED' 'PRECEDING')|('CURRENT' 'ROW')|(valexpr ('PRECEDING'|'FOLLOWING'))) 'AND' (('UNBOUNDED' 'FOLLOWING')|('CURRENT' 'ROW')|(valexpr ('PRECEDING'|'FOLLOWING')))))));
windowFrameClause:      ('ROWS'|'RANGE'|'GROUPS') (('UNBOUNDED' 'PRECEDING')|('CURRENT' 'ROW')|('BETWEEN'(('UNBOUNDED' 'PRECEDING')|('CURRENT' 'ROW')|('BETWEEN' (('UNBOUNDED' 'PRECEDING')|('CURRENT' 'ROW')) 'AND' (('UNBOUNDED' 'FOLLOWING')|('CURRENT' 'ROW'))))));
windowFrameExclusion:   'EXECUTE' ('CURRENT' 'ROW'|'GROUP'|'TIES'|'NO' 'OTHERS');
windowFunctionArguments:(aggregateQualifier? expr (',' expr (',' expr)?)?)?;
windowFunctionOptions:  nthvalFrom? nullsTreatment?;
windowFunctionType:     (aggregateFunctions|rankFunctions|'ROW_NUMBER'|'RATIO_TO_REPORT'|'NTILE'|'LAG'|'LEAD'|'FIRST_VALUE'|'LAST_VALUE'|'NTH_VALUE');
windowFunction:         windowFunctionType '(' windowFunctionArguments ')' windowFunctionOptions? 'OVER' '(' windowClause ')';
windowOrderClause:      'ORDER' 'BY' (orderingTerm(',' orderingTerm)*);
windowOrderTerm:        ('ASC'|'DESC')? ('NULLS' ('FIRST'|'LAST'))?;
windowPartitionClause:  'PARTION' 'BY' (expr (',' expr));

    // Bucket
bucketName:             identifier;
bucketRef:              (poolName ':')? bucketName ('AS'? alias)?;
bucketSpec:             (poolName ':')? bucketName;
bucketStmt:             alterBucket;
alterBucket:            'ALTER' 'BUCKET' (poolName ':')? bucketName 'RENAME' subpath 'TO' identifier;

    // Index
alterIndex:             'ALTER' 'INDEX' namedBucketRef '.' indexName 'RENAME' 'TO' indexName;
buildIndexes:           'BUILD' 'INDEXES' 'ON' namedKeyspaceRef '(' indexName (',' indexName) ')' indexUsing?;
createIndex:            'CREATE' 'INDEX' indexName 'ON' namedKeyspaceRef '(' expr (',' expr)* ')' whereClause? indexUsing? indexWith?;
createPrimaryIndex:     'CREATE' 'PRIMARY' 'INDEX' indexName? 'ON' namedKeyspaceRef indexUsing? indexWith?;
createViewIndex:        'CREATE' 'VIEW' 'INDEX' identifier 'ON' (poolName ':')? bucketName '(' subpath (',' subpath)* ')';
dropIndex:              'DROP' 'INDEX' namedKeyspaceRef '.' indexName indexUsing?;
dropViewIndex:          'DROP' 'VIEW' 'INDEX' (poolName ':')? bucketName '.' identifier;
indexJoinPredicate:     'ON' 'PRIMARY'? 'KEY' expr 'FOR' alias;

    // Merge
merge:                  'MERGE' 'INTO' keyspaceRef 'USING' mergeSource 'ON' keyClause mergeActions limitClause? returningClause?;
mergeActions:           mergeUpdate? mergeDelete? mergeInsert?;
mergeDelete:            'WHEN' 'MATCHED' 'THEN' 'DELETE' whereClause?;
mergeInsert:            'WHEN' 'NOT' 'MATCHED' 'THEN' 'INSERT' expr whereClause?;
mergeUpdate:            'WHEN' 'MATCHED' 'THEN' 'UPDATE' setClause? unsetClause? whereClause?;
mergeSource:            ((fromKeyspace ('AS'? alias)? useClause?)|('(' select ')' 'AS'? alias)|(expr ('AS'? alias)?));


indexName:              identifier;
// indexRef:               indexRef indexUsing?;
indexRef:               indexUsing indexRef?;
indexStmt:              (createPrimaryIndex|createIndex|dropPrimaryIndex|dropIndex|buildIndexes);
indexUsing:             'USING' ('VIEW'|'GSI');
indexWith:              'WITH' expr;

    // POOL
poolName:               identifier;

    // Comments
commit:                 'COMMIT' 'WORK'?;
blockComment:           '/*' (text newline)* '*/';
lineComment:            '--' (text newline);

  // Datatypes

    // Comparison Term
comparisonTerm: expr (('IS' 'NOT'? ('NULL'|'MISSING'|'KNOWN'|'VALUED'))|(('='|'=='|'!='|'<>'|'>'|'>='|'<'|'<='|('NOT'? ('BETWEEN' expr 'AND'|'LIKE'))) expr));

    // Alias
alias:                  identifier;

    // ID
identifier:             (escapedIdentifier|UnescapedIdentifier);
escapedIdentifier:      '\'' chars '\'';
UnescapedIdentifier:    [a-zA-Z_] ([$_a-zA-Z0-9])*;

    // Variables
var:                    identifier;
variable:               identifier;
nameVar:                identifier;
valVar:                 var;
keyVar:                 var;

    // Arrays
array:                  '[' elements? ']';
elements:               (expr|expr ',' elements);

    // Objects
object:                 '{' members? '}';
members:                (pair|pair ',' members);

    // Literals
literal:                (string|number|'TRUE'|'FALSE'|'NULL'|'MISSING');
literalValue:           (string|number|object|array|'TRUE'|'FALSE'|'NULL');

    // Text
string:                 '"' chars? '"';
char:                   (UnicodeCharacter|('\\' ('\\'|'/'|'b'|'f'|'n'|'r'|'t'|('u' HexDigit HexDigit HexDigit HexDigit))));
chars:                  (char|char chars?);
UnicodeCharacter:       [\u0080-\ufffe];
text:                           chars;  ///////////// This is my guess at what it is as 'text' was not in the github database
newline:                ('\r\n'|'\n'|'\r');    

    // Math
arithmeticTerm:         ('-'|(expr ('+'|'-'|'*'|'/'|'%'))) expr;
number:                 int frac? exp?;
int:                    '-'? uint;
uint:                   (Digit|(NonZeroDigit digits));
Digit:                  [0-9];
digits:                 Digit digits?;
NonZeroDigit:           [1-9];
HexDigit:               ([0-9]|[a-f]|[A-F]);
frac:                   '.' digits;
exp:                    e digits;
e:                      ('e'|'E') ('-'|'+');

// Whitespace
WS:                     [ \r\n\t]+ -> skip;

