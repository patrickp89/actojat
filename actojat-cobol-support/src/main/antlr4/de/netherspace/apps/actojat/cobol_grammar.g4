// This context-free grammar describes a subset of the COBOL85 syntax.
grammar cobol_grammar;


// The grammar's start symbol:
program                 : identificationdivision environmentdivision? datadivision? proceduredivision?
                        ;



// ################ The set of variables ################

// "IDENTIFICATION DIVISION."
identificationdivision  : IDENTIFICATION DIVISION DOT identstatements*
                        ;

identstatements         : programidstatement
                        | authorstatement
                        | datewrittenstatement
                        ;

programidstatement      : PROGRAMID DOT ID DOT
                        ;

authorstatement         : AUTHOR DOT ID DOT // TODO: "ID" should rather be (word COMMA*)+ or something similar!
                        ;

datewrittenstatement    : DATEWRITTEN DOT ID DOT
                        ;


// "ENVIRONMENT DIVISION."
environmentdivision     : ENVIRONMENT DIVISION DOT configurationsection inputoutputsection
                        | ENVIRONMENT DIVISION DOT inputoutputsection configurationsection
                        | ENVIRONMENT DIVISION DOT configurationsection
                        | ENVIRONMENT DIVISION DOT inputoutputsection
                        | ENVIRONMENT DIVISION DOT
                        ;

configurationsection    : CONFIGURATION SECTION DOT specialnamesparagraph
                        | CONFIGURATION SECTION DOT
                        ;

inputoutputsection      : FILECONTROL filecontrolparagraph
                        ;

specialnamesparagraph   : SPECIALNAMES decimalpointspec
                        | SPECIALNAMES symboliccharsspec
                        | SPECIALNAMES DOT
                        ;

decimalpointspec        : DECIMALPOINT IS ID DOT
                        ;

symboliccharsspec       : SYMBOLIC CHARACTERS ID* DOT
                        ;

filecontrolparagraph    : 'SELECT' PLACEHOLDER
                        ; // TODO: fix this rule! Should be: SELECT (ID ASSIGN TO ID)+ or something similar!


// "DATA DIVISION."
datadivision            : DATA DIVISION DOT (filesection | workingstoragesection | linkagesection | reportsection)+
                        | DATA DIVISION DOT
                        ; // TODO: the above rule is not the right one!

filesection             : FILE SECTION DOT
                        // TODO: "FD ..."
                        // TODO: "COPY ..."
                        ;

workingstoragesection   //: WORKINGSTORAGE SECTION DOT (datadecl | importcopyfile)+
                        : WORKINGSTORAGE SECTION DOT (importcopyfile)+
                        | WORKINGSTORAGE SECTION DOT (datadeclaration)+ // TODO: data decl. AND imports possible!
                        | WORKINGSTORAGE SECTION DOT
                        ; // TODO: fix the (A|B)+ rule!

linkagesection          : LINKAGE SECTION DOT
                        // TODO: ...
                        ;

reportsection           : REPORT SECTION DOT
                        // TODO: ...
                        ;

importcopyfile          : COPY QUOTATIONMARK FILEID QUOTATIONMARK DOT
                        ;

// TODO: are tailing imports parts of the COBOL85 standard or a MF COBOL gimmick?
tailingimports          : importcopyfile+
                        ;

datadeclaration         : datahierarchylevel ID datatype
                        ;

datahierarchylevel      : NUMBER
                        ;

// the type is given either explicitly (e.g. "PIC 999") or implicitly (e.g. "PIC 9(3)"):
datatype                : (PIC | PICTURE) picturetype size? VALUE initialvalue DOT
                        | (PIC | PICTURE) picturetype size? DOT
                        ;

picturetype             : '9'+
                        // TODO: | '1'+
                        // TODO: | 'A'+
                        // TODO: | 'N'+
                        // TODO: | 'Z'+
                        | 'X'+
                        // TODO: | '*'+
                        ;

size                    : OPENINGPARENTHESIS NUMBER CLOSINGPARENTHESIS
                        ;

initialvalue            : NUMBER
                        | STRINGVALUE
                        ;

