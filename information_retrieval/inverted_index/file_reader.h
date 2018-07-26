#include <fstream>
#include <string>

#ifndef FILE_READER

#define FILE_READER

class file_reader{

public:
	file_reader(){
	}

	std::string get_contents_line_by_line(const char *file_name){
	    // input ::: <type c-string> name of file to be read (from working directory)
	    // output ::: <type std::string> containing all contents of the file 
	    //     (with spaces instead of newlines)
	    std::ifstream infile;
	    infile.open(file_name);
	    std::string line, contents;
	    while(std::getline(infile, line)){
	        contents += line + " ";
	    }
	    return contents;
	    // 7.189s/100k runs 
	}	

	std::string get_contents_full(const char *file_name){
	    // input ::: <type c-string> name of a file to be read (from working directory)
	    // output ::: <type std::string> containing all contents of the file as the 
	    //     file contained them (with linebreaks etc)
	    std::ifstream infile;
	    infile.open(file_name);
	    std::string contents;
	    contents.assign( (std::istreambuf_iterator<char>(infile) ),
	                     (std::istreambuf_iterator<char>()       ) ); 
	    infile.close();
	    return contents;
	    // 7.626s/100k runs 
	}

};

#endif 
