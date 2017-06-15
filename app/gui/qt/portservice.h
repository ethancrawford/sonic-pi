//--
// This file is part of Sonic Pi: http://sonic-pi.net
// Full project source: https://github.com/samaaron/sonic-pi
// License: https://github.com/samaaron/sonic-pi/blob/master/LICENSE.md
//
// Copyright 2013, 2014, 2015, 2016 by Sam Aaron (http://sam.aaron.name).
// All rights reserved.
//
// Permission is granted for use, copying, modification, and
// distribution of modified versions of this work as long as this
// notice is included.
//++

#ifndef PORTSERVICE_H
#define PORTSERVICE_H

#include <QString>
#include <QStringList>
#include <QDir>
#include <QProcess>
#include <iostream>

class PortService
{

public:
    PortService(QString ruby_path, QString port_discovery_path);
    int PortNumber(QString port_name, QString log_port_name, int default_port_number);

private:
    QString ruby_path_;
    QString port_discovery_path_;
};

#endif // PORTSERVICE_H
