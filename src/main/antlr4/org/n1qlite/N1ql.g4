// Naming this grammar as 'Parser'
grammar N1ql;

//   JDW:  Doesn't work yet Test versions require EOF
testNumber : pNumber EOF;
testBoolean : pBoolean EOF;

//////// Parser rules ////////

// Numbers
pNumber : Negative? (Decimal|Scinumber) ;
////   JDW:  I added Negative? to the front to allow for negative numbers

pBoolean : (True|False);


//test
test : (pString|pNumber|pNull|pBoolean|pObject)+;

// Strings
///////////////////////////////// Note to self, ask doug about the ? optional character that makes it so that the string could contain nothing
pString : (('"' Unicode+? '"')|('""' Unicode+? '""'));
////// JDW:  You probably want below, I believe they are equivalent, though
// pString : (('"' Unicode* '"')|('""' Unicode* '""'));

// Adding case insensitive Null characters
pNull : N U L L;

// Objects
pObject :'{' (pAttribVal (',' pAttribVal)* )? '}';

// Attribute value pairs
pAttribVal : pString ':' pValue;

// Value
pValue :  pString|pNumber|pObject|pArrays;

// Arrays
pArrays : '[' (pValue (',' pValue)*)? ']';



//////// Lexer rules ////////

// adding support for all unicode characters
Unicode : ('\u0000'..'\uFFFF');

// adding Boolean true false
True : T R U E;
False : F A L S E;

//// Adding scientifically notated numbers
Scinumber : Decimal E Negative? Decimal;

//// Adding Decimals
Decimal : [0-9]+ ('.' [0-9]+)?;

//// Adding Signed notation
Negative : '-';

/* Adding Case Insensitivity if you call the fragments instead of just letters
for example:
'This Is Case Sensitive'
T H I S  I S  C A S E  I N S E N S I T I V E */
fragment A : [aA];
fragment B : [bB];
fragment C : [cC];
fragment D : [dD];
fragment E : [eE];
fragment F : [fF];
fragment G : [gG];
fragment H : [hH];
fragment I : [iI];
fragment J : [jJ];
fragment K : [kK];
fragment L : [lL];
fragment M : [mM];
fragment N : [nN];
fragment O : [oO];
fragment P : [pP];
fragment Q : [qQ];
fragment R : [rR];
fragment S : [sS];
fragment T : [tT];
fragment U : [uU];
fragment V : [vV];
fragment W : [wW];
fragment X : [xX];
fragment Y : [yY];
fragment Z : [zZ];
// This creates a  that can can contain any amount of letters, numbers
// fragment PText : (A|B|C|D|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z|' ')+;

WS: [ \r\n\t]+ -> skip;
