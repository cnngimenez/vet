# coding: utf-8
# Copyright 2021 Christian Gimenez
#
# wabout.rb
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

# frozen_string_literal: true

require 'fox16'

# User Interface module
module GUI
  include Fox
  # The about window.
  class WAbout < FXMDIChild
    PROJECT_TEXT = <<~MESSAGE
      Christian Gimenez (https://github.com/cnngimenez).

      Los siguientes enlaces que pueden resultarle útil para consultar la documentación del software:

      - Código fuente: https://github.com/cnngimenez/vet
      - Reportar errores y sugerencias: https://github.com/cnngimenez/vet/issues
      - Wiki y documentación de ayuda del proyecto: https://github.com/cnngimenez/vet/wiki
    MESSAGE

    LICENSE_TEXT = <<~LICENSE
      Este programa está bajo la licencia GNU General Public License versión 3 (GPLv3).
      Puede leer el archivo LICENSE o visite la siguiente página Web para más información: https://www.gnu.org/licenses/gpl-3.0.html

      Este proyecto es Software Libre ( https://fsf.org ).

      Las licencias de las imágenes se encuentra en el directorio gui/imgs/Readme.org del proyecto. Se intentaron buscar imágenes basadas en las licencias Creative Commons ( https://creativecommons.org ) o de Dominio Público.
    LICENSE
    def initialize(mdiclient, x = 10, y = 10, width = 400, height = 400)
      super mdiclient, 'Ayuda y soporte', nil, nil, 0, x, y, width, height

      @fbtns = {}
      f1 = FXVerticalFrame.new self, LAYOUT_FILL_X | LAYOUT_FILL_Y

      FXLabel.new f1, 'Acerca del proyecto'
      txt = FXText.new f1, nil, 0, TEXT_READONLY | TEXT_WORDWRAP | LAYOUT_FILL_X | LAYOUT_FILL_Y
      txt.text = PROJECT_TEXT

      f2 = FXHorizontalFrame.new f1, LAYOUT_FILL_X
      @fbtns[:source] = FXButton.new f2, 'Código fuente'
      @fbtns[:issues] = FXButton.new f2, 'Errores y sugerencias'
      @fbtns[:wiki] = FXButton.new f2, 'Wiki'

      FXLabel.new f1, 'Licencia del proyecto'
      txt = FXText.new f1, nil, 0, TEXT_READONLY | TEXT_WORDWRAP | LAYOUT_FILL_X | LAYOUT_FILL_Y
      txt.text = LICENSE_TEXT

      f2 = FXHorizontalFrame.new f1, LAYOUT_FILL_X
      @fbtns[:gpl] = FXButton.new f2, 'gnu.org'
      @fbtns[:fsf] = FXButton.new f2, 'fsf.org'
      @fbtns[:license_file] = FXButton.new f2, 'Abrir archivo LICENSE'

      FXLabel.new f1, "Ubicación de la aplicación: #{Dir.pwd}"
      FXLabel.new f1, "Ubicación de la base de datos: #{Dir.pwd}/database.sqlite3"
      @fbtns[:install_dir] = FXButton.new f1, 'Abrir ubicación'

      assign_handlers
    end

    private

    def open_app(link)
      case RbConfig::CONFIG['host_os']
      when /mswin|mingw|cygwin/
        cmd = "start #{link}"
      when /darwin/
        cmd = "open #{link}"
      when /linux|bsd/
        cmd = "xdg-open #{link}"
      else
        return
      end
      puts "Executing: '#{cmd}'"
      system cmd
    end

    def open_source(...)
      open_app 'https://github.com/cnngimenez/vet'
    end

    def open_license_file(...)
      open_app "#{Dir.pwd}/LICENSE"
    end

    def open_install_dir(...)
      open_app Dir.pwd
    end

    def open_issues(...)
      open_app 'https://github.com/cnngimenez/vet/wiki'
    end

    def open_wiki(...)
      open_app 'https://github.com/cnngimenez/vet/issues'
    end

    def open_gpl(...)
      open_app 'https://www.gnu.org/licenses/gpl-3.0.html'
    end

    def open_fsf(...)
      open_app 'https://fsf.org'
    end

    def assign_handlers
      @fbtns[:source].connect SEL_COMMAND, method(:open_source)
      @fbtns[:issues].connect SEL_COMMAND, method(:open_issues)
      @fbtns[:wiki].connect SEL_COMMAND, method(:open_wiki)

      @fbtns[:gpl].connect SEL_COMMAND, method(:open_gpl)
      @fbtns[:fsf].connect SEL_COMMAND, method(:open_fsf)
      @fbtns[:license_file].connect SEL_COMMAND, method(:open_license_file)
      @fbtns[:install_dir].connect SEL_COMMAND, method(:open_install_dir)
    end
  end
end
