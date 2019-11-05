#include "shortcutservice.h"

ShortcutService::ShortcutService(QMainWindow *main_window) : QObject(main_window) {
  main_window_ = main_window;

  // Main app shortcuts
  macos_shortcuts_["runCode"] = new QShortcut(key_bindings_["sonic_pi"]["runCode"], main_window_, SLOT(runCode()));
  macos_shortcuts_["stopCode"] = new QShortcut(key_bindings_["sonic_pi"]["stopCode"], main_window_, SLOT(stopCode()));
  macos_shortcuts_["toggleRecording"] = new QShortcut(key_bindings_["sonic_pi"]["toggleRecording"], main_window_, SLOT(toggleRecording()));
  macos_shortcuts_["appSaveAs"] = new QShortcut(key_bindings_["sonic_pi"]["appSaveAs"], main_window_, SLOT(saveAs()));
  macos_shortcuts_["appLoadFile"] = new QShortcut(key_bindings_["sonic_pi"]["appLoadFile"], main_window_, SLOT(loadFile()));
  macos_shortcuts_["textAlign"] = new QShortcut(key_bindings_["sonic_pi"]["textAlign"], main_window_, SLOT(beautifyCode()));
  macos_shortcuts_["textInc"] = new QShortcut(key_bindings_["sonic_pi"]["textInc"], main_window_, SLOT(zoomCurrentWorkspaceIn()));
  macos_shortcuts_["textDec"] = new QShortcut(key_bindings_["sonic_pi"]["textDec"], main_window_, SLOT(zoomCurrentWorkspaceOut()));
  macos_shortcuts_["toggleScope"] = new QShortcut(key_bindings_["sonic_pi"]["toggleScope"], main_window_, SLOT(toggleScope()));
  macos_shortcuts_["toggleInfo"] = new QShortcut(key_bindings_["sonic_pi"]["toggleInfo"], main_window_, SLOT(about()));
  macos_shortcuts_["toggleHelp"] = new QShortcut(key_bindings_["sonic_pi"]["toggleHelp"], main_window_, SLOT(help()));
  macos_shortcuts_["togglePrefs"] = new QShortcut(key_bindings_["sonic_pi"]["togglePrefs"], main_window_, SLOT(togglePrefs()));
#if QT_VERSION >= 0x050400
  //requires Qt 5
  macos_shortcuts_["zoomInLogs"] = new QShortcut(key_bindings_["sonic_pi"]["zoomInLogs"], main_window_, SLOT(zoomInLogs()));
  macos_shortcuts_["zoomOutLogs"] = new QShortcut(key_bindings_["sonic_pi"]["zoomOutLogs"], main_window_, SLOT(zoomOutLogs()));
#endif
}

ShortcutService::~ShortcutService() {
}

QShortcut* ShortcutService::Shortcut(QString name) {
  return macos_shortcuts_[name];
}

