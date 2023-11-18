grammar FeatherweightJavaScript;


@header { package edu.sjsu.fwjs.parser; }

// Reserved words
IF        : 'if' ;
ELSE      : 'else' ;
WHILE     : 'while' ;
FUNCTION  : 'function' ;
VAR       : 'var' ;
PRINT     : 'print' ;

// Literals
INT       : [1-9][0-9]* | '0' ;
BOOL      : 'true' | 'false' ;
NULL      : 'null' ;

// Symbols
MUL       : '*' ;
DIV       : '/' ;
SEPARATOR : ';' ;
ADD       : '+';
SUB       : '-';
MOD       : '%';
LT        : '<';
GT        : '>';
LE        : '<=';
GE        : '>=';
EQ        : '==';
SET       : '=';
ARGSEP    : ',';


// Identifiers
ID: [a-zA-Z_][a-zA-Z0-9_]*;


// Whitespace and comments
NEWLINE   : '\r'? '\n' -> skip ;
LINE_COMMENT  : '//' ~[\n\r]* -> skip ;
WS            : [ \t]+ -> skip ; // ignore whitespace
BLOCK_COMMENT : '/*' .*? '*/' -> skip; //ignore block


// ***Parsing rules ***

/** The start rule */
prog: stat+ ;

stat: expr SEPARATOR                                    # bareExpr
    | IF '(' expr ')' block ELSE block                  # ifThenElse
    | IF '(' expr ')' block                             # ifThen
    ;

expr: expr op=( '*' | '/' | '%' ) expr                  # MulDivMod
    | expr op = ( '+' | '-') expr						# AddSub
	| expr op = ('<' | '<=' | '>' | '>=' | '==') expr	# compare
	| FUNCTION params '{' stat* '}'						# functionDecl
	| expr args											# functionAppl
	| INT												# int
	| VAR ID (op = '=' expr)?							# varDecl
	| ID												# varRef
	| ID op = '=' expr									# assign
	| (INT | BOOL | NULL)								# constant
	| '(' expr ')'										# parens
    ;


block: '{' stat* '}'                                    # fullBlock
     | stat                                             # simpBlock
     ;

args: '(' (expr (',' expr)*)? ')' # arguments;

params: '(' (ID (',' ID)*)? ')' # parameters;