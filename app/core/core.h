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

#ifndef CORE_H
#define CORE_H

#include <string>

class Core
{
public:
    explicit Core();
    ~Core();
    std::string read_file(const char * filename);
    std::string ascii_art_logo();
    void print_ascii_art_logo();
};

#endif // CORE_H
