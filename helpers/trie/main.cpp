#include "node.h"
#include "trie.h"
#include <string>
int main(){
    Trie t;
    std::string temp = "bullshit";
    t.grow(temp);
    return 0;
}
