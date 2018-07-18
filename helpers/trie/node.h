#include <vector>
#include <string>

#ifndef NODE

struct Node{
    std::vector<Node>* children;
    char value;
    bool endpoint;

    Node(){
        endpoint = false;
        value = '\0';
    }
    Node(char tmp_value, bool tmp_endpoint = false){
        value = tmp_value;
        endpoint = tmp_endpoint;
    }
};

#define NODE
#endif
