%{
    #include<iostream>
    #include<vector>
    #include<stack>
    #include<stdio.h>
    #include<string.h>
    #include<stdlib.h>
    #include<string>
    #include<map>

    using namespace std;

    extern FILE * yyin;

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
    struct 

    map<string , string> m;

%}

%union {
    float dval;
    char lexeme[32];
    char type[31];
    struct Snode *snode;
}

%token OCB CCB OSB CSB ASG SCL COM PTR DT ID NUM PLS MIN FSH BSH PCT LOR LAND BOR BAND BXOR EQL NEQL GT LT GTE LTE OB CB QM CL STR BLK MN IF ELS FN OS

%type <type> NUM
%type <lexeme> ID
%type <type> io_statement
%type <type> expression
%type <type> block
%type <type> additive_expression
%type <type> multiplicative_expression
%type <type> assignment_statement
%type <type> selection_statement
%type <type> relational_expression
%type <type> equality_expression
%type <type> identifier
%type <type> function_call
%type <type> FN
%type <type> declaration_statement
%type <type> DT
%type <type> and_expression
%type <type> or_expression

%%

//main function , point where program starts to run
main:                   MN OB CB OCB io_statements CCB;

// io_statement -> IO
io_statements:          statement 
                        | io_statements statement;
// statement -> IO    
statement:              io_statement SCL
                        | selection_statement;

// selection_statement -> expression
selection_statement:    IF OB or_expression CB OCB expression CCB ELS OCB expression CCB{string s1 = $6; string s2 = $10; if(s1 == s2){
                                                                                        strcpy($$,$6);
                                                                                                }
                                                                                    else{
                                                                                        cout<<("Error - type " + s1 + " and type " + s2 + " don't match")<<endl;
                                                                                        exit(0);
                                                                                    }
                                                                    };

// or_expression -> bool
or_expression:          and_expression{strcpy($$,"bool");}
                        | and_expression LOR or_expression{strcpy($$,"bool");};

// and_expression -> bool                        
and_expression:         equality_expression {strcpy($$,"bool");}
                        | equality_expression LAND and_expression{strcpy($$,"bool");};

// equality_expression -> bool
equality_expression:    relational_expression{strcpy($$,"bool");}
                        | relational_expression EQL equality_expression{strcpy($$,"bool");}
                        | relational_expression NEQL equality_expression{strcpy($$,"bool");}
                        | expression EQL expression{strcpy($$,"bool");}
                        | expression NEQL expression{strcpy($$,"bool");};

// relational_expression -> bool
relational_expression:  expression LT expression{string s1 = $1; string s2 = $3; if(s1 == s2){
                                                                                        strcpy($$,"bool");
                                                                                                }
                                                                                    else{
                                                                                        cout<<("Error - type " + s1 + " and type " + s2 + " don't match")<<endl;
                                                                                        exit(0);
                                                                                    }
                                                                    }
                        | expression GT expression{string s1 = $1; string s2 = $3; if(s1 == s2){
                                                                                        strcpy($$,"bool");
                                                                                                }
                                                                                    else{
                                                                                        cout<<("Error - type " + s1 + " and type " + s2 + " don't match")<<endl;
                                                                                        exit(0);
                                                                                    }
                                                                    }
                        | expression LTE expression{string s1 = $1; string s2 = $3; if(s1 == s2){
                                                                                        strcpy($$,"bool");
                                                                                                }
                                                                                    else{
                                                                                        cout<<("Error - type " + s1 + " and type " + s2 + " don't match")<<endl;
                                                                                        exit(0);
                                                                                    }
                                                                    }
                        | expression GTE expression{string s1 = $1; string s2 = $3; if(s1 == s2){
                                                                                        strcpy($$,"bool");
                                                                                                }
                                                                                    else{
                                                                                        cout<<("Error - type " + s1 + " and type " + s2 + " don't match")<<endl;
                                                                                        exit(0);
                                                                                    }
                                                                    };


// io_statement -> IO
io_statement:           assignment_statement{strcpy($$,"io");}
                        | output_statement{strcpy($$,"io");}
                        | block{strcpy($$,"io");}
                        | declaration_statement{strcpy($$,"io");}
                        ;

declaration_statement:  DT ID {string s1 = $1, s2 = $2 ; m[s2] = s1; strcpy($$,"io");} ;

// assignment_statement -> IO
assignment_statement:   ID ASG expression{strcpy($$,"io");};

// output_statement -> IO
output_statement:       OS;

// block -> IO
block:                  BLK OCB io_statements CCB{strcpy($$,"io");};


expression:             function_call{strcpy($$,$1);}
                        | io_statement SCL {strcpy($$,$1);}
                        | selection_statement{strcpy($$,$1);}
                        | additive_expression{strcpy($$,$1);}
                        ;

additive_expression:    multiplicative_expression{strcpy($$,$1);}
                        | additive_expression PLS multiplicative_expression{string s1 = $1; string s2 = $3; if(s1 == s2){
                                                                                                            strcpy($$,$1);
                                                                                                                    }
                                                                                                        else{
                                                                                                            cout<<("Error - type " + s1 + " and type " + s2 + " don't match")<<endl;
                                                                                                            exit(0);
                                                                                                        }
                                                                    }
                        | additive_expression MIN multiplicative_expression{string s1 = $1; string s2 = $3; if(s1 == s2){
                                                                                                            strcpy($$,$1);
                                                                                                                    }
                                                                                                        else{
                                                                                                            cout<<("Error - type " + s1 + " and type " + s2 + " don't match")<<endl;
                                                                                                            exit(0);
                                                                                                        }
                                                                    };

multiplicative_expression:  identifier{strcpy($$,$1);}
                            | multiplicative_expression STR identifier{string s1 = $1; string s2 = $3; if(s1 == s2){
                                                                                                            strcpy($$,$1);
                                                                                                                    }
                                                                                                        else{
                                                                                                            cout<<("Error - type " + s1 + " and type " + s2 + " don't match")<<endl;
                                                                                                            exit(0);
                                                                                                        }
                                                                    }
                            | multiplicative_expression FSH identifier{string s1 = $1; string s2 = $3; if(s1 == s2){
                                                                                                            strcpy($$,$1);
                                                                                                                    }
                                                                                                        else{
                                                                                                            cout<<("Error - type " + s1 + " and type " + s2 + " don't match")<<endl;
                                                                                                            exit(0);
                                                                                                        }
                                                                    }
                            | multiplicative_expression PCT identifier{string s1 = $1; string s2 = $3; if(s1 == s2){
                                                                                                            strcpy($$,$1);
                                                                                                                    }
                                                                                                        else{
                                                                                                            cout<<("Error - type " + s1 + " and type " + s2 + " don't match")<<endl;
                                                                                                            exit(0);
                                                                                                        }
                                                                    };

identifier:             NUM{strcpy($$,$1);}
                        | ID{string inf = $1;if(m.find(inf) == m.end()){cout << "Error - " << inf << " is not declared!" << endl; exit(0);};strcpy($$,m[inf].c_str());};

function_call:          FN;

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
