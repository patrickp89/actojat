// This context-free grammar describes a subset of GCC's C syntax.
grammar c_grammar;


// The grammar's start symbol:
program             //: statements
                    : functionlist
                    | imports functionlist
//                  | imports globalvariables functionlist
                    ;

// ################ The set of variables ################
imports             : importheader+
                    ;

functionlist        : functiondeclr+
                    ;

importheader        : INCLUDEKWRD LESSER FILEID GREATER
                    | INCLUDEKWRD QUOTATIONMARK FILEID QUOTATIONMARK
                    ;

//TODO: recognize non-primitive and n-dimensional types!
functiondeclr       : primitivetype ID OPENINGPARENTHESIS parameterlist CLOSINGPARENTHESIS block
//                  | NDIMTYPE ID OPENINGPARENTHESIS parameterlist CLOSINGPARENTHESIS block
                    ;

primitivetype       : (INT | VOID) // TODO: add the others!
                    ;

parameterlist       : (primitivetype ID)*
                    | VOID
                    ;

block               : OPENINGCURLYBRACKET statementlist CLOSINGCURLYBRACKET
                    ;

statementlist       : statement*
                    ;

statement           : assignment SEMICOLON
                    | functioncall SEMICOLON
                    | returnstatement SEMICOLON
                    | ifthenelse
                    | forloop
                    ;

assignment          : lhs ASSIGNMENTOP rhs
                    ;

functioncall        : ID OPENINGPARENTHESIS argumentlist CLOSINGPARENTHESIS
                    | ID OPENINGPARENTHESIS CLOSINGPARENTHESIS
                    ;

returnstatement     : RETURN rhs
                    | RETURN
                    ;

ifthenelse          : IF OPENINGPARENTHESIS condition CLOSINGPARENTHESIS block elseblock
                    | IF OPENINGPARENTHESIS condition CLOSINGPARENTHESIS block
                    ;

elseblock           : ELSE block
                    ;

forloop             : FOR OPENINGPARENTHESIS assignment SEMICOLON condition SEMICOLON incrementstatement CLOSINGPARENTHESIS block
                    | FOR OPENINGPARENTHESIS rhs SEMICOLON condition SEMICOLON incrementstatement CLOSINGPARENTHESIS block
                    ;

condition           : expression comparisonoperator expression
                    ;

incrementstatement  : ID '++'
                    | ID '--'
                    ;

argumentlist        : argument (COMMA argument)+
                    | argument
                    ;

argument            : STRING //e.g. bla("Hello World");
//                  | ID //e.g. blubb(tigerente);
                    ;

lhs                 : variabledecl
                    | ID
                    ;

//TODO: multiple/composite and nested expressions:
rhs                 : expression
                    ;

expression          : OPENINGPARENTHESIS expression operand expression CLOSINGPARENTHESIS
                    | expression operand expression
                    | (NUMBER | ID) // TODO: composite expressions, function calls, etc.!
                    ;

variabledecl        : primitivetype ID // TODO: allow all possible types...
                    ;

operand             : PLUSSIGN
                    | MINUSSIGN
                    | ASTERISK
                    | SLASH
                    ;

comparisonoperator  : LESSEROREQUAL
                    | GREATEROREQUAL
                    | EQUAL
                    | LESSER
                    | GREATER
                    ;


// ################ The set of terminals ################

INCLUDEKWRD         : '#include'
                    ;

RETURN              : 'return'
                    ;

ELSE                : 'ELSE'
                    ;

VOID                : 'void'
                    ;

INT                 : 'int'
                    ;

FOR                 : 'for'
                    ;

IF                  : 'if'
                    ;


EQUAL               : '=='
                    ;

LESSEROREQUAL       : '<='
                    ;

GREATEROREQUAL      : '=>'
                    ;

DOT                 : '.'
                    ;

COMMA               : ','
                    ;

QUOTATIONMARK       : '"'
                    ;

SINGLEQUOTE         : '\''
                    ;

LESSER              : '<'
                    ;

GREATER             : '>'
                    ;

OPENINGPARENTHESIS  : '('
                    ;

CLOSINGPARENTHESIS  : ')'
                    ;

OPENINGBRACKET      : '['
                    ;

CLOSINGBRACKET      : ']'
                    ;

OPENINGCURLYBRACKET : '{'
                    ;

CLOSINGCURLYBRACKET : '}'
                    ;

ASSIGNMENTOP        : '='
                    ;

SEMICOLON           : ';'
                    ;

MINUSSIGN           : '-'
                    ;

PLUSSIGN            : '+'
                    ;

ASTERISK            : '*'
                    ;

SLASH               : '/'
                    ;

// identifiers are matched last:
FILEID              : (ALLCHARS | DIGIT)+ DOT CHARACTER+
                    ;

STRING              : QUOTATIONMARK (CHARACTER | DIGIT | WHITESPACE)+ QUOTATIONMARK
                    ;

NUMBER              : DIGIT+
                    ;

ID                  : CHARACTER+
                    ;

// auxiliary terminals:

WHITESPACE          : [ \t]+ -> channel(HIDDEN)
                    ;

LINEBREAK           : [\r\n]+ -> skip
                    ;


// fragments, which are part of the grammar but NOT actual terminals:
fragment DIGIT      : [0-9]
                    ;

fragment CHARACTER  : [a-zA-Z]
                    ;

fragment ALLCHARS   : ([a-zA-Z] | '-' | '/' | '_' )
                    ;
