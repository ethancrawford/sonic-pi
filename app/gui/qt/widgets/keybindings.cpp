#include "keybindings.h"

QHash<QString, QKeySequence> sonic_pi_bindings_ {
 // Main app key bindings
  { "runCode", metaKey('R') },
  { "stopCode", metaKey('S') },
  { "toggleRecording", shiftMetaKey('R') },
  { "appSaveAs", shiftMetaKey('S') },
  { "appLoadFile", shiftMetaKey('O') },
  { "textAlign", metaKey('M') },
  { "textInc", metaKey('+') },
  { "textDec", metaKey('-') },
  { "toggleScope", metaKey('O') },
  { "toggleInfo", metaKey('1') },
  { "toggleHelp", metaKey('I') },
  { "togglePrefs", metaKey('P') },
  { "zoomInLogs", ctrlKey('=') },
  { "zoomOutLogs", ctrlKey('-') },
  { "tabPrev", shiftMetaKey('[') },
  { "tabNext", shiftMetaKey(']') },
  { "reloadServerCode", QKeySequence("F8") },
  { "toggleButtonVisibility", QKeySequence("F9") },
  { "toggleButtonVisibility2", shiftMetaKey('B') },
  { "toggleFocusMode", QKeySequence("F10") },
  { "toggleFullScreenMode", shiftMetaKey('F') },
  { "cycleThemes", shiftMetaKey('M') },
  { "toggleLogVisibility", QKeySequence("F11") },
  { "toggleLogVisibility2", shiftMetaKey('L') },
  { "toggleScopePaused", QKeySequence("F12") },

  // Buffer key bindings
  { "indentLine", QKeySequence("Tab") },
  { "bufferSaveAs", shiftMetaKey('S') },
  { "bufferLoadFile", shiftMetaKey('o') },
  { "forwardTenLines", shiftMetaKey('u') },
  { "backTenLines", shiftMetaKey('d') },
  { "fontZoom", metaKey('=') },
  { "fontZoom2", metaKey('+') },
  { "fontZoomOut", metaKey('-') },
  { "fontZoomOut2", metaKey('_') },
  { "transposeChars", ctrlKey('t') },
  { "moveLineUp", ctrlMetaKey('p') },
  { "moveLineDown", ctrlMetaKey('n') },
  { "contextHelp", ctrlKey('i') },
  { "contextHelp2", QKeySequence("F1") },
  { "setMark", setMark() },
  { "escape", ctrlKey('g') },
  { "escape2", QKeySequence("Escape") },
  { "forwardOneLine", ctrlKey('p') },
  { "backOneLine", ctrlKey('n') },
  { "cutToEndOfLine", ctrlKey('k') },
  { "copyToBuffer", metaKey(']') },
  { "cutToBufferLive", ctrlKey(']') },
  { "cutToBuffer", ctrlKey('x') },
  { "pasteToBufferWin", ctrlKey('v') },
  { "pasteToBuffer", metaKey('v') },
  { "pasteToBufferEmacs", ctrlKey('y') },
  { "toggleLineComment", metaKey('/') },
  { "upcaseWord", metaKey('u') },
  { "downCaseWord", metaKey('l') }
};

// QHash<QString, QKeySequence> mac_os_bindings_ {
//   // Main app key bindings
//   { "stopCode", QKeySequence("alt+S") },
//   { "appLoadFile", metaKey('O') },
//   { "toggleScope", shiftMetaKey('O') },
//   { ""}

QHash<QString, QHash<QString, QKeySequence>> key_bindings_ { { "sonic_pi", sonic_pi_bindings_ } };

// Cmd on Mac, Alt everywhere else
QKeySequence metaKey(char key)
{
#ifdef Q_OS_MAC
  return QKeySequence(QString("Ctrl+%1").arg(key));
#else
  return QKeySequence(QString("alt+%1").arg(key));
#endif
}

QKeySequence shiftMetaKey(char key) {
#ifdef Q_OS_MAC
  return QKeySequence(QString("Shift+Ctrl+%1").arg(key));
#else
  return QKeySequence(QString("Shift+alt+%1").arg(key));
#endif
}

QKeySequence ctrlKey(char key)
{
#ifdef Q_OS_MAC
  return QKeySequence(QString("Meta+%1").arg(key));
#else
  return QKeySequence(QString("Ctrl+%1").arg(key));
#endif
}

QKeySequence ctrlMetaKey(char key)
{
#ifdef Q_OS_MAC
  return QKeySequence(QString("Ctrl+Meta+%1").arg(key));
#else
  return QKeySequence(QString("Ctrl+alt+%1").arg(key));
#endif
}

QKeySequence ctrlShiftMetaKey(char key)
{
#ifdef Q_OS_MAC
  return QKeySequence(QString("Shift+Ctrl+Meta+%1").arg(key));
#else
  return QKeySequence(QString("Shift+Ctrl+alt+%1").arg(key));
#endif
}

QKeySequence setMark() {
#ifdef Q_OS_MAC
  return QKeySequence("Meta+Space");
#else
  return QKeySequence("Ctrl+Space");
#endif
}
