#include "portservice.h"

PortService::PortService(QString ruby_path, QString port_discovery_path) {
  ruby_path_ = ruby_path;
  port_discovery_path_ = port_discovery_path;
}

int PortService::PortNumber(QString port_name, QString log_port_name, int default_port_number) {
  QProcess* determine_port_number = new QProcess();
  QStringList send_args;
  int port_number;
  send_args << port_discovery_path_ << port_name;

  determine_port_number->start(ruby_path_, send_args);
  determine_port_number->waitForFinished();
  port_number = determine_port_number->readAllStandardOutput().trimmed().toInt();

  if (port_number == 0) {
    std::cout << QString("[GUI] - unable to determine %1. Defaulting to %2:").arg(log_port_name, default_port_number).toStdString() << std::endl;
    port_number = default_port_number;
  }
  return port_number;
}
