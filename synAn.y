%{
    #include<iostream>
    #include<vector>
    #include<stack>
    #include<stdio.h>
    #include<string.h>
    #include<stdlib.h>

    using namespace std;

    extern FILE * yyin;

    char gb_type[31];
    int isError = 0;

    int yylex();    
    int yyerror(char* s);
    struct Snode{
        char type[31];
        int address;
        char lexval[32];
        float dval;
        int size;
        int isDval;
        int isArray;
    };

    int temp_var_count = 0;

    vector<vector<struct Snode> > SymTable;
    stack<vector<struct Snode> > Stack;

%}

%union {
    float dval;
    char lexeme[32];
    char type[31];
    struct Snode *snode;
}

%token OCB CCB OSB CSB ASG SCL COM PTR DT ID NUM PLS MIN FSH BSH PCT LOR LAND BOR BAND BXOR EQL NEQL GL LT GTE LTE OB CB QM CL STR

%type <dval> NUM
%type <lexeme> ID 
%type <type> DT
%type <snode> C
%type <snode> D
%type <snode> E
%type <snode> F
%type <snode> G
%type <lexeme> H
%type <snode> I
%type <dval> J
%type <lexeme> K
%type <lexeme> L
%type <lexeme> M
%type <lexeme> N

%%

//main function , point where program starts to run
main:                   MN OB CB OCB compound_statement CCB;

// io_statement -> IO
io_statements:          statement 
                        | io_statements statement;
// statement -> IO    
statement:              io_statement
                        | selection_statement;

// selection_statement -> expression
selection_statement:    IF OB or_expression CB OCB expression CCB ELS OCB expression CCB;

// or_expression -> bool
or_expression:          and_expression
                        | and_expression LOR or_expression;

// and_expression -> bool                        
and_expression:         equality_expression 
                        | equality_expression LAND and_expression;

// equality_expression -> bool
equality_expression:    relational_expression
                        | relational_expression EQL equality_expression
                        | relational_expression NEQL equality_expression
                        | expression EQL expression
                        | expression NEQL expression;

// relational_expression -> bool
relational_expression:  expression LT expression
                        | expression GT expression
                        | expression LTE expression
                        | expression GTE expression
                        | relational_expression LT expression
                        | relational_expression GT expression
                        | relational_expression LTE expression
                        | relational_expression GTE expression;


// io_statement -> IO
io_statement:           assignment_statement
                        | output_statement
                        | block;

// assignment_statement -> IO
assignment_statement:   ID ASG expression;

// output_statement -> IO
output_statement:       ;

// block -> IO
block:                  BLK OCB io_statements CCB;


expression:             function_call
                        | io_statement
                        | selection_statement
                        ! additive_expression
                        ;

additive_expression:    multiplicative_expression
                        | additive_expression PLS multiplicative_expression
                        | additive_expression MIN multiplicative_expression;

multiplicative_expression:  identifier
                            | multiplicative_expression * identifier
                            | multiplicative_expression / identifier
                            | multiplicative_expression % identifier;

identifier:             NUM
                        | ID;

%%

int main(int argc, char** argv)
{
   
    yyin = fopen(argv[1], "r");
    yyparse();
}

int yyerror(char *s){
    printf("Error: %s\n", s);
    isError = 1;
}
