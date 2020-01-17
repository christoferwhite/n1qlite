// Naming this grammar as 'N1ql'
grammar N1ql;

// Tests
testNumber : pNumber EOF;
testBoolean : pBoolean EOF;
testObject: pObject EOF;

//////// Parser rules ////////

////Functions

// Object Functions
funcObj: (PObjValues|PObjLength|PObjNames|PObjPairs) LPar (pObject) RPar;

// Number Functions

funcNum: (((PAbs|PAcos|PAsin|PAtan|PCeil|PCos|PDeg|Pe|PExp|PLn|PLog|PFloor|PPi|PPower|PRadians|PRandom|DefSign|PSin|PSqrt|PTan) LPar pExp RPar) |
          (PAtanTwo (LPar pExp Comma pExp RPar) |
          (PTrunc|PRound) LPar pExp (Comma Digits)? RPar ) ;


/////// Lower level data 

// Mathamatical expression
pExp: pNumber (POperator pNumber)*;

// Numbers
pNumber : PSign? (Decimal|Scinumber) ;

// Booleans
pBoolean : (True|False);

// Strings
PString : ((SQuote Unicode* SQuote)|(DQuote Unicode* DQuote));

// Adding case insensitive Null characters
pNull : N U L L;

// Objects
pObject :LBrce (pAttribVal (Comma pAttribVal)* )? RBrce;

// Attribute value pairs
pAttribVal : PString Colon pValue;

// Value
pValue :  (PString|pNumber|pObject|pArrays);

// Arrays
pArrays : LBrac (pValue (Comma pValue)*)?;


//////// Lexer rules ////////

//


// Adding support for all unicode characters
Unicode: ('\u0000'..'\uFFFF');

// Adding Boolean true false
True: T R U E;
False: F A L S E;

// Adding Hex numbers
PHexdigit: ('0'..'9'|'a'..'f'|'A'..'F') ;

//// Adding scientifically notated numbers
Scinumber: Decimal E PMinus? Decimal;

//// Adding Decimals 
Decimal: Digits+ (PDot Digits+)?;

// Adding Simple Integers
Digits: [0-9];

// Math Operators
POperator: (PPlus|PMinus|PDivide|PEquals|PMultiply);
PMultiply: '*';
PDivide: '/';
PEquals: '=';
PPlus: '+';
PMinus: '-';
PDot: '.';

// Adding Grouping Characters and misc.
SQuote: '\'';
DQuote: '"';
LPar: '(';
RPar: ')';
LBrac: '[';
RBrac: ']';
LBrce: '{';
RBrce: '}';
Comma: ',';
Colon: ':';

// Keywords 
PAllDef: A L L;
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
DefMinus: M I N U S;
PMissing: M I S S I N G;
PNamespace: N A M E S P A C E;
PNest: N E S T;
PNot: N O T;
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
DefString: S T R I N G;
PSystem: S Y S T E M;
PThen: T H E N;
PTo: T O;
PTransaction: T R A N S A C T I O N;
PTrigger: T R I G G E R;
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

// Object Functions
PObjLength: O B J E C T '_' L E N G T H;
PObjNames: O B J E C T '_' N A M E S;
PObjPairs: O B J E C T '_' P A I R S;
PObjValues: O B J E C T '_' V A L U E S;


// Math Functions
PAbs: A B S;
PAcos: A C O S;
PAsin: A S I N;
PAtan: A T A N;
PAtanTwo: A T A N '2';
PCeil: C E I L;
PCos: C O S;
PDeg: D E G R E E S;
Pe: E;
PExp: E X P;
PLn: L N;
PLog: L O G;
PFloor: F L O O R;
PPi: P I;
PPower: P O W E R;
PRadians: R A D I A N S;
PRandom: R A N D O M;
PRound: R O U N D;
DefSign: S I G N;
PSin: S I N;
PSqrt: S Q R T;
PTan: T A N;
PTrunc: T R U N C; 

// Adding Case Insensitivity if you call the fragments instead of just letters
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
