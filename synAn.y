%{
    #include"include.h"

    using namespace std;

    extern FILE * yyin;

    int yylex();    
    int yyerror(char* s);
    

%}

%union {
    char dval[32];
    char lexeme[32];
    char type[31];
    struct Snode *snode;
    unsigned long long int id;
}

%token OCB CCB OSB CSB ASG SCL COM PTR DT ID NUM PLS MIN FSH BSH PCT LOR LAND BOR BAND BXOR EQL NEQL GT LT GTE LTE OB CB QM CL STR BLK MN IF ELS FN OS

%type <dval> NUM
%type <lexeme> ID
%type <id> io_statement
%type <id> io_statements
%type <id> statement
%type <id> expression
%type <id> block
%type <id> additive_expression
%type <id> multiplicative_expression
%type <id> assignment_statement
%type <id> selection_statement
%type <id> relational_expression
%type <id> equality_expression
%type <id> identifier
%type <id> function_call
%type <id> declaration_statement
%type <type> DT
%type <id> and_expression
%type <id> or_expression

%%

upper_chunk:            function_declaration function_defination upper_chunk
			            |
                        ;

function_declartion:    DT ID OB pram_list CB SCL {$$ = $1 ; string temp = $1 ;get<4>(node[$$]).ret = temp; string temp2 = $2; if(name2id.find(temp2) == name2id.end()){
                                                                                                                                                                                get<3>(node[$$]) = temp2;  
                                                                                                                                                                        }
                                                                                                                               else{
                                                                                                                                   cout <<"Error- name already used!!"<< endl;
                                                                                                                                   exit(0);
                                                                                                                               }                                        
                                                                                                                                                                        };

function_defination:    ID OB param_def CB OCB {vector<unsigned long long> v = get<4>(node[$3]).vars; scope.push(v);} expression {scope.pop();} CCB {string temp = $1; if(name2id.find(temp) == name2id.end())
                                                                                        {
                                                                                            cout <<"Error- function " << temp << " not declared!!" << endl;
                                                                                            exit(0);
                                                                                        }
                                                                                      else
                                                                                      {
                                                                                          if((get<4>(node[name2id[temp]]).params).size() != (get<4>(node[$3]).vars).size())
                                                                                          {
                                                                                              cout << "Error - worng number of arguments" << endl;
                                                                                          }
                                                                                          else
                                                                                          {
                                                                                              ;//code generation;
                                                                                          }
                                                                                      }
                                                                                        };

pram_list:             pram_lists {$$ = $1;}
                        | {$$ = global_id++;push_tuple();}
                        ;

pram_lists:             DT COM pram_lists {$$ = $3 ; string temp = $1 ;(get<4>(node[$$]).params).push_back(temp);}
                        | DT {$$ = global_id++;push_tuple(); string temp = $1 ;(get<4>(node[$$]).params).push_back(temp);}
                        ;

param_def:              param_defs {$$ = $1;}
                        | {$$ = global_id++;push_tuple();}
                        ;

param_defs:             ID COM param_defs {$$ = $3 ; string temp = $1 ;(get<4>(node[$$]).params).push_back(temp);}
                        |  {$$ = global_id++;push_tuple(); string temp = $1 ;(get<4>(node[$$]).params).push_back(temp);}
                        ;

//main function , point where program starts to run
main:                   MN OB CB OCB {local l; scope.push(l);}io_statements {scope.pop();}CCB;

// io_statement -> IO
io_statements:          statement
                        | io_statements statement;
// statement -> IO    
statement:              io_statement SCL{$$ = scope.top().local_id++;push_tuple();get<0>(node[$$])="io";}
                        | selection_statement{$$ = scope.top().local_id++;push_tuple();get<0>(node[$$])="io";check_type($1,$$,f1);};

// selection_statement -> expression
selection_statement:    IF OB or_expression CB OCB or_expression CCB ELS OCB or_expression CCB{$$ = scope.top().local_id++;push_tuple();check_type($10,$6,f1);get<0>(node[$$])=get<0>(node[$6]);};

