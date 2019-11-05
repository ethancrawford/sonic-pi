#ifndef KEYBINDINGS_H
#define KEYBINDINGS_H
#include <QHash>
#include <QString>
#include <QKeySequence>

QKeySequence metaKey(char key);
QKeySequence shiftMetaKey(char key);
QKeySequence ctrlKey(char key);
QKeySequence ctrlMetaKey(char key);
QKeySequence ctrlShiftMetaKey(char key);
QKeySequence setMark();
extern QHash<QString, QKeySequence> sonic_pi_bindings_;
extern QHash<QString, QHash<QString, QKeySequence>> key_bindings_;

#endif // KEYBINDINGS_H
