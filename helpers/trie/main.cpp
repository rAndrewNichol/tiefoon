#include "node.h"
#include "trie.h"
#include <string>
int main(){
    Trie t;
    std::string temp = "bullshit";
    int _id = 1;
    t.grow(temp, _id);
    return 0;
}
