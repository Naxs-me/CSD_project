#include<bits/stdc++.h>

using namespace std;

typedef unsigned long long intl;

ofstream tac("AC.txt");


class func_sign{

    public:
    
    vector<string> params;
    vector<unsigned long long> vars;

};


class local{
    public:
    //          0 type    1 value  2 line 3 name  4 function_sign 5 current code  6 last variable
    vector<tuple<string , string , int , string ,   func_sign     , vector<string>  ,   string> > node;
    unsigned long long int local_id;
    map<string , int> name2id;
    vector<string> lines;
    local();
    void print_3add();
};

local::local()
{
    local_id = 0;
}

void local::print_3add()
{
    for(int i = 0; i < lines.size(); i++)
    {
        tac << lines[i] << endl;
    }
}

//  name     id
map<string , int> name2id;
//           type     value    line  name     function_sign
vector<tuple<string , string , int , string , func_sign >> node;
unsigned long long global_id = 0;

unsigned long long label_id = 0;
unsigned long long t_id = 0;
unsigned long long dec_count = 0;

string get_f(int id1, int id2)
{
    string s = "function ";

    s += get<3>(node[id1]);

    s += " 0";

    vector<string> v = get<4>(node[id2]).params;

    for(int i = v.size()-1 ; i >= 0 ; i--)
    {
        s += " ";
        s += v[i];
    }

    return s;
}

string get_m(){
    string s = "function main ";

    return s;
}

string get_label()
{
    string s = "_L";
    s += to_string(label_id++);
    s += " :";
    return s;
}

string get_temp()
{
    string s = "_t";
    s += to_string(t_id++);
    return s;
}

stack<local> scope;

//unsigned long long int global_id = 0;
struct Snode{
        char type[31];
        int address;
        char lexval[32];
        float dval;
        int size;
        int isDval;
        int isArray;
};

void f1()
{
    ;
}

void check_type(local &l, int id1, int id2, function<void (void)> f1){
    string s1 = get<0>(l.node[id1]);
    string s2 = get<0>(l.node[id2]);
    if(s1 == s2){
        f1();
    }
    else{
        //cout<<get<3>(l.node[id1])<<":: "<<get<3>(l.node[id2])<<endl;;
        cout<<("Error - type " + s1 + " and type " + s2 + " don't match")<<endl;
        exit(0);
    }
}

void push_tuple(local &l){

    l.node.push_back(make_tuple("","",0,"",func_sign(),vector<string>(),""));
}

void push_tuple_global()
{
    node.push_back(make_tuple("","",0,"",func_sign()));

}

// not used
int get_next_id(){
    local l = scope.top();
    scope.pop();
    int ret = l.local_id++;
    scope.push(l);
    return ret;
}

// not used
void updated_type(int id1, int id2){
    local l = scope.top();
    get<0>(l.node[id1])=get<0>(l.node[id2]);
    scope.pop();
    scope.push(l);
}

void get_line(local& l, int id0, int id1, int id2, string op){

    string s;

    string new_temp = get_temp();

    s += (new_temp + " = " + get<6>(l.node[id1]) + " " + op + " " + get<6>(l.node[id2]));

    vector<string> temp = get<5>(l.node[id2]);

    temp.insert(temp.end(), get<5>(l.node[id1]).begin(), get<5>(l.node[id1]).end());

    temp.push_back(s);

    get<5>(l.node[id0]) = temp;

    get<6>(l.node[id0]) = new_temp;

}

void get_assgn(local& l, int id0, int id1, int id2)
{
    string s;

    s += (get<6>(l.node[id1]) + " = " + get<6>(l.node[id2]));

    vector<string> temp = get<5>(l.node[id2]);

    temp.push_back(s);

    get<5>(l.node[id0]) = temp;

    get<6>(l.node[id0]) = get<6>(l.node[id1]);
}

void get_line(local& l,int id0,int id1){
    get<6>(l.node[id0]) = get<6>(l.node[id1]);
    get<5>(l.node[id0]) = get<5>(l.node[id1]);
}

void print_code(local& l,int id){
    vector<string> code = get<5>(l.node[id]);
    for(int i = 0; i < code.size();i++){
        tac<<code[i]<<endl;
    }
}

void get_line_func(local& l,int id0, int id1, int param){
    string s;
    string new_temp = get_temp();
    s+=(new_temp + " = call " + get<3>(node[id1]) + " " + to_string(get<4>(l.node[param]).params.size()));
    get<5>(l.node[id0]).push_back(s);
    get<6>(l.node[id0]) = new_temp;
}

