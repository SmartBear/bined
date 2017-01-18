; deltahex-editor-0.1.3-SNAPSHOT-win32.nsi
!include MUI2.nsh
!define CLIENT_VERSION "0.1.3-SNAPSHOT"
!define TITLE "DeltaHex Editor"
!define FULL_TITLE "DeltaHex Editor - 0.1.3-SNAPSHOT"
!define CREATOR "ExBin Project"
; !define CHANGELOG_FILE "Novinky.txt"
!define MUI_TEXT_WELCOME_TITLE "!"
!define MUI_FILE "DeltaHexEditor"
!define MUI_PRODUCT "DeltaHex Editor"

Var SF_SELORPSEL

; The name of the installer
Name "DeltaHex Editor Installer"
Caption "DeltaHex Editor Installer"

; The file to write
OutFile "deltahex-editor-0.1.3-SNAPSHOT-win32.exe"

; The default installation directory
InstallDir "$PROGRAMFILES\ExBin Project\DeltaHex"

; Registry key to check for directory (so if you install again, it will 
; overwrite the old one automatically)
InstallDirRegKey HKLM "Software\ExBin Project\DeltaHex" "Install_Dir"

; Request application privileges for Windows Vista
RequestExecutionLevel admin

;--------------------------------

!define MUI_WELCOMEPAGE_TEXT "This wizard will guide you through the installation of DeltaHex Editor version ${CLIENT_VERSION}.$\r$\n$\r$\nDeltaHex editor is free and open source hexadecimal editor written in Java / Swing.$\r$\n$\r$\n$_CLICK"
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "LICENSE-2.0.txt"
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES

UninstPage uninstConfirm
UninstPage instfiles
Icon "imgs\icon.ico"

;--------------------------------
;Languages

!insertmacro MUI_LANGUAGE "English"

;--------------------------------
!include Sections.nsh

; The stuff to install
Section

  SectionIn RO

  ; Set output path to the installation directory.
  SetOutPath $INSTDIR

  ; Put file there
  File "LICENSE-2.0.txt"
  File "readme.txt"
  File "changes.txt"
  File "DeltaHexEditor.exe"
  File "deltahex-editor.jar"

  SetOutPath $INSTDIR\lib
  File /r lib\*

  SetOutPath $INSTDIR\plugins
  File /r plugins\*

  SetOutPath $INSTDIR\imgs
  File /r imgs\*

  ; Write the installation path into the registry
  WriteRegStr HKLM "SOFTWARE\${CREATOR}\${TITLE}" "Install_Dir" "$INSTDIR"

  ; Write the uninstall keys for Windows
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${CREATOR}\${TITLE}" "DisplayName" "Uninstall DeltaHex Editor"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${CREATOR}\${TITLE}" "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${CREATOR}\${TITLE}" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${CREATOR}\${TITLE}" "NoRepair" 1
  WriteUninstaller "uninstall.exe"

SectionEnd

; Optional sections (can be disabled by the user)
Section "Create Desktop Icon" DesktopIcon
  CreateShortCut "$DESKTOP\${MUI_PRODUCT}.lnk" "$INSTDIR\${MUI_FILE}.exe" ""
SectionEnd

Section "Start Menu Shortcuts" ShortCut

  StrCpy $R0 ${SF_SELECTED}
  IntOp $R0 $R0 | ${SF_PSELECTED}
  StrCpy $SF_SELORPSEL $R0

  CreateDirectory "$SMPROGRAMS\${TITLE}"
  CreateShortCut "$SMPROGRAMS\${TITLE}\DeltaHex Editor.lnk" "$INSTDIR\${MUI_FILE}.exe" "" "" 0
  CreateShortCut "$SMPROGRAMS\${TITLE}\Uninstall.lnk" "$INSTDIR\uninstall.exe" "" "$INSTDIR\uninstall.exe" 0
  CreateShortCut "$SMPROGRAMS\${TITLE}\Readme.lnk" "$INSTDIR\readme.txt" "" "" 0

SectionEnd

;--------------------------------

; Uninstaller

Section "Uninstall"

  ; Remove registry keys
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${CREATOR}\${TITLE}"
  DeleteRegKey HKLM "SOFTWARE\${CREATOR}\${TITLE}"

  ; Remove files and uninstaller
  Delete $INSTDIR\readme.txt
  Delete $INSTDIR\LICENSE-2.0.txt
  Delete $INSTDIR\changes.txt
  Delete $INSTDIR\uninstall.exe
  Delete $INSTDIR\DeltaHexEditor.exe
  Delete $INSTDIR\deltahex-editor.jar

  Delete $INSTDIR\imgs\*
  RMDir $INSTDIR\imgs
  RMDir /r $INSTDIR\lib
  RMDir /r $INSTDIR\plugins

  ; Remove shortcuts, if any
  Delete "$DESKTOP\${MUI_PRODUCT}.lnk"
  Delete "$SMPROGRAMS\${TITLE}\*.*"

  ; Remove directories used
  RMDir /r "$SMPROGRAMS\${TITLE}"
  RMDir "$INSTDIR"

SectionEnd

Function .onInit
FunctionEnd