// or_expression -> bool
or_expression:          and_expression{$$ = scope.top().local_id++;push_tuple();get<0>(node[$$])=get<0>(node[$1]);}
                        | and_expression LOR or_expression{$$ = scope.top().local_id++;push_tuple();check_type($1,$3,f1);get<0>(node[$$])=get<0>(node[$1]);};

// and_expression -> bool                        
and_expression:         equality_expression {$$ = scope.top().local_id++;push_tuple();get<0>(node[$$])=get<0>(node[$1]);}
                        | equality_expression LAND and_expression{$$ = scope.top().local_id++;push_tuple();check_type($1,$3,f1);get<0>(node[$$])=get<0>(node[$1]);};

// equality_expression -> bool
equality_expression:    relational_expression{$$ = scope.top().local_id++;push_tuple();get<0>(node[$$])=get<0>(node[$1]);}
                        | relational_expression EQL equality_expression{$$ = scope.top().local_id++;push_tuple();check_type($1,$3,f1);get<0>(node[$$])=get<0>(node[$1]);}
                        | relational_expression NEQL equality_expression{$$ = scope.top().local_id++;push_tuple();check_type($1,$3,f1);get<0>(node[$$])=get<0>(node[$1]);}
                        | expression EQL expression{$$ = scope.top().local_id++;push_tuple();check_type($1,$3,f1);get<0>(node[$$])=get<0>(node[$1]);}
                        | expression NEQL expression{$$ = scope.top().local_id++;push_tuple();check_type($1,$3,f1);get<0>(node[$$])=get<0>(node[$1]);};

// relational_expression -> bool
relational_expression:  expression{$$ = scope.top().local_id++;push_tuple();get<0>(node[$$])=get<0>(node[$1]);}
                        | expression LT expression{$$ = scope.top().local_id++;push_tuple();check_type($1,$3,f1);get<0>(node[$$])=get<0>(node[$1]);}
                        | expression GT expression{$$ = scope.top().local_id++;push_tuple();check_type($1,$3,f1);get<0>(node[$$])=get<0>(node[$1]);}
                        | expression LTE expression{$$ = scope.top().local_id++;push_tuple();check_type($1,$3,f1);get<0>(node[$$])=get<0>(node[$1]);}
                        | expression GTE expression{$$ = scope.top().local_id++;push_tuple();check_type($1,$3,f1);get<0>(node[$$])=get<0>(node[$1]);};


// io_statement -> IO
io_statement:           assignment_statement{$$ = scope.top().local_id++;push_tuple();get<0>(node[$$])=get<0>(node[$1]);}
                        | output_statement{$$ = scope.top().local_id++;push_tuple();get<0>(node[$$])=get<0>(node[$1]);}
                        | block{$$ = scope.top().local_id++;push_tuple();get<0>(node[$$])=get<0>(node[$1]);}
                        | declaration_statement{$$ = scope.top().local_id++;push_tuple();get<0>(node[$$])=get<0>(node[$1]);};

declaration_statement:  DT ID {$$ = scope.top().local_id++;push_tuple();get<0>(node[$$])="io";int temp = scope.top().local_id++;push_tuple();string s2 = $2;string s1 = $1;name2id[s2] = temp;get<0>(node[temp]) = s1; get<3>(node[temp]) = s2;};

// assignment_statement -> IO
assignment_statement:   ID ASG expression{
                                            $$ = scope.top().local_id++;
                                            push_tuple();
                                            get<0>(node[$$])="io";
                                            string tmp = $1; 
                                            if(name2id.find(tmp) == name2id.end()){
                                                cout << "Variable not declared!!" << endl;
                                                exit(0);
                                            }
                                        };

// output_statement -> IO
output_statement:       OS;

// block -> IO
block:                  BLK OCB io_statements CCB{$$ = scope.top().local_id++;push_tuple();get<0>(node[$$])="io";};


