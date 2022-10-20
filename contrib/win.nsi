; Script generated by the HM NIS Edit Script Wizard.

!ifndef PRODUCT_VERSION
!define PRODUCT_VERSION "1.0.0"
!endif

!ifndef BINDIR
!define BINDIR "..\release\opt\exec-agent\bin\exec-agent.exe"
!endif

!ifndef ARCH
!define ARCH "amd64"
!endif

Unicode True

; HM NIS Edit Wizard helper defines
!define PRODUCT_NAME "exec-agent"
!define PRODUCT_PUBLISHER "jkstack"
!define PRODUCT_WEB_SITE "https://www.jkstack.com/"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\exec-agent.exe"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

; MUI 1.67 compatible ------
!include "MUI.nsh"

; MUI Settings
!define MUI_ABORTWARNING
;!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\modern-install.ico"
!define MUI_ICON ".\install.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico"

; Language Selection Dialog Settings
!define MUI_LANGDLL_REGISTRY_ROOT "${PRODUCT_UNINST_ROOT_KEY}"
!define MUI_LANGDLL_REGISTRY_KEY "${PRODUCT_UNINST_KEY}"
!define MUI_LANGDLL_REGISTRY_VALUENAME "NSIS:Language"

; Welcome page
!insertmacro MUI_PAGE_WELCOME
; License page
;!insertmacro MUI_PAGE_LICENSE "..\..\..\path\to\licence\YourSoftwareLicence.txt"
; Directory page
!insertmacro MUI_PAGE_DIRECTORY
; Instfiles page
!insertmacro MUI_PAGE_INSTFILES
; Finish page
;!define MUI_FINISHPAGE_RUN "$INSTDIR\exec-agent.exe"
!insertmacro MUI_PAGE_FINISH

; Uninstaller pages
!insertmacro MUI_UNPAGE_INSTFILES

; Language files
;!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_LANGUAGE "SimpChinese"

; MUI end ------

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "exec-agent_${PRODUCT_VERSION}_windows_${ARCH}.exe"
InstallDir "$PROGRAMFILES32\exec-agent"
InstallDirRegKey HKLM "${PRODUCT_DIR_REGKEY}" ""
ShowInstDetails show
ShowUnInstDetails show

Function .onInit
;  !insertmacro MUI_LANGDLL_DISPLAY
  StrCpy $0 $INSTDIR "" -4
  ${If} $0 == "\bin"
    StrCpy $INSTDIR $INSTDIR -4
  ${EndIf}
FunctionEnd

Section "MainSection" SEC01
  SetOutPath "$INSTDIR"
  SetOverwrite ifnewer
  CreateDirectory "$SMPROGRAMS\exec-agent"
  CreateDirectory "$INSTDIR\bin"
  CreateDirectory "$INSTDIR\conf"
  File "/oname=$INSTDIR\bin\exec-agent.exe" "${BINDIR}"
  File "/oname=$INSTDIR\conf\agent.conf" "..\conf\agent.conf"
SectionEnd

Section -AdditionalIcons
  CreateShortCut "$SMPROGRAMS\exec-agent\Uninstall.lnk" "$INSTDIR\uninst.exe"
SectionEnd

Section -Post
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR\bin\exec-agent.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\exec-agent.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
  SimpleSC::InstallService "exec-agent" "exec-agent" "16" "2" "$INSTDIR\bin\exec-agent.exe -conf $\"$INSTDIR\conf\agent.conf$\""
  SimpleSC::SetServiceDescription "exec-agent" "jkstack metrics agent"
SectionEnd


Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) 已成功从你的计算机移除。"
FunctionEnd

Function un.onInit
!insertmacro MUI_UNGETLANGUAGE
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "你要完全移除 $(^Name) ，及其所有组件？" IDYES +2
  Abort
FunctionEnd

Section Uninstall
  SimpleSC::StopService "exec-agent" "1" "30"
  SimpleSC::RemoveService "exec-agent"

  Delete "$INSTDIR\uninst.exe"
  Delete "$INSTDIR\conf\agent.conf"
  Delete "$INSTDIR\bin\exec-agent.exe"

  Delete "$SMPROGRAMS\exec-agent\Uninstall.lnk"

  RMDIR "$INSTDIR\conf"
  RMDIR "$INSTDIR\bin"
  RMDir "$INSTDIR"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
  SetAutoClose true
SectionEnd