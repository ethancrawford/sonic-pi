//--
// This file is part of Sonic Pi: http://sonic-pi.net
// Full project source: https://github.com/samaaron/sonic-pi
// License: https://github.com/samaaron/sonic-pi/blob/main/LICENSE.md
//
// Copyright 2013, 2014, 2015, 2016 by Sam Aaron (http://sam.aaron.name).
// All rights reserved.
//
// Permission is granted for use, copying, modification, and
// distribution of modified versions of this work as long as this
// notice is included.
//++
#include <fstream>
#include <iostream>
#include <string>
#include "core.h"

using namespace std;

Core::Core(){}
Core::~Core() {}

string Core::read_file(const char * filename)
{
  ifstream in(filename, ios::in | ios::binary);
    if (in)
    {
        string contents;
        in.seekg(0, ios::end);
        contents.resize(in.tellg());
        in.seekg(0, ios::beg);
        in.read(&contents[0], contents.size());
        in.close();
        return (contents);
    }
    cerr << "Core - could not open file " << filename << "\n";
    return "";
}

string Core::ascii_art_logo()
{
    return read_file("logo.txt");
}

void Core::print_ascii_art_logo()
{
  string s = ascii_art_logo();
  cout << s;
}