expression:             function_call{$$ = scope.top().local_id++;push_tuple();get<0>(node[$$])=get<0>(node[$1]);}
                        | io_statement SCL {$$ = scope.top().local_id++;push_tuple();get<0>(node[$$])=get<0>(node[$1]);}
                        | selection_statement{$$ = scope.top().local_id++;push_tuple();get<0>(node[$$])=get<0>(node[$1]);}
                        | additive_expression{$$ = scope.top().local_id++;push_tuple();get<0>(node[$$])=get<0>(node[$1]);}
                        ;

additive_expression:    multiplicative_expression{$$ = scope.top().local_id++;push_tuple();get<0>(node[$$])=get<0>(node[$1]);}
                        | additive_expression PLS multiplicative_expression{check_type($1,$3,f1); $$ = scope.top().local_id++;push_tuple();get<0>(node[$$])=get<0>(node[$1]);}
                        | additive_expression MIN multiplicative_expression{check_type($1,$3,f1); $$ = scope.top().local_id++;push_tuple();get<0>(node[$$])=get<0>(node[$1]);};

multiplicative_expression:  identifier{$$ = scope.top().local_id++;push_tuple();get<0>(node[$$])=get<0>(node[$1]);}
                            | multiplicative_expression STR identifier{check_type($1,$3,f1);$$ = scope.top().local_id++;push_tuple();get<0>(node[$$])=get<0>(node[$1]);} 
                            | multiplicative_expression FSH identifier{check_type($1,$3,f1);$$ = scope.top().local_id++;push_tuple();get<0>(node[$$])=get<0>(node[$1]);}
                            | multiplicative_expression PCT identifier{check_type($1,$3,f1);$$ = scope.top().local_id++;push_tuple();get<0>(node[$$])=get<0>(node[$1]);};

identifier:             NUM{
                            $$ = scope.top().local_id++;
                            push_tuple();
                            string tmp = $1;
                            get<1>(node[$$]) = tmp;
                            }
                        | ID{vector<int> curr_scope = scope.top();
                            string tmp = $1;
                            int idf = name2id.find(tmp);
                            int isfound = 0;
                            for(int i = 0; i < curr_scope.size(); i++){
                                if(idf == curr_scope[i]){
                                    isfound = 1;
                                    break;
                                }
                            }
                            if(!isfound){
                                cout << "Variable is not declared!!" << endl;
                                exit(0);  
                            }
                            else
                            {
                                $$ = scope.top().local_id++;
                                push_tuple();
                                node[$$] = node[name2id[tmp]];
                            }
                        };

function_call:          ID OB parameter_list CB {
                                                    $$ = scope.top().local_id++;
                                                    push_tuple();
                                                    get<0>(node[$$])=get<0>(node[$1]);
                                                    vector<int> curr_scope = scope.top();
                                                    string tmp = $1;
                                                    if(name2id.find(tmp) == name2id.end()){
                                                        cout << "Function not declared!!" << endl;
                                                        exit(0);  
                                                    }
                                                    string tmp1 = $1;
                                                    int id1 = name2id.find(tmp1);
                                                    int id2 = $3;
                                                    func_sign f = get<4>(node[id1]);
                                                    func_sign pm = get<4>(node[id2]);
                                                    if(f.params.size() != pm.params.size()){
                                                        cout<< "Invalid Parameters!!" << endl;
                                                        exit(0);
                                                    }
                                                    for(int i = 0; i < f.params.size(); i++){
                                                        if(f.params[i] != pm.params[i]){
                                                            cout<< "Invalid Parameters!!" << endl;
                                                            exit(0);
                                                        }
                                                    }
                                                    
                        };

parameter_list:         parameter_lists {$$ = $1;}
                        | {$$ = scope.top().local_id++;push_tuple();}   
                        ;

parameter_lists:        expression COM parameter_lists {$$ = $3 ; string temp = get<0>(node[$1]);(get<4>(node[$$]).params).push_back(temp);}
                        | expression {$$ = scope.top().local_id++;push_tuple(); string temp = get<0>(node[$1]) ;(get<4>(node[$$]).params).push_back(temp);}
                        ;

%%

int main(int argc, char** argv)
{
   
    yyin = fopen(argv[1], "r");
    yyparse();
}

int yyerror(char *s){
    printf("Error: %s\n", s);
}

