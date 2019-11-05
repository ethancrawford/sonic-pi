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

#ifndef SHORTCUTSERVICE_H
#define SHORTCUTSERVICE_H

#include <QSignalMapper>
#include <QShortcut>
#include <QKeySequence>
#include "sonicpiscintilla.h"
#include "mainwindow.h"
#include "keybindings.h"

class ShortcutService : public QObject
{
  Q_OBJECT
public:
  ShortcutService(QMainWindow *main_window);
  ~ShortcutService();
  QShortcut* Shortcut(const QString name);
  void CreateBufferShortcuts(SonicPiScintilla *workspace, QString i);
  void CreateShortcuts();
  void CreateUpDownShortcuts(QString name, QWidget *widget);
  void ConnectBufferShortcuts(QSignalMapper *signal_mapper, SonicPiScintilla *workspace, int index);
  void addUniversalCopyShortcuts(QTextEdit *te);
  //unordered_map MacosShortcuts();
private:
  QMainWindow *main_window_;
  QSignalMapper *signal_mapper_;
  QString i;
  QHash<QString, QShortcut*> macos_shortcuts_;
  //QHash<QString, QHash<QString, QKeySequence>> key_bindings_;
};

#endif // SHORTCUTSERVICE_H
