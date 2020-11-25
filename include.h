#include<iostream>
#include<vector>
#include<stack>
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include<string>
#include<map>
#include<tuple>
#include <functional>

using namespace std;

typedef unsigned long long intl;


class func_sign{

    public:
    
    vector<string> params;
    vector<unsigned long long> vars;

};


class local{
    public:
    //           type     value    line  name     function_sign
    vector<tuple<string , string , int , string , func_sign>> node;
    unsigned long long int local_id;
    map<string , int> name2id;
    local();
};

local::local()
{
    local_id = 0;
}


//  name     id
map<string , int> name2id;
//           type     value    line  name     function_sign
vector<tuple<string , string , int , string , func_sign>> node;
unsigned long long global_id = 0;

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
    cout << "test" << endl;
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
    l.node.push_back(make_tuple("","",0,"",func_sign()));
}

void push_tuple_global()
{
    node.push_back(make_tuple("","",0,"",func_sign()));;
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