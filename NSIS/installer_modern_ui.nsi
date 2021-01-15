# Copyright 2021 Christian Gimenez
#
# installer_modern_ui.nsi
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

!include "MUI2.nsh"

Name "Instalar Vet"
Caption "Instalar Vet"
# Icon
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\modern-install.ico"
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_BITMAP "${NSISDIR}\Contrib\Graphics\Header\orange.bmp"

!define MUI_INSTFILESPAGE_COLORS "ff8080 000030"
!define MUI_BGCOLOR ffdd88
# !define MUI_HEADER_TRANSPARENT_TEXT 
# InstallColors FF8080 000030
# BGGradient 000000 800000 FFFFFF

!define MUI_ABORTWARNING

OutFile "Instalar_Vet_MUI.exe"
ManifestSupportedOS all
RequestExecutionLevel admin
Unicode true
InstallDir "$LOCALAPPDATA\Vet"

# SetCompressor /SOLID lzma


LicenseData "license.txt"
LicenseForceSelection checkbox "Acepto"

BrandingText "Vet"

LicenseText "Por favor, revise la licencia antes de instalar Vet. Si acepta los términos, haga clic en el casillero de abajo. Luego, clic en Siguiente para continuar." "Siguiente"
DirText "Este programa instalará Vet en la siguiente carpeta. Para instalar los archivos en una carpeta diferente, haga clic en Browse y seleccione otro directorio. Clic en Instalar para comenzar la copia e instalación."
ComponentText "Verifique los componentes que quiera instalar y destilde aquellos que no desee. Luego, haga clic en Siguiente para continuar." "" "Componentes a instalar:"

MiscButtonText "< Volver" "Siguiente >" "Cancelar" "Cerrar"
InstallButtonText "Instalar"
DetailsButtonText "Mostrar detalles"
CompletedText "Instalación Completada"
SpaceTexts "Espacio requerido:" "Espacio disponible:"

!define MUI_FINISHPAGE_TITLE "Gracias por Instalar Vet"
!define MUI_FINISHPAGE_TEXT "Se han copiado todos los archivos. Puede ejecutar la aplicación haciendo doble clic en el acceso directo que se encuentra en el escritorio.$\n$\n     ¡Gracias por instalar Vet!"
!define MUI_FINISHPAGE_LINK "Ir a la Web del proyecto"
!define MUI_FINISHPAGE_LINK_COLOR 0000FF
!define MUI_FINISHPAGE_LINK_LOCATION "https://github.com/cnngimenez/vet"

!define MUI_WELCOMEPAGE_TITLE "Bienvenid@s"
!define MUI_WELCOMEPAGE_TEXT "Este programa instalará Vet y sus dependencias.$\n$\nSe recomienda seleccionar todos los componentes que aparecerán a continuación.$\n$\nAnte preguntas o comentarios, puede visitar la página del proyecto:$\n   https://github.com/cnngimenez/vet"
!define MUI_WELCOMEFINISHPAGE_BITMAP "cat1.bmp"
!define MUI_WELCOMEFINISHPAGE_BITMAP_STRETCH AspectFitHeight

# !define MUI_FINISHPAGE_NOAUTOCLOSE

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "license.txt"
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_LANGUAGE "Spanish"

# Page license
# Page components
# Page directory
# Page instfiles
# Page custom thanksPage

# UninstPage uninstConfirm
# UninstPage instfiles

Section "!Ruby 2.7.2" Ruby
  AddSize 13316
  AddSize 89396
  DetailPrint "Instalando Ruby 2.7"
  SetOutPath "$INSTDIR\dist"
  File "dist\rubyinstaller-2.7.2-1-x64.exe"
  ExecWait '"$INSTDIR\dist\rubyinstaller-2.7.2-1-x64.exe" /verysilent' $0
  DetailPrint "Ruby installation returned $0."
SectionEnd

Section "!Gemas necesarias" Gemas
  AddSize 20268
  AddSize 144468
  DetailPrint "Extrayendo gemas para Ruby"  
  SetOutPath "$INSTDIR\dist\gems"
  File /r "dist\gems\*.*"
  DetailPrint "Instalando las gemas"
  nsExec::ExecToLog 'geminstall.bat'
SectionEnd

Section "!Aplicación principal" AppPrincipal
  DetailPrint "Extrayendo código ruby de la aplicación principal."
  SetOutPath $INSTDIR
  IfFileExists "$INSTDIR\database.sqlite3" 0 +2
    Call warnAndCopyDatabase
  File /a /r "vet-main\*.*"
  DetailPrint "Código ruby extraído."
  CreateShortcut "$DESKTOP\Vet.lnk" "rubyw $INSTDIR\vet.rb"
  DetailPrint "Acceso directo creado."
  WriteRegStr HKCU "Software\Vet" "Install_Dir" $INSTDIR
SectionEnd

LangString DESC_Ruby ${LANG_SPANISH} "Intérprete del lenguaje de programación Ruby. Necesario para ejecutar el código Ruby de la aplicación. $\n Intalarlo puede llevar un momento. No es necesario seleccionarlo si ya lo instaló prevamente."
LangString DESC_Gemas ${LANG_SPANISH} "Paquetes de Ruby (gemas) necesarios para la aplicación. $\n Instalarlo puede llevar un momento. No es necesario seleccionarlo si ya lo instaló prevamente."
LangString DESC_AppPrincipal ${LANG_SPANISH} "Código fuente en Ruby de la aplicación. $\n ¡Es la aplicación misma!"

!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${Ruby} $(DESC_Ruby)
  !insertmacro MUI_DESCRIPTION_TEXT ${Gemas} $(DESC_Gemas)
  !insertmacro MUI_DESCRIPTION_TEXT ${AppPrincipal} $(DESC_AppPrincipal)
!insertmacro MUI_FUNCTION_DESCRIPTION_END


; Function thanksPage
;   MessageBox MB_OK "Se han copiado todos los archivos. Puede ejecutar la aplicación haciendo doble clic en el acceso directo que se encuentra en el escritorio.$\n$\n     ¡Gracias por instalar Vet!"
; FunctionEnd
Function warnAndCopyDatabase
  MessageBox MB_OK "Se ha encontrado un archivo de base de datos. Este instalador *no pisará tal archivo*. Se realizará una copia de respaldo a $INSTDIR\backups\database.sqlite3 antes de continuar. Considere copiarla a otro medio físico y renombrar el archivo con la fecha del día de hoy."
  CreateDirectory "$INSTDIR\backups"
  CopyFiles "$INSTDIR\database.sqlite3" "$INSTDIR\backups\database.sqlite3"
FunctionEnd