// "PROCEDURE DIVISION."
proceduredivision       : PROCEDURE DIVISION USING ID DOT (paragraph | section)+
                        | PROCEDURE DIVISION DOT (paragraph | section)+
                        ;

section                 : sectiondecl paragraph+
                        ;

paragraph               : ID DOT sentence+  // TODO: can both statements and sentences appear in one block?
                        ;

sentence                : statements DOT
                        ;

// TODO: This is the only rule where comment(s) are made explicit. Adding a 'comment*' symbol might not
// TODO: be very vital! See the blabla down below (where the terminal symbol is defined)!
statements              : (comment* statement)+
                        ;

comment                 : inlineComment
                        // TODO: These comments can only occur at the very beginning of a line:
                        // TODO: '*' .*
                        // TODO: '/' .*
                        // TODO: ...and they can only be used with the "fixed" format!
                        | COMMENT // TODO: ensure that it starts at the beginning of a line??
                        ;

inlineComment           : INLINECOMMENT
                        ;

sectionend              : SECTIONNAME DOT EXIT PROGRAM DOT
                        | SECTIONNAME DOT EXIT DOT
                        ;

sectiondecl             : SECTIONNAME SECTION
                        ;

statement               : performtimes
                        | performuntil
                        | performvarying
                        | performsinglefunction
                        | displayvalue
                        | assignment
                        | stopoperation
                        | ifthenelse
                        //: operation operand+ // TODO: erase? not needed?
                        ;

performtimes            : PERFORM counter TIMES statementsorsentences ENDPERFORM
                        | PERFORM blockname counter TIMES
                        ;

blockname               : ID
                        ;

counter                 : ID
                        | NUMBER
                        ;

performuntil            : PERFORM blockname throughblockname? WITH TEST BEFORE UNTIL condition
                        | PERFORM blockname throughblockname? WITH TEST AFTER UNTIL condition
                        | PERFORM blockname throughblockname? UNTIL condition
                        | PERFORM WITH TEST BEFORE UNTIL condition statementsorsentences ENDPERFORM
                        | PERFORM WITH TEST AFTER UNTIL condition statementsorsentences ENDPERFORM
                        | PERFORM UNTIL condition statementsorsentences ENDPERFORM
                        ;

throughblockname        : (THRU | THROUGH) blockname
                        ;

performvarying          : PERFORM blockname throughblockname? VARYING counter fromx byz UNTIL condition
                        // TODO: add the other PERFORM_UNTIL combinations as well (see above)!
                        ;

fromx                   : FROM NUMBER
                        // TODO: | FROM ID
                        ;

byz                     : BY NUMBER
                        // TODO: can the step width be a variable value as well? if so: | BY ID
                        ;

performsinglefunction   : PERFORM ID
                        ;

stopoperation           : STOP RUN
                        ;

displayvalue            : DISPLAY STRINGVALUE+
                        ;

assignment              : MOVE sourceItem TO destItem
                        // TODO: move to multiple variables
                        ;

sourceItem              : STRINGVALUE
                        | NUMBER
                        | ID
                        ;

destItem                : ID
                        ;

ifthenelse              : IF condition thenblock elseblock ENDIF
                        | IF condition thenblock ENDIF
                        ;

thenblock               : THEN statementsorsentences
                        ;

elseblock               : ELSE statementsorsentences
                        ;

statementsorsentences   : (statements | sentence+) // TODO: can both statements and sentences appear in one block?
                        ;

condition               : relationcondition
                        // TODO: | classcondition
                        // TODO: | signcondition
                        ;

relationcondition       : compval IS* comparisonoperator compval
                        ;

compval                 : arithmeticexpression
                        | NUMBER
                        | ID
                        ;

arithmeticexpression    : OPENINGPARENTHESIS compval arithmeticoperator compval CLOSINGPARENTHESIS
                        // TODO:| compval arithmeticoperator compval
                        // README:
                        // TODO: this rules is not corecct:
                        // TODO: a) right now, no expressions (apart from mere numbers and IDs) are allowed
                        // TODO:    on the left hand side. This is due to a left-recursion problem and will
                        // TODO:    probably require some non-trivial tweeking of the grammer (i.e. the
                        // TODO:    condition rules specificly)
                        // TODO: b) the way paranthesis are handled is faulty: right now, one can only place
                        // TODO:    exactly one opening- and closing paranthesis or none at all. But paranthesis
                        // TODO:    should be handled more (((felxibble))) !
                        ;