void ShortcutService::CreateBufferShortcuts(SonicPiScintilla *workspace, QString i) {
  macos_shortcuts_["indentLine" + i] = new QShortcut(key_bindings_["sonic_pi"]["indentLine"], workspace);
  macos_shortcuts_["bufferSaveAs" + i] = new QShortcut(key_bindings_["sonic_pi"]["bufferSaveAs"], workspace);
  macos_shortcuts_["bufferLoadFile" + i] = new QShortcut(key_bindings_["sonic_pi"]["bufferLoadFile"], workspace);
  macos_shortcuts_["forwardTenLines" + i] = new QShortcut(key_bindings_["sonic_pi"]["forwardTenLines"], workspace);
  macos_shortcuts_["backTenLines" + i] = new QShortcut(key_bindings_["sonic_pi"]["backTenLines"], workspace);
  macos_shortcuts_["fontZoom" + i] = new QShortcut(key_bindings_["sonic_pi"]["fontZoom"], workspace);
  macos_shortcuts_["fontZoom2" + i] = new QShortcut(key_bindings_["sonic_pi"]["fontZoom2"], workspace);
  macos_shortcuts_["fontZoomOut" + i] = new QShortcut(key_bindings_["sonic_pi"]["fontZoomOut"], workspace);
  macos_shortcuts_["fontZoomOut2" + i] = new QShortcut(key_bindings_["sonic_pi"]["fontZoomOut2"], workspace);
  macos_shortcuts_["transposeChars" + i] = new QShortcut(key_bindings_["sonic_pi"]["transposeChars"], workspace);
  macos_shortcuts_["moveLineUp" + i] = new QShortcut(key_bindings_["sonic_pi"]["moveLineUp"], workspace);
  macos_shortcuts_["moveLineDown" + i] = new QShortcut(key_bindings_["sonic_pi"]["moveLineDown"], workspace);
  macos_shortcuts_["contextHelp" + i] = new QShortcut(key_bindings_["sonic_pi"]["contextHelp"], workspace);
  macos_shortcuts_["contextHelp2" + i] = new QShortcut(key_bindings_["sonic_pi"]["contextHelp2"], workspace);
  macos_shortcuts_["setMark" + i] = new QShortcut(key_bindings_["sonic_pi"]["setMark"], workspace);
  macos_shortcuts_["escape" + i] = new QShortcut(key_bindings_["sonic_pi"]["escape"], workspace);
  macos_shortcuts_["escape2" + i] = new QShortcut(key_bindings_["sonic_pi"]["escape2"], workspace);
  macos_shortcuts_["forwardOneLine" + i] = new QShortcut(key_bindings_["sonic_pi"]["forwardOneLine"], workspace);
  macos_shortcuts_["backOneLine" + i] = new QShortcut(key_bindings_["sonic_pi"]["backOneLine"], workspace);
  macos_shortcuts_["cutToEndOfLine" + i] = new QShortcut(key_bindings_["sonic_pi"]["cutToEndOfLine"], workspace);
  macos_shortcuts_["copyToBuffer" + i] = new QShortcut(key_bindings_["sonic_pi"]["copyToBuffer"], workspace);
  macos_shortcuts_["cutToBufferLive" + i] = new QShortcut(key_bindings_["sonic_pi"]["cutToBufferLive"], workspace);
  macos_shortcuts_["cutToBuffer" + i] = new QShortcut(key_bindings_["sonic_pi"]["cutToBuffer"], workspace);
  macos_shortcuts_["pasteToBufferWin" + i] = new QShortcut(key_bindings_["sonic_pi"]["pasteToBufferWin"], workspace);
  macos_shortcuts_["pasteToBuffer" + i] = new QShortcut(key_bindings_["sonic_pi"]["pasteToBuffer"], workspace);
  macos_shortcuts_["pasteToBufferEmacs" + i] = new QShortcut(key_bindings_["sonic_pi"]["pasteToBufferEmacs"], workspace);
  macos_shortcuts_["toggleLineComment" + i] = new QShortcut(key_bindings_["sonic_pi"]["toggleLineComment"], workspace);
  macos_shortcuts_["upcaseWord" + i] = new QShortcut(key_bindings_["sonic_pi"]["upcaseWord"], workspace);
  macos_shortcuts_["downcaseWord" + i] = new QShortcut(key_bindings_["sonic_pi"]["downcaseWord"], workspace);
}

void ShortcutService::CreateShortcuts() {
  new QShortcut(key_bindings_["sonic_pi"]["tabPrev"], main_window_, SLOT(tabPrev()));
  new QShortcut(key_bindings_["sonic_pi"]["tabNext"], main_window_, SLOT(tabNext()));
  new QShortcut(key_bindings_["sonic_pi"]["reloadServerCode"], main_window_, SLOT(reloadServerCode()));
  new QShortcut(key_bindings_["sonic_pi"]["toggleButtonVisibility"], main_window_, SLOT(toggleButtonVisibility()));
  new QShortcut(key_bindings_["sonic_pi"]["toggleButtonVisibility2"], main_window_, SLOT(toggleButtonVisibility()));
  new QShortcut(key_bindings_["sonic_pi"]["toggleFocusMode"], main_window_, SLOT(toggleFocusMode()));
  new QShortcut(key_bindings_["sonic_pi"]["toggleFullScreenMode"], main_window_, SLOT(toggleFullScreenMode()));
  new QShortcut(key_bindings_["sonic_pi"]["cycleThemes"], main_window_, SLOT(cycleThemes()));
  new QShortcut(key_bindings_["sonic_pi"]["toggleLogVisibility"], main_window_, SLOT(toggleLogVisibility()));
  new QShortcut(key_bindings_["sonic_pi"]["toggleLogVisibility2"], main_window_, SLOT(toggleLogVisibility()));
  new QShortcut(key_bindings_["sonic_pi"]["toggleScopePaused"], main_window_, SLOT(toggleScopePaused()));
}

void ShortcutService::CreateUpDownShortcuts(QString name, QWidget *widget){
  // these don't work yet and don't seem to have done so for several earlier versions either
  //macos_shortcuts_[name + "Up"] = new QShortcut(ctrlKey('_'), widget);
  //macos_shortcuts_[name + "Down"] = new QShortcut(ctrlKey('n'), widget);
}

