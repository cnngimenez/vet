# Copyright 2021 Christian Gimenez
#
# installer.nsi
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

Name "Instalar Vet"
Caption "Instalar Vet"
# Icon
OutFile "Instalar_Vet.exe"
ManifestSupportedOS all
RequestExecutionLevel admin
Unicode true

# SetCompressor /SOLID lzma

InstallDir "$LOCALAPPDATA\Vet"

LicenseData "license.txt"
LicenseForceSelection checkbox "Acepto"

BGGradient 000000 800000 FFFFFF
InstallColors FF8080 000030

BrandingText "Vet"

LicenseText "Por favor, revise la licencia antes de instalar Vet. Si acepta los t�rminos, haga clic en el casillero de abajo. Luego, clic en Siguiente para continuar." "Siguiente"
DirText "Este programa instalar� Vet en la siguiente carpeta. Para instalar los archivos en una carpeta diferente, haga clic en Browse y seleccione otro directorio. Clic en Instalar para comenzar la copia e instalaci�n."
ComponentText "Verifique los componentes que quiera instalar y destilde aquellos que no desee. Luego, haga clic en Siguiente para continuar." "" "Componentes a instalar:"

MiscButtonText "< Volver" "Siguiente >" "Cancelar" "Cerrar"
InstallButtonText "Instalar"
DetailsButtonText "Mostrar detalles"
CompletedText "Instalaci�n Completada"
SpaceTexts "Espacio requerido:" "Espacio disponible:"

Page license
Page components
Page directory
Page instfiles
Page custom thanksPage

UninstPage uninstConfirm
UninstPage instfiles

Section "!Ruby 2.7.2"
  AddSize 13316
  AddSize 89396
  DetailPrint "Instalando Ruby 2.7"
  SetOutPath "$INSTDIR\dist"
  File "dist\rubyinstaller-2.7.2-1-x64.exe"
  ExecWait '"$INSTDIR\dist\rubyinstaller-2.7.2-1-x64.exe" /verysilent' $0
  DetailPrint "Ruby installation returned $0."
SectionEnd

Section "!Gemas necesarias"
  AddSize 20268
  AddSize 144468
  DetailPrint "Extrayendo gemas para Ruby"  
  SetOutPath "$INSTDIR\dist\gems"
  File /r "dist\gems\*.*"
  DetailPrint "Instalando las gemas"
  nsExec::ExecToLog 'geminstall.bat'
SectionEnd

Section "!Aplicaci�n principal"
  DetailPrint "Extrayendo c�digo ruby de la aplicaci�n principal."
  SetOutPath $INSTDIR
  File /a /r "vet-main\*.*"
  DetailPrint "C�digo ruby extra�do."
  CreateShortcut "$DESKTOP\Vet.lnk" "rubyw $INSTDIR\vet.rb"
  DetailPrint "Acceso directo creado."
SectionEnd

Function thanksPage
  MessageBox MB_OK "Se han copiado todos los archivos. Puede ejecutar la aplicaci�n haciendo doble clic en el acceso directo que se encuentra en el escritorio.$\n$\n     �Gracias por instalar Vet!"
FunctionEnd
