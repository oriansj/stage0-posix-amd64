#!/usr/bin/env bash
# Mes --- Maxwell Equations of Software
# Copyright © 2020 Jeremiah Orians
#
# This file is part of Mes.
#
# Mes is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or (at
# your option) any later version.
#
# Mes is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Mes.  If not, see <http://www.gnu.org/licenses/>.

# This folder contains the build artifacts for AMD64 bootstrapping to enable complete auditing

set -eux
# cleaning up what git clean -xdf misses

rm -vf AMD64/artifact/M0
rm -vf AMD64/artifact/M0.hex2
rm -vf AMD64/artifact/M1-0
rm -vf AMD64/artifact/M1-macro-0-0.M1
rm -vf AMD64/artifact/M1-macro-0-0.hex2
rm -vf AMD64/artifact/M1-macro-0-footer.M1
rm -vf AMD64/artifact/M1-macro-0.M1
rm -vf AMD64/artifact/M1-macro-0.hex2
rm -vf AMD64/artifact/M1-macro-1-footer.M1
rm -vf AMD64/artifact/M1-macro-1.M1
rm -vf AMD64/artifact/M1-macro-1.hex2
rm -vf AMD64/artifact/M2
rm -vf AMD64/artifact/M2-0-0.M1
rm -vf AMD64/artifact/M2-0-0.hex2
rm -vf AMD64/artifact/M2-0.M1
rm -vf AMD64/artifact/M2-0.c
rm -vf AMD64/artifact/M2-0.hex2
rm -vf AMD64/artifact/M2-1-footer.M1
rm -vf AMD64/artifact/M2-1.M1
rm -vf AMD64/artifact/M2-1.hex2
rm -vf AMD64/artifact/M2-Mesoplanet-1-footer.M1
rm -vf AMD64/artifact/M2-Mesoplanet-1.M1
rm -vf AMD64/artifact/M2-Mesoplanet-1.hex2
rm -vf AMD64/artifact/blood-elf-0
rm -vf AMD64/artifact/blood-elf-0-0.M1
rm -vf AMD64/artifact/blood-elf-0-0.hex2
rm -vf AMD64/artifact/blood-elf-0.M1
rm -vf AMD64/artifact/blood-elf-0.hex2
rm -vf AMD64/artifact/blood-elf-1-footer.M1
rm -vf AMD64/artifact/blood-elf-1.M1
rm -vf AMD64/artifact/blood-elf-1.hex2
rm -vf AMD64/artifact/catm
rm -vf AMD64/artifact/cc_amd64
rm -vf AMD64/artifact/cc_amd64-0.hex2
rm -vf AMD64/artifact/cc_amd64.hex2
rm -vf AMD64/artifact/get_machine-footer.M1
rm -vf AMD64/artifact/get_machine.M1
rm -vf AMD64/artifact/get_machine.hex2
rm -vf AMD64/artifact/hex0
rm -vf AMD64/artifact/hex1
rm -vf AMD64/artifact/hex2-0
rm -vf AMD64/artifact/hex2-1
rm -vf AMD64/artifact/hex2_linker-1-0.hex2
rm -vf AMD64/artifact/hex2_linker-1-footer.M1
rm -vf AMD64/artifact/hex2_linker-1.M1
rm -vf AMD64/artifact/hex2_linker-1.hex2
rm -vf AMD64/artifact/hex2_linker-2-footer.M1
rm -vf AMD64/artifact/hex2_linker-2.M1
rm -vf AMD64/artifact/hex2_linker-2.hex2
rm -vf AMD64/artifact/kaem-0
rm -vf AMD64/artifact/kaem-footer.M1
rm -vf AMD64/artifact/kaem.M1
rm -vf AMD64/artifact/kaem.hex2
