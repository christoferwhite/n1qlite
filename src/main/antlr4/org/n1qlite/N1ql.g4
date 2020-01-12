// Naming this grammar as 'N1ql'
grammar N1ql;

//   JDW:  Doesn't work yet Test versions require EOF
testNumber : pNumber EOF;
testBoolean : pBoolean EOF;

//////// Parser rules ////////

// Numbers
pNumber : Negative? (Decimal|Scinumber) ;
////   JDW:  I added Negative? to the front to allow for negative numbers

pBoolean : (PTrue|PFalse);

// Strings
// pString : (('"' Unicode* '"')|('""' Unicode* '""'));

// Adding case insensitive Null characters
pNull : PNull;

// Objects
pObject :'{' (pAttribVal (',' pAttribVal)* )? '}';

// Attribute value pairs
pAttribVal : pString ':' pValue;

// Value
pValue :  (pString|pNumber|pObject|pArrays);

// Arrays
pArrays : '[' (pValue (',' pValue)*)? ']';

//////// Lexer rules ////////

// Adding support for all unicode characters
Unicode : ('\u0000'..'\uFFFF');

// Adding Boolean true false

// Adding Hex numbers
Hexdigit : ('0'..'9'|'a'..'f'|'A'..'F') ;

//// Adding scientifically notated numbers
Scinumber : Decimal E Negative? Decimal;

//// Adding Decimals
Decimal : [0-9]+ (PPoint [0-9]+)?;

//// Adding Signed notation
PMinus : '-';

PComma: ',';

PPoint: '.';

// Lexer Keywords
PAll: A L L;
PAlter: A L T E R;
PAnalyze: A N A L Y Z E;
PAnd: A N D;
PAny: A N Y;
PArray: A R R A Y;
PAs: A S;
PAsc: A S C;
PBegin: B E G I N;
PBetween: B E T W E E N;
PBinary: B I N A R Y;
PBreak: B R E A K;
PBucket: B U C K E T;
PBuild: B U I L D;
PBy: B Y;
PCall: C A L L;
PCase: C A S E;
PCast: C A S T;
PCluster: C L U S T E R;
PCollate: C O L L A T E;
PCollection: C O L L E C T I O N;
PCommit: C O M M I T;
PConnect: C O N N E C T;
PContinue: C O N T I N U E;
PCorrelate: C O R R E L A T E;
PCover: C O V E R;
PCreate: C R E A T E;
PDatabase: D A T A B A S E;
PDataset: D A T A S E T;
PDatastore: D A T A S T O R E;
PDeclare: D E C L A R E;
PDecrement: D E C R E M E N T;
PDelete: D E L E T E;
PDerived: D E R I V E D;
PDesc: D E S C;
PDescribe: D E S C R I B E;
PDistinct: D I S T I N C T;
PDo: D O;
PDrop: D R O P;
PEach: E A C H;
PElement: E L E M E N T;
PElse: E L S E;
PEnd: E N D;
PEvery: E V E R Y;
PExcept: E X C E P T;
PExclude: E X C L U D E;
PExecute: E X E C U T E;
PExists: E X I S T S;
PExplain: E X P L A I N;
PFalse: F A L S E;
False : F A L S E;
PFetch: F E T C H;
PFirst: F I R S T;
PFlatten: F L A T T E N;
PFor: F O R;
PForce: F O R C E;
PFrom: F R O M;
PFunction: F U N C T I O N;
PGrant: G R A N T;
PGroup: G R O U P;
PGsi: G S I;
PHaving: H A V I N G;
PIf: I F;
PIgnore: I G N O R E;
PIlike: I L I K E;
PIn: I N;
PInclude: I N C L U D E;
PIncrement: I N C R E M E N T;
PIndex: I N D E X;
PInfer: I N F E R;
PInline: I N L I N E;
PInner: I N N E R;
PInsert: I N S E R T;
PIntersect: I N T E R S E C T;
PInto: I N T O;
PIs: I S;
PJoin: J O I N;
PKey: K E Y;
PKeys: K E Y S;
PKeyspace: K E Y S P A C E;
PKnown: K N O W N;
PLast: L A S T;
PLeft: L E F T;
PLet: L E T;
PLetting: L E T T I N G;
PLike: L I K E;
PLimit: L I M I T;
PLsm: L S M;
PMap: M A P;
PMapping: M A P P I N G;
PMatched: M A T C H E D;
PMaterialized: M A T E R I A L I Z E D;
PMerge: M E R G E;
PMinus: M I N U S;
PMissing: M I S S I N G;
PNamespace: N A M E S P A C E;
PNest: N E S T;
PNot: N O T;
PNull: N U L L;
PNumber: N U M B E R;
PObject: O B J E C T;
POffset: O F F S E T;
POn: O N;
POption: O P T I O N;
POr: O R;
POrder: O R D E R;
POuter: O U T E R;
POver: O V E R;
PParse: P A R S E;
PPartition: P A R T I T I O N;
PPassword: P A S S W O R D;
PPath: P A T H;
PPool: P O O L;
PPrepare: P R E P A R E;
PPrimary: P R I M A R Y;
PPrivate: P R I V A T E;
PPrivlege: P R I V I L E G E;
PProduce: P R O C E D U R E;
PPublic: P U B L I C;
PRaw: R A W;
PRealm: R E A L M;
PReduce: R E D U C E;
PRename: R E N A M E;
PReturn: R E T U R N;
PReturning: R E T U R N I N G;
PRevoke: R E V O K E;
PRight: R I G H T;
PRole: R O L E;
PRollback: R O L L B A C K;
PSatisfies: S A T I S F I E S;
PSchema: S C H E M A;
PSelect: S E L E C T;
PSelf: S E L F;
PSemi: S E M I;
PSet: S E T;
PShow: S H O W;
PSome: S O M E;
PStart: S T A R T;
PStaristics: S T A T I S T I C S;
PString: S T R I N G;
PSystem: S Y S T E M;
PThen: T H E N;
PTo: T O;
PTransaction: T R A N S A C T I O N;
PTrigger: T R I G G E R;
PTrue : T R U E;
PTruncate: T R U N C A T E;
PUnder: U N D E R;
PUnion: U N I O N;
PUnique: U N I Q U E;
PUnknown: U N K N O W N;
PUnnest: U N N E S T;
PUnset: U N S E T;
PUpdate: U P D A T E;
pUpsert: U P S E R T;
PUse: U S E;
PUser: U S E R;
PUsing: U S I N G;
PValidate: V A L I D A T E;
PValue: V A L U E;
PValued: V A L U E D;
PValues: V A L U E S;
PVia: V I A;
PView: V I E W;
PWhen: W H E N;
PWhere: W H E R E;
PWhile: W H I L E;
PWith: W I T H;
PWithin: W I T H I N;
PWork: W O R K;
PXor: X O R;


/* Adding Case Insensitivity if you call the fragments instead of just letters
for example: 'This Is Case Sensitive' T H I S  I S  C A S E  I N S E N S I T I V E */
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

WS: [ \r\n\t]+ -> skip;