arithmeticoperator      : <assoc=right>POWERSYMBOL // 2^3^4=2^81
                        | MULTIPLYSYMBOL
                        | DIVIDESYMBOL
                        | ADDSYMBOL
                        | SUBTRACTSYMBOL
                        ;

// there's only a finite set of possible combinations of conditional keywords and literals:
comparisonoperator      : greaterthanorequalto
                        | lessthanorequalto
                        | notgreaterthan
                        | notlessthan
                        | notequalto
                        | greaterthan
                        | lessthan
                        | equalto
                        | notlessersign
                        | notgreatersign
                        | notequalsign
                        | LESSEROREQUALSIGN
                        | GREATEROREQUALSIGN
                        | LESSERSIGN
                        | GREATERSIGN
                        | EQUALSIGN
                        ;

greaterthanorequalto    : GREATER THAN OR EQUAL TO
                        ;

lessthanorequalto       : LESS THAN OR EQUAL TO
                        ;

notgreaterthan          : NOT GREATER THAN
                        ;

notlessthan             : NOT LESS THAN
                        ;

notequalto              : NOT EQUAL TO
                        ;

greaterthan             : GREATER THAN
                        ;

lessthan                : LESS THAN
                        ;

equalto                 : EQUAL TO
                        ;

notlessersign           : NOT LESSERSIGN
                        ;

notgreatersign          : NOT GREATERSIGN
                        ;

notequalsign            : NOT EQUALSIGN
                        ;

// TODO: is the generic "operation operand+" rule (see above!) unnecessary?
operation               : SUBTRACT
                        | DISPLAY
                        | PERFORM
                        | COMPUTE
                        | MOVE
                        | STOP
                        ;

operand                 : TIMES
                        | UNTIL
                        | RUN
                        | STRINGVALUE
                        | ID
                        ;


// ################ The set of terminals ################

WORKINGSTORAGE          : 'WORKING-STORAGE'
                        ;

IDENTIFICATION          : 'IDENTIFICATION'
                        ;

CONFIGURATION           : 'CONFIGURATION'
                        ;

STARTSECT               : 'START-SECTION'
                        ;

DECIMALPOINT            : 'DECIMAL-POINT'
                        ;

SPECIALNAMES            : 'SPECIAL-NAMES'
                        ;

FILECONTROL             : 'FILE-CONTROL'
                        ;

DATEWRITTEN             : 'DATE-WRITTEN'
                        ;

ENVIRONMENT             : 'ENVIRONMENT'
                        ;

ENDPERFORM              : 'END-PERFORM'
                        ;

PROGRAMID               : 'PROGRAM-ID'
                        ;

CHARACTERS              : 'CHARACTERS'
                        ;

PROCEDURE               : 'PROCEDURE'
                        ;

SUBTRACT                : 'SUBTRACT'
                        ;

DIVISION                : 'DIVISION'
                        ;

SYMBOLIC                : 'SYMBOLIC'
                        ;

SECTION                 : 'SECTION'
                        ;

LINKAGE                 : 'LINKAGE'
                        ;

PROGRAM                 : 'PROGRAM'
                        ;

GREATER                 : 'GREATER'
                        ;

DISPLAY                 : 'DISPLAY'
                        ;

PERFORM                 : 'PERFORM'
                        ;

COMPUTE                 : 'COMPUTE'
                        ;

VARYING                 : 'VARYING'
                        ;

PICTURE                 : 'PICTURE'
                        ;

THROUGH                 : 'THROUGH'
                        ;

ENDIF                   : 'END-IF'
                        ;

AUTHOR                  : 'AUTHOR'
                        ;

BEFORE                  : 'BEFORE'
                        ;

REPORT                  : 'REPORT'
                        ;

USING                   : 'USING'
                        ;

