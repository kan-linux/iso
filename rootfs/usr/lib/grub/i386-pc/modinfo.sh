#!/bin/bash

# User-controllable options
grub_modinfo_target_cpu=i386
grub_modinfo_platform=pc
grub_disk_cache_stats=0
grub_boot_time_stats=0
grub_have_font_source=0

# Autodetected config
grub_have_asm_uscore=0
grub_bss_start_symbol="__bss_start"
grub_end_symbol="end"

# Build environment
grub_target_cc='x86_64-kan-linux-gnu-gcc'
grub_target_cc_version='x86_64-kan-linux-gnu-gcc (GCC) 16.2.0'
grub_target_cflags='-std=gnu99 -fno-common -Os -m32 -Wall -W -Wshadow -Wpointer-arith -Wundef -Wchar-subscripts -Wcomment -Wdeprecated-declarations -Wdisabled-optimization -Wdiv-by-zero -Wfloat-equal -Wformat-extra-args -Wformat-security -Wformat-y2k -Wimplicit -Wimplicit-function-declaration -Wimplicit-int -Wmain -Wmissing-braces -Wmissing-format-attribute -Wmultichar -Wparentheses -Wreturn-type -Wsequence-point -Wshadow -Wsign-compare -Wswitch -Wtrigraphs -Wunknown-pragmas -Wunused -Wunused-function -Wunused-label -Wunused-parameter -Wunused-value  -Wunused-variable -Wwrite-strings -Wnested-externs -Wstrict-prototypes -g -Wredundant-decls -Wmissing-prototypes -Wmissing-declarations  -Wextra -Wattributes -Wendif-labels -Winit-self -Wint-to-pointer-cast -Winvalid-pch -Wmissing-field-initializers -Wnonnull -Woverflow -Wvla -Wpointer-to-int-cast -Wstrict-aliasing -Wvariadic-macros -Wvolatile-register-var -Wpointer-sign -Wmissing-include-dirs -Wmissing-prototypes -Wmissing-declarations -Wformat=2 -march=i386 -mrtd -mregparm=3 -falign-functions=1 -falign-loops=1 -falign-jumps=1 -freg-struct-return -mno-mmx -mno-sse -mno-sse2 -mno-sse3 -mno-3dnow -Wa,-mx86-used-note=no -msoft-float -fno-omit-frame-pointer -fno-dwarf2-cfi-asm -mno-stack-arg-probe -fno-asynchronous-unwind-tables -fno-unwind-tables -fno-ident -fno-PIE -fno-pie -fno-stack-protector -Wtrampolines'
grub_target_cppflags=' -Wall -W  -DGRUB_MACHINE_PCBIOS=1 -DGRUB_MACHINE=I386_PC -m32 -nostdinc -isystem /home/zhouwg/kanlinux/out/toolchain/lib/gcc/x86_64-kan-linux-gnu/16.2.0/include -I$(top_srcdir)/include -I$(top_builddir)/include'
grub_target_ccasflags=' -m32 -g  -Wa,-mx86-used-note=no -msoft-float -fno-PIE -fno-pie'
grub_target_ldflags=' -m32 -Wl,-melf_i386 -no-pie -Wl,--build-id=none'
grub_cflags='-O2 -DPATH_MAX=4096 -DMB_LEN_MAX=16 -DIOV_MAX=1024 -DNGROUPS_MAX=65536 -DLINE_MAX=2048'
grub_cppflags=' -D_FILE_OFFSET_BITS=64'
grub_ccasflags='-O2 -DPATH_MAX=4096 -DMB_LEN_MAX=16 -DIOV_MAX=1024 -DNGROUPS_MAX=65536 -DLINE_MAX=2048'
grub_ldflags=''
grub_target_strip='x86_64-kan-linux-gnu-strip'
grub_target_nm='x86_64-kan-linux-gnu-nm'
grub_target_ranlib='x86_64-kan-linux-gnu-ranlib'
grub_target_objconf=''
grub_target_obj2elf=''
grub_target_img_base_ldopt='-Wl,--image-base'
grub_target_img_ldflags='@TARGET_IMG_BASE_LDFLAGS@'

# Version
grub_version="2.14"
grub_package="grub"
grub_package_string="GRUB 2.14"
grub_package_version="2.14"
grub_package_name="GRUB"
grub_package_bugreport="bug-grub@gnu.org"