void ShortcutService::ConnectBufferShortcuts(QSignalMapper *signal_mapper, SonicPiScintilla *workspace, int index) {
  i = QString::number(index);
  CreateBufferShortcuts(workspace, i);
  //tab completion when in list
  main_window_->connect(Shortcut("indentLine" + i), SIGNAL(activated()), signal_mapper, SLOT(map()));
  signal_mapper->setMapping(Shortcut("indentLine" + i), (QObject*)workspace);

  // save and load buffers
  QObject::connect(Shortcut("bufferSaveAs" + i), SIGNAL(activated()), main_window_, SLOT(saveAs()));
  QObject::connect(Shortcut("bufferLoadFile" + i), SIGNAL(activated()), main_window_, SLOT(loadFile()));

  //quick nav by jumping up and down 10 lines at a time
  main_window_->connect(Shortcut("forwardTenLines" + i), SIGNAL(activated()), workspace, SLOT(forwardTenLines()));
  QObject::connect(Shortcut("backTenLines" + i), SIGNAL(activated()), workspace, SLOT(backTenLines()));

  // Font zooming
  QObject::connect(Shortcut("fontZoom" + i), SIGNAL(activated()), workspace, SLOT(zoomFontIn()));
  QObject::connect(Shortcut("fontZoom2" + i), SIGNAL(activated()), workspace, SLOT(zoomFontIn()));
  QObject::connect(Shortcut("fontZoomOut" + i), SIGNAL(activated()), workspace, SLOT(zoomFontOut()));
  QObject::connect(Shortcut("fontZoomOut2" + i), SIGNAL(activated()), workspace, SLOT(zoomFontOut()));

  //transpose chars
  QObject::connect(Shortcut("transposeChars" + i), SIGNAL(activated()), workspace, SLOT(transposeChars()));

  //move line or selection up and down
  QObject::connect(Shortcut("moveLineUp" + i), SIGNAL(activated()), workspace, SLOT(moveLineOrSelectionUp()));
  QObject::connect(Shortcut("moveLineDown" +  i), SIGNAL(activated()), workspace, SLOT(moveLineOrSelectionDown()));

  // Contextual help
  QObject::connect(Shortcut("contextHelp" + i), SIGNAL(activated()), main_window_, SLOT(helpContext()));
  QObject::connect(Shortcut("contextHelp2" + i), SIGNAL(activated()), main_window_, SLOT(helpContext()));

  //set Mark
  QObject::connect(Shortcut("setMark" + i), SIGNAL(activated()), workspace, SLOT(setMark()));

  //escape
  QObject::connect(Shortcut("escape" + i), SIGNAL(activated()), main_window_, SLOT(escapeWorkspaces()));
  QObject::connect(Shortcut("escape2" + i), SIGNAL(activated()), main_window_, SLOT(escapeWorkspaces()));

  //quick nav by jumping up and down 1 lines at a time
  QObject::connect(Shortcut("forwardOneLine" + i), SIGNAL(activated()), workspace, SLOT(forwardOneLine()));
  QObject::connect(Shortcut("backOneLine" + i), SIGNAL(activated()), workspace, SLOT(backOneLine()));

  //cut to end of line
  QObject::connect(Shortcut("cutToEndOfLine" + i), SIGNAL(activated()), workspace, SLOT(cutLineFromPoint()));

  //Emacs live copy and cut
  QObject::connect(Shortcut("copyToBuffer" + i), SIGNAL(activated()), workspace, SLOT(copyClear()));
  QObject::connect(Shortcut("cutToBufferLive" + i), SIGNAL(activated()), workspace, SLOT(sp_cut()));

  // Standard cut
  QObject::connect(Shortcut("cutToBuffer" + i), SIGNAL(activated()), workspace, SLOT(sp_cut()));

  // paste
  QObject::connect(Shortcut("pasteToBufferWin" + i), SIGNAL(activated()), workspace, SLOT(sp_paste()));
  QObject::connect(Shortcut("pasteToBuffer" + i), SIGNAL(activated()), workspace, SLOT(sp_paste()));
  QObject::connect(Shortcut("pasteToBufferEmacs" + i), SIGNAL(activated()), workspace, SLOT(sp_paste()));

  //comment line
  QObject::connect(Shortcut("toggleLineComment" + i), SIGNAL(activated()), main_window_, SLOT(toggleCommentInCurrentWorkspace()));

  //upcase next word
  QObject::connect(Shortcut("upcaseWord" + i), SIGNAL(activated()), workspace, SLOT(upcaseWordOrSelection()));

  //downcase next word
  QObject::connect(Shortcut("downcaseWord" + i), SIGNAL(activated()), workspace, SLOT(downcaseWordOrSelection()));
}

void ShortcutService::addUniversalCopyShortcuts(QTextEdit *te){
  new QShortcut(ctrlKey('c'), te, SLOT(copy()));
  new QShortcut(ctrlKey('a'), te, SLOT(selectAll()));

  new QShortcut(metaKey('c'), te, SLOT(copy()));
  new QShortcut(metaKey('a'), te, SLOT(selectAll()));
}