UNTIL                   : 'UNTIL'
                        ;

VALUE                   : 'VALUE'
                        ;

TIMES                   : 'TIMES'
                        ;

AFTER                   : 'AFTER'
                        ;

EQUAL                   : 'EQUAL'
                        ;

LESS                    : 'LESS'
                        ;

THRU                    : 'THRU'
                        ;

THAN                    : 'THAN'
                        ;

EXIT                    : 'EXIT'
                        ;

WITH                    : 'WITH'
                        ;

DATA                    : 'DATA'
                        ;

STOP                    : 'STOP'
                        ;

ELSE                    : 'ELSE'
                        ;

FILE                    : 'FILE'
                        ;

TEST                    : 'TEST'
                        ;

THEN                    : 'THEN'
                        ;

FROM                    : 'FROM'
                        ;

COPY                    : 'copy ' // TODO: set this (lowercase == uppercase) in the parser implementation itself!
                        | 'COPY '
                        ;

MOVE                    : 'MOVE'
                        ;

PIC                     : 'PIC'
                        ;

NOT                     : 'NOT'
                        ;

RUN                     : 'RUN'
                        ;

BY                      : 'BY'
                        ;

IF                      : 'IF'
                        ;

IS                      : 'IS'
                        ;

OR                      : 'OR'
                        ;

TO                      : 'TO'
                        ;

STRINGVALUE             : QUOTATIONMARK (ALLCHARS | DIGIT | [ \t])+ QUOTATIONMARK
                        ;

LESSEROREQUALSIGN       : '<='
                        ;

GREATEROREQUALSIGN      : '>='
                        ;

POWERSYMBOL             : '**'
                        ;

// TODO: Throwing all comments away is a suitable approach for a compiler that
// TODO: generates byte code only. In our case, the transpiler should rather _keep_
// TODO: comments, as they are valuable pieces of information for any code base!
// TODO: We could add a  "commment*" or "comment?" symbol to all rules and attach the
// TODO: comments to our IR objects. But:
// TODO: a) this is super tedious and significantly increaes the size of our grammar, and
// TODO: b) would not work if someone placed a comment between keywords
// TODO: (e.g. 'ENVIRONMENT\n* blabla\n DIVISION.')
// TODO: Is there a smart way??
SLASHCOMMENT            : '/*' (~[\r\n])* -> channel(HIDDEN)
                        ; // a comment can NOT span more than a single line!

INLINECOMMENT           : '*>' (~[\r\n])* -> channel(HIDDEN)
                        ; // a comment can NOT span more than a single line!

COMMENT                 : '*' (~[\r\n])* -> channel(HIDDEN)
                        ; // a comment can NOT span more than a single line!

OPENINGPARENTHESIS      : '('
                        ;

CLOSINGPARENTHESIS      : ')'
                        ;

EQUALSIGN               : '='
                        ;

DOT                     : '.'
                        ;

QUOTATIONMARK           : '"'
                        ;

LESSERSIGN              : '<'
                        ;

GREATERSIGN             : '>'
                        ;

MULTIPLYSYMBOL          : '*'
                        ;

DIVIDESYMBOL            : '/'
                        ;

ADDSYMBOL               : '+'
                        ;

SUBTRACTSYMBOL          : '-'
                        ;

// identifiers are matched last:
SECTIONNAME             : DIGIT+ ('-' (CHARACTER+))+
                        ;

FILEID                  : (ALLCHARS | DIGIT)+ DOT CHARACTER+
                        ;

NUMBER                  : DIGIT+
                        ;

ID                      : ALLCHARS+
                        ;

// auxiliary terminals:
PLACEHOLDER             : CHARACTER* ; // TODO: erase!!!

WHITESPACE              : [ \t]+ -> channel(HIDDEN)
                        ;

LINEBREAK               : [\r\n]+ -> skip
                        ;


// fragments, which are part of the grammar but NOT actual terminals:
fragment DIGIT          : [0-9]
                        ;

fragment CHARACTER      : [a-zA-Z]
                        ;

fragment ALLCHARS       : ([a-zA-Z] | '-' | '/' | '_' | '!')
                        ;
