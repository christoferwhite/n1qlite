grammar N1ql;

n1ql : number;

number: NUMBER;

NUMBER	: [0-9]+;

/* It will ignore all white space characters */
WHITESPACE  :(' ' | '\t' | '\r'| '\n' );